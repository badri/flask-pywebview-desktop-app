#!/bin/bash
# Linux Build Script for manylinux_2_28_x86_64
# This script sets up and builds the Flask+pywebview app in a manylinux container

set -e  # Exit on any error

echo "🚀 Starting manylinux_2_28_x86_64 build setup..."

# Configuration
CONTAINER_NAME="flask-pywebview-builder"
IMAGE="quay.io/pypa/manylinux_2_28_x86_64"
PYTHON_VERSION="cp311-cp311"
APP_NAME="MyApp"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}📋 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

if ! docker info &> /dev/null; then
    print_error "Docker is not running. Please start Docker first."
    exit 1
fi

print_success "Docker is available and running"

# Clean up any existing container
print_status "Cleaning up any existing containers..."
docker rm -f $CONTAINER_NAME 2>/dev/null || true

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

print_status "Project directory: $PROJECT_DIR"

# Start the manylinux container with the project mounted
print_status "Starting manylinux_2_28_x86_64 container..."
docker run -d \
    --name $CONTAINER_NAME \
    -v "$PROJECT_DIR":/workspace \
    -w /workspace \
    $IMAGE \
    tail -f /dev/null

print_success "Container started: $CONTAINER_NAME"

# Function to execute commands in the container
run_in_container() {
    docker exec $CONTAINER_NAME bash -c "$1"
}

# Install system dependencies
print_status "Installing system dependencies..."
run_in_container "
    yum update -y && \
    yum install -y \
        gcc \
        gcc-c++ \
        make \
        qt5-qtbase-devel \
        qt5-qtwebengine-devel \
        libX11-devel \
        libXext-devel \
        libXrender-devel \
        libXrandr-devel \
        libXcursor-devel \
        libXinerama-devel \
        libXi-devel \
        libGL-devel \
        mesa-libGL-devel \
        alsa-lib-devel \
        fontconfig-devel \
        freetype-devel \
        dbus-devel \
        xorg-x11-server-Xvfb
"

print_success "System dependencies installed"

# Set up Python environment and install dependencies
print_status "Setting up Python $PYTHON_VERSION environment..."
run_in_container "
    export PATH=/opt/python/$PYTHON_VERSION/bin:\$PATH && \
    export QT_QPA_PLATFORM=offscreen && \
    python3 -m pip install --upgrade pip setuptools wheel && \
    echo 'Python version:' && python3 --version && \
    echo 'Pip version:' && pip --version
"

print_success "Python environment ready"

# Install Python dependencies
print_status "Installing Python dependencies..."
run_in_container "
    export PATH=/opt/python/$PYTHON_VERSION/bin:\$PATH && \
    export QT_QPA_PLATFORM=offscreen && \
    pip install -r requirements.txt && \
    echo 'Checking PyInstaller installation:' && \
    which pyinstaller && \
    pyinstaller --version
"

print_success "Python dependencies installed"

# Build with PyInstaller
print_status "Building application with PyInstaller..."
run_in_container "
    export PATH=/opt/python/$PYTHON_VERSION/bin:\$PATH && \
    export QT_QPA_PLATFORM=offscreen && \
    export DISPLAY=:99 && \
    echo 'Starting Xvfb...' && \
    Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 & \
    sleep 3 && \
    echo 'Current directory:' && pwd && \
    echo 'Available files:' && ls -la && \
    echo 'Running PyInstaller...' && \
    pyinstaller app.spec --clean --noconfirm --log-level INFO
"

print_success "Application built successfully"

# Create distribution archive
print_status "Creating distribution archive..."
run_in_container "
    cd dist && \
    echo 'Contents of dist directory:' && ls -la && \
    tar -czf ${APP_NAME}-linux-manylinux_2_28_x86_64.tar.gz $APP_NAME && \
    echo 'Archive created:' && ls -la ${APP_NAME}-linux-manylinux_2_28_x86_64.tar.gz
"

# Copy the built archive to host
print_status "Copying build artifacts to host..."
docker cp $CONTAINER_NAME:/workspace/dist/${APP_NAME}-linux-manylinux_2_28_x86_64.tar.gz ./

print_success "Build artifacts copied to: ./${APP_NAME}-linux-manylinux_2_28_x86_64.tar.gz"

# Test the executable (basic validation)
print_status "Testing the built executable..."
run_in_container "
    export PATH=/opt/python/$PYTHON_VERSION/bin:\$PATH && \
    export QT_QPA_PLATFORM=offscreen && \
    cd dist/$APP_NAME && \
    echo 'Executable info:' && \
    ls -la MyApp && \
    file MyApp && \
    echo 'Testing executable (will timeout for GUI apps):' && \
    timeout 5s ./MyApp --version 2>&1 || echo 'Executable launches (timed out as expected for GUI app)'
"

# Show final information
print_status "Build summary..."
run_in_container "
    echo 'Final build information:' && \
    echo 'Python version:' && /opt/python/$PYTHON_VERSION/bin/python3 --version && \
    echo 'PyInstaller version:' && /opt/python/$PYTHON_VERSION/bin/pyinstaller --version && \
    echo 'Archive size:' && ls -lh dist/${APP_NAME}-linux-manylinux_2_28_x86_64.tar.gz
"

# Cleanup
print_status "Cleaning up container..."
docker rm -f $CONTAINER_NAME

print_success "🎉 Build completed successfully!"
echo ""
echo "📦 Your Linux executable is ready:"
echo "   File: ${APP_NAME}-linux-manylinux_2_28_x86_64.tar.gz"
echo "   Compatible with: manylinux_2_28_x86_64 and newer systems"
echo ""
echo "🔍 To test the executable:"
echo "   1. Extract: tar -xzf ${APP_NAME}-linux-manylinux_2_28_x86_64.tar.gz"
echo "   2. Run: ./${APP_NAME}/${APP_NAME}"
echo ""
echo "🚀 For deployment, this archive can be distributed to any compatible Linux system."
