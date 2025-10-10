# Repository Guidelines

## Project Structure & Module Organization
STTextKitPlus is a Swift Package library defined in `Package.swift`. Core source files live in `Sources/STTextKitPlus` and are organized by the AppKit/TextKit type they extend (for example, `NSTextLayoutManager.swift` or `NSRange.swift`). Keep new APIs grouped in type-specific extensions and mirror the filename to the primary type. Introduce shared fixtures or sample assets under a new `Resources/` directory only when required by the tests.

## Build, Test, and Development Commands
- `swift build` compiles the library for the active platform; run it before opening a pull request.
- `swift test` executes the Swift Package Manager test suite once a test target is defined.
- `swift package generate-xcodeproj` (optional) produces an Xcode project when interactive debugging is needed.

## Coding Style & Naming Conventions
Use Swift 5.7+ and follow the Swift API Design Guidelines. Indent with four spaces and place opening braces on the same line as declarations. Prefer extensions scoped to a single type and name files after that type (`NSTextRange+Selection.swift` when adding focused behavior). Public APIs should use descriptive, lowerCamelCase names, while implementation details stay `private` or `internal`.

## Testing Guidelines
Adopt XCTest and place specs under `Tests/STTextKitPlusTests`. Name test files and classes after the symbol under test (`NSTextLayoutManagerTests`). Cover boundary scenarios around TextKit selection math and document layout calculations, especially where platform availability differs. Run `swift test` locally and ensure new tests pass on macOS and iOS simulators where applicable.

## Commit & Pull Request Guidelines
Commit messages are short, imperative, and start with a capital verb (`Fix`, `Add`, `Remove`) as seen in existing history. Squash work-in-progress commits before opening a pull request. Pull requests should outline motivation, summarize API changes, note any platform caveats, and link related issues. Include screenshots or code snippets when behavior changes are visual or interaction-driven.
