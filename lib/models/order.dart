class Order {
  Order({
    required this.addressDetails,
    required this.receiverDetails,
    required this.id,
    required this.orderId,
    required this.trackingId,
    required this.userId,
    required this.status,
    required this.paymentStatus,
    required this.deliveryService,
    required this.deliveryOption,
    required this.averageRating,
    required this.deliveryFee,
    required this.isDelete,
    required this.ratings,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.amount,
  });

  final AddressDetails? addressDetails;
  final ReceiverDetails? receiverDetails;
  final String? id;
  final String? orderId;
  final String? trackingId;
  final UserId? userId;
  final String? status;
  final String? paymentStatus;
  final String? deliveryService;
  final String? deliveryOption;
  final num? averageRating;
  final num? deliveryFee;
  final bool? isDelete;
  final List<Rating> ratings;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;
  final num? amount;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      addressDetails: json["addressDetails"] == null
          ? null
          : AddressDetails.fromJson(json["addressDetails"]),
      receiverDetails: json["receiverDetails"] == null
          ? null
          : ReceiverDetails.fromJson(json["receiverDetails"]),
      id: json["_id"],
      orderId: json["orderId"],
      trackingId: json["trackingId"],
      userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
      status: json["status"],
      paymentStatus: json["paymentStatus"],
      deliveryService: json["deliveryService"],
      deliveryOption: json["deliveryOption"],
      averageRating: json["averageRating"],
      deliveryFee: json["deliveryFee"],
      isDelete: json["isDelete"],
      ratings: json["ratings"] == null
          ? []
          : List<Rating>.from(json["ratings"]!.map((x) => Rating.fromJson(x))),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
      amount: json["amount"],
    );
  }

  Map<String, dynamic> toJson() => {
        "addressDetails": addressDetails?.toJson(),
        "receiverDetails": receiverDetails?.toJson(),
        "_id": id,
        "orderId": orderId,
        "trackingId": trackingId,
        "userId": userId?.toJson(),
        "status": status,
        "paymentStatus": paymentStatus,
        "deliveryService": deliveryService,
        "deliveryOption": deliveryOption,
        "averageRating": averageRating,
        "deliveryFee": deliveryFee,
        "isDelete": isDelete,
        "ratings": ratings.map((x) => x.toJson()).toList(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "amount": amount,
      };
}

class AddressDetails {
  AddressDetails({
    required this.houseNumber,
    required this.landMark,
    required this.contactNumber,
    required this.lng,
    required this.lat,
  });

  final num? houseNumber;
  final String? landMark;
  final String? contactNumber;
  final num? lng;
  final num? lat;

  factory AddressDetails.fromJson(Map<String, dynamic> json) {
    return AddressDetails(
      houseNumber: json["houseNumber"],
      landMark: json["landMark"],
      contactNumber: json["contactNumber"],
      lng: json["lng"],
      lat: json["lat"],
    );
  }

  Map<String, dynamic> toJson() => {
        "houseNumber": houseNumber,
        "landMark": landMark,
        "contactNumber": contactNumber,
        "lng": lng,
        "lat": lat,
      };
}

class Rating {
  Rating({
    required this.rate,
    required this.review,
    required this.ratedBy,
    required this.id,
  });

  final num? rate;
  final String? review;
  final RatedBy? ratedBy;
  final String? id;

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: json["rate"],
      review: json["review"],
      ratedBy:
          json["ratedBy"] == null ? null : RatedBy.fromJson(json["ratedBy"]),
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "review": review,
        "ratedBy": ratedBy?.toJson(),
        "_id": id,
      };
}

class RatedBy {
  RatedBy({
    required this.id,
    required this.fullName,
    required this.phone,
  });

  final String? id;
  final String? fullName;
  final String? phone;

  factory RatedBy.fromJson(Map<String, dynamic> json) {
    return RatedBy(
      id: json["_id"],
      fullName: json["fullName"],
      phone: json["phone"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "phone": phone,
      };
}

class ReceiverDetails {
  ReceiverDetails({
    required this.name,
    required this.phone,
    required this.address,
    required this.lng,
    required this.lat,
  });

  final String? name;
  final String? phone;
  final String? address;
  final num? lng;
  final num? lat;

  factory ReceiverDetails.fromJson(Map<String, dynamic> json) {
    return ReceiverDetails(
      name: json["name"],
      phone: json["phone"],
      address: json["address"],
      lng: json["lng"],
      lat: json["lat"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "address": address,
        "lng": lng,
        "lat": lat,
      };
}

class UserId {
  UserId({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.wallet,
    required this.password,
    required this.isDelete,
    required this.isVerified,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.email,
    required this.verificationOtp,
  });

  final String? id;
  final String? fullName;
  final String? phone;
  final num? wallet;
  final String? password;
  final bool? isDelete;
  final bool? isVerified;
  final DateTime? verified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? v;
  final String? email;
  final String? verificationOtp;

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      id: json["_id"],
      fullName: json["fullName"],
      phone: json["phone"],
      wallet: json["wallet"],
      password: json["password"],
      isDelete: json["isDelete"],
      isVerified: json["isVerified"],
      verified: DateTime.tryParse(json["verified"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
      email: json["email"],
      verificationOtp: json["verificationOtp"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "phone": phone,
        "wallet": wallet,
        "password": password,
        "isDelete": isDelete,
        "isVerified": isVerified,
        "verified": verified?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "email": email,
        "verificationOtp": verificationOtp,
      };
}
