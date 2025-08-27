# -*- mode: python ; coding: utf-8 -*-

import sys
import os
from PyInstaller.utils.hooks import collect_data_files, collect_submodules

# Collect Flask templates and static files
flask_datas = collect_data_files('flask')


# Check for icon files
icon_file = None
if sys.platform == 'win32' and os.path.exists('icon.ico'):
    icon_file = 'icon.ico'
elif sys.platform == 'darwin' and os.path.exists('icon.icns'):
    icon_file = 'icon.icns'

block_cipher = None

a = Analysis(
    ['app.py'],  # Your main Flask app file
    pathex=['.\\dist'],
    binaries=[],
    datas=flask_datas + [
        ('templates', 'templates'),  # Include your Flask templates
        ('static', 'static'),        # Include your Flask static files
    ],
    hiddenimports=['clr'],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='MyApp',
    debug=False,
    bootloader_ignore_signals=False,
    strip=True,
    upx=True,
    console=False,  # Set to True for debugging
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=icon_file  # Only set if icon file exists
)

