# XCAFill

## 1. Product Vision
**XCAFill** aims to be the definitive tool for Apple platform developers to bridge the gap between high-fidelity vector design and Xcode asset catalogs. By automating the mundane and error-prone process of manually resizing icons, XCAFill empowers developers to focus on building features while ensuring their applications look pixel-perfect across all Apple platforms.

The core vision is **"One Source, Infinite Scale"**—maintaining a single, high-quality vector master (PDF) that automatically satisfies the complex requirements of any Xcode asset catalog.

## 2. Core Objectives
- **Efficiency:** Reduce the manual overhead of icon generation from minutes to milliseconds.
- **Consistency:** Guarantee that every icon size and scale is perfectly derived from the same source, eliminating design drift.
- **Compliance:** Built-in awareness of Apple's platform-specific design guidelines (e.g., macOS-specific safe area padding and corner rounding).
- **Simplicity:** A CLI-first approach that integrates seamlessly into developer workflows and build scripts.

## 3. User Problem & Value Proposition
### The Problem
Apple's ecosystem requires dozens of icon variations (iPhone, iPad, Mac, Watch, TV) in multiple resolutions (@1x, @2x, @3x). Managing these manually in design software like Figma or Sketch and exporting them individually to `.appiconset` folders is:
1.  **Tedious:** Dozens of export settings to manage.
2.  **Error-Prone:** Easy to misplace a file or use the wrong scale.
3.  **Fragile:** Any design tweak requires a full re-export and re-import.

### The Value Proposition
XCAFill reads the requirements directly from the `Contents.json` provided by Xcode and populates the folder with the correct PNGs. If the design changes, simply update the source PDF and run one command.

## 4. Target Audience & User Personas
### Target Audience
Primary: iOS, macOS, watchOS, and visionOS developers.
Secondary: Product designers who manage asset handoffs to developers.

### User Personas
- **The Independent Developer:** Needs a fast, "set it and forget it" way to handle icons for their side projects without expensive design tooling.
- **The Agency Engineer:** Manages multiple enterprise apps and needs a scriptable way to ensure icon consistency across large-scale projects.
- **The Design Lead:** Wants to ensure that the final product exactly matches the vector source without relying on manual export steps by developers.

## 5. Feature Roadmap

### Short-Term (0-6 Months)
- **SVG Support:** Transition from PDF-only to supporting SVG as a primary vector input.
- **Image Set Support:** Expand beyond `AppIcon` sets to standard `ImageSet` catalogs (e.g., UI icons, buttons).
- **Verbose Reporting:** Provide detailed logs of which assets were generated and their dimensions.

### Medium-Term (6-12 Months)
- **Xcode Extension:** A "Right-Click -> Fill with Source" integration directly inside Xcode's project navigator.
- **visionOS Refinements:** Specialized support for multi-layered 3D icons in visionOS.
- **Dry-Run Mode:** Allow users to see what *would* be generated without writing files.

### Long-Term (12+ Months)
- **CI/CD Integration:** A "Ready-to-use" GitHub Action for automated icon generation during build processes.
- **Smart Compression:** Automatic integration with tools like `pngquant` or `optipng` to minimize binary size.
- **Cloud Source Support:** Ability to pull source vectors directly from a Figma or Sketch cloud URL.

## 6. Feature Prioritization
Core value is derived from **Accuracy** and **Automation**.
- **P0 (Critical):** Precision rendering of PDFs into `.appiconset` requirements. macOS-specific padding/clipping logic is core because it is the hardest to do manually.
- **P1 (Important):** SVG support (modern industry standard) and scriptability (CLI ergonomics).
- **P2 (Nice to Have):** GUI wrappers or Xcode extensions. While useful, they don't solve the core technical bottleneck that the CLI addresses.

## 7. Iteration Strategy
Our strategy is rooted in **Developer-Centric Feedback**:
1.  **Observational Research:** Monitoring changes in Apple's `Contents.json` schema (e.g., when visionOS was introduced) to ensure XCAFill is always ahead of official requirements.
2.  **Dogfooding:** Using XCAFill in our own internal app development to identify friction points in the CLI interface.
3.  **Community Contributions:** Maintaining a lean core library that allows contributors to add new platform-specific "idioms" (e.g., custom padding for CarPlay).

## 8. Release Strategy & Onboarding
- **Distribution:** Distributed via Homebrew for macOS users and as a Swift Package for integration into other tools.
- **Onboarding Goal:** "First Icon in 60 Seconds." A minimal CLI interface (`xcafill source.pdf .`) ensures that new users can see value immediately without complex configuration files.
- **Documentation:** A focus on "Recipe-based" docs (e.g., "How to generate icons for a multi-platform app").

## 9. Success Metrics & KPIs
- **Adoption:** Number of unique installs via Homebrew.
- **Workflow Savings:** Estimated time saved per icon set (Target: < 2 seconds for a full 20+ image set).
- **Error Rate:** Number of reported "invalid sizing" bugs compared to successful fills.
- **Retention:** Number of projects where XCAFill is integrated into the `Build Phases` of an Xcode project.

## 10. Future Opportunities
- **Icon Templating:** Moving beyond 1:1 conversion to applying "Filters" (e.g., generating dark mode or tinted versions of an icon automatically).
- **Unified Branding:** Using a single configuration file to manage icons across multiple apps in a workspace, ensuring brand consistency at the organizational level.
