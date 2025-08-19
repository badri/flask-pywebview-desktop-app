# -*- mode: python ; coding: utf-8 -*-

import sys
import os
from PyInstaller.utils.hooks import collect_data_files, collect_submodules

# Collect Flask templates and static files
flask_datas = collect_data_files('flask')

# Collect pywebview data files
webview_datas = collect_data_files('webview')

# Hidden imports for Qt and webview
hidden_imports = [
    'webview',
    'webview.platforms.qt',
    'PyQt5',
    'PyQt5.QtCore',
    'PyQt5.QtGui',
    'PyQt5.QtWidgets',
    'PyQt5.QtWebEngineWidgets',
    'flask',
    'werkzeug',
    'jinja2',
    'click',
    'itsdangerous',
    'markupsafe'
]

# Add Qt5 plugins and libraries
qt_binaries = []
qt_datas = []

if sys.platform == 'win32':
    # Windows-specific Qt paths
    import PyQt5
    qt_path = os.path.dirname(PyQt5.__file__)
    qt_datas.extend([
        (os.path.join(qt_path, 'Qt5', 'bin', 'Qt5WebEngineCore.dll'), 'PyQt5/Qt5/bin'),
        (os.path.join(qt_path, 'Qt5', 'resources'), 'PyQt5/Qt5/resources'),
        (os.path.join(qt_path, 'Qt5', 'translations'), 'PyQt5/Qt5/translations'),
    ])

block_cipher = None

a = Analysis(
    ['app.py'],  # Your main Flask app file
    pathex=[],
    binaries=qt_binaries,
    datas=flask_datas + webview_datas + qt_datas + [
        ('templates', 'templates'),  # Include your Flask templates
        ('static', 'static'),        # Include your Flask static files
    ],
    hiddenimports=hidden_imports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        'tkinter',
        'matplotlib',
        'numpy',
        'pandas',
        'PIL'
    ],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='MyApp',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=False,  # Set to True for debugging
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon='icon.ico'  # Optional: add your app icon
)

coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='MyApp'
)

# macOS app bundle (optional)
if sys.platform == 'darwin':
    app = BUNDLE(
        coll,
        name='MyApp.app',
        icon='icon.icns',  # macOS icon format
        bundle_identifier='com.yourcompany.myapp',
        info_plist={
            'NSHighResolutionCapable': 'True',
            'NSRequiresAquaSystemAppearance': 'False',
        },
    )
