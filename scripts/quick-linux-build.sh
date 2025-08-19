#!/bin/bash
# Quick Docker build script for Linux manylinux_2_28_x86_64

set -e

echo "🚀 Building Linux executable using Docker..."

# Build the Docker image
echo "📦 Building Docker image..."
docker build -f Dockerfile.linux -t flask-pywebview-linux .

# Run the container and extract the build
echo "🔨 Running build in container..."
docker run --rm -v "$(pwd)/dist-linux:/workspace/dist" flask-pywebview-linux

echo "✅ Build completed!"
echo "📁 Output directory: ./dist-linux/"
echo "📦 Archive: ./dist-linux/MyApp-linux-manylinux_2_28_x86_64.tar.gz"

# Create dist-linux directory if it doesn't exist
mkdir -p dist-linux

# Copy the archive from container to host
CONTAINER_ID=$(docker create flask-pywebview-linux)
docker cp "$CONTAINER_ID:/workspace/dist/MyApp-linux-manylinux_2_28_x86_64.tar.gz" ./dist-linux/
docker rm "$CONTAINER_ID"

echo "🎉 Linux build ready for distribution!"
