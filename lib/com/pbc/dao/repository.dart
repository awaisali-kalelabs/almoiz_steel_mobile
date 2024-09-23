import 'dart:async';

import 'package:order_booker/com/pbc/model/outlet_areas.dart';
import 'package:order_booker/com/pbc/model/outlet_products_alternative_prices.dart';
import 'package:order_booker/com/pbc/model/outlet_products_prices.dart';
import 'package:order_booker/com/pbc/model/outlet_sub_areas.dart';
import 'package:order_booker/com/pbc/model/pci_sub_channel.dart';
import 'package:order_booker/com/pbc/model/pre_sell_outlets.dart';
import 'package:order_booker/com/pbc/model/product_lrb_types.dart';
import 'package:order_booker/com/pbc/model/product_sub_categories.dart';
import 'package:order_booker/com/pbc/model/products.dart';
import 'package:order_booker/com/pbc/model/user.dart';
import 'package:order_booker/com/pbc/model/user_features.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../globals.dart' as globals;
import '../model/PJP_MarketVisit.dart';

class Repository {
  var database;
  Repository({this.database});
  static Database _db;
  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initdb();
    return _db;
  }

  Future<Database> getDatabaseObject() {
    return database;
  }

  initdb() async {
    // //print

    /*try{
     final Database db = await database;
     await db.delete('pre_sell_outlets2');
   }catch(error)
    {
      //print(error.toString());
    }*/
    database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'delivery_managerV84.db'),
      // When the database is first created, create a table to store dogs.
      onUpgrade: _onUpgrade,
      onCreate: (db, version) {
        //print('test');
        /* db.execute(
            "CREATE TABLE products_old( category_id INTEGER,category_label TEXT,sap_code INTEGER,product_id INTEGER,package_id INTEGER,package_label TEXT,package_sort_order INTEGER,liquid_in_ml  INTEGER,conversion_rate_in_ml  TEXT,brand_id INTEGER,brand_label TEXT,unit_per_sku INTEGER,is_visible INTEGER,type_id INTEGER,ssrb_type_id INTEGER,lrb_type_id INTEGER,is_other_brand INTEGER);"
        );*/
        db.execute(
            "CREATE TABLE outlet_orders_images(id INTEGER, file_type_id TEXT, file TEXT,is_uploaded INTEGER DEFAULT 0)");
        print(
            "CREATE TABLE spot_discount(product_id INTEGER, default_discount real, maximum_discount real)");
        db.execute(
            "CREATE TABLE products( product_id INTEGER,product_label TEXT,package_id INTEGER,package_label TEXT,sort_order INTEGER,brand_id INTEGER,brand_label TEXT,unit_per_case INTEGER,lrb_type_id INTEGER,unitcarton INTEGER,MinimumQuantity INTEGER);");
        db.execute(
            "CREATE TABLE pre_sell_outlets2(outlet_id INTEGER,outlet_name TEXT,day_number INTEGER,owner TEXT ,address TEXT,telephone TEXT,nfc_tag_id TEXT, order_created_on_date TEXT, channel_label TEXT ,visit_type INTEGER,lat TEXT,lng TEXT,area_label TEXT, sub_area_label TEXT, is_alternate_visible INTEGER, pci_channel_id INTEGER,IsGeoFence INTEGER,Radius INTEGER)");

        db.execute("CREATE TABLE product_lrb_types(id INTEGER,label TEXT)");
        db.execute("CREATE TABLE Outlet_Visit_Time(id INTEGER,outlet_id INTEGER, mobile_timestamp TEXT,file_type INTEGER,lat TEXT,lng TEXT,accuracy TEXT,is_uploaded INTEGER DEFAULT 0)");

        db.execute(
            "CREATE TABLE product_sub_categories(id INTEGER,label TEXT)");

        db.execute(
            "CREATE TABLE outlet_product_prices(price_id INTEGER,outlet_id INTEGER,product_id INTEGER,raw_case REAL,unit TEXT)");

        db.execute(
            "CREATE TABLE outlet_orders(id INTEGER,outlet_id INTEGER,is_completed INTEGER,is_uploaded INTEGER,total_amount REAL,uuid TEXT,created_on TEXT,lat TEXT,lng TEXT,accuracy TEXT, is_spot_sale INTEGER)");

        db.execute(
            "CREATE TABLE outlet_order_items(id INTEGER,source_id INTEGER,order_id INTEGER,product_id INTEGER,brand_id INTEGER,discount REAL,quantity INTEGER,amount REAL,created_on TEXT,rate REAL,product_label TEXT, unit_quantity INTEGER, is_promotion INTEGER, promotion_id INTEGER)");
        db.execute(
            "CREATE TABLE users(user_id INTEGER,display_name TEXT,designation TEXT,distributor_employee_id TEXT,password TEXT, created_on TEXT, department TEXT)");
        db.execute("CREATE TABLE no_order_reasons(id INTEGER,label TEXT)");
        db.execute(
            "CREATE TABLE outlet_no_orders(id INTEGER,outlet_id INTEGER,reason_type_id INTEGER,is_uploaded INTEGER,uuid TEXT,created_on TEXT,lat TEXT,lng TEXT,accuracy TEXT )");

//added by farhan after danish code STARTS
        db.execute(
            "CREATE TABLE outlet_product_alternative_prices(product_id INTEGER,package_id INTEGER,package_label TEXT,brand_id INTEGER,brand_label TEXT,raw_case_price REAL,unit_price REAL,liquid_in_ml INTEGER)");

        db.execute("CREATE TABLE outlet_areas(id INTEGER,label TEXT)");

        db.execute(
            "CREATE TABLE outlet_sub_areas(id INTEGER,label TEXT,area_id INTEGER)");

        db.execute(
            "CREATE TABLE pci_sub_channel(id INTEGER,label TEXT,parent_channel_id INTEGER)");

        db.execute(
            "CREATE TABLE registered_outlets(outlet_name TEXT,mobile_request_id TEXT,mobile_timestamp TEXT, channel_id INTEGER,area_label TEXT,sub_area_label TEXT,address TEXT, owner_name TEXT,owner_cnic TEXT, owner_mobile_no TEXT,purchaser_name TEXT,purchaser_mobile_no TEXT, is_owner_purchaser INTEGER, lat REAL, lng REAL, accuracy INTEGER, created_on TEXT,created_by INTEGER,is_uploaded INTEGER )");

        db.execute(
            "CREATE TABLE stock_position(product_id INTEGER,units REAL,raw_cases REAL)");
        db.execute(
            "CREATE TABLE outlet_images(mobile_request_id TEXT,user_id INTEGER,outlet_type_id INTEGER,mobile_timestamp TEXT,lat REAL, lng REAL, accuracy INTEGER,is_uploaded INTEGER,uuid TEXT,image_path TEXT,is_photo_uploaded INTEGER)");
        db.execute(
            "CREATE TABLE attendance(mobile_request_id TEXT,user_id INTEGER,attendance_type_id INTEGER,mobile_timestamp TEXT,lat REAL, lng REAL, accuracy INTEGER,is_uploaded INTEGER,uuid TEXT,image_path TEXT,is_photo_uploaded INTEGER)");
        db.execute("CREATE TABLE user_features(id INTEGER )");

        db.execute(
            "CREATE TABLE merchandising(mobile_request_id TEXT,outlet_id INTEGER,user_id INTEGER,mobile_timestamp TEXT,lat REAL, lng REAL, accuracy INTEGER,is_completed INTEGER,uuid TEXT,image TEXT,type_id INTEGER,is_photo_uploaded INTEGER)");

        db.execute(
            "CREATE TABLE outlet_mark_close(id INTEGER ,outlet_id INTEGER,image_path TEXT,is_uploaded INTEGER,is_photo_uploaded INTEGER,uuid TEXT,created_on TEXT,lat TEXT,lng TEXT,accuracy TEXT )");

        db.execute(
            "CREATE TABLE spot_discount(product_id INTEGER, default_discount real, maximum_discount real)");

        print(
            "CREATE TABLE spot_discount(product_id INTEGER, default_discount real, maximum_discount real)");

        db.execute(
            "CREATE TABLE promotions_products(promotion_id INTEGER,package_id INTEGER,total_units INTEGER,brand_id INTEGER)");

        db.execute(
            "CREATE TABLE promotions_active(promotion_id INTEGER,outlet_id INTEGER)");

        db.execute(
            "CREATE TABLE promotions_products_free(promotion_id INTEGER,package_id INTEGER,total_units INTEGER, package_label TEXT, brand_id INTEGER, brand_label TEXT, unit_per_case INTEGER, product_id INTEGER)");
        db.execute(
            "CREATE TABLE hand_to_hand_discount_percentage_Brandwise(discount_id INTEGER,brand_id INTEGER, from_qty INTEGER, to_qty INTEGER, discount_percentage real, pci_channel_id INTEGER, isbrandskudiscount INTEGER)");
        db.execute(
            "CREATE TABLE hand_to_hand_discount_percentage_Brands_ProductsWise(discount_id INTEGER,brand_id INTEGER, from_qty INTEGER, to_qty INTEGER, discount_percentage real, pci_channel_id INTEGER,product_id INTEGER)");

        db.execute(
            "CREATE TABLE hand_to_hand_discount_percentage(product_id INTEGER, from_qty INTEGER, to_qty INTEGER, discount_percentage real, pci_channel_id INTEGER)");
//added by farhan after danish code ENDS
        db.execute(
            "CREATE TABLE channel_tagging_images(mobile_request_id TEXT, id TEXT, file_type_id TEXT, file TEXT,lat TEXT,lng TEXT,accuracy TEXT, mobile_timeStamp TEXT,is_uploaded INTEGER DEFAULT 0)");
        db.execute(
            "CREATE TABLE channel_tagging(mobile_request_id TEXT,outlet_id TEXT,outlet_name TEXT, channel_id Text, lat TEXT,lng TEXT,accuracy TEXT,user_id TEXT, is_uploaded INTEGER DEFAULT 0)");
        db.execute(
            "CREATE TABLE register_outlet_images(id TEXT, outlet_request_id TEXT, file_type_id INTEGER, file TEXT,lat TEXT,lng TEXT,accuracy TEXT, mobile_timeStamp TEXT,is_uploaded INTEGER DEFAULT 0)");
        //print("db created");
        db.execute(
            "CREATE TABLE BeatPlan_MarketVisit(id TEXT,label TEXT,city TEXT)");
        db.execute(
            "CREATE TABLE MV_Outlets(outlet_id TEXT,outlet_name TEXT,outlet_address TEXT,id TEXT,pjp_label TEXT,distributor_idd TEXT,distributor_name TEXT,owner_name TEXT,owner_contact TEXT,region_idd TEXT,region_name TEXT,region_short TEXT,channel_idd TEXT,channel_name TEXT,day_number INTEGER,lat TEXT,lng TEXT,IsGeoFence TEXT,Radius INTEGER)");
        db.execute(
            "CREATE TABLE Cities(city TEXT , id INTEGER)");
        db.execute(
            "CREATE TABLE outlet_order_items_MV(order_id INTEGER,product_id INTEGER,product_label TEXT)");


        // db.execute(
        //   "CREATE TABLE MV_Products(product_id TEXT,brand_label TEXT,package_label TEXT,sort_order TEXT,unit_per_case TEXT,package_id TEXT,brand_id TEXT,lrb_label TEXT,lrb_type_id TEXT,product TEXT)");
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 4,
    );
    return database;
  }
  Future<List<Map<String, dynamic>>> getAddedChnnelTgging(
      ) async {
    print('get channel ================');
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;
    //print("Product ID "+productId.toString());
    //print("outletId ID "+outletId.toString());
    // Query the table for all The Dogs.
    List args = new List();

    final List<Map> maps = await db.rawQuery(
        "select *  from channel_tagging");

    // /print(maps);
    return maps;
  }



  Future<void> deleteHandDiscountsPercentages() async {
    final Database db = await database;
    await db.delete('hand_to_hand_discount_percentage');
  }
  Future<void> deleteHandDiscountsPercentagesBrand() async {
    final Database db = await database;
    await db.delete('hand_to_hand_discount_percentage_Brandwise');
  }
  Future<void> deleteHandDiscountsPercentagesBrand_Products() async {
    final Database db = await database;
    await db.delete('hand_to_hand_discount_percentage_Brands_ProductsWise');
  }
  Future<void> deleteChannel(String mobile_order_id) async {
    print('mobile_order_id '+mobile_order_id);
    final Database db = await database;

    await db.rawDelete(
        "delete from channel_tagging where mobile_request_id=?1", [mobile_order_id]);
  }
  Future<void> Delete_items_MV() async {
   // print('mobile_order_id '+mobile_order_id);
    final Database db = await database;

    await db.rawDelete(
        "delete from outlet_order_items_MV ");
  }
  Future<void> deleteOutletImage() async {
    //print('mobile_order_id '+mobile_order_id);
    final Database db = await database;

    await db.rawDelete(
        "delete from outlet_orders_images");
  }
  Future<void> deleteNoOrder() async {
    //print('mobile_order_id '+mobile_order_id);
    final Database db = await database;

    await db.rawDelete(
        "delete from outlet_no_orders");
  }
  Future<void> deleteChannelImage(String mobile_order_id) async {
    print('mobile_order_id '+mobile_order_id);
    final Database db = await database;

    await db.rawDelete(
        "delete from channel_tagging_images where mobile_request_id=?1", [mobile_order_id]);
  }
  Future<void> insertHandDiscountsPercentages(
      product_id, from_qty, to_qty, discount_percentage, pci_channel_id) async {
    await this.initdb();
    final Database db = await database;
    try {
      await db.rawInsert(
          "insert into hand_to_hand_discount_percentage(product_id,from_qty,to_qty,discount_percentage, pci_channel_id) values  (?,?,?,?,?) ",
          [product_id, from_qty, to_qty, discount_percentage, pci_channel_id]);
    } catch (error) {
      //print(error);
    }
  }
  Future<void> insertHandDiscountsPercentagesBrand(
      discount_id, brand_id, from_qty, to_qty, discount_percentage, pci_channel_id, isbrandskudiscount) async {
    await this.initdb();
    final Database db = await database;
    try {
      await db.rawInsert(
          "insert into hand_to_hand_discount_percentage_Brandwise(discount_id,brand_id,from_qty,to_qty,discount_percentage, pci_channel_id,isbrandskudiscount) values  (?,?,?,?,?,?,?) ",
          [discount_id,brand_id, from_qty, to_qty, discount_percentage, pci_channel_id,isbrandskudiscount]);
    } catch (error) {
      print("=="+error);
    }
  }
  Future<void> insertHandDiscountsPercentagesBrand_Products(
      discount_id, brand_id, from_qty, to_qty, discount_percentage, pci_channel_id,product_id) async {
    await this.initdb();
    final Database db = await database;
    try {
      await db.rawInsert(
          "insert into hand_to_hand_discount_percentage_Brands_ProductsWise(discount_id,brand_id,from_qty,to_qty,discount_percentage, pci_channel_id,product_id) values  (?,?,?,?,?,?,?) ",
          [discount_id,brand_id, from_qty, to_qty, discount_percentage, pci_channel_id,product_id]);
    } catch (error) {
      print("=="+error);
    }
  }

  Future<double> getHandDiscountsPercentage(
      product_id, qty, outlet_pci_channel_id) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    print(product_id);
    print(qty);
    args.add(product_id);
    args.add(qty);

    final List<Map> maps = await db.rawQuery(
        "select discount_percentage, pci_channel_id from hand_to_hand_discount_percentage where product_id=?1 and from_qty<=?2 and to_qty>=?2",
        args);
    print(maps.toString());
    double discountPercentage = 0;
    var pci_channel_id = 0;
    if (maps.isNotEmpty) {
      discountPercentage = maps[0]['discount_percentage'];
      pci_channel_id = maps[0]['pci_channel_id'];
    }
    if (pci_channel_id != 0) {
      if (pci_channel_id != outlet_pci_channel_id) {
        discountPercentage = 0;
      }
    }
    return discountPercentage;
  }
 /* Future<double> getHandDiscountsPercentageBrand(
      brand_id, qty, outlet_pci_channel_id) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    print(brand_id);
    print(qty);
    args.add(brand_id);
    args.add(qty);

    final List<Map> maps = await db.rawQuery(
        "select discount_percentage, pci_channel_id from hand_to_hand_discount_percentage_Brandwise where brand_id=?1 and from_qty<=?2 and to_qty>=?2",
        args);
    print(maps.toString());
    double discountPercentage = 0;
    var pci_channel_id = 0;
    if (maps.isNotEmpty) {
      discountPercentage = maps[0]['discount_percentage'];
      pci_channel_id = maps[0]['pci_channel_id'];
    }
    if (pci_channel_id != 0) {
      if (pci_channel_id != outlet_pci_channel_id) {
        discountPercentage = 0;
      }
    }
    return discountPercentage;
  }*/
  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      db.execute("ALTER TABLE registered_outlets ADD COLUMN area_label text;");
      db.execute(
          "ALTER TABLE registered_outlets ADD COLUMN sub_area_label text;");
      print("haseeb called1");
    }
    print("haseeb called");
  }

  Future<void> insertPromotionsProducts(
      promotion_id, package_id, total_units, brand_id) async {
    await this.initdb();
    final Database db = await database;
    try {
      await db.rawInsert(
          "insert into promotions_products(promotion_id,package_id,total_units,brand_id) values  (?,?,?,?) ",
          [promotion_id, package_id, total_units, brand_id]);
    } catch (error) {
      //print(error);
    }
  }

  Future<void> insertPromotionsActive(promotion_id, outlet_id) async {
    await this.initdb();
    final Database db = await database;
    try {
      await db.rawInsert(
          "insert into promotions_active(promotion_id,outlet_id) values  (?,?) ",
          [promotion_id, outlet_id]);
    } catch (error) {
      //print(error);
    }
  }

  Future<void> insertPromotionsProductsFree(
      promotion_id,
      package_id,
      total_units,
      package_label,
      brand_id,
      brand_label,
      unit_per_case,
      product_id) async {
    await this.initdb();
    final Database db = await database;
    try {
      await db.rawInsert(
          "insert into promotions_products_free(promotion_id,package_id,total_units, package_label, brand_id, brand_label, unit_per_case, product_id) values  (?,?,?,?,?,?,?,?) ",
          [
            promotion_id,
            package_id,
            total_units,
            package_label,
            brand_id,
            brand_label,
            unit_per_case,
            product_id
          ]);
    } catch (error) {
      //print(error);
    }
  }

  Future<List<Map<String, dynamic>>> getPromotionProductsFree(
      promotion_id) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(promotion_id);

    final List<Map> maps = await db.rawQuery(
        "select * from promotions_products_free where promotion_id=?1", args);
    print("maps.toString()" + maps.toString());

    return maps;
  }

  Future<int> getPromotionIdaa(outlet_id) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(outlet_id);

    final List<Map> maps = await db.rawQuery(
        "select * from promotions_active where outlet_id=?1", args);
    //print(maps.toString());
    int promotionId = 0;
    if (maps.isNotEmpty) {
      promotionId = maps[0]['promotion_id'];
    }
    return promotionId;
  }

  Future<List<Map<String, dynamic>>> getPromotionalProduct(
      promotion_id, package_id, brand_id) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(promotion_id);
    args.add(package_id);
    args.add(brand_id);

    print('promotion_id:' + promotion_id);
    print('package_id:' + package_id);
    print('brand_id' + brand_id);
    final List<Map> maps = await db.rawQuery(
        "select * from promotions_products where promotion_id =?1 and package_id=?2 and brand_id=?3",
        args);
    //print(maps.toString());

    return maps;
  }

  Future<List<Map<String, dynamic>>> getAllPromotionalProducts() async {
    await this.initdb();
    final Database db = await database;
    List args = new List();

    final List<Map> maps =
    await db.rawQuery("select * from promotions_products", args);
    print("promotions_products:" + maps.toString());

    return maps;
  }

  Future<int> getPromotionId(outlet_id, package_id, brand_id) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(outlet_id);
    args.add(package_id);
    args.add(brand_id);

    final List<Map> maps = await db.rawQuery(
        "select promotion_id from promotions_products where promotion_id in(select promotion_id from promotions_active where outlet_id=?1) and package_id=?2 and brand_id=?3",
        args);
    //print(maps.toString());
    int promotionId = 0;
    if (maps.isNotEmpty) {
      promotionId = maps[0]['promotion_id'];
    }
    return promotionId;
  }

  Future<List<Map<String, dynamic>>> getAllPromotionalProduct(
      outlet_id, package_id, brand_id) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(outlet_id);
    args.add(package_id);
    args.add(brand_id);

    final List<Map> maps = await db.rawQuery(
        "select * from promotions_products where promotion_id in(select promotion_id from promotions_active where outlet_id=?1) and package_id=?2 and brand_id=?3",
        args);
    print("select:" + maps.toString());

    return maps;
  }
  Future<List<Map<String, dynamic>>> getAddedChnnelTggingImages() async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;
    //print("Product ID "+productId.toString());
    //print("outletId ID "+outletId.toString());
    // Query the table for all The Dogs.
    List args = new List();

    final List<Map> maps = await db.rawQuery(
        "select *  from channel_tagging_images");

    // /print(maps);
    return maps;
  }
  Future<List<Map<String, dynamic>>> getminQuantity(product_id) async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;
    //print("Product ID "+productId.toString());
    //print("outletId ID "+outletId.toString());
    // Query the table for all The Dogs.
    List args = new List();
    args.add(product_id);
    final List<Map> maps = await db.rawQuery(
        "select * from products where product_id=?1 and lrb_type_id not in (8 , 9)",args);

    print("MinimumQuantity"+maps.toString());
    return maps;
  }
  Future<List<Map<String, dynamic>>> getminQuantityfor8() async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;
    //print("Product ID "+productId.toString());
    //print("outletId ID "+outletId.toString());
    // Query the table for all The Dogs.

    final List<Map> maps = await db.rawQuery(
        "select * from products where  lrb_type_id=8");

    print("getminQuantityfor8"+maps.toString());
    return maps;
  }
  Future<List<Map<String, dynamic>>> getminQuantityfor9() async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;
    //print("Product ID "+productId.toString());
    //print("outletId ID "+outletId.toString());
    // Query the table for all The Dogs.

    final List<Map> maps = await db.rawQuery(
        "select * from products where  lrb_type_id=9");

    print("getminQuantityfor9"+maps.toString());
    return maps;
  }

  Future<List<Map<String, dynamic>>> getAllAddedItemsOfOrderByIsPromotion(
      int orderId, isPromotion) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(orderId);
    args.add(isPromotion);

    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select * from outlet_order_items where order_id=?1 and is_promotion=?2",
        args);

    return maps;
  }
  Future<List<Map<String, dynamic>>> getAllBrandID(
      int orderId) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(orderId);
    //args.add(isPromotion);

    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select distinct brand_id as brand_id from outlet_order_items where order_id=?1",
        args);
