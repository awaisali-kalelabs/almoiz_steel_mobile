// import 'package:flutter/material.dart';
//
// class MVProduct {
//   final String product_id;
//   final String brand_label;
//   final String package_label;
//   final String sort_order;
//   final String unit_per_case;
//   final String package_id;
//   final String brand_id;
//   final String lrb_label;
//   final String lrb_type_id;
//   final String product;
//
//
//   MVProduct(
//       {this.product_id,
//         this.brand_label,
//         this.package_label,
//         this.sort_order,
//         this.unit_per_case,
//         this.package_id,
//         this.brand_id,
//         this.lrb_label,
//         this.lrb_type_id,
//         this.product
//       });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'product_id': product_id,
//       'brand_label': brand_label,
//       'package_label': package_label,
//       'sort_order': sort_order,
//       'unit_per_case': unit_per_case,
//       'package_id': package_id,
//       'brand_id': brand_id,
//       'lrb_label':lrb_label,
//       'lrb_type_id': lrb_type_id,
//       'product':product
//
//     };
//   }
//
//   factory MVProduct.fromJson(Map<String, dynamic> json) {
//     return MVProduct(
//         product_id: json['ProductID'],
//         brand_label: json['Brand'],
//         package_label: json['Package'],
//         sort_order: json['SortOrder'],
//         unit_per_case: json['UnitPerCase'],
//         package_id: json['PackageID'],
//         brand_id: json['BrandID'],
//         lrb_label: json['LRB'],
//         lrb_type_id: json['LRBID'],
//         product: json['Product']
//     );
//   }
//
//   @override
//   String toString() {
//     return 'MV_Outlets{product_id: $product_id, brand_label: $brand_label, package_label: $package_label, sort_order: $sort_order, unit_per_case: $unit_per_case, '
//         'package_id: $package_id, brand_id: $brand_id, lrb_label: $lrb_label,lrb_type_id:$lrb_type_id,product:$product}';
//   }
// }