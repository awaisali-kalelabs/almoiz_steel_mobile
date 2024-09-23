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
      version: 9,
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

    /// outlets
    await db.execute("CREATE TABLE preSellOutletsTable ("
        "outlet_id INTEGER, "
        "outlet_name TEXT, "
        "day_number INTEGER, "
        "owner TEXT, "
        "address TEXT, "
        "telephone TEXT, "
        "nfc_tag_id TEXT, "
        "visit_type INTEGER, "
        "lat TEXT, "
        "lng TEXT, "
        "area_label TEXT, "
        "sub_area_label TEXT, "
        "is_alternate_visible INTEGER, "
        "pic_channel_id TEXT, "
        "channel_label TEXT, "
        "order_created_on_date TEXT, "
        "common_outlets_vpo_classifications TEXT, "
        "Visit TEXT, "
        "purchaser_name TEXT, "
        "purchaser_mobile_no TEXT, "
        "cache_contact_nic TEXT)");
    /// No Order table
    await db.execute('''
  CREATE TABLE  outletNoOrdersTable (
    id INTEGER ,
    outlet_id INTEGER,
    reason_type_id INTEGER,
    is_uploaded INTEGER DEFAULT 0,
    uuid TEXT,
    created_on TEXT,
    lat TEXT,
    lng TEXT,
    accuracy TEXT
  )
''');

  }


  Future<bool> columnExists(
      Database db, String tableName, String columnName) async {
    final List<Map<String, dynamic>> columns = await db.rawQuery(
      "PRAGMA table_info($tableName)",
    );
    for (var column in columns) {
      if (column['name'] == columnName) {
        return true;
      }
    }
    return false;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      if (!await columnExists(db, 'outletImages', 'IsUploaded')) {
        await db.execute(
            "ALTER TABLE outletImages ADD COLUMN IsUploaded INTEGER DEFAULT 0");
      }

      await db.execute('''
        CREATE TABLE IF NOT EXISTS outletImages(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userID INTEGER NOT NULL,
          imagePath1 TEXT NOT NULL,
          imagePath2 TEXT NOT NULL,
          imagePath3 TEXT NOT NULL,
          IsUploaded INTEGER DEFAULT 0,
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

      await db.execute(" CREATE TABLE IF NOT EXISTS preSellOutletsTable ("
          "outlet_id INTEGER, "
          "outlet_name TEXT, "
          "day_number INTEGER, "
          "owner TEXT, "
          "address TEXT, "
          "telephone TEXT, "
          "nfc_tag_id TEXT, "
          "visit_type INTEGER, "
          "lat TEXT, "
          "lng TEXT, "
          "area_label TEXT, "
          "sub_area_label TEXT, "
          "is_alternate_visible INTEGER, "
          "pic_channel_id TEXT, "
          "channel_label TEXT, "
          "order_created_on_date TEXT, "
          "common_outlets_vpo_classifications TEXT, "
          "Visit TEXT, "
          "purchaser_name TEXT, "
          "purchaser_mobile_no TEXT, "
          "cache_contact_nic TEXT)");

      await db.execute('''
  CREATE TABLE  IF NOT EXISTS outletNoOrdersTable (
    id INTEGER ,
    outlet_id INTEGER,
    reason_type_id INTEGER,
    is_uploaded INTEGER DEFAULT 0,
    uuid TEXT,
    created_on TEXT,
    lat TEXT,
    lng TEXT,
    accuracy TEXT
  )
''');
    }
  }

  ///table for user data
  // Insert a new user
  Future<void> addUserData({
    required String userID,
    required String name,
    required String password,
    required String timestamp,
  }) async {
    // Get a reference to the database
    final db = await database;

    // Insert the user data into the 'userData' table
    await db.insert(
      'userData', // Table name
      {
        'userID': userID,
        'name': name,
        'password': password,
        'timestamp': timestamp, // Timestamp of creation
      },
    );
  }

  Future<String?> getStoredUsername() async {
    final db =
        await database; // Assuming you have a method to get the database instance
    final List<Map<String, dynamic>> result =
        await db.query('userData', columns: ['userID'], limit: 1);
    print("UserID::${result.first['userID'].toString()}");
    if (result.isNotEmpty) {
      return result.first['userID'].toString();
    }
    return null;
  }

  // Read all users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('userData');
  }

  // Update a user
  Future<int> updateUser(
      int id, int userID, String name, String password) async {
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
    required String orderID,
    required String deviceID,
  }) async {
    // Get a reference to the database
    final db = await database;

    // Insert the image data into the 'outletImages' table
    await db.insert(
      'outletImages', // Table name
      {
        'userID': userID,
        'imagePath1': imagePath1, // First image path
        'imagePath2': imagePath2, // Second image path
        'imagePath3': imagePath3, // Third image path
        'lat': lat, // Latitude
        'lng': lng, // Longitude
        'accuracy': accuracy, // Accuracy of location
        'createdOn': createdOn, // Timestamp when data was created
        'OrderID': orderID, // Order ID associated with the outlet
        'DeviceID': deviceID, // Device ID
      },
    );
  }
  // Future<List<Map<String, dynamic>>> getAllOutletImages(int orderID) async {
  //   final db = await database;
  //
  //   // Query the database to fetch all images for the given OrderID
  //   List<Map<String, dynamic>> result = await db.query(
  //     'OutletImages',
  //     where: 'OrderID = ?',
  //     whereArgs: [orderID],
  //   );
  //
  //   return result;
  // }

  // Future<List<Map>> getAllOutletImages(int UserID) async {
  //   final db = await database;
  //   final List<Map> maps = await db.rawQuery(
  //       "select * from outletImages where isUploaded=0 and UserID=$UserID");
  //   print("outlet_orders_images :"+maps.toString());
  //   return maps;
  // }

  // Read all outlet images
  Future<List<Map<String, dynamic>>> getAllOutletImages() async {
    final db = await database;
    return await db.query('outletImages');
  }

  // Update an outlet image entry
  Future<int> updateImage(
      int id,
      String imagePath1,
      String imagePath2,
      String imagePath3,
      double lat,
      double lng,
      double accuracy,
      int orderID,
      String deviceID) async {
    final db = await database;
    String createdOn = DateTime.now().toString();
    Map<String, dynamic> data = {
      'imagePath1': imagePath1, // First image path
      'imagePath2': imagePath2, // Second image path
      'imagePath3': imagePath3, // Third image path
      'lat': lat,
      'lng': lng,
      'accuracy': accuracy,
      'createdOn': createdOn,
      'OrderID': orderID,
      'DeviceID': deviceID,
    };
    return await db
        .update('outletImages', data, where: 'id = ?', whereArgs: [id]);
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
      'attendanceRecords', // Table name
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

  /// functions for preselloutlets
  Future<List<Map<String, dynamic>>> getAllOutletData(int dayNumber) async {
    final Database db = await database;
    List args = [];
    args.add(dayNumber);
    print("Day Number : $dayNumber");
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "select * from preSellOutletsTable where day_number=?1", args);
    print("Maps: $maps");
    return maps;
  }
  Future<List<Map<String, dynamic>>> getOutletDataById(int outletId) async {
    final Database db = await database;
    List args = [];
    args.add(outletId);
    print("Outlet ID: $outletId");
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM preSellOutletsTable WHERE outlet_id = ?1", args);
    print("Maps: $maps");
    return maps;
  }


  Future<void> insertPreSellOutlet({
    required int outlet_id,
    required String outlet_name,
    required int day_number,
    required String owner,
    required String address,
    required String telephone,
    required String nfc_tag_id,
    required int visit_type,
    required String lat,
    required String lng,
    required String area_label,
    required String sub_area_label,
    required int is_alternate_visible,
    required String pic_channel_id,
    required String channel_label,
    required String order_created_on_date,
    required String common_outlets_vpo_classifications,
    required String Visit,
    required String purchaser_name,
    required String purchaser_mobile_no,
    required String cache_contact_nic,
  }) async {
    final db = await database;
    await db.insert(
      'preSellOutletsTable',
      {
        "outlet_id": outlet_id,
        "outlet_name": outlet_name,
        "day_number": day_number,
        "owner": owner,
        "address": address,
        "telephone": telephone,
        "nfc_tag_id": nfc_tag_id,
        "visit_type": visit_type,
        "lat": lat,
        "lng": lng,
        "area_label": area_label,
        "sub_area_label": sub_area_label,
        "is_alternate_visible": is_alternate_visible,
        "pic_channel_id": pic_channel_id,
        "channel_label": channel_label,
        "order_created_on_date": order_created_on_date,
        "common_outlets_vpo_classifications":
            common_outlets_vpo_classifications,
        "Visit": Visit,
        "purchaser_name": purchaser_name,
        "purchaser_mobile_no": purchaser_mobile_no,
        "cache_contact_nic": cache_contact_nic,
      },
    );
    print("Pre-sell outlet added: $outlet_name");
  }

  Future<List<Map<String, dynamic>>> getPreSellOutlets() async {
    final db = await database;
    return await db.query('preSellOutletsTable');
  }

  Future<List<Map<String, dynamic>>> getOutletProductPrices() async {
    final db = await database;
    return await db.query('outletProductPrices');
  }

  // Update a specific record in the pre_sell_outlets2 table
  Future<void> updatePreSellOutlet(
      int outlet_id, Map<String, dynamic> updatedOutlet) async {
    final db = await database;
    await db.update(
      'preSellOutletsTable',
      updatedOutlet,
      where: 'outlet_id = ?',
      whereArgs: [outlet_id],
    );
  }

  // Delete a specific record from the pre_sell_outlets2 table
  // Future<void> deletePreSellOutlet() async {
  //   final db = await database;
  //   await db.delete(
  //     'preSellOutletsTable',
  //     where: 'outlet_id = ?',
  //     whereArgs: [outlet_id],
  //   );
  // }
  Future<void> deletePreSellOutlet() async {
    final Database db = await database;
    await db.delete('preSellOutletsTable');
  }

  // Delete all records from the pre_sell_outlets2 table
  Future<void> deleteAllPreSellOutlets() async {
    final db = await database;
    await db.delete('preSellOutletsTable');
  }

  Future<void> addOutletNoOrder({
    required int id,
    required int outletId,
    required String reasonTypeId,
    required String isUploaded,
    required String uuid,
    required String createdOn,
    required String lat,
    required String lng,
    required String accuracy,
  }) async {
    final db = await database;
    await db.insert(
      'outletNoOrdersTable',
      {
        "id": id,
        "outlet_id": outletId,
        'reason_type_id': reasonTypeId,
        'is_uploaded': isUploaded,
        'uuid': uuid,
        'created_on': createdOn,
        'lat': lat,
        'lng': lng,
        'accuracy': accuracy,
      },
    );
    print("Outlet no order added to db");
  }
  Future<List<Map<String, dynamic>>> getOutletNoOrders() async {
    final db = await database;
    // Query the table for all outletNoOrders
    final List<Map<String, dynamic>> results = await db.query('outletNoOrdersTable');
    print("getOutletNoOrders${results}");

    return results;
  }
  Future<int> deleteOutletNoOrders() async {
    final db = await database;
    // Delete all records from outletNoOrdersTable
    final int result = await db.delete('outletNoOrdersTable');
    print("deleteOutletNoOrders: $result entries deleted");

    return result;
  }



}