//count(distinct brand_id) as brand_count
    return maps;
  }
  Future<List<Map<String, dynamic>>> getBrandOnly(
      int brandId ) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(brandId);
    //args.add(total_qty);
   // print("Brand====>>>>"+brandId.toString());

    final List<Map> maps = await db.rawQuery(
        "SELECT * FROM hand_to_hand_discount_percentage_Brandwise WHERE brand_id =?1 ",
        args);
//count(distinct brand_id) as brand_count
    print("Maps"+maps.toString());
    return maps;
  }
/*  Future<List<Map<String, dynamic>>> getDiscount(
      int brandId , int total_qty , pci) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(brandId);
    args.add(pci);
    //args.add(total_qty);
   // print("Brand===="+brandId.toString());

    final List<Map> maps = await db.rawQuery(
        "SELECT * FROM hand_to_hand_discount_percentage_Brandwise WHERE brand_id =?1  AND ${total_qty} = from_qty  or ${total_qty} = to_qty and pci_channel_id=?2" ,
        args);
//count(distinct brand_id) as brand_count
print("Maps"+maps.toString());
    return maps;
  }*/
  Future<List<Map<String, dynamic>>> getDiscountSKU(
      int brandId ,  total_qty, pci) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(brandId);
    args.add(pci);

    //args.add(total_qty);
    print("Brand===="+brandId.toString());
    print("pci===="+pci.toString());

    final List<Map> maps = await db.rawQuery(
          "SELECT * FROM hand_to_hand_discount_percentage_Brandwise WHERE brand_id =?1  AND ${total_qty} >= from_qty  AND ${total_qty} <= to_qty and pci_channel_id=?2",
        args);
