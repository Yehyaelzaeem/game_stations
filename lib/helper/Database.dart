import 'dart:async';
import 'dart:io';
import 'ClientModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DBProvider {
  DBProvider();
  static final DBProvider db = DBProvider();
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "assask.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE User ("
              "id INTEGER PRIMARY KEY,"
              "username TEXT,"
              "email TEXT,"
              "password TEXT,"
              "phone TEXT,"
              "country TEXT,"
              "userid TEXT,"
              "location TEXT,"
              "lang TEXT,"
              "token TEXT,"
              "blocked BIT"
              ")");
        });
  }
  newClient(Client newClient) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db!.rawQuery("SELECT MAX(id)+1 as id FROM User");
    Object? id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into User (id,username,email,password,phone,country,userid,location,lang,token,blocked)"
            " VALUES (?,?,?,?,?,?,?,?,?,?,?)",
        [0, newClient.username, newClient.email,newClient.password,newClient.phone.toString(),
          newClient.country,newClient.userId,newClient.location,newClient.lang
          ,newClient.token,newClient.blocked]);
    print("raw:"+raw.toString());
    return raw.toString();
  }
  blockOrUnblock(Client client) async {
    final db = await database;
    Client blocked = Client(
        id: client.id,
        username: client.username,
        email: client.email,
        password: client.password,
        phone: client.phone,
        country: client.country,
        userId: client.userId,
        location: client.location,
        lang: client.lang,
        token: client.token,
        blocked: client.blocked);
    var res = await db!.update("User", blocked.toMap(),
        where: "id = ?", whereArgs: [client.id]);
    return res;
  }
  updateClient(Client newClient) async {
    final db = await database;
    var res = await db!.update("User", newClient.toMap(),
        where: "id = ?", whereArgs: [newClient.id]);
    return res;
  }
  getClient(int id) async {
    final db = await database;
    var res = await db!.query("User", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }
  Future<List<Client>> getBlockedClients() async {
    final db = await database;
    // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
    var res = await db!.query("User", where: "blocked = ? ", whereArgs: [1]);
    List<Client> list =
    res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    print("works getBlockedClients"+res.last.toString());
    return list;
  }
  Future<List<Client>> getAllClients() async {
    final db = await database;
    var res = await db!.query("User");
    List<Client> list =
    res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    if(res==null||res.length==0){
      print("no user founded ");
    }else{
      print("works getAllClients"+res.toString());
    }
    return list;
  }
  Future<String> checkExistdb()async{
    final db = await database;
    var res = await db!.query("User");
    return res.length.toString();
  }
  Future<String> getEmail(id)async{
    final db = await database;
//    var res = await db.query("SELECT * FROM SELECT 'email' FROM 'User' WHERE 'id' = ?");
    var res = await db!.query("User", where: "id = ?", whereArgs: [0]);
    return res.toString().split("email:").last.toString().split(",").first.toString();
  }
  Future<String> getUsername(id)async{
    final db = await database;
//    var res = await db.query("SELECT * FROM SELECT 'email' FROM 'User' WHERE 'id' = ?");
    var res = await db!.query("User", where: "id = ?", whereArgs: [0]);
    return res.toString().split("username:").last.toString().split(",").first.toString();
  }
  Future<String> getUserpassword(id)async{
    final db = await database;
//    var res = await db.query("SELECT * FROM SELECT 'email' FROM 'User' WHERE 'id' = ?");
    var res = await db!.query("User", where: "id = ?", whereArgs: [0]);
    return res.toString().split("password:").last.toString().split(",").first.toString();
  }
  Future<String> getuserPhone(id)async{
    final db = await database;
//    var res = await db.query("SELECT * FROM SELECT 'email' FROM 'User' WHERE 'id' = ?");
    var res = await db!.query("User", where: "id = ?", whereArgs: [0]);
    return res.toString().split("phone:").last.toString().split(",").first.toString();
  }
  Future<String> getuserCountry(id)async{
    final db = await database;
//    var res = await db.query("SELECT * FROM SELECT 'email' FROM 'User' WHERE 'id' = ?");
    var res = await db!.query("User", where: "id = ?", whereArgs: [0]);
    return res.toString().split("country:").last.toString().split(",").first.toString();
  }
  Future<String> getuserId(id)async{
    final db = await database;
//    var res = await db.query("SELECT * FROM SELECT 'email' FROM 'User' WHERE 'id' = ?");
    var res = await db!.query("User", where: "id = ?", whereArgs: [0]);
    return res.toString().split("userid:").last.toString().split(",").first.toString();
  }
  Future<String> getCurrentLang(id)async{
    final db = await database;
//    var res = await db.query("SELECT * FROM SELECT 'email' FROM 'User' WHERE 'id' = ?");
    var res = await db!.query("User", where: "id = ?", whereArgs: [0]);
    return res.toString().split("lang:").last.toString().split(",").first.toString();
  }
  Future<String> getUserToken(id)async{
    final db = await database;
//    var res = await db.query("SELECT * FROM SELECT 'email' FROM 'User' WHERE 'id' = ?");
    var res = await db!.query("User", where: "id = ?", whereArgs: [0]);
    return res.toString().split("token:").last.toString().split(",").first.toString();
  }
  deleteClient(int id) async {
    final db = await database;
    return db!.delete("User", where: "id = ?", whereArgs: [id]);
  }
  deleteAll() async {
    final db = await database;
//    db.rawDelete("Delete * from Client");
    db!.delete("User");
    print("User deleted");
  }

}