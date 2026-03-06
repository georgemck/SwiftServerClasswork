# 4.5 File middleware

@Metadata {
    @PageKind(article)
    @SupportedLanguage(swift)
    @PageColor(blue)
}

Step 5

## Serving the openapi.yaml file

You will add routes so that when someone visits the `/` page they can see the OpenAPI documentation.

First, create a new folder named `Public` within `Sources/PollsApp`. The folder you create will have this path:
`Sources/PollsApp/Public`.

Then create a new file named `openapi.html` within the `Public` folder. Add the following code to the file:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" type="text/css" href="//unpkg.com/swagger-ui-dist@5/swagger-ui.css">
  <title>PollsApp</title>
<body>
  <div id="sample" />
  <script src="//unpkg.com/swagger-ui-dist@5/swagger-ui-bundle.js"></script>
  <script>
    window.onload = function() {
      const ui = SwaggerUIBundle({
        url: "openapi.yaml",
        dom_id: "#sample",
        deepLinking: true,
        validatorUrl: "none"
      })
    }
  </script>
</body>
</html>
```

This file uses a Content Delivery Network (CDN) to download the `swagger-ui` which displays the `openapi.yaml`
document in a format that reads well for consumers of the API.

Finally, move your `openapi.yaml` file to the `Public` folder. Drag the file into the folder, and if a confirmation
screen appears, click "Move" to confirm that you want to move this file.

## Updating Package.swift

By convention, the files in the `Public` folder are excluded from `Package.swift`. Update your `Package.swift` file
accordingly, to exclude the `Public` folder:

```swift
...
    .executableTarget(
        name: "PollsApp",
        dependencies: [
            ... // dependencies listed here
        ],
        exclude: [
            "Public/"
        ],
        plugins: [
            ... // plugins listed here
        ]
    )
...
```

## Creating a symlink for Swift OpenAPI

The Swift OpenAPI packages expect you to have a file named `openapi.yaml` in the root of the target. However, your
`openapi.yaml` file is now in the `Public` directory. To create a symlink, `cd` into the `Sources/PollsApp` folder and
create a relative symlink from `Public/openapi.yaml` to the `openapi.yaml` file.

```bash
cd Sources/PollsApp
mv openapi.yaml Public/
ln -s Public/openapi.yaml openapi.yaml
```

Now you have both the original `Public/openapi.yaml` file and a symlink in `Sources/PollsApp` that links to the file.
Changes to the `Public/openapi.yaml` file are automatically visible via the symlink, which is accessed when generating
the types.

## Adding the file middleware

The final step here is to serve everything in the `Public` folder via HTTP and to introduce a redirect route so that
visitors hitting the root of the application (which locally is `http://localhost:8080`) will see the OpenAPI document.

To do that, update the `configureServer` function in the `ServerService.swift`:

```swift
func configureServer(_ application: Application) async throws -> Service {
    // Keep existing route configuration
    routes(application)

    // Create API handler for request processing
    let handler = APIHandler()

    // Register OpenAPI-generated handlers with Vapor transport
    let transport = VaporTransport(routesBuilder: application)
    try handler.registerHandlers(
        on: transport,
        serverURL: Servers.Server1.url(),
        configuration: .init()
    )

    // Configure static file serving from PollsApp Public directory
    application.middleware.use(FileMiddleware(publicDirectory: "Sources/PollsApp/Public"))

    // Configure OpenAPI documentation routes
    application.get("openapi") { $0.redirect(to: "/openapi.html", redirectType: .normal) }
    application.get { $0.redirect(to: "/openapi.html", redirectType: .normal) }

    return ServerService(application: application)
}
```

## Confirming visually

After completing the setup, run the server via Run and Debug. Then open `localhost:8080` in a web browser and view the
Swagger documentation.

> For this confirmation check, if you run the server via `swift run` you likely get an error in the browser.
>
> If running the server in Xcode, you may need to set a custom working directory:
>
> 1. From the menu, choose Product > Scheme > Edit Scheme.
> 2. Select the Run action, then click the Options tab.
> 3. Enable "Use Custom Working Directory" and set it to the folder containing Package.swift.

![File middleware](FileMiddleware.png)