//count(distinct brand_id) as brand_count
    print("Maps"+maps.toString());
    return maps;
  }
  Future<List<Map<String, dynamic>>> getDiscountforBrandProduct(
      int brandId , int Product_id,int total_qty) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(brandId);
    args.add(Product_id);
    print("Brand===="+brandId.toString());
    print("total_qty===="+total_qty.toString());

    final List<Map> maps = await db.rawQuery(
        "SELECT * FROM hand_to_hand_discount_percentage_Brands_ProductsWise WHERE brand_id =?1 and product_id=?2 AND ${total_qty} = from_qty  or  ${total_qty} = to_qty",
        args);
    print("args"+args.toString());
//count(distinct brand_id) as brand_count
print("Maps======"+maps.toString());
    return maps;
  }
  Future<List<Map<String, dynamic>>> GetLRBName(
      int brandId) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(brandId);
    print("Brand===="+brandId.toString());

    final List<Map> maps = await db.rawQuery(
        "SELECT * FROM product_lrb_types WHERE id =?1",
        args);
    return maps;
  }
  Future<List<Map<String, dynamic>>> getTotalQuantityforDisSKU(
       brandId , orderid , product_id) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(brandId);
    args.add(orderid);
    args.add(product_id);
  /*  print("Brand====>>>>>>>"+brandId.toString());
    print("product_id====>>>>>>>"+brandId.toString());*/

    final List<Map> maps = await db.rawQuery(
        "SELECT quantity FROM outlet_order_items WHERE brand_id =?1 and order_id=?2 and product_id=?3",
        args);
    return maps;
  }
  Future<List<Map<String, dynamic>>> getBrandDiscount(
  int brandId, int orderId) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    //print("orderId :"+orderId.toString());
  //  print("brandId :"+brandId.toString());
    args.add(brandId);
    args.add(orderId);

    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "SELECT SUM(quantity) AS total_quantity, SUM(amount) AS total_amount , brand_id , product_id  FROM outlet_order_items WHERE brand_id = ?1 AND order_id = ?2",
        args);
  //  print("==maps=="+maps.toString());
//
    return maps;
  }
  Future<List<Map<String, dynamic>>> getBrandDiscountBrandsProduct(
      int brandId, int orderId ) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(brandId);
    args.add(orderId);

    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "SELECT SUM(quantity) AS total_quantity, SUM(amount) AS total_amount , brand_id , product_id ,product_label FROM outlet_order_items WHERE brand_id = ?1 AND order_id = ?2 group by product_id",
        args);
    //print("==maps=="+maps.toString());
