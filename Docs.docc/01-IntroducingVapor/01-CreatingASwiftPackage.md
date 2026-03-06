# 1.1 Creating a Swift package

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Create a Swift package with executable target and platform requirements for your Vapor server application.

## Step 1: Install and configure an editor

You can use Xcode, VS Code, or Neovim for this tutorial. Choose the editor that works best for your workflow.

## Step 2: Create the default package

```bash
mkdir -p ~/Education/301-SwiftServerFundamentals/
cd ~/Education/301-SwiftServerFundamentals/
swift package init --type executable --name PollsApp
```

## Step 3: Inspect the package

Before you begin, copy two files not included in `swift package init` into your project:

- `.swift-version` specifies the Swift version for your project.
- `.swift-format` defines styling rules that ensure consistency.

Your instructor will provide these files at the start of the workshop.

Next, open `Package.swift`.

```swift
// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "PollsApp",
    targets: [
        .executableTarget(
            name: "PollsApp"
        ),
    ]
)
```

This code declares a package named `PollsApp` with a single executable target that shares the same name. The
comment specifies the minimum Swift tools version as 6.2, which is required for package manifests.

Update the file to specify that this package runs on macOS 26 (Tahoe) or later:

```swift
...
let package = Package(
    name: "PollsApp",
    platforms: [.macOS(.v26)],
...
```

Next, add an entry point for what becomes the server application.
