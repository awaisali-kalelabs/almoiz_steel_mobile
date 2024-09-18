import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';

// Database Helper Class
class DatabaseHelper extends GetxService {
  static DatabaseHelper get to => Get.find();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'userData.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // Create userData table
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE userData(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userID INTEGER NOT NULL,
        name TEXT NOT NULL,
        password TEXT NOT NULL,
        timeStamp TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE outletImages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userID INTEGER NOT NULL,
        imagePath1 TEXT NOT NULL,
        imagePath2 TEXT NOT NULL,
        imagePath3 TEXT NOT NULL,
        lat REAL NOT NULL,
        lng REAL NOT NULL,
        accuracy REAL NOT NULL,
        createdOn TEXT NOT NULL,
        OrderID INTEGER NOT NULL,
        DeviceID TEXT NOT NULL
      )
    ''');
    /// attendance
    await db.execute('''
    CREATE TABLE attendanceRecords(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      mobile_request_id INTEGER,
      user_id INTEGER,
      attendance_type_id INTEGER,
      mobile_timestamp TEXT,
      lat REAL,
      lng REAL,
      accuracy INTEGER,
      is_uploaded INTEGER,
      uuid TEXT,
      image_path TEXT,
      is_photo_uploaded INTEGER
    )
  ''');

  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS outletImages(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userID INTEGER NOT NULL,
          imagePath1 TEXT NOT NULL,
          imagePath2 TEXT NOT NULL,
          imagePath3 TEXT NOT NULL,
          lat REAL NOT NULL,
          lng REAL NOT NULL,
          accuracy REAL NOT NULL,
          createdOn TEXT NOT NULL,
          OrderID INTEGER NOT NULL,
          DeviceID TEXT NOT NULL
        )
      ''');
      ///attendance
      await db.execute('''
        CREATE TABLE IF NOT EXISTS attendanceRecords(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          mobile_request_id INTEGER,
          user_id INTEGER,
          attendance_type_id INTEGER,
          mobile_timestamp TEXT,
          lat REAL,
          lng REAL,
          accuracy INTEGER,
          is_uploaded INTEGER,
          uuid TEXT,
          image_path TEXT,
          is_photo_uploaded INTEGER
        )
      ''');
    }
  }
///table for user data
  // Insert a new user
  Future<void> addUserData({
    required int userID,
    required String name,
    required String password,
    required String timestamp,
  }) async {
    // Get a reference to the database
    final db = await database;

    // Insert the user data into the 'userData' table
    await db.insert(
      'userData',  // Table name
      {
        'userID': userID,
        'name': name,
        'password': password,
        'timestamp': timestamp,  // Timestamp of creation
      },
    );
  }

  // Read all users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('userData');
  }

  // Update a user
  Future<int> updateUser(int id, int userID, String name, String password) async {
    final db = await database;
    String timeStamp = DateTime.now().toString();
    Map<String, dynamic> data = {
      'userID': userID,
      'name': name,
      'password': password,
      'timeStamp': timeStamp,
    };
    return await db.update('userData', data, where: 'id = ?', whereArgs: [id]);
  }

  // Delete a user
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('userData', where: 'id = ?', whereArgs: [id]);
  }

  /// functions for outlet images
  Future<void> addOutletImage({
    required int userID,
    required String imagePath1,
    required String imagePath2,
    required String imagePath3,
    required String lat,
    required String lng,
    required String accuracy,
    required String createdOn,
    required int orderID,
    required String deviceID,
  }) async {
    // Get a reference to the database
    final db = await database;

    // Insert the image data into the 'outletImages' table
    await db.insert(
      'outletImages',  // Table name
      {
        'userID': userID,
        'imagePath1': imagePath1,  // First image path
        'imagePath2': imagePath2,  // Second image path
        'imagePath3': imagePath3,  // Third image path
        'lat': lat,                // Latitude
        'lng': lng,                // Longitude
        'accuracy': accuracy,      // Accuracy of location
        'createdOn': createdOn,    // Timestamp when data was created
        'OrderID': orderID,        // Order ID associated with the outlet
        'DeviceID': deviceID,      // Device ID
      },
    );
  }


  // Read all outlet images
  Future<List<Map<String, dynamic>>> getAllOutletImages() async {
    final db = await database;
    return await db.query('outletImages');
  }

  // Update an outlet image entry
  Future<int> updateImage(int id, String imagePath1, String imagePath2, String imagePath3, double lat, double lng, double accuracy, int orderID, String deviceID) async {
    final db = await database;
    String createdOn = DateTime.now().toString();
    Map<String, dynamic> data = {
      'imagePath1': imagePath1,  // First image path
      'imagePath2': imagePath2,  // Second image path
      'imagePath3': imagePath3,  // Third image path
      'lat': lat,
      'lng': lng,
      'accuracy': accuracy,
      'createdOn': createdOn,
      'OrderID': orderID,
      'DeviceID': deviceID,
    };
    return await db.update('outletImages', data, where: 'id = ?', whereArgs: [id]);
  }

  // Delete an outlet image entry
  Future<int> deleteImage(int id) async {
    final db = await database;
    return await db.delete('outletImages', where: 'id = ?', whereArgs: [id]);
  }

  /// attendance functions


  Future<void> addAttendanceRecord({
    required int mobileRequestId,
    required int userId,
    required int attendanceTypeId,
    required String mobileTimestamp,
    required double lat,
    required double lng,
    required int accuracy,
    required int isUploaded,
    required String uuid,
    required String imagePath,
    required int isPhotoUploaded,
  }) async {
    final db = await database;

    await db.insert(
      'attendanceRecords',  // Table name
      {
        'mobile_request_id': mobileRequestId,
        'user_id': userId,
        'attendance_type_id': attendanceTypeId,
        'mobile_timestamp': mobileTimestamp,
        'lat': lat,
        'lng': lng,
        'accuracy': accuracy,
        'is_uploaded': isUploaded,
        'uuid': uuid,
        'image_path': imagePath,
        'is_photo_uploaded': isPhotoUploaded,
      },
    );
  }

  // Read all attendance records
  Future<List<Map<String, dynamic>>> getAllAttendanceRecords() async {
    final db = await database;
    return await db.query('attendanceRecords');
  }

  // Update an attendance record
  Future<int> updateAttendanceRecord({
    required int id,
    required int mobileRequestId,
    required int userId,
    required int attendanceTypeId,
    required String mobileTimestamp,
    required double lat,
    required double lng,
    required int accuracy,
    required int isUploaded,
    required String uuid,
    required String imagePath,
    required int isPhotoUploaded,
  }) async {
    final db = await database;

    return await db.update(
      'attendanceRecords',
      {
        'mobile_request_id': mobileRequestId,
        'user_id': userId,
        'attendance_type_id': attendanceTypeId,
        'mobile_timestamp': mobileTimestamp,
        'lat': lat,
        'lng': lng,
        'accuracy': accuracy,
        'is_uploaded': isUploaded,
        'uuid': uuid,
        'image_path': imagePath,
        'is_photo_uploaded': isPhotoUploaded,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete an attendance record
  Future<int> deleteAttendanceRecord(int id) async {
    final db = await database;

    return await db.delete(
      'attendanceRecords',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