//
    return maps;
  }

  Future changePromotionProduct(id, product_id, product_label) async {
    await this.initdb();
    final Database db = await database;
//print("ORDER ID"+orderId.toString());

    List args = new List();

    args.add(product_id);
    args.add(product_label);
    args.add(id);

    await db.rawUpdate(
        'update outlet_order_items set product_id=?1,product_label=?2 where id=?3',
        args);
    return true;
  }

  Future<void> deletePromotionsProductsFree() async {
    final Database db = await database;
    await db.delete('promotions_products_free');
  }

  Future<void> deletePromotionsActive() async {
    final Database db = await database;
    await db.delete('promotions_active');
  }

  Future<void> deletePromotionsProducts() async {
    final Database db = await database;
    await db.delete('promotions_products');
  }

  void saveOutletMarkClose(
      id, outlet_id, image_path, lat, lng, accuracy, uuid) async {
    await this.initdb();
    final Database db = await database;
    try {
      await db.rawInsert(
          "insert into outlet_mark_close(id,outlet_id, image_path, lat, lng, accuracy, uuid, created_on, is_uploaded) values  (?,?, ?, ?, ?, ?, ?,DATETIME('now','5 hours'), 0) ",
          [id, outlet_id, image_path, lat, lng, accuracy, uuid]);
    } catch (error) {
      //print(error);
    }
  }

  Future<void> insertSpotDiscount(
      product_id, default_discount, maximum_discount) async {
    await this.initdb();
    final Database db = await database;
    try {
      await db.rawInsert(
          "insert into spot_discount(product_id,default_discount, maximum_discount) values  (?,?, ?) ",
          [product_id, default_discount, maximum_discount]);
    } catch (error) {
      //print(error);
    }
  }

  Future<void> deleteAllSpotDiscount() async {
    final Database db = await database;
    await db.delete('spot_discount');
  }

  Future<Map> getSpotDiscount(productId) async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;

    // Query the table for all The Dogs.
    List args = new List();
    args.add(productId);

    final List<Map> maps = await db.rawQuery(
        "select *  from spot_discount where product_id=?1 ", args);

    return maps.isEmpty ? null : maps[0];
  }

  Future markOutletMarkCloseUploaded(int id) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(id);
    await db.rawUpdate(
        'update outlet_mark_close set is_uploaded=1 where id=?1 ', args);
    return true;
  }

  Future markOutletMarkCloseUploadedPhoto(int id) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(id);
    await db.rawUpdate(
        'update outlet_mark_close set is_photo_uploaded=1 where id=?1 and is_uploaded=1',
        args);
    return true;
  }

  Future<List<Map<String, dynamic>>> getAllOutletMarkClose(isUploaded) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(isUploaded);

    final List<Map> maps = await db.rawQuery(
        "select * from outlet_mark_close where is_uploaded=?1", args);
    //print(maps.toString());
    return maps;
  }

  Future<void> deleteAllUserFeatures() async {
    final Database db = await database;
    await db.delete('user_features');
  }

  Future<List> isUserAllowed(int featureId) async {
    await initdb();
    final Database db = await database;

    List args = new List();
    args.add(featureId);
    List maps =
    await db.rawQuery("select id from user_features where id=?1", args);
    print(maps.toString());

    return maps;
  }

  Future<void> insertFeatures(UserFeatures userFeature) async {
    final Database db = await database;
    try {
      await db.insert(
        'user_features',
        userFeature.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (error) {
      print("ERROR in inserting UserFeatures : " + error);
      //print(error);
    }
  }

  Future<void> deleteAllStockPosition() async {
    final Database db = await database;
    await db.delete('stock_position');
  }

  void insertStockPosition(productId, units, rawCases) async {
    await this.initdb();
    final Database db = await database;
    try {
      await db.rawInsert(
          'insert into stock_position (product_id,units, raw_cases) values  (?,?,?) ',
          [productId, units, rawCases]);
    } catch (error) {
      print(error);
    }
  }

  Future<double> getAvailableStock(productId) async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;

    // Query the table for all The Dogs.
    List args = new List();
    args.add(productId);

    final List<Map> maps = await db.rawQuery(
        "select raw_cases  from stock_position where product_id=?1 ", args);

   // print('stock:' + maps[0]['raw_cases'].toString());
    return maps[0]['raw_cases'];
  }

  Future<List<Map>> getStockData() async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;

    // Query the table for all The Dogs.
    List args = new List();
    //args.add(productId);

    final List<Map> maps = await db.rawQuery(
      " select brand_label, package_label, (select raw_cases from stock_position sp where p.product_id = sp.product_id) stock from products p order by sort_order, brand_label",
    );

    return maps;
  }

  Future<void> insertProduct(Products product) async {
    // Get a reference to the database.
    final Database db = await database;
    try {
      await db.insert(
        'products',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (error) {
      //print("//print ERROR");
      //print(error);
    }
  }

  Future<void> deleteAllProducts() async {
    final Database db = await database;
    await db.delete('products');
  }

  Future<void> deleteAllPreSellOutlet() async {
    final Database db = await database;
    await db.delete('pre_sell_outlets2');
  }

  Future<void> insertPreSellOutlet(PreSellOutlets outlet) async {
    // Get a reference to the database.
    final Database db = await database;
    print("inside insertion function");
    print("outlet_id :"+outlet.outlet_id.toString());
    print("lat :"+outlet.lat);
    print("address :"+outlet.address);
   // print("area_label :"+outlet.area_label);
    print("channel_label :"+outlet.channel_label);
    print("lng :"+outlet.lng);
   // print("nfc_tag_id :"+outlet.nfc_tag_id);
   // print("order_created_on_date :"+outlet.order_created_on_date);
    print("outlet_name :"+outlet.outlet_name);
    print("owner :"+outlet.owner);
  //  print("sub_area_label :"+outlet.sub_area_label);
    print("telephone :"+outlet.telephone);
    print("day_number :"+outlet.day_number.toString());
 //   print("is_alternate_visible :"+outlet.is_alternate_visible.toString());
    print("IsGeoFence :"+outlet.IsGeoFence.toString());
    print("pci_channel_id :"+outlet.pci_channel_id.toString());
    print("Radius :"+outlet.Radius.toString());
   // print("visit_type :"+outlet.visit_type.toString());

    try {
      await db.insert(
        'pre_sell_outlets2',
        outlet.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (error) {
      //print("ERROR ==>> "+error.toString());
    }
  }

  Future<void> deleteAllProductsLrbTypes() async {
    final Database db = await database;
    await db.delete('product_lrb_types');
  }

  Future<void> insertProductsLrbTypes(ProductsLrbTypes lrbTypes) async {
    // Get a reference to the database.
    final Database db = await database;

    try {
      await db.insert(
        'product_lrb_types',
        lrbTypes.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (error) {
      //print("ERROR ==>> "+error.toString());
    }
  }

  Future<void> deleteAllSubCategories() async {
    final Database db = await database;
    await db.delete('product_sub_categories');
  }

  Future<void> insertProductsSubCategories(
      ProductSubCategories subCategories) async {
    // Get a reference to the database.
    final Database db = await database;

    try {
      await db.insert(
        'product_sub_categories',
        subCategories.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (error) {
      //print("ERROR ==>> "+error.toString());
    }
  }

  Future<void> insertOutletProductsPrices(
      OutletProductsPrices ProductsPrices) async {
    // Get a reference to the database.
    final Database db = await database;
    try {
      await db.insert(
        'outlet_product_prices',
        ProductsPrices.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (error) {
      //print("ERROR outlet_product_prices : ");
      //print(error);
    }
  }

  Future<void> deleteAllOutletProductsPrices() async {
    final Database db = await database;
    await db.delete('outlet_product_prices');
  }

  Future<List<Map<String, dynamic>>> getActiveProductPriceList(
      int productId, int outletId) async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;
    //print("Product ID "+productId.toString());
    //print("outletId ID "+outletId.toString());
    // Query the table for all The Dogs.
    List args = new List();
    args.add(outletId);
    args.add(productId);
    final List<Map> maps = await db.rawQuery(
        "select *  from outlet_product_prices where outlet_id=?1 and product_id=?2 limit 1",
        args);

    //print(maps);
    return maps;
  }
  Future<List<Map<String, dynamic>>> getPreSellOutletsByIsVisible1(
      int dayNumber, String PJPID ) async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;
    //print("DAY NUMER "+dayNumber.toString());
    final List<Map> maps = await db.rawQuery("select *  from MV_Outlets where day_number=" + dayNumber.toString() + " and  id ="+globals.PJPID );

    print("select *  from MV_Outlets where day_number=" + dayNumber.toString() + " and  id ="+globals.PJPID  );


    // Query the table for all The Dogs.

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    //print('list');
    //print(maps);
    return maps;
  }
  Future<List<Map<String, dynamic>>> getPreSellOutletsByIsVisible(
      int dayNumber, String name, isVisible) async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;
    //print("DAY NUMER "+dayNumber.toString());
    String OutletQuery = "";
    List SearchOutletTerms = name.split(" ");
    for (int i = 0; i < SearchOutletTerms.length; i++) {
      if (i > 0) {
        OutletQuery += " or ";
      }
      //area_label TEXT, sub_area_label
      OutletQuery += "  ( outlet_id like '%" +
          SearchOutletTerms[i] +
          "%' or area_label like '%" +
          SearchOutletTerms[i] +
          "%' or sub_area_label like '%" +
          SearchOutletTerms[i] +
          "%' or "
              " outlet_name like '%" +
          SearchOutletTerms[i] +
          "%' or address like '%" +
          SearchOutletTerms[i] +
          "%' ) ";
    }
    String visibleQuery =
        " and is_alternate_visible=" + isVisible.toString() + " ";
    if (isVisible == -1) {
      visibleQuery = "  ";
    }
    List<Map> maps = null;
    try {
      print("select *  from pre_sell_outlets2 where day_number=" +
          dayNumber.toString() +
          visibleQuery +
          " and  " +
          OutletQuery +
          " group by outlet_id limit 500");
      maps = await db.rawQuery(
          "select *  from pre_sell_outlets2 where day_number=" +
              dayNumber.toString() +
              visibleQuery +
              " and  " +
              OutletQuery +
              " group by outlet_id limit 500");
    } catch (e) {}

    // Query the table for all The Dogs.

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    //print('list');
    //print(maps);
    return maps;
  }

  Future<List<Map<String, dynamic>>> getTotalOutlets(int dayNumber) async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;

    // Query the table for all The Dogs.
    List args = new List();
    args.add(dayNumber);

    final List<Map> maps = await db.rawQuery(
        "select count(*) as totalOutlets from pre_sell_outlets2 where day_number=?1 and is_alternate_visible=" +
            globals.isAlternative.toString(),
        args);

    //print(maps);
    return maps;
  }

  Future<int> getTotalOrders() async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;
    int totoalVisits = 0;
    final List<Map> maps = await db.rawQuery(
        "select count(*) as totalOrders from outlet_orders where date(created_on)=date('now') and is_completed=1");

    totoalVisits = maps[0]['totalOrders'];
    return totoalVisits;
  }

  Future<int> getTotalNoOrders() async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;
    int totoalVisits = 0;

    final List<Map> maps1 = await db.rawQuery(
        "select count(*) as totalNoOrders from outlet_no_orders where date(created_on)=date('now') ");
    totoalVisits = maps1[0]['totalNoOrders'];
    return totoalVisits;
  }

  Future<int> getTotalOutletClosed() async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;
    int totoalVisits = 0;

    final List<Map> maps1 = await db.rawQuery(
        "select count(*) as totalNoOrders from outlet_mark_close where date(created_on)=date('now') ");
    totoalVisits = maps1[0]['totalNoOrders'];
    return totoalVisits;
  }

  Future<List<Map<String, dynamic>>> getProducts(lrbTypeId, brandId) async {
    await this.initdb();
    final Database db = await database;
    // Query the table for all The Dogs.
    List<Map> maps = null;
    if (lrbTypeId == 0 && brandId == 0) {
      maps = await db.rawQuery(
          "select distinct product_label , product_id , lrb_type_id from products  order by product_label asc limit 500");
    } else if (lrbTypeId != 0 && brandId == 0) {
      List args = new List();
      args.add(lrbTypeId);
      maps = await db.rawQuery(
          "select distinct product_label , product_id from products where lrb_type_id=?1  order by product_label asc limit 500",
          args);
    } else if (lrbTypeId == 0 && brandId != 0) {
      List args = new List();
      args.add(brandId);
      maps = await db.rawQuery(
          "select distinct product_label , product_id from products where brand_id=?1  order by product_label asc limit 500",
          args);
    } else if (lrbTypeId != 0 && brandId != 0) {
      List args = new List();
      args.add(lrbTypeId);
      args.add(brandId);
      maps = await db.rawQuery(
          "select distinct product_label,product_id from products where lrb_type_id=?1 and brand_id=?2 order by package_label asc limit 500",
          args);
    }

    return maps;
  }

  Future<List<Map<String, dynamic>>> getProductsByPackageIdAndBrandId(
      packageId, brandId) async {
    await this.initdb();
    final Database db = await database;
    // Query the table for all The Dogs.
    List<Map> maps = null;
    if (packageId == 0 && brandId == 0) {
      maps = await db.rawQuery(
          "select * from products  order by is_suggestion desc limit 500");
    } else if (packageId != 0 && brandId == 0) {
      List args = new List();
      args.add(packageId);
      maps = await db.rawQuery(
          "select * from products where package_id=?1  order by package_label asc limit 500",
          args);
    } else if (packageId == 0 && brandId != 0) {
      List args = new List();
      args.add(brandId);
      maps = await db.rawQuery(
          "select * from products where brand_id=?1  order by package_label asc limit 500",
          args);
    } else if (packageId != 0 && brandId != 0) {
      List args = new List();
      args.add(packageId);
      args.add(brandId);
      maps = await db.rawQuery(
          "select * from products where package_id=?1 and brand_id=?2 order by package_label asc limit 500",
          args);
    }

    return maps;
  }

  Future<List<Map<String, dynamic>>> getProductsLrbTypes(String name) async {
    await this.initdb();
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery("select * from product_lrb_types");
    //print("LRB TYPES"+maps.toString());
    return maps;
  }
  Future<List<Map<String, dynamic>>> getUnitpercarton(product_id) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(product_id);
    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery("select * from products where product_id=?1", args);
    //print("LRB TYPES"+maps.toString());
    return maps;
  }

  Future<List<Map<String, dynamic>>> getProductsSubCategories(
      String name) async {
    await this.initdb();
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map> maps = await db
        .rawQuery("select * from product_sub_categories order by label asc");
    return maps;
  }

  Future<List<Map<String, dynamic>>> getProductsSubCategoriesByCategoryId(
      int categoryId) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(categoryId);

    // Query the table for all The Dogs.
    String qry =
        "select * from product_sub_categories where id in(select brand_id from products where lrb_type_id=?1)  order by label asc";
    if (categoryId == 0) {
      qry =
      "select * from product_sub_categories where ?1=?1   order by label asc";
    }
    //print(categoryId.toString() + ":" +qry);
    final List<Map> maps = await db.rawQuery(qry, args);
    return maps;
  }

  Future<List<Map<String, dynamic>>> getProductsBySerachMethod(
      int lrbTypeId, int brandId, String searchProduct) async {
    await this.initdb();
    final Database db = await database;
    // Query the table for all The Dogs.
    List<Map> maps = null;
    String ProductQuery = "";
    List SearchProductTerms = searchProduct.split(" ");
    for (int i = 0; i < SearchProductTerms.length; i++) {
      if (i > 0) {
        ProductQuery += " and ";
      }
      ProductQuery +=
          "  (product_label like '%" + SearchProductTerms[i] + "%') ";
    }
    print(ProductQuery);
    if (lrbTypeId == 0 && brandId == 0) {
      List args = new List();
      args.add(ProductQuery);
      maps = await db.rawQuery("select * from products where " +
          ProductQuery +
          "  order by package_label asc limit 50");
    } else if (lrbTypeId != 0 && brandId == 0) {
      List args = new List();
      args.add(lrbTypeId);
      // args.add(ProductQuery);
      maps = await db.rawQuery(
          "select * from products where lrb_type_id=?1 and " +
              ProductQuery +
              "  order by package_label asc limit 50",
          args);
    } else if (lrbTypeId == 0 && brandId != 0) {
      List args = new List();
      args.add(brandId);
      // args.add(ProductQuery);
      maps = await db.rawQuery(
          "select * from products where brand_id=?1 and " +
              ProductQuery +
              "   order by package_label asc limit 50",
          args);
    } else if (lrbTypeId != 0 && brandId != 0) {
      List args = new List();
      args.add(lrbTypeId);
      args.add(brandId);
      // args.add(ProductQuery);
      maps = await db.rawQuery(
          "select * from products where lrb_type_id=?1 and brand_id=?2  and  " +
              ProductQuery +
              "  order by package_label asc limit 50",
          args);
    }
    return maps;
  }

  Future<void> deleteAllIncompleteOrder(outletId) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(outletId);

    int isdeleted = await db.rawDelete(
        "delete from outlet_orders where outlet_id=?1 and is_completed=0",
        args);
    if (isdeleted > 0) {
      print("Deleted incomplete order");
    } else {
      print("Not Deleted incomplete order");
    }
  }

  void deleteNoOrderReasons() async {
    final Database db = await database;
    await db.rawDelete("delete from no_order_reasons");
  }

  Future<void> deletePastOrders(outletId) async {
    final Database db = await database;
    List args = new List();
    args.add(outletId);

    int isdeleted = await db.rawDelete(
        "delete from outlet_orders where outlet_id=?1 and is_completed=0",
        args);
    if (isdeleted > 0) {
      //print("Deleted Unsed");
      return true;
    } else {
      //print("not Deleted Unsed");
      return false;
    }
  }

  Future initOrder(id, outlet_id, is_completed, is_uploaded, total_amount, uuid,
      created_on, lat, lng, accuracy) async {
    await this.initdb();
    final Database db = await database;

    int i = 0;
    try {
      i = await db.rawInsert(
          'insert into outlet_orders (id,outlet_id,is_completed,is_uploaded,total_amount,uuid,created_on, lat, lng, accuracy) values  (?,?,?,?,?,?,DATETIME("now","5 hours"),?,?,?) ',
          [
            id,
            outlet_id,
            is_completed,
            is_uploaded,
            total_amount,
            uuid,
            lat,
            lng,
            accuracy
          ]);
    } catch (error) {
      //print("//print ERROR");
      //print(error);
    }
    if (i > 0) {
      //print("created");
      return true;
    } else {
      //print("not created");
      return false;
    }
  }

  void insertNoOrderReason(id, label) async {
    await this.initdb();
    final Database db = await database;
    try {
      await db.rawInsert(
          'insert into no_order_reasons (id,label) values  (?,?) ',
          [id, label]);
    } catch (error) {
      //print(error);
    }
  }

  void saveNoOrder(
      id, outlet_id, reason_type_id, lat, lng, accuracy, uuid) async {
    await this.initdb();
    final Database db = await database;
    try {
      await db.rawInsert(
          "insert into outlet_no_orders (id, outlet_id, reason_type_id, lat, lng, accuracy, uuid, created_on, is_uploaded) values  (?, ?, ?, ?, ?, ?, ?,DATETIME('now','5 hours'), 0) ",
          [id, outlet_id, reason_type_id, lat, lng, accuracy, uuid]);
    } catch (error) {
      //print(error);
    }
  }

  Future<List<Map<String, dynamic>>> getAllNoOrders(isUploaded) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(isUploaded);

    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select * from outlet_no_orders where is_uploaded=?1", args);
    //print(maps.toString());
    return maps;
  }

  Future<List<Map<String, dynamic>>> getAllOrders(
      int outletId, int isCompleted) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(outletId);
    args.add(isCompleted);

    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select * from outlet_orders where outlet_id=?1 and is_completed=?2",
        args);
    print(maps.toString());
    return maps;
  }

  Future<List<Map<String, dynamic>>> getNoOrderReasons() async {
    await this.initdb();
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery("select * from no_order_reasons");
    //print(maps.toString());
    return maps;
  }

  Future<List<Map<String, dynamic>>> getAllOrdersByIsUploaded(
      int isUploaded) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(isUploaded);
    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select * from outlet_orders where is_completed=1 and is_uploaded=?1",
        args);
    return maps;
  }
  Future<List<Map<String, dynamic>>> getAllOrdersforminQuantityfor8(order_id) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(order_id);
    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select sum(quantity) as quantity8 from outlet_order_items where  order_id=?1 and brand_id=8 ",args);
    print("getAllOrdersforminQuantityfor8"+maps.toString());
    return maps;
  }
  Future<List<Map<String, dynamic>>> getAllOrdersforminQuantityfor9(order_id) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(order_id);
    print("order_id"+order_id.toString());
    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select sum(quantity) as quantity9 from outlet_order_items where order_id=?1and brand_id=9 ",args);
    print("getAllOrdersforminQuantityfor9"+maps.toString());
    return maps;
  }//order_id4441711961454955
