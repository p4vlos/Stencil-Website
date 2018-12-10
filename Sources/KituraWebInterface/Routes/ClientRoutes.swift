import Foundation
import KituraStencil
import Kitura

func initializeClientRoutes(app: App) {
  // 1 With Kitura, you have a choice between templating engines. This tutorial uses Stencil, but you can choose from others such as Mustache or Markdown.
  app.router.setDefault(templateEngine: StencilTemplateEngine())
  // 2 Here you set up a handler to serve the static files in the public directory.
  app.router.all(middleware: StaticFileServer())
  
  // 3 This is actual definition for your route. Notice how you override the main home page path? This means this route will respond when you visit http://localhost:8080
  app.router.get("/") { _, response, _ in
    // 4 This is where you define the context to pass into your rendered response. The render function does not accept nil for a context; instead, you should always provide a context of type [String: Any].
    let context: [String: Any] = [:]
    // 5 Notice that, because you set Stencil as the default template engine, you can leave off the default .stencil extension when referring to templates.
    try response.render("home", context: context)
  }
}