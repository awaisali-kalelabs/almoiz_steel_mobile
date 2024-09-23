import 'package:flutter/material.dart';
class PJP_MarketVisit{

  final String id;
  final String label;



  PJP_MarketVisit({
    this.id,this.label
  });

  Map<String, String> toMap() {
    return {

      'id':id,'label':label
    };
  }


  factory PJP_MarketVisit.fromJson(Map<dynamic, String> json){
    return PJP_MarketVisit(
        id:json['value'],label:json['text']
    );
  }
  @override
  String toString() {
    return 'PJP_MarketVisit{ id: $id, label: $label}';
  }


}