//Added by Irteza
  Future<List<Map<String, dynamic>>> getVisitTime() async {
    await this.initdb();
    final Database db = await database;
   // List args = new List();
    //args.add(isUploaded);
    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select * from Outlet_Visit_Time where is_uploaded=0 ");
    //print(maps.toString());
    return maps;
  }
  Future<List<Map<String, dynamic>>> getAllOrdersForSyncReport() async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    //args.add(isUploaded);
    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select id,outlet_id,total_amount,is_uploaded,(select outlet_name from pre_sell_outlets2 pso where pso.outlet_id=oo.outlet_id) outlet_name from outlet_orders oo where (is_completed = 1 and date(created_on)=date('now') and is_uploaded=1) or (is_completed = 1  and is_uploaded=0)");
    //print(maps.toString());
    return maps;
  }

  Future<List<Map<String, dynamic>>> getAllAttendanceForSyncReport() async {
    await this.initdb();
    final Database db = await database;
    List args = new List();

    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select * from attendance where date(mobile_timestamp) = date('now')",
        args);

    return maps;
  }

  Future getOrderItemInfo(int orderId, int product_id) async {
    await this.initdb();
    final Database db = await database;
    List args1 = new List();
    args1.add(orderId);
    args1.add(product_id);
    final List<Map> maps = await db.rawQuery(
        "select * from outlet_order_items where order_id=?1 and product_id=?2",
        args1);
    return maps;
  }

  Future addItemToCurrentOrderV0(int orderId, List item) async {
    await this.initdb();
    final Database db = await database;
//print("ORDER ID"+orderId.toString());
    double totalAmount = 0.0;
    for (int i = 0; i < item.length; i++) {
      List args = new List();
      args.add(orderId);
      args.add(item[i]['product_id']);
      args.add(globals.brand_id);
      args.add(item[i]['discount']);
      args.add(item[i]['quantity']);
      args.add(item[i]['amount']);
      double Amount = item[i]['amount'];
      args.add(item[i]['created_on']);
      args.add(item[i]['rate']);
      args.add(item[i]['product_label']);
      totalAmount += Amount;

      List args1 = new List();
      args1.add(orderId);
      args1.add(item[i]['product_id']);
      final List<Map> maps = await db.rawQuery(
          "select * from outlet_order_items where order_id=?1 and product_id=?2",
          args1);
      if (maps.isEmpty) {
        await db.rawInsert(
            'insert into outlet_order_items (order_id ,product_id ,brand_id,discount,quantity ,amount ,created_on,rate,product_label) values  (?,?,?,?,?,?,?,?,?) ',
            args);
      } else {
        List args2 = new List();
        args2.add(item[i]['quantity']);
        args2.add(item[i]['discount']);
        args2.add(item[i]['amount']);
        args2.add(item[i]['rate']);
        args2.add(orderId);
        args2.add(item[i]['product_id']);
        args2.add(globals.brand_id);
        await db.rawUpdate(
            'update outlet_order_items set quantity=?1,discount=?2,amount=?3, rate=?4 where order_id=?5 and product_id=?6',
            args2);
      }
    }
    List args1 = new List();
    args1.add(orderId);
    final List<Map> maps = await db.rawQuery(
        "select sum(amount) amount from outlet_order_items where order_id=?1",
        args1);
    if (maps.isNotEmpty) {
      totalAmount = maps[0]['amount'];
    }
    List args = new List();
    args.add(orderId);
    args.add(totalAmount);
    print(
        'update outlet_orders set is_completed=0,total_amount=$totalAmount where id=$orderId ');
    await db.rawUpdate(
        'update outlet_orders set is_completed=0,total_amount=?2 where id=?1 ',
        args);
    return true;
  }
  Future<int> addItemToCurrentOrders(
      int orderId, List item) async {
    await this.initdb();
    final Database db = await database;
    int isNewEntry = 0;
//print("ORDER ID"+orderId.toString());
    double totalAmount = 0.0;
    for (int i = 0; i < item.length; i++) {
      List args = new List();
      args.add(orderId);
      args.add(item[i]['product_id']);
      args.add(item[i]['product_label']);

      List args1 = new List();
      args1.add(orderId);
      args1.add(item[i]['product_id']);
      final List<Map> maps = await db.rawQuery(
          "select * from outlet_order_items_MV where order_id=?1 and product_id=?2",
          args1);
        await db.rawInsert(
            'insert into outlet_order_items_MV (order_id ,product_id , product_label) values  (?,?,?) ',
            args);

    }

    return isNewEntry;
  }

  Future<int> addItemToCurrentOrder(
      int orderId, List item, isForcedNewEntry) async {
    await this.initdb();
    final Database db = await database;
    int isNewEntry = 0;
//print("ORDER ID"+orderId.toString());
    double totalAmount = 0.0;
    print("Items==>"+item.length.toString());
    for (int i = 0; i < item.length; i++) {
      List args = new List();

      //int brandId=0;
      print("Items==>"+isNewEntry.toString());

      List<Map<String, dynamic>> product = await getProductById(item[i]['product_id']);

      args.add(orderId);
      args.add(item[i]['product_id']);
      args.add(product[0]['lrb_type_id']);
      args.add(item[i]['discount']);
      args.add(item[i]['quantity']);
      args.add(item[i]['amount']);
      double Amount = item[i]['amount'];
      args.add(item[i]['created_on']);
      args.add(item[i]['rate']);
      args.add(item[i]['product_label']);

      args.add(item[i]['unit_quantity']);
      args.add(item[i]['is_promotion']);
      args.add(item[i]['promotion_id']);
      args.add(item[i]['id']);
      args.add(item[i]['source_id']);

      totalAmount += Amount;

      List args1 = new List();
      args1.add(orderId);
      args1.add(item[i]['product_id']);
      final List<Map> maps = await db.rawQuery(
          "select * from outlet_order_items where order_id=?1 and product_id=?2",
          args1);
      if (isForcedNewEntry == 1) {
        await db.rawInsert(
            'insert into outlet_order_items (order_id ,product_id ,brand_id,discount,quantity ,amount ,created_on,rate,'
                'product_label, unit_quantity, is_promotion, promotion_id, id, source_id) values  (?,?,?,?,?,?,?,?,?,?,?,?,?,?) ',
            args);
      } else if (maps.isEmpty) {
        isNewEntry = 1;
        await db.rawInsert(
            'insert into outlet_order_items (order_id ,product_id ,brand_id,discount,quantity ,amount ,created_on,rate,'
                'product_label, unit_quantity, is_promotion, promotion_id,id,source_id) values  (?,?,?,?,?,?,?,?,?,?,?,?,?,?) ',
            args);
      } else {
        print("inside Update section");
        List args2 = new List();

        args2.add(item[i]['quantity']);
        args2.add(item[i]['discount']);
        args2.add(item[i]['amount']);
        args2.add(item[i]['rate']);
        args2.add(item[i]['unit_quantity']);
        args2.add(item[i]['is_promotion']);
        args2.add(item[i]['promotion_id']);
        args2.add(orderId);
        args2.add(item[i]['product_id']);

        print("args2 =>"+args2.toString());


        if (item[i]['is_promotion'] == 0) {
          print("inside If ===>");
          await db.rawUpdate(
              'update outlet_order_items set quantity=?1,discount=?2,amount=?3, rate=?4, unit_quantity=?5,is_promotion=?6, promotion_id=?7  where order_id=?8 and product_id=?9 and source_id=0',
              args2);
        }
        else {
          print("inside Else =====> ");
          await db.rawUpdate(
              'update outlet_order_items set quantity=?1,discount=?2,amount=?3, rate=?4, unit_quantity=?5,is_promotion=?6, promotion_id=?7  where order_id=?8 and product_id=?9 and promotion_id=?7',
              args2);
        }
      }
    }
    List args1 = new List();
    args1.add(orderId);
    final List<Map> maps = await db.rawQuery(
        "select sum(amount) amount from outlet_order_items where order_id=?1 and is_promotion=0",
        args1);
    if (maps.isNotEmpty) {
      totalAmount = maps[0]['amount'];
    }

    List args = new List();
    args.add(orderId);
    args.add(totalAmount);
    await db.rawUpdate(
        'update outlet_orders set is_completed=0,total_amount=?2 where id=?1 ',
        args);
    return isNewEntry;
  }

  Future<List<Map<String, dynamic>>> getProductById(productId) async {
    await this.initdb();
    final Database db = await database;
    // Query the table for all The Dogs.
    List<Map> maps = null;

    List args = new List();
    args.add(productId);

    maps =
    await db.rawQuery("select * from products where  product_id=?1 ", args);

    return maps;
  }
  Future<List<Map<String, dynamic>>> getLRbName8() async {
    await this.initdb();
    final Database db = await database;
    // Query the table for all The Dogs.
    List<Map> maps = null;


    maps =
    await db.rawQuery("select * from product_lrb_types where  id=8");

    return maps;
  }
  Future<List<Map<String, dynamic>>> getLRbName9() async {
    await this.initdb();
    final Database db = await database;
    // Query the table for all The Dogs.
    List<Map> maps = null;


    maps =
    await db.rawQuery("select * from product_lrb_types where  id=9");

    return maps;
  }
  Future<List<Map<String, dynamic>>>  SelectOutletByIDMV(int outletId) async {
    await this.initdb();
    final Database db = await database;

    // Query the table for all The Dogs.
    List args = new List();
    args.add(outletId);

    final List<Map> maps =  await db.rawQuery('Select *from  MV_Outlets where outlet_id=?1 ', args);
    return maps;
  }
  Future<List<Map<String, dynamic>>>  SelectOutletByID(int outletId) async {
    await this.initdb();
    final Database db = await database;

    // Query the table for all The Dogs.
    List args = new List();
    args.add(outletId);

    final List<Map> maps =  await db.rawQuery('Select *from  pre_sell_outlets2 where outlet_id=?1 ', args);
    return maps;
  }

  Future  completeOrder(lat, lng, accuracy, int outletId, int isSpotSale) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();

    args.add(lat);
    args.add(lng);
    args.add(accuracy);
    args.add(outletId);
    args.add(isSpotSale);
    await db.rawUpdate(
        'update outlet_orders set is_completed=1,accuracy=?3, is_spot_sale=?5 where outlet_id=?4 ',
        args);
    return true;
  }

  Future markOrderUploaded(int orderId) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(orderId);
    await db.rawUpdate(
        'update outlet_orders set is_uploaded=1 where id=?1 ', args);
    return true;
  }
