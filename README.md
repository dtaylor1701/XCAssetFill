I will read the documentation files and the package manifest to understand the project's purpose, features, and dependencies.
I will read the `CLI/XCAFill.swift` file to determine the exact command-line arguments and usage for the `XCAFill` tool.
# XCAFill

**One Source, Infinite Scale.**

XCAFill is a macOS command-line tool that automates the generation of raster assets (PNGs) for Xcode Asset Catalogs from a single vector source (PDF). By reading the requirements directly from an asset set's `Contents.json`, XCAFill ensures your app icons are pixel-perfect and compliant with Apple's platform-specific design guidelines across iOS, macOS, watchOS, and visionOS.

---

## Features

- **Automated Generation**: Automatically populates `.appiconset` folders with all required sizes and scales (@1x, @2x, @3x).
- **Platform Aware**: Built-in support for macOS-specific safe area padding (10%) and standard squircle corner rounding.
- **High Fidelity**: Leverages `CoreGraphics` for professional-grade PDF-to-PNG rendering.
- **Source of Truth**: Maintain a single high-quality PDF master to satisfy dozens of icon variations.
- **CLI-First**: Designed for seamless integration into developer workflows and CI/CD build scripts.

## Installation

### From Source

Ensure you have Swift 5.8+ and macOS 13.0+ installed.

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/XCAFill.git
   cd XCAFill
   ```
2. Build the project:
   ```bash
   swift build -c release
   ```
3. (Optional) Install the binary to your path:
   ```bash
   cp .build/release/XCAFill /usr/local/bin/xcafill
   ```

## Usage

XCAFill takes your source PDF and an optional path to an Xcode `.appiconset` folder.

```bash
xcafill <source-icon-path> [<asset-folder-path>]
```

### Examples

**Populate an App Icon set in the current directory:**
```bash
xcafill IconMaster.pdf
```

**Specify a target asset catalog path:**
```bash
xcafill Design/AppIcon.pdf MyProject/Assets.xcassets/AppIcon.appiconset
```

## How It Works

1. **Analysis**: The tool parses the `Contents.json` within the target `.appiconset` directory to identify every required image size, scale, and platform idiom.
2. **Rendering**: For each requirement, it uses `CoreGraphics` to render the source PDF into a bitmap context at the precise target resolution.
3. **Transformation**: Platform-specific logic is applied (e.g., applying specific margins or clipping paths for macOS icons).
4. **Export**: High-quality PNG files are written to the directory, and the `Contents.json` is automatically updated to reference the new files.

## Components

The project is organized into two main modules:

- **CLI (`XCAFill`)**: A thin wrapper using `swift-argument-parser` to handle user input and execution.
- **XCAFillLibrary**: The core engine containing:
    - `XCAssetFill`: Orchestrates the high-level workflow.
    - `ImageConverter`: Handles low-level PDF rendering and image encoding.
    - `Contents` & `Image`: Type-safe Swift models for the Xcode asset catalog schema.

## Requirements

- **macOS**: 13.0+ (Ventura or later)
- **Swift**: 5.8+
- **Toolchain**: Xcode 14.3+ or the Swift 5.8+ toolchain.

## Dependencies

- [swift-argument-parser](https://github.com/apple/swift-argument-parser): Powering the command-line interface.

---

*XCAFill is built for developers who value consistency and efficiency in their Apple platform design workflows.*
