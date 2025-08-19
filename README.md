# Flask + pywebview Desktop App

🚀 A cross-platform desktop application built with Flask, pywebview, and Qt with automated CI/CD builds.

## Features

- **Cross-platform**: Runs on Windows, macOS, and Linux
- **Modern UI**: Web-based interface using Flask and HTML/CSS/JS
- **Native packaging**: Single executable files using PyInstaller
- **Automated builds**: GitHub Actions CI/CD for all platforms
- **Qt integration**: Uses Qt5 for consistent cross-platform experience
- **manylinux support**: Compatible with manylinux_2_28_x86_64 for broad Linux compatibility

## Quick Start

### Prerequisites

- Python 3.11
- Git
- Docker (for Linux builds)

### Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/badri/flask-pywebview-desktop-app.git
   cd flask-pywebview-desktop-app
   ```

2. **Create virtual environment**
   ```bash
   python -m venv venv
   
   # Windows
   venv\Scripts\activate
   
   # macOS/Linux
   source venv/bin/activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run the development version**
   ```bash
   python app.py
   ```

## Building Executables

### Local Build (Current Platform)

```bash
# Build using the spec file
pyinstaller app.spec

# Output will be in dist/MyApp/
```

### Linux Build (manylinux_2_28_x86_64)

For faster Linux builds without waiting for CI/CD, use our Docker-based build scripts:

#### Option 1: Quick Docker Build
```bash
chmod +x scripts/quick-linux-build.sh
./scripts/quick-linux-build.sh
```

#### Option 2: Full manylinux Build Script
```bash
chmod +x scripts/build-linux.sh
./scripts/build-linux.sh
```

#### Option 3: Manual Docker Build
```bash
# Build Docker image
docker build -f Dockerfile.linux -t flask-pywebview-linux .

# Run build
docker run --rm -v "$(pwd)/dist-linux:/output" flask-pywebview-linux

# Extract results
docker cp $(docker create flask-pywebview-linux):/workspace/dist/MyApp-linux-manylinux_2_28_x86_64.tar.gz ./
```

### Platform-specific Notes

**Windows:**
- Requires Visual C++ redistributables
- Output: `dist/MyApp/MyApp.exe`

**macOS:**
- Creates `.app` bundle: `dist/MyApp.app`
- May require code signing for distribution

**Linux:**
- Uses manylinux_2_28_x86_64 for broad compatibility
- Output: `dist/MyApp/MyApp`
- Compatible with most modern Linux distributions

## Automated Builds

The repository includes GitHub Actions that automatically build executables for all platforms:

- **Triggers**: Push to main/develop, tags, or manual dispatch
- **Artifacts**: Downloadable builds for Windows, macOS, and Linux
- **Releases**: Automatic releases when you push a version tag

### Creating a Release

1. **Tag your release**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **GitHub Actions will automatically**:
   - Build for all platforms
   - Create a new GitHub release
   - Attach the build artifacts

## Project Structure

```
flask-pywebview-desktop-app/
├── app.py                 # Main application entry point
├── app.spec              # PyInstaller configuration
├── requirements.txt      # Python dependencies
├── Dockerfile.linux      # Linux build container
├── templates/
│   └── index.html       # Main UI template
├── static/              # CSS, JS, images (add your assets here)
├── scripts/
│   ├── build-linux.sh   # Full Linux build script
│   └── quick-linux-build.sh  # Quick Docker build
├── .github/
│   └── workflows/
│       └── build.yml    # CI/CD configuration
└── README.md
```

## Technology Stack

- **Backend**: Flask (Python web framework)
- **Frontend**: HTML/CSS/JavaScript
- **Desktop Integration**: pywebview with Qt5
- **Packaging**: PyInstaller
- **Linux Compatibility**: manylinux_2_28_x86_64
- **CI/CD**: GitHub Actions
- **Platforms**: Windows, macOS, Linux

## Development Workflow

### Fast Linux Development Loop

Instead of waiting for CI/CD queue:

1. **Make changes to your code**
2. **Test locally**: `python app.py`
3. **Quick Linux build**: `./scripts/quick-linux-build.sh`
4. **Test the executable** on your target Linux system

This gives you a ~2-3 minute feedback loop instead of waiting 30+ minutes for CI.

## Customization

### Adding Routes

Add new Flask routes in `app.py`:

```python
@app.route('/api/new-endpoint')
def new_endpoint():
    return jsonify({'data': 'your data here'})
```

### Styling

Modify `templates/index.html` or add CSS files to the `static/` directory.

### App Configuration

Update `app.spec` to:
- Change app name and icon
- Add additional files or dependencies
- Modify build settings

## Troubleshooting

### Common Issues

1. **Qt not found on Linux**
   ```bash
   sudo apt-get install python3-pyqt5
   ```

2. **Build fails on macOS**
   - Ensure Xcode command line tools are installed
   - Try: `xcode-select --install`

3. **Windows antivirus flags executable**
   - This is common with PyInstaller builds
   - Consider code signing for production releases

4. **Docker build fails**
   - Ensure Docker is running: `docker info`
   - Try clearing Docker cache: `docker system prune`

### Development Tips

- Set `console=True` in `app.spec` for debugging
- Use `webview.start(debug=True)` for development
- Check GitHub Actions logs for build issues
- Use local Docker builds for faster Linux testing

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on multiple platforms (or rely on CI)
5. Submit a pull request

## License

MIT License - see LICENSE file for details.

## Support

If you encounter issues:

1. Check the [Issues](https://github.com/badri/flask-pywebview-desktop-app/issues) page
2. Review the GitHub Actions build logs
3. Try local Docker builds for debugging
4. Create a new issue with details about your problem

---

**Happy coding!** 🎉
