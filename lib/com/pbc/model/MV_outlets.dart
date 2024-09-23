import 'package:flutter/material.dart';

class MV_Outlets {
  final int outlet_id;
  final String outlet_name;
  final String outlet_address;
  final String id;
  final String pjp_label;
  final String distributor_idd;
  final String distributor_name;
  final String owner_name;
  final String owner_contact;
  final String region_idd;
  final String region_name;
  final String region_short;
  final String channel_idd;
  final String channel_name;
  final int day_number;
  final String lat;
  final String lng;
  final String IsGeoFence;
  final int Radius;






  MV_Outlets(
      {  this.outlet_id,
        this.outlet_name,
        this.outlet_address,
        this.id,
        this.pjp_label,
        this.distributor_idd,
        this.distributor_name,
        this.owner_name,
        this.owner_contact,
        this.region_idd,
        this.region_name,
        this.region_short,
        this.channel_idd,
        this.channel_name,
        this.day_number,
        this.lat,
        this.lng,
        this.IsGeoFence,
        this.Radius,

       });

  Map<String, dynamic> toMap() {
    return {
      'outlet_id' : outlet_id,
      'outlet_name': outlet_name,
      'outlet_address': outlet_address,
      'id': id,
      'pjp_label': pjp_label,
      'distributor_idd': distributor_idd,
      'distributor_name': distributor_name,
      'owner_name': owner_name,
      'owner_contact':owner_contact,
      'region_idd': region_idd,
      'region_name':region_name,
      'region_short': region_short,
      'channel_idd': channel_idd,
      'channel_name': channel_name,
      'day_number' : day_number,
      'lat': lat,
      'lng' : lng,
      'IsGeoFence': IsGeoFence,
      'Radius' : Radius,



    };
  }

  factory MV_Outlets.fromJson(Map<String, dynamic> json) {
    return MV_Outlets(
      outlet_id : json['OutletID'],
    outlet_name: json['OutletName'],
      outlet_address: json['OutletAddress'],
      id: json['OutletPJPID'],
      pjp_label: json['OutletPJPLabel'],
      distributor_idd: json['DistributorID'],
      distributor_name: json['DistributorName'],
      owner_name: json['OwnerName'],
      owner_contact: json['OwnerContact'],
      region_idd: json['Region'],
      region_name: json['RegionName'],
      region_short: json['RegionShortName'],
      channel_idd: json['ChannelID'],
      channel_name: json['ChannelLabel'],
        day_number :  json['DayNumber'],
      lat: json['lat'],
      lng :  json['lng'],
        IsGeoFence: json['IsGeoFence'],
        Radius : json['Radius']

    );
  }

  @override
  String toString() {
     return 'MV_Outlets{outlet_id:$outlet_id ,outlet_name: $outlet_name, outlet_address: $outlet_address, id: $id, pjp_label: $pjp_label, distributor_idd: $distributor_idd, '
         'distributor_name: $distributor_name, owner_name: $owner_name, owner_contact: $owner_contact,region_idd:$region_idd,region_name:$region_name'
         ',region_short:$region_short,channel_idd:$channel_idd,channel_name:$channel_name ,day_number:$day_number,lat:$lat ,lng:$lng}';
  }
}