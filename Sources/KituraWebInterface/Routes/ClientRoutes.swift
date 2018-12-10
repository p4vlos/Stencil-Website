import Foundation
import KituraStencil
import Kitura

func initializeClientRoutes(app: App) {
  // 1
  app.router.setDefault(templateEngine: StencilTemplateEngine())
  // 2
  app.router.all(middleware: StaticFileServer())
  
  // 3
  app.router.get("/") { _, response, _ in
    // 4
    let context: [String: Any] = [:]
    // 5
    try response.render("home", context: context)
  }
}