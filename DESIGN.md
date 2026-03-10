# Design Document: XCAFill

## 1. Overview
`XCAFill` is a macOS command-line tool designed to automate the generation of raster assets (PNGs) for Xcode Asset Catalogs from a single vector source (PDF). It specifically targets `AppIcon` sets, reading the requirements from a directory's `Contents.json` and producing all necessary scaled and idiomatic variations.

## 2. Architecture & System Design
The project follows a modular architecture split into a thin CLI wrapper and a robust core library.

### High-Level Components
- **CLI Executable (`XCAFill`)**: Handles command-line argument parsing and user interaction using `swift-argument-parser`.
- **Core Library (`XCAFillLibrary`)**:
    - **Orchestration (`XCAssetFill`)**: Manages the high-level workflow: reading the asset catalog configuration, iterating through requirements, and invoking the conversion engine.
    - **Conversion Engine (`ImageConverter`)**: A low-level utility leveraging `CoreGraphics` to render PDF pages into bitmapped images with specific transformations.
    - **Data Models (`Contents`, `Image`)**: Type-safe representations of the Xcode `Contents.json` schema, enhanced with computed properties for asset naming and platform-specific logic.

## 3. Technical Stack
- **Language**: Swift 5.8+
- **Platform**: macOS 13.0+
- **Core Frameworks**:
    - `Foundation`: File system operations and JSON decoding.
    - `CoreGraphics`: High-fidelity PDF rendering and image manipulation.
    - `ImageIO`: Encoding and writing image data to disk.
- **Dependencies**:
    - `swift-argument-parser`: Standard library for CLI input handling.
- **Build System**: Swift Package Manager (SPM).

## 4. Design Philosophies & Patterns
- **Single Source of Truth**: The design centers on using a single PDF file to generate all required assets, ensuring consistency across resolutions and idioms.
- **Convention over Configuration**: The tool infers required dimensions and scales directly from the existing `Contents.json` within the target `.appiconset` folder.
- **Idiomatic Specialization**: It encapsulates platform-specific design rules (e.g., macOS-specific padding and corner rounding) within the data models, rather than exposing them as complex CLI flags.

## 5. Data Models
### `Contents`
The root container representing the `Contents.json` file. It maps directly to the Xcode asset catalog structure.

### `Image`
Represents an individual asset requirement.
- **Attributes**: `size`, `scale`, `idiom`, `platform`.
- **Computed Logic**:
    - `outputName`: Generates a deterministic filename based on attributes (e.g., `mac_1024x1024_1x.png`).
    - `paddingRatio`: Returns `0.1` for `mac` idiom to account for the standard icon safe area.
    - `cornerRatio`: Returns `0.2` for `mac` idiom to apply standard squircle clipping.

## 6. Technical Specifications
### Error Handling
- **`ImageConverterError`**: Handles PDF access issues, empty documents, and graphics context failures.
- **`XCAFillError`**: Handles high-level logic failures, such as missing or malformed property sets in `Contents.json`.

### Rendering Pipeline
1. Load PDF document via `CGPDFDocument`.
2. Calculate target dimensions based on `size * scale`.
3. Create a bitmap `CGContext` with premultiplied alpha.
4. Apply clipping paths (e.g., rounded corners for macOS).
5. Apply transformations (scaling and translation for padding).
6. Draw PDF page into context.
7. Finalize and write to disk using `CGImageDestination`.

## 7. Performance & Scalability
- **Memory Efficiency**: The tool processes images sequentially to keep the memory footprint low, avoiding concurrent loading of multiple high-resolution bitmaps.
- **Performance**: Leveraging `CoreGraphics` ensures hardware-accelerated rendering and high-quality interpolation for downscaling.

## 8. Testing Strategy
- **Unit Testing**: Focused on `Image` model logic (name generation, dimension parsing).
- **Integration Testing**: End-to-end verification by providing a sample `.appiconset` and a source PDF, then validating the existence and dimensions of the resulting PNG files.
