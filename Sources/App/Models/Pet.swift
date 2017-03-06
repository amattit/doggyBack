import Vapor
import Fluent

final class Pet: Model {
  var id: Node?
  var userId: Node?
  var name: String
  var birthday: String
  var descriptions: String
  var isArchive:Bool = false
  var exists: Bool = false
		
  
  init(userId:Node, name: String, birthday:String, descriptions:String) {
    self.userId = userId
    self.name = name
    self.birthday = birthday
    self.descriptions = descriptions
  }
  
  init(node: Node, in context: Context) throws {
    id = try node.extract("id")
    userId = try node.extract("user_Id")
    name = try node.extract("name")
    birthday = try node.extract("birthday")
    descriptions = try node.extract("descriptions")
    isArchive = try node.extract("isArchive")
  }
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [
      "id": id,
      "user_Id": userId,
      "name": name,
      "birthday": birthday,
      "descriptions": descriptions,
      "isArchive": isArchive
      ])
  }
  
  static func prepare(_ database: Database) throws {
    try database.create("pet") { pet in
      pet.id()
      pet.int("user_Id")
      pet.string("name")
      pet.string("birthday")
      pet.string("descriptions")
      pet.bool("isArchive")
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("pet")
  }
}

