import Vapor
import Fluent

final class User: Model {
  var id: Node?
  var name: String
  var isArchive: Bool = false
  var exists: Bool = false
  
  init(name: String) {
    self.name = name
  }
  
  init(node: Node, in context: Context) throws {
    id = try node.extract("id")
    name = try node.extract("name")
    isArchive = try node.extract("isArchive")
  }
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "id": id,
      "name": name,
      "isArchive": isArchive
      ])
  }
  
  static func prepare(_ database: Database) throws {
    try database.create("user") { user in
      user.id()
      user.string("name")
      user.bool("isArchive")
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("user")
  }
}

extension User {
  func pets() throws -> Children<Pet> {
    return try children()
  }
}
