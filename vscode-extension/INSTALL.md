# Installation Guide

## Installing the GrillCheese Script VS Code Extension

### Method 1: Install from .vsix file (Recommended)

1. **Download the extension package**
   - The file `grillcheese-script-1.1.0.vsix` is the installable extension package

2. **Install in VS Code**
   - Open VS Code
   - Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac) to open the Command Palette
   - Type "Extensions: Install from VSIX..."
   - Select the `grillcheese-script-1.1.0.vsix` file
   - Click "Install"

3. **Reload VS Code**
   - VS Code will prompt you to reload the window
   - Click "Reload" to activate the extension

### Method 2: Install from command line

```bash
# Install the extension
code --install-extension grillcheese-script-1.1.0.vsix

# Or if you have the full path
code --install-extension /path/to/grillcheese-script-1.1.0.vsix
```

### Method 3: Copy to extensions folder

1. **Find your VS Code extensions folder**
   - Windows: `%USERPROFILE%\.vscode\extensions`
   - macOS: `~/.vscode/extensions`
   - Linux: `~/.vscode/extensions`

2. **Extract the .vsix file**
   - Rename `grillcheese-script-1.1.0.vsix` to `grillcheese-script-1.1.0.zip`
   - Extract the zip file to a folder named `grillcheese-script-1.1.0`
   - Copy this folder to your VS Code extensions directory

3. **Restart VS Code**

## Verification

1. **Open a .gcs file**
   - Create a new file with `.gcs` extension
   - You should see syntax highlighting

2. **Test IntelliSense**
   - Type `love.` and you should see auto-completion
   - Type `fn` and you should see function snippet suggestions

3. **Test hover documentation**
   - Hover over `love.graphics.print` to see documentation
   - Hover over `fn` to see keyword documentation

## Features to Test

- ✅ Syntax highlighting for GrillCheese Script
- ✅ Auto-completion for Love2D functions
- ✅ Code snippets (type `fn` and press Tab)
- ✅ Hover documentation
- ✅ Type declarations (`string[]`, `bool`, `int`, `float`, `table`)
- ✅ Typed arrays (`string[]`, `int[]`, `float[]`, `bool[]`)
- ✅ Table declarations (`table player = {x = 100, y = 200}`)
- ✅ Array syntax (`array = [1, 2, 3]`)
- ✅ Logical operators (`&&`, `||`, `==`, `!=`, `<`, `>`, `<=`, `>=`)
- ✅ Import statements (`import { load, render } from "sprlib"`)
- ✅ C-style comments (`//`)
- ✅ JavaScript-style curly braces (`{}`)

## Troubleshooting

### Extension not working?
1. Make sure you have VS Code version 1.74.0 or higher
2. Check that the extension is enabled in the Extensions panel
3. Try reloading VS Code window (`Ctrl+Shift+P` → "Developer: Reload Window")

### No syntax highlighting?
1. Make sure your file has `.gcs` extension
2. Check that the language mode is set to "GrillCheese Script"
3. You can manually set it by clicking the language mode in the status bar

### No IntelliSense?
1. Make sure the extension is activated
2. Try typing in a `.gcs` file
3. Check the Output panel for any error messages

## Uninstalling

1. Open VS Code
2. Go to Extensions panel (`Ctrl+Shift+X`)
3. Search for "GrillCheese Script"
4. Click the gear icon and select "Uninstall"
5. Reload VS Code

## Support

If you encounter any issues:
1. Check the VS Code Output panel for error messages
2. Make sure you're using the latest version of VS Code
3. Try reinstalling the extension
