# Flask + pywebview Desktop App

🚀 A cross-platform desktop application built with Flask, pywebview, and Qt with automated CI/CD builds.

## Features

- **Cross-platform**: Runs on Windows, macOS, and Linux
- **Modern UI**: Web-based interface using Flask and HTML/CSS/JS
- **Native packaging**: Single executable files using PyInstaller
- **Automated builds**: GitHub Actions CI/CD for all platforms
- **Qt integration**: Uses Qt5 for consistent cross-platform experience

## Quick Start

### Prerequisites

- Python 3.11
- Git

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

### Local Build

```bash
# Build using the spec file
pyinstaller app.spec

# Output will be in dist/MyApp/
```

### Platform-specific Notes

**Windows:**
- Requires Visual C++ redistributables
- Output: `dist/MyApp/MyApp.exe`

**macOS:**
- Creates `.app` bundle: `dist/MyApp.app`
- May require code signing for distribution

**Linux:**
- Requires system Qt5 libraries
- Output: `dist/MyApp/MyApp`

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
├── templates/
│   └── index.html       # Main UI template
├── static/              # CSS, JS, images (add your assets here)
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
- **CI/CD**: GitHub Actions
- **Platforms**: Windows, macOS, Linux

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

### Development Tips

- Set `console=True` in `app.spec` for debugging
- Use `webview.start(debug=True)` for development
- Check GitHub Actions logs for build issues

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
3. Create a new issue with details about your problem

---

**Happy coding!** 🎉
