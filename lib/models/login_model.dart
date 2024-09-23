


class UserModel {
  int isPasswordExpired;
  int isOutletLocationUpdate;
  String designation;
  int beatPlanID;
  List<dynamic> pciSubChannel;
  List<dynamic> outletsAreas;
  List<dynamic> outletsSubAreas;
  List<BeatPlanRow> beatPlanRows;
  String department;
  bool success;
  int userID;
  int distributorID;
  String displayName;
  List<dynamic> userFeatures;
  List<dynamic> noOrderReasonTypes;
  List<OutletChannel> outletChannel;

  UserModel({
    required this.isPasswordExpired,
    required this.isOutletLocationUpdate,
    required this.designation,
    required this.beatPlanID,
    required this.pciSubChannel,
    required this.outletsAreas,
    required this.outletsSubAreas,
    required this.beatPlanRows,
    required this.department,
    required this.success,
    required this.userID,
    required this.distributorID,
    required this.displayName,
    required this.userFeatures,
    required this.noOrderReasonTypes,
    required this.outletChannel,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      isPasswordExpired: json['IsPasswordExpired'],
      isOutletLocationUpdate: json['IsOutletLocationUpdate'],
      designation: json['Designation'],
      beatPlanID: json['BeatPlanID'],
      pciSubChannel: List<dynamic>.from(json['PCISubChannel']),
      outletsAreas: List<dynamic>.from(json['OutletsAreas']),
      outletsSubAreas: List<dynamic>.from(json['OutletsSubAreas']),
      beatPlanRows: List<BeatPlanRow>.from(
          json['BeatPlanRows'].map((x) => BeatPlanRow.fromJson(x))),
      department: json['Department'],
      success: json['success'],
      userID: json['UserID'],
      distributorID: json['distributor_id'],
      displayName: json['DisplayName'],
      userFeatures: List<dynamic>.from(json['UserFeatures']),
      noOrderReasonTypes: List<dynamic>.from(json['NoOrderReasonTypes']),
      outletChannel: List<OutletChannel>.from(
          json['OutletChannel'].map((x) => OutletChannel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IsPasswordExpired': isPasswordExpired,
      'IsOutletLocationUpdate': isOutletLocationUpdate,
      'Designation': designation,
      'BeatPlanID': beatPlanID,
      'PCISubChannel': pciSubChannel,
      'OutletsAreas': outletsAreas,
      'OutletsSubAreas': outletsSubAreas,
      'BeatPlanRows': List<dynamic>.from(beatPlanRows.map((x) => x.toJson())),
      'Department': department,
      'success': success,
      'UserID': userID,
      'distributor_id': distributorID,
      'DisplayName': displayName,
      'UserFeatures': userFeatures,
      'NoOrderReasonTypes': noOrderReasonTypes,
      'OutletChannel':
      List<dynamic>.from(outletChannel.map((x) => x.toJson())),
    };
  }
}

class BeatPlanRow {
  int outletID;
  String outletName;
  int dayNumber;
  String owner;
  String address;
  String telephone;
  String? nfcTagID;
  String? accuracy;
  int isGeoFence;
  int radius;
  String? subChannelID;
  String? subChannelLabel;
  String? orderCreatedOnDate;
  String commonOutletsVpoClassifications;
  int visit;
  double lat;
  double lng;
  String? areaLabel;
  String? subAreaLabel;
  int isAlternative;
  String? purchaserName;
  String? purchaserMobileNo;
  String? cacheContactNic;
  int channelID;
  String? channelName;

  BeatPlanRow({
    required this.outletID,
    required this.outletName,
    required this.dayNumber,
    required this.owner,
    required this.address,
    required this.telephone,
    this.nfcTagID,
    this.accuracy,
    required this.isGeoFence,
    required this.radius,
    this.subChannelID,
    this.subChannelLabel,
    this.orderCreatedOnDate,
    required this.commonOutletsVpoClassifications,
    required this.visit,
    required this.lat,
    required this.lng,
    this.areaLabel,
    this.subAreaLabel,
    required this.isAlternative,
    this.purchaserName,
    this.purchaserMobileNo,
    this.cacheContactNic,
    required this.channelID,
    this.channelName,
  });

  factory BeatPlanRow.fromJson(Map<String, dynamic> json) {
    return BeatPlanRow(
      outletID: json['OutletID'],
      outletName: json['OutletName'],
      dayNumber: json['DayNumber'],
      owner: json['Owner'],
      address: json['Address'],
      telephone: json['Telepohone'],
      nfcTagID: json['NFCTagID'],
      accuracy: json['accuracy'],
      isGeoFence: json['IsGeoFence'],
      radius: json['Radius'],
      subChannelID: json['SUBChannelID'],
      subChannelLabel: json['SUBChannelLabel'],
      orderCreatedOnDate: json['order_created_on_date'],
      commonOutletsVpoClassifications: json['common_outlets_vpo_classifications'],
      visit: json['Visit'],
      lat: json['lat'],
      lng: json['lng'],
      areaLabel: json['AreaLabel'],
      subAreaLabel: json['SubAreaLabel'],
      isAlternative: json['IsAlternative'],
      purchaserName: json['purchaser_name'],
      purchaserMobileNo: json['purchaser_mobile_no'],
      cacheContactNic: json['cache_contact_nic'],
      channelID: json['channel_id'],
      channelName: json['channel_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OutletID': outletID,
      'OutletName': outletName,
      'DayNumber': dayNumber,
      'Owner': owner,
      'Address': address,
      'Telepohone': telephone,
      'NFCTagID': nfcTagID,
      'accuracy': accuracy,
      'IsGeoFence': isGeoFence,
      'Radius': radius,
      'SUBChannelID': subChannelID,
      'SUBChannelLabel': subChannelLabel,
      'order_created_on_date': orderCreatedOnDate,
      'common_outlets_vpo_classifications': commonOutletsVpoClassifications,
      'Visit': visit,
      'lat': lat,
      'lng': lng,
      'AreaLabel': areaLabel,
      'SubAreaLabel': subAreaLabel,
      'IsAlternative': isAlternative,
      'purchaser_name': purchaserName,
      'purchaser_mobile_no': purchaserMobileNo,
      'cache_contact_nic': cacheContactNic,
      'channel_id': channelID,
      'channel_name': channelName,
    };
  }
}

class OutletChannel {
  int id;
  String channelLabel;

  OutletChannel({
    required this.id,
    required this.channelLabel,
  });

  factory OutletChannel.fromJson(Map<String, dynamic> json) {
    return OutletChannel(
      id: json['ID'],
      channelLabel: json['ChannelLabel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'ChannelLabel': channelLabel,
    };
  }
}
