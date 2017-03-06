import Vapor
import VaporMySQL

let drop = Droplet()
try drop.addProvider(VaporMySQL.Provider.self)
drop.preparations.append(User.self)
drop.preparations.append(Pet.self)

drop.get("users") { req in
  let users = try User.query().all()
  return try users.array.makeJSON()
}

drop.get("users", Int.self) { req, id in
  let user = try User.query().filter("id", id).all()
  return try user.array.makeJSON()
}

drop.get("users", Int.self, "/pets") { req, userId in
  let pets = try Pet.query().filter("user_id", userId).all()
  return try pets.array.makeJSON()
}

drop.post("users") { req in
  guard let name = req.data["name"]?.string else {
    throw Abort.badRequest
  }
  
  var newUser = User(name: name)
  try newUser.save()
  return newUser
}

drop.patch("users") { req in
  guard let name = req.data["name"]?.string else {
    throw Abort.badRequest
  }
  guard let userId = req.data["userId"]?.int else {
    throw Abort.badRequest
  }
  var user = try User.query().filter("id", userId).first()
  user?.name = name
  try user?.save()
  return user!
}

drop.delete("users", User.self) { req, user in
  try user.delete()
  return JSON([
    "status": "204"
    ])
}

drop.post("pets") { req in
  guard let name = req.data["name"]?.string else {
    throw Abort.badRequest
  }
  guard let birthday = req.data["birthday"]?.string else {
    throw Abort.badRequest
  }
  guard let descriptions = req.data["descriptions"]?.string else {
    throw Abort.badRequest
  }
  guard let userId = req.data["userId"]?.string else {
    throw Abort.badRequest
  }
  let user = try User.query().filter("id", userId)
  if try user.count() > 0 {
  var newPet = Pet(userId: Node(userId), name: name, birthday: birthday, descriptions: descriptions)
  try newPet.save()
  return newPet
  }
  else {
    return JSON([
      "status": 404,
      "error": "Пользователь не найден"
      ])
  }
}

drop.get("pets") { req in
  let pets = try Pet.query().all()
  return try pets.array.makeJSON()
}

drop.patch("pets") { req in
  guard let id = req.data["id"]?.int else {
    throw Abort.badRequest
  }
  guard let name = req.data["name"]?.string else {
    throw Abort.badRequest
  }
  guard let birthday = req.data["birthday"]?.string else {
    throw Abort.badRequest
  }
  guard let descriptions = req.data["descriptions"]?.string else {
    throw Abort.badRequest
  }
  var pet = try Pet.query().filter("id", id).first()
  pet?.name = name
  pet?.birthday = birthday
  pet?.descriptions = descriptions
  try pet?.save()
  return try pet!.makeJSON()
}
drop.delete("pets", User.self) { req, pet in
  try pet.delete()
  return JSON([
    "status": "204"
    ])
}

drop.run()
