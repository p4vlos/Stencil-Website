import Foundation
import KituraStencil
import Kitura

func initializeClientRoutes(app: App) {
  // 1 With Kitura, you have a choice between templating engines. This tutorial uses Stencil, but you can choose from others such as Mustache or Markdown.
  app.router.setDefault(templateEngine: StencilTemplateEngine())
  // 2 Here you set up a handler to serve the static files in the public directory.
  app.router.all(middleware: StaticFileServer())
  
  // 3 This is actual definition for your route. Notice how you override the main home page path? This means this route will respond when you visit http://localhost:8080
//  app.router.get("/") { _, response, _ in
//    // 4 This is where you define the context to pass into your rendered response. The render function does not accept nil for a context; instead, you should always provide a context of type [String: Any].
//    let context: [String: Any] = [:]
//    // 5 Notice that, because you set Stencil as the default template engine, you can leave off the default .stencil extension when referring to templates.
//    try response.render("home", context: context)
//  }
    
    app.router.get("/") { _, response, _ in
        if let database = app.database {
            // 1 First, you call Persistence.getAll to retrieve all of the acronyms.
            Acronym.Persistence.getAll(from: database) { acronyms, error in
                guard let acronyms = acronyms else {
                    response.send(error?.localizedDescription)
                    return
                }
                var contextAcronyms: [[String: Any]] = []
                for acronym in acronyms {
                    // 2 You’ll soon add support for creating an Acronym, but for now, you only use those that already have an id within the database.
                    if let id = acronym.id {
                        // 3 In order for Stencil to read properties from your context, you must serialize them. Stencil doesn’t yet support automatic serialization through Codable so you do it the old fashioned way.
                        let map = ["short": acronym.short, "long": acronym.long, "id": id]
                        contextAcronyms.append(map)
                    }
                }
                // 4 Finally, you set the contextAcronyms using the key "acronyms". Later on, you’ll use this same key to access this array in HTML.
                do {
                    try response.render("home", context: ["acronyms": contextAcronyms])
                } catch let error {
                    response.send(error.localizedDescription)
                }
            }
        }
    }
}
