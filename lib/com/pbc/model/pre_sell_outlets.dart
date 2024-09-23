import 'package:flutter/material.dart';

class PreSellOutlets {
  final int outlet_id;
  final String outlet_name;
  final int day_number;
  final String owner;
  final String address;
  final String telephone;
  final String nfc_tag_id;
  final int visit_type;
  final String lat;
  final String lng;
  final String channel_label;
  final String area_label;
  final String order_created_on_date;
  final String sub_area_label;
  final int is_alternate_visible;
  final int pci_channel_id;
  final int IsGeoFence;
  final int Radius;

  PreSellOutlets(
      {this.outlet_id,
      this.outlet_name,
      this.day_number,
      this.owner,
      this.address,
      this.telephone,
      this.nfc_tag_id,
       this.order_created_on_date,
        this.channel_label,
      this.visit_type,
      this.lat,
      this.lng,
      this.area_label,
      this.sub_area_label,
      this.is_alternate_visible,
      this.pci_channel_id,
        this.IsGeoFence,
      this.Radius,});

  Map<String, dynamic> toMap() {
    return {
      'outlet_id': outlet_id,
      'outlet_name': outlet_name,
      'day_number': day_number,
      'owner': owner,
      'address': address,
      'telephone': telephone,
      'nfc_tag_id': nfc_tag_id,
      'order_created_on_date':order_created_on_date,
      'visit_type': visit_type,
      'channel_label':channel_label,
      'lat': lat,
      'lng': lng,
      'area_label': area_label,
      'sub_area_label': sub_area_label,
      'is_alternate_visible': is_alternate_visible,
      'pci_channel_id': pci_channel_id,
      'IsGeoFence': IsGeoFence,
      'Radius' : Radius,

    };
  }

  factory PreSellOutlets.fromJson(Map<String, dynamic> json) {
    return PreSellOutlets(
        outlet_id: int.parse(json['OutletID']),
        outlet_name: json['OutletName'],
        address: json['Address'],
        day_number: int.parse(json['DayNumber']),
        owner: json['Owner'],
        telephone: json['Telepohone'],
        nfc_tag_id: json['NFCTagID'],
        order_created_on_date: json['order_created_on_date'],
        visit_type: json['visit_type'],
        lat: json['lat'],
        lng: json['lng'],
        area_label: json['AreaLabel'],
        sub_area_label: json['SubAreaLabel'],
        is_alternate_visible: json['is_alternate_visible'],
        channel_label: json['SUBChannelLabel'],
        pci_channel_id: json['OutletPciSubChannelID'],
      IsGeoFence: json['IsGeoFence'],
        Radius : json['Radius']);
  }

  @override
  String toString() {
    // return 'PreSellOutlets{outlet_id: $outlet_id, name: $name, address: $address, lat: $lat, lng: $lng, cache_contact_number: $cache_contact_number, net_amount: $net_amount, sale_invoice_id: $sale_invoice_id,dispatch_id:$dispatch_id,is_delivered:$is_delivered}';
  }
}