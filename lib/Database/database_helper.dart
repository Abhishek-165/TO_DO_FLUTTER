  import 'dart:io';
import "dart:async";
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper
{

  static final _dbname ="myDatabase.db";
  static final _dbversion =1;
  static final _tableName ="taskdetails";
  static final columnId = '_id';
  static final columntitle ="_title";
  static final columndate ="_date";
  static final columnpriority ="_priority";
  static final columnstatus = "_status";


// making it a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;


  Future<Database> get database async
  {
      if(_database != null)  return _database;

      _database = await _initateDatabase();
            return _database;
            
        }
      
        _initateDatabase() async 
        {
          Directory directory = await getApplicationDocumentsDirectory();
          String path = join(directory.path,_dbname);
          return await openDatabase(path,version:_dbversion,onCreate: _onCreate);

        }

        // create a table in the database 

          Future _onCreate(Database db, int version)
            async {
           await db.execute(

              '''
            CREATE TABLE $_tableName(
              $columnId INTEGER PRIMARY KEY,
              $columntitle TEXT Not NULL,
              $columndate TEXT Not NULL,
              $columnpriority TEXT Not NULL,
              $columnstatus TEXT Not NULL
              
              
              )
              '''
            );
          }

          // insert a row in the table

          // ignore: unused_element
          Future insert(Map<String,dynamic> row) async
          {
            Database db = await instance.database;
            return await db.insert(_tableName,row);
          }


          // returns all the data in the form of list

          Future SpecificQuery(int id) async
          {
             Database db = await instance.database;
             //return await database.rawUpdate('UPDATE taskdetails SET columnstatus = ${value} WHERE id = ${id}');
             return await db.rawQuery('SELECT * FROM taskdetails WHERE _id =?',[id]);

          }

          Future<List<Map<String,dynamic>>> queryAll() async
          {
            Database db = await instance.database;
            return await db.query(_tableName);
          }
    
          Future update(int id,String value) async {
          Database db = await instance.database;
         return await db.rawUpdate('''
    UPDATE ${DatabaseHelper._tableName} 
    SET ${DatabaseHelper.columnstatus} = ? 
    WHERE ${DatabaseHelper.columnId} = ?
    ''',
    [ value, id]);
        //return await database.rawUpdate('UPDATE taskdetails SET columnstatus = ${value} WHERE id = ${id}');
        }

        Future updateQuery(int id,String name, String date, String priority) async
        {
          
          Database db = await instance.database;
          return await db.rawUpdate(
            '''
            UPDATE ${DatabaseHelper._tableName}
            SET ${DatabaseHelper.columntitle}=?,${DatabaseHelper.columndate}=?,${DatabaseHelper.columnpriority}=?
            WHERE ${DatabaseHelper.columnId} = ?
            ''',
            [name,date,priority,id]
          );

        }

        Future deleteQuery(int id) async
        {
          Database db = await instance.database;
          return await db.rawDelete(
          '''
          DELETE FROM ${DatabaseHelper._tableName}
           WHERE ${DatabaseHelper.columnId} = ?;
          ''',
          [id]
          );
        }

        


}