//Added by Irteza Ali
  Future delete_outlet_visit_time() async {
    await this.initdb();
    final Database db = await database;
    await db.rawUpdate(
        'delete from Outlet_Visit_Time');
    return true;
  }
  Future MarkVisitUpdate(int Outlet_id) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(Outlet_id);
    await db.rawUpdate(

        'update Outlet_Visit_Time set is_uploaded=1 where outlet_id=?1 ', args);
    return true;
  }
  Future markNoOrderUploaded(int orderId) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(orderId);
    await db.rawUpdate(
        'update outlet_no_orders set is_uploaded=1 where id=?1 ', args);
    return true;
  }

  Future markOutletUploaded(String outletId) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    print('outletId '+outletId);
    await db.rawUpdate(
        'update registered_outlets set is_uploaded=1 where mobile_request_id=?1 ',
        [outletId]);
    return true;
  }
//SO_MV===============
  Future<List<Map<String, dynamic>>> getAllAddedItemsOfOrders(
      int orderId) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(orderId);

    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select distinct product_id,product_label,order_id from  outlet_order_items_MV where order_id=?1", args);
    //print(maps);

    return maps;
  }
  //End=================
  Future<List<Map<String, dynamic>>> getAllAddedItemsOfOrder(
      int orderId) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(orderId);

    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select  *from  outlet_order_items where order_id=?1", args);
    //print(maps);

    return maps;
  }
  Future<void> deleteUploadedOrder(orderId) async {
    final Database db = await database;
    List args = new List();
    args.add(orderId);
    int isdeleted2 = await db.rawDelete(
        "delete from outlet_order_items where order_id=?1", args);
    int isdeleted =
    await db.rawDelete("delete from outlet_orders where id=?1", args);

    if (isdeleted > 0) {
      //print("Deleted outlet_orders");

      if (isdeleted2 > 0) {
        //print("Deleted outlet_orders_items");
        return true;
      } else {
        //print("not Deleted outlet_orders_items");
        return false;
      }
    } else {
      //print("not Deleted outlet_orders");
      return false;
    }
  }

  Future<void> deleteOrderItem(int orderId, int itemId) async {
    final Database db = await database;
    List args = new List();
    args.add(orderId);
    args.add(itemId);
    await db.rawDelete(
        "delete from outlet_order_items where order_id=?1 and product_id=?2",
        args);
  }

  Future<void> deleteOrderItemBySourceId(int orderId, int sourceId) async {
    final Database db = await database;
    List args = new List();
    args.add(orderId);
    args.add(sourceId);
    print(
        "delete from outlet_order_items where order_id=$orderId and source_id=$sourceId");
    await db.rawDelete(
        "delete from outlet_order_items where order_id=?1 and source_id=?2",
        args);
  }

  Future<List<Map<String, dynamic>>> getUser(
      int UserId, String Password) async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;

    // Query the table for all The Dogs.
    List args = new List();
    args.add(UserId);
    args.add(Password);
    final List<Map> maps = await db.rawQuery(
        "select user_id,display_name,designation,distributor_employee_id,password, created_on   from users where user_id=? and password=?",
        args);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    //print('list: ');
    //print(maps);
    return maps;
  }

  Future<void> deleteUsers() async {
    final Database db = await database;
    await db.delete('users');
  }

  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    // //print(product);
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> isVisitExists(outletId) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(outletId);
    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select * from outlet_orders where is_completed=1 and outlet_id=?1 and date(created_on)= DATE('NOW')",
        args);
    int typeId = 0;
    final List<Map> maps1 = await db.rawQuery(
        "select * from outlet_no_orders where outlet_id=?1 and date(created_on)= DATE('NOW')",
        args);
    final List<Map> maps2 = await db.rawQuery(
        "select * from outlet_mark_close where outlet_id=?1 and date(created_on)= DATE('NOW')",
        args);
    //print(maps1.toString());

    if (maps.isNotEmpty || maps2.isNotEmpty || maps1.isNotEmpty) {
      typeId = 1;
    }

    return typeId;
  }

  /**
   * Returns visit type
   * 0 for not visited
   * 1 for order
   * 2 for no order
   * 3 for outlet closed
   */
  Future<int> getVisitType(String outletId) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(outletId);
    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select * from outlet_orders where is_completed=1 and outlet_id=?1 and date(created_on)= DATE('NOW')",
        args);
    //print(maps.toString());
    int typeId = 0;

    final List<Map> maps1 = await db.rawQuery(
        "select * from outlet_no_orders where outlet_id=?1 and date(created_on)= DATE('NOW')",
        args);
    final List<Map> maps2 = await db.rawQuery(
        "select * from outlet_mark_close where outlet_id=?1 and date(created_on)= DATE('NOW')",
        args);
    final List<Map> maps3 = await db.rawQuery(
        "select * from Outlet_Visit_Time where outlet_id=?1 and date(mobile_timestamp)= DATE('NOW')",
        args);
    //print(maps1.toString());

    if (maps1.isNotEmpty) {
      //print("i am here danish");
      typeId = 2;
    }
    if (maps.isNotEmpty) {
      typeId = 1;
    }
    if (maps2.isNotEmpty) {
      typeId = 3;
    }
    if(!maps.isNotEmpty && !maps1.isNotEmpty && !maps2.isNotEmpty){
      if (maps3.isNotEmpty) {
        typeId = 4;
      }
    }


    return typeId;
  }

  /**
   * set visit type
   * 0 for not visited
   * 1 for order
   * 2 for no order
   * 3 for outlet closed
   */
  Future setVisitType(int outletId, int visitType) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(outletId);
    args.add(visitType);
    print("visitType"+visitType.toString());
    await db.rawUpdate(
        'update pre_sell_outlets2 set visit_type=?2 where outlet_id=?1 ', args);
    return true;
  }
  Future<bool> CheckVisit(int outletId) async {
    await this.initdb();
    final Database db = await database;
    List args = [outletId]; // Use a list literal for simplicity
    List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT * FROM pre_sell_outlets2 WHERE visit_type IN (1, 2) AND outlet_id = ? AND visit_type != 0',
      args,
    );


    bool hasVisits = results.isNotEmpty;
    print("hasVisits"+hasVisits.toString());

    return !hasVisits;



  }



  /***************************************************************/
  //FARHAN WORK Starts
  /***************************************************************/
  Future<void> deleteAllOutletProductsAlternativePrices() async {
    final Database db = await database;
    await db.delete('outlet_product_alternative_prices');
  }

  Future<void> insertOutletProductsAlternativePrices(
      OutletProductsAlternativePrices ProductsPrices) async {
    // Get a reference to the database.
    final Database db = await database;
    try {
      await db.insert(
        'outlet_product_alternative_prices',
        ProductsPrices.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (error) {
      //print("ERROR outlet_product_alternative_prices : "+error);
      //print(error);
    }
  }

  Future<void> deleteAllOutletAreas() async {
    final Database db = await database;
    await db.delete('outlet_areas');
  }

  Future<void> insertOutletAreas(OutletAreas outletAreas) async {
    final Database db = await database;
    try {
      await db.insert(
        'outlet_areas',
        outletAreas.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (error) {
      //print("ERROR insertOutletAreas : "+error);
      //print(error);
    }
  }

  Future<void> deleteAllOutletSubAreas() async {
    final Database db = await database;
    await db.delete('outlet_sub_areas');
  }

  Future<void> insertOutletSubAreas(OutletSubAreas outletSubAreas) async {
    final Database db = await database;
    try {
      await db.insert(
        'outlet_sub_areas',
        outletSubAreas.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (error) {
      //print("ERROR insertOutletSubAreas : "+error);
      //print(error);
    }
  }

  Future<void> deleteAllPCISubAreas() async {
    final Database db = await database;
    await db.delete('pci_sub_channel');
  }

  Future<void> insertPCISubAreas(PCISubAreas pciSubAreas) async {
    final Database db = await database;
    try {
      await db.insert(
        'pci_sub_channel',
        pciSubAreas.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (error) {
      //print("ERROR insertPCISubAreas : "+error);
      //print(error);
    }
  }
  Future<void> deleteAllPJP() async {
    final Database db = await database;
    await db.delete('BeatPlan_MarketVisit');
  }
  Future<void> insertBeatPlan_MV(List PJP_MarketVisit) async {
    final Database db = await database;
    for (int i = 0; i < PJP_MarketVisit.length; i++) {
      List args = new List();
      args.add(PJP_MarketVisit[i]['value']);
      args.add(PJP_MarketVisit[i]['text']);
      args.add(PJP_MarketVisit[i]['city']);
      await db.rawInsert(
          'insert into BeatPlan_MarketVisit (id,label,city) values  (?,?,?) ',
          args);
    }
  }
  Future<void> deleteAllCities() async {
    final Database db = await database;
    await db.delete('Cities');
  }
  Future<void> insertCities(List Cities_MarketVisit) async {
    final Database db = await database;
    for (int i = 0; i < Cities_MarketVisit.length; i++) {
      List args = new List();
      args.add(Cities_MarketVisit[i]['city']);
      args.add(Cities_MarketVisit[i]['id']);
      await db.rawInsert(
          'insert into Cities (city,id) values  (?,?) ',
          args);
    }
  }
  Future<void> deleteAllMVOutlets() async {
    final Database db = await database;
    await db.delete('MV_Outlets');
  }
  Future<void> insertMV_Outlets(List MV_Outlets) async {
    final Database db = await database;
    for (int i = 0; i < MV_Outlets.length; i++) {
      List args = new List();
      args.add(MV_Outlets[i]['OutletName']);
      args.add(MV_Outlets[i]['OutletAddress']);
      args.add(MV_Outlets[i]['OutletPJPID']);
      args.add(MV_Outlets[i]['OutletPJPLabel']);
      args.add(MV_Outlets[i]['DistributorID']);
      args.add(MV_Outlets[i]['DistributorName']);
      args.add(MV_Outlets[i]['OwnerName']);
      args.add(MV_Outlets[i]['OwnerContact']);
      args.add(MV_Outlets[i]['Region']);
      args.add(MV_Outlets[i]['RegionName']);
      args.add(MV_Outlets[i]['RegionShortName']);
      args.add(MV_Outlets[i]['ChannelID']);
      args.add(MV_Outlets[i]['ChannelLabel']);
      args.add(MV_Outlets[i]['DayNumber']);
      args.add(MV_Outlets[i]['OutletID']);
      args.add(MV_Outlets[i]['lat']);
      args.add(MV_Outlets[i]['lng']);
      args.add(MV_Outlets[i]['IsGeoFence']);
      args.add(MV_Outlets[i]['Radius']);





      await db.rawInsert(
          'insert into MV_Outlets (outlet_name,outlet_address,id,pjp_label,distributor_idd,distributor_name,owner_name,owner_contact,region_idd,region_name,region_short,channel_idd,channel_name,day_number,outlet_id,lat,lng,IsGeoFence,Radius) values  (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ',
          args);
    }
  }
/*  Future<void> insertMV_Products(List MVProduct) async {
    final Database db = await database;
    for (int i = 0; i < MVProduct.length; i++) {
      List args = new List();
      args.add(MVProduct[i]['ProductID']);
      args.add(MVProduct[i]['Brand']);
      args.add(MVProduct[i]['Package']);
      args.add(MVProduct[i]['SortOrder']);
      args.add(MVProduct[i]['UnitPerCase']);
      args.add(MVProduct[i]['PackageID']);
      args.add(MVProduct[i]['BrandID']);
      args.add(MVProduct[i]['LRB']);
      args.add(MVProduct[i]['LRBID']);
      args.add(MVProduct[i]['Product']);

      await db.rawInsert(
          'insert into MV_Products(product_id TEXT,brand_label TEXT,package_label TEXT,sort_order TEXT,unit_per_case TEXT,package_id TEXT,brand_id TEXT,lrb_label TEXT,lrb_type_id TEXT,product TEXT) values  (?,?,?,?,?,?,?,?,?,?) ',
          args);
    }
  }*/
  Future<List<Map<String, dynamic>>> getOutletProductsAlternativePrices(
      int productId) async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;

    // Query the table for all The Dogs.
    List args = new List();
    args.add(productId);
    final List<Map> maps = await db.rawQuery(
        "select *  from outlet_product_alternative_prices where product_id=?1 limit 1",
        args);

    return maps;
  }

  Future registerOutlet(List formFields) async {
    await this.initdb();
    final Database db = await database;

    for (int i = 0; i < formFields.length; i++) {
      print("saved " + i.toString());
      List args = new List();

      args.add(formFields[i]['outlet_name'].toString());
      args.add(formFields[i]['mobile_request_id'].toString());

      args.add(formFields[i]['channel_id']);
      args.add(formFields[i]['area_label'].toString());
      args.add(formFields[i]['sub_area_label'].toString());
      args.add(formFields[i]['address'].toString());
      args.add(formFields[i]['owner_name'].toString());
      args.add(formFields[i]['owner_cnic'].toString());
      args.add(formFields[i]['owner_mobile_no'].toString());
      args.add(formFields[i]['purchaser_name'].toString());
      args.add(formFields[i]['purchaser_mobile_no'].toString());
      args.add(formFields[i]['is_owner_purchaser'].toString());
      args.add(formFields[i]['lat']);
      args.add(formFields[i]['lng']);
      args.add(formFields[i]['accuracy']);

      args.add(formFields[i]['created_by']);
      args.add(formFields[i]['is_uploaded']);

      //"CREATE TABLE (outlet_name TEXT,mobile_request_id TEXT,mobile_timestamp TEXT, channel_id INTEGER,sub_area_id INTEGER,address TEXT, owner_name TEXT,owner_cnic TEXT, owner_mobile_no TEXT,purchaser_name TEXT,purchaser_mobile_no TEXT, is_owner_purchaser INTGER, lat REAL, lng REAL, accuracy INTEGER, created_on TEXT,created_by INTEGER)"

      await db.rawInsert(
          'insert into registered_outlets (outlet_name ,mobile_request_id ,mobile_timestamp,channel_id ,area_label,sub_area_label ,address,owner_name,owner_cnic,owner_mobile_no,purchaser_name,purchaser_mobile_no,is_owner_purchaser,lat,lng,accuracy,created_on,created_by,is_uploaded) values  (?,?,DATETIME("now","5 hours"),?,?,?,?,?,?,?,?,?,?,?,?,?,DATETIME("now","5 hours"),?,?) ',
          args);
    }

    return true;
  }

  Future<bool> saveRegisterOutletImages(List DocumentPicture) async {
    await this.initdb();
    final Database db = await database;
    int j = 0;
    try {
      for (int i = 0; i < DocumentPicture.length; i++) {
        List args = new List();
        args.add(DocumentPicture[i]['unique_id']);
        args.add(DocumentPicture[i]['mobile_request_id']);
        args.add(DocumentPicture[i]['documentfile']);
        args.add(DocumentPicture[i]['lat']);
        args.add(DocumentPicture[i]['lng']);
        args.add(DocumentPicture[i]['accuracy']);
        args.add(DocumentPicture[i]['mobile_timeStamp']);
        print(args);
        j = await db.rawInsert(
            'insert into register_outlet_images(id, outlet_request_id ,file, lat,lng ,accuracy, mobile_timeStamp) values  (?,?,?,?,?,?,?) ', args);
      }
    } catch (error) {
      print("//print ERROR");
      print(error);
    }
    if (j > 0) {
      //print("created");
      return true;
    } else {
      //print("not created");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getRegisterOutletImages() async {
    // Get a reference to the database.
    await this.initdb();
    final Database db = await database;
    //print("Product ID "+productId.toString());
    //print("outletId ID "+outletId.toString());
    // Query the table for all The Dogs.
    List args = new List();

    final List<Map> maps = await db.rawQuery(
        "select *  from register_outlet_images");

    // /print(maps);
    return maps;
  }

  Future<void> deleteRegisterOutletImage(String unique_id) async {
    print('mobile_order_id '+unique_id);
    final Database db = await database;

    await db.rawDelete(
        "delete from register_outlet_images where id=?1", [unique_id]);
  }

  Future<List<Map<String, dynamic>>> getAllRegisteredOutletsByIsUploaded(
      int isUploaded) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(isUploaded);

    final List<Map> maps = await db.rawQuery(
        "select * from registered_outlets where  is_uploaded=?1", args);

    return maps;
  }

  Future<List<Map<String, dynamic>>> getPCIChannels() async {
    await this.initdb();
    final Database db = await database;

    final List<Map> maps = await db.rawQuery("select *  from pci_sub_channel");

    return maps;
  }
  Future<List> getPJPforMarketVisit() async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(globals.Cities);
    print("args============>"+args.toString());
    print("Cities================>"+globals.Cities);

    print("Inside========================>");
    final List<Map> maps = await db.rawQuery("select * from BeatPlan_MarketVisit where  city= ?1", args);

    return maps;
  }
  Future<List> getCities() async {
    await this.initdb();
    final Database db = await database;

    final List<Map> maps = await db.rawQuery("select * from Cities");

    return maps;
  }
  Future<List<Map<String, dynamic>>> getOutletAreas() async {
    await this.initdb();
    final Database db = await database;

    final List<Map> maps = await db.rawQuery("select *  from outlet_areas ");

    //print('getOutletAreas: ');

    //print(maps);
    return maps;
  }

  Future<List> getChannelSuggestions(String query) async {
    await initdb();
    final Database db = await database;
    // await Future.delayed(Duration(seconds: 1));

    List args = new List();
    args.add(query);
    //print("QUERY"+query);

    final List maps = await db.rawQuery(
        "select id,label  from pci_sub_channel where label like ?1", args);

    //print('pci_sub_channel: ');

    //print(maps);
    return maps;

    /*
    return List.generate(3, (index) {
      return {'name': query + index.toString(), 'price': Random().nextInt(100)};
    });
*/
  }
  Future<List<Map<String, dynamic>>> getpjp(String City) async {
    await initdb();
    final Database db = await database;
    // await Future.delayed(Duration(seconds: 1));

    List args = new List();
    //  args.add(query);
    args.add(globals.Cities);

    print("================>>>>>>>"+args.toString());
    // print("QUERY"+query);

    final List<Map> maps = await db.rawQuery(
        "select id,label  from BeatPlan_MarketVisit where  city= ?1", args);

    //print('pci_sub_channel: ');

    print(maps);
    return maps;

    /*
    return List.generate(3, (index) {
      return {'name': query + index.toString(), 'price': Random().nextInt(100)};
    });
*/
  }
  Future<List> getcity(String query) async {
    await initdb();
    final Database db = await database;
    // await Future.delayed(Duration(seconds: 1));

    List args = new List();
    args.add(query);
    //print("QUERY"+query);

    final List maps = await db.rawQuery(
        "select distinct city  from Cities where city like ?1", args);

    //print('pci_sub_channel: ');

    //print(maps);
    return maps;

    /*
    return List.generate(3, (index) {
      return {'name': query + index.toString(), 'price': Random().nextInt(100)};
    });
*/
  }
  Future<List> getAreaSuggestions(String query) async {
    await initdb();
    final Database db = await database;
    //await Future.delayed(Duration(seconds: 1));

    List args = new List();
    args.add(query);
    //print("QUERY"+query);

    final List maps = await db.rawQuery(
        "select id,label  from outlet_areas where label like ?1", args);

    //print('getOutletAreas: ');

    //print(maps);
    return maps;
/*
    return List.generate(3, (index) {
      return {'name': query + index.toString(), 'price': Random().nextInt(100)};
    });
*/
  }

  Future<List> getSubAreaSuggestions(String query, int areaId) async {
    await initdb();
    final Database db = await database;
    //await Future.delayed(Duration(seconds: 1));

    List maps = null;
    if (query != "") {
      List args = new List();
      args.add(areaId);
      args.add(query);
      //print("QUERY"+query);
      maps = await db.rawQuery(
          "select id,label from outlet_sub_areas where area_id=?1 and label like ?2",
          args);
    } else {
      List args = new List();
      args.add(areaId);
      //print("QUERY"+query);
      maps = await db.rawQuery(
          "select id,label from outlet_sub_areas where id area_id=?1 ", args);
    }

    //print('outlet_sub_areas: ');

    //print(maps);
    return maps;
  }

/***************************************************************/
//FARHAN WORK ENDS
/***************************************************************/
  /*Future<List<Map<String, dynamic>>> getAllMarkedOutlets(int isUploaded) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(isUploaded);
    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select * from outlet_images where is_uploaded=?1", args);

    return maps;
  }

  Future<List<Map<String, dynamic>>> getAllMarkedUploadedOutlets(
      int isPhotoUploaded) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(isPhotoUploaded);
    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select * from outlet_images where is_uploaded=1 and is_photo_uploaded=?1",
        args);

    return maps;
  }

  Future markOutlet(mobile_request_id, image_path, outlet_type_id, lat, lng,
      accuracy, user_id, is_uploaded, uuid, is_photo_uploaded) async {
    await this.initdb();
    final Database db = await database;

    try {
      await db.rawInsert(
          'insert into outlet_images (mobile_request_id ,mobile_timestamp,outlet_type_id,lat,lng,accuracy,is_uploaded,uuid,image_path,user_id,is_photo_uploaded) values  (?,DATETIME("now","5 hours"),?,?,?,?,?,?,?,?,?) ',
          [
            mobile_request_id,
            outlet_type_id,
            lat,
            lng,
            accuracy,
            is_uploaded,
            uuid,
            image_path,
            user_id,
            is_photo_uploaded
          ]);
    } catch (error) {
      print(error);
    }

    return true;
  }

  Future markOutletsUploaded(int id) async {
    print("markoutlet_imagesUploaded id" + id.toString());
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(id);

    try {
      await db.rawUpdate(
          'update outlet_images set is_uploaded=1 where mobile_request_id=?1 ',
          args);
    } catch (error) {
      print("markoutlet_imagesUploaded ==>> " + error);
    }

    return true;
  }

  Future markOutletsUploadedPhoto(int id) async {
    print("markoutlet_imagesUploaded id  ==>> " + id.toString());
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(id);
    try {
      await db.rawUpdate(
          'update outlet_images set is_photo_uploaded=1 where mobile_request_id=?1 and is_uploaded=1',
          args);
    } catch (error) {
      print("markoutlet_imagesUploadedPhoto ==>> " + error);
    }

    return true;
  }

  ///////////////////////Outlet images End///////////////////////////////////////////
  */
  Future<List<Map<String, dynamic>>> getAllMarkedAttendances(
      int isUploaded) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(isUploaded);
    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select * from attendance where is_uploaded=?1", args);

    return maps;
  }

  Future<List<Map<String, dynamic>>> getAllMarkedUploadedAttendances(
      int isPhotoUploaded) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(isPhotoUploaded);
    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select * from attendance where is_uploaded=1 and is_photo_uploaded=?1",
        args);

    return maps;
  }

  Future markAttendance(mobile_request_id, image_path, attendance_type_id, lat,
      lng, accuracy, user_id, is_uploaded, uuid, is_photo_uploaded) async {
    await this.initdb();
    final Database db = await database;

    try {
      await db.rawInsert(
          'insert into attendance (mobile_request_id ,mobile_timestamp,attendance_type_id,lat,lng,accuracy,is_uploaded,uuid,image_path,user_id,is_photo_uploaded) values  (?,DATETIME("now","5 hours"),?,?,?,?,?,?,?,?,?) ',
          [
            mobile_request_id,
            attendance_type_id,
            lat,
            lng,
            accuracy,
            is_uploaded,
            uuid,
            image_path,
            user_id,
            is_photo_uploaded
          ]);
    } catch (error) {
      print(error);
    }

    return true;
  }

  Future markAttendanceUploaded(int id) async {
    print("markAttendanceUploaded id" + id.toString());
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(id);

    try {
      await db.rawUpdate(
          'update attendance set is_uploaded=1 where mobile_request_id=?1 ',
          args);
    } catch (error) {
      print("markAttendanceUploaded ==>> " + error);
    }

    return true;
  }

  Future markAttendanceUploadedPhoto(int id) async {
    print("markAttendanceUploaded id  ==>> " + id.toString());
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(id);
    try {
      await db.rawUpdate(
          'update attendance set is_photo_uploaded=1 where mobile_request_id=?1 and is_uploaded=1',
          args);
    } catch (error) {
      print("markAttendanceUploadedPhoto ==>> " + error);
    }

    return true;
  }

  Future insertMerchandising(mobile_request_id, outlet_id, lat, lng, accuracy,
      is_completed, uuid, imagesList, is_photo_uploaded, user_id) async {
    await this.initdb();
    final Database db = await database;
    try {
      for (int i = 0; i < imagesList.length; i++) {
        await db.rawInsert(
            'insert into merchandising (mobile_request_id ,outlet_id ,user_id ,mobile_timestamp ,lat , lng , accuracy ,is_completed,uuid,image,type_id,is_photo_uploaded) values  (?,?,?,DATETIME("now","5 hours"),?,?,?,?,?,?,?,?)',
            [
              mobile_request_id,
              outlet_id,
              user_id,
              lat,
              lng,
              accuracy,
              is_completed,
              uuid,
              imagesList[i]["image"],
              imagesList[i]["typeId"],
              is_photo_uploaded
            ]);
      }
    } catch (error) {
      print(error);
    }

    return true;
  }

  Future<List<Map<String, dynamic>>> getAllMerchandising(
      int isPhotoUploaded) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(isPhotoUploaded);
    // Query the table for all The Dogs.
    final List<Map> maps = await db.rawQuery(
        "select * from merchandising where is_photo_uploaded=?1", args);

    return maps;
  }

  Future markMerchandisingPhotoUploaded(int id, int typeId) async {
    print("markMerchandisingPhotoUploaded id  ==>> " + id.toString());
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(id);
    args.add(typeId);
    try {
      await db.rawUpdate(
          'update merchandising set is_photo_uploaded=1  where mobile_request_id=?1 and type_id=?2',
          args);
    } catch (error) {
      print("markMerchandisingPhotoUploaded  ==>> " + error);
    }

    return true;
  }
  Future<bool> saveChannelTaggingImage(List DocumentPicture) async {
    await this.initdb();
    final Database db = await database;
    int j = 0;
    try {
      for (int i = 0; i < DocumentPicture.length; i++) {
        List args = new List();
        args.add(DocumentPicture[i]['mobile_request_id']);
        args.add(DocumentPicture[i]['outletId']);
        args.add(DocumentPicture[i]['documentfile']);
        args.add(DocumentPicture[i]['lat']);
        args.add(DocumentPicture[i]['lng']);
        args.add(DocumentPicture[i]['accuracy']);
        args.add(DocumentPicture[i]['mobile_timeStamp']);
        print(args);
        j = await db.rawInsert(
            'insert into channel_tagging_images(mobile_request_id, id ,file, lat,lng ,accuracy, mobile_timeStamp) values  (?,?,?,?,?,?,?) ', args);
      }
    } catch (error) {
      print("//print ERROR");
      print(error);
    }
    if (j > 0) {
      //print("created");
      return true;
    } else {
      //print("not created");
      return false;
    }
  }
  Future<bool> addChannel(mobile_request_id,outlet_id,outlet_name, channel_id, lat,lng,accuracy,user_id) async {
    await this.initdb();
    final Database db = await database;
    print('addd channel ================');
    print([
      mobile_request_id,
      outlet_id,
      outlet_name,
      channel_id,
      lat,
      lng,
      accuracy,
      user_id
    ]);
    int j = 0;
    try {

      j = await db.rawInsert(
        'insert into channel_tagging(mobile_request_id,outlet_id,outlet_name, channel_id, lat,lng,accuracy, user_id) values  (?,?,?,?,?,?,?,?) ',
        [
          mobile_request_id,
          outlet_id,
          outlet_name,
          channel_id,
          lat,
          lng,
          accuracy,
          user_id
        ],
      );

    } catch (error) {
      //print("//print ERROR");
      print(error);
    }
    if (j > 0) {
      print("created");
      return true;
    } else {
      //print("not created");
      return false;
    }
  }
  Future<bool> saveOutletOrderImage(List DocumentPicture) async {
    await this.initdb();
    final Database db = await database;
    int j = 0;
    try {
      for (int i = 0; i < DocumentPicture.length; i++) {
        List args = new List();

        args.add(DocumentPicture[i]['id']);
        args.add(DocumentPicture[i]['documentfile'].toString());

        j = await db.rawInsert(
            'insert into outlet_orders_images(id  , file) values  (?,?) ',
            args);
      }
    } catch (error) {
      //print("//print ERROR");
      //print(error);
    }
    if (j > 0) {
      //print("created");
      return true;
    } else {
      //print("not created");
      return false;
    }
  }
//Added by Irteza Ali
  Future<bool> InsertVisitTime(List Document) async {
    await this.initdb();
    final Database db = await database;
    int j = 0;
    try {
      for (int i = 0; i < Document.length; i++) {
        List args = new List();

        args.add(Document[i]['id']);
        args.add(Document[i]['outlet_id'].toString());
        args.add(Document[i]['mobile_timestamp'].toString());
        args.add(Document[i]['file_type'].toString());
        args.add(Document[i]['lat'].toString());
        args.add(Document[i]['lng'].toString());
        args.add(Document[i]['accuracy'].toString());



        j = await db.rawInsert(
            'insert into Outlet_Visit_Time(id  ,outlet_id,mobile_timestamp, file_type,lat,lng,accuracy) values  (?,?,?,?,?,?,?) ',
            args);
      }
    } catch (error) {
      //print("//print ERROR");
      //print(error);
    }

  }

  Future<List<Map<String, dynamic>>> getAllOutletImages(int id) async {
    await this.initdb();
    final Database db = await database;
    final List<Map> maps = await db.rawQuery(
        "select *  from outlet_orders_images where is_uploaded=0 and id=" +
            id.toString());

    return maps;
  }

  Future markPhotoUploaded(int id) async {
    await this.initdb();
    final Database db = await database;
    List args = new List();
    args.add(id);
    try {
      await db.rawUpdate(
          'update outlet_orders_images set is_uploaded=1  where id=?1 ', args);
    } catch (error) {
      print("markMerchandisingPhotoUploaded  ==>> " + error);
    }

    return true;
  }
}
