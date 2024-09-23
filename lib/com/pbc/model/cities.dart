import 'package:flutter/material.dart';
class Cities_MarketVisit{

  final String city;
  final int id;





  Cities_MarketVisit({
    this.city,
    this.id
  });

  Map<String, dynamic> toMap() {
    return {

      'city':city,
      'city_Id':id
    };
  }


  factory Cities_MarketVisit.fromJson(Map<String, dynamic> json){
    return Cities_MarketVisit(
        city:json['city'],
        id:json['city_Id']
    );
  }
  @override
  String toString() {
    return 'Cities_MarketVisit{ city: $city},Cities_MarketVisit{ id: $id}';
  }


}