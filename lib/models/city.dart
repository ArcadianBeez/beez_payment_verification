class City {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? latitude;
  String? longitude;
  int? status;
  String? supportNumber;
  double? deliveryBase;
  double? kmBase;
  double? deliveryFactor;
  int? ordersFlow;
  String? messageClose;
  String? messageWarning;
  int? enableManualOrders;
  int? minCashback;
  Null? deliveryBaseManual;
  Null? comisionManual;
  int? userAdminId;
  bool? hasMedia;
  //List<Media>? media;

  City(
      {this.id,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.latitude,
        this.longitude,
        this.status,
        this.supportNumber,
        this.deliveryBase,
        this.kmBase,
        this.deliveryFactor,
        this.ordersFlow,
        this.messageClose,
        this.messageWarning,
        this.enableManualOrders,
        this.minCashback,
        this.deliveryBaseManual,
        this.comisionManual,
        this.userAdminId,
        this.hasMedia,
      //  this.media
      });

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    supportNumber = json['support_number'];
    deliveryBase = json['delivery_base'];
    kmBase = json['km_base'];
    deliveryFactor = json['delivery_factor'];
    ordersFlow = json['orders_flow'];
    messageClose = json['message_close'];
    messageWarning = json['message_warning'];
    enableManualOrders = json['enable_manual_orders'];
    minCashback = json['min_cashback'];
    deliveryBaseManual = json['delivery_base_manual'];
    comisionManual = json['comision_manual'];
    userAdminId = json['user_admin_id'];
    hasMedia = json['has_media'];
    // if (json['media'] != null) {
    //   media = <Media>[];
    //   json['media'].forEach((v) {
    //     media!.add(new Media.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['support_number'] = this.supportNumber;
    data['delivery_base'] = this.deliveryBase;
    data['km_base'] = this.kmBase;
    data['delivery_factor'] = this.deliveryFactor;
    data['orders_flow'] = this.ordersFlow;
    data['message_close'] = this.messageClose;
    data['message_warning'] = this.messageWarning;
    data['enable_manual_orders'] = this.enableManualOrders;
    data['min_cashback'] = this.minCashback;
    data['delivery_base_manual'] = this.deliveryBaseManual;
    data['comision_manual'] = this.comisionManual;
    data['user_admin_id'] = this.userAdminId;
    data['has_media'] = this.hasMedia;
    // if (this.media != null) {
    //   data['media'] = this.media!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
