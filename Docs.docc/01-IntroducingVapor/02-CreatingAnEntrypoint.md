# 1.2 Creating an entrypoint

@Metadata {
    @PageKind(sampleCode)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Create the entry point for your server application using the @main attribute and a static main() method.

## Step 2: Examine Sources

The `Sources` directory structure depends on your Swift tools version.

### Legacy setup

Before Swift 6.2 tools, the `Sources` directory contains a single file named `main.swift`.

If this is your setup, delete `main.swift`. Select the file in the explorer and either use Command-Delete
(Ctrl-Delete) or Ctrl-Click the file and select Delete from the context menu.

Create a new folder named `PollsApp` inside `Sources`. Ctrl-Click on `Sources` and choose `New Folder...` from
the context menu.

Name the new folder `PollsApp`.

### Modern setup

Starting with Swift 6.2 tools, the `Sources` directory already contains a `PollsApp` directory with a file
named `PollsApp.swift`.

Delete `PollsApp.swift` so your starting point matches the following directions. Select the file in the
explorer and either use Command-Delete (Ctrl-Delete) or Ctrl-Click the file and select Delete from the context
menu.

## Create Entrypoint.swift

Create a new file named `Entrypoint.swift` inside `Sources/PollsApp`.

Ctrl-Click on `PollsApp` and choose `New File...` from the context menu.

> Note: Make sure you have selected `PollsApp` and not `Sources`.

Name the file `Entrypoint.swift`. This is a commonly used name for the entry point to the running server.

To begin, add the following code to stub out a struct named `Entrypoint`.

```swift
struct Entrypoint {

}
```

Save the file.

## Run the package

Run the package using the Run and Debug button, the menu item `Run > Start Debugging`, or the keyboard
shortcut F5.

You can also run the package from the terminal (Terminal > New Terminal or Ctrl-Shift-\) with
`swift run`.

You should get no output.

Two changes are needed to tell the package what to do when it executes.

> Note: It is often helpful to clean the package using `swift package clean` from the terminal before running
> it again. Sometimes you have to restart VS Code and the terminal. From the terminal you can always run the
> package using `swift run`.

## Set the entry point

Configure `Entrypoint.swift` as the entry point for the executable package when you run it.

To observe when this works, print something to the console when the package runs.

This configuration requires two things:

- `Entrypoint` needs a method named `main()` that is static—in other words, `main` belongs to the
  `Entrypoint` type and not to any particular instance.
- `Entrypoint` needs annotation with `@main`

### main()

Add a `static main()` method.

```swift
struct Entrypoint {
    static func main() {
        print("Hello, Server!")
    }
}
```

> Note: In VS Code sometimes the file will get out of sync. Notice if the name of the file appears in red
> perhaps with a number after it such as `Entrypoint.swift 1`. Save your work and bring up the Command Palette
> (Shift - Command - P) and choose: `Developer: Reload Window`.

Run the package. It runs but nothing is printed. You have satisfied one of the two requirements.

### @main

Add the annotation `@main` to make `main()` in `Entrypoint` the entry point.

```swift
@main
struct Entrypoint {
    static func main() {
        print("Hello, Server!")
    }
}
```

The `@main` attribute can apply to only one type in a module. This attribute was automatically added to
`PollsApp.swift` when you created the package. Open `PollsApp.swift` and delete the `@main` attribute from the
file.

## Switch to an enum

Make one small refinement. `Entrypoint` only exists as a starting point and a place to put `main()`. You do
not want anyone to create an instance of it.

To ensure this, change `Entrypoint` to an enum with no cases.

```swift
@main
enum Entrypoint {
    static func main() {
        print("Hello, Server!")
    }
}
```

> Note: Using an enum is the default in the standard Vapor tools for creating a new Vapor project.

The package runs as before.

Next, install Vapor and begin to transition this package to a server application.
