
// class Order {
//   final String id;
//   final String orderId;
//   final String trackingId;
//   final double amount;
//   final double price;
//   final String status;
//   final String paymentStatus;
//   final String deliveryService;
//   final String deliveryOption;
//   final double averageRating;
//   final double deliveryFee;
//   final bool isDelete;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final AddressDetails addressDetails;
//   final ReceiverDetails receiverDetails;
//   final LocationCoord locationCoord;
//   final RiderLocation riderLocation;
//   final User userId;
//   final Rider riderId;

//   Order({
//     required this.id,
//     required this.orderId,
//     required this.trackingId,
//     required this.amount,
//     required this.price,
//     required this.status,
//     required this.paymentStatus,
//     required this.deliveryService,
//     required this.deliveryOption,
//     required this.averageRating,
//     required this.deliveryFee,
//     required this.isDelete,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.addressDetails,
//     required this.receiverDetails,
//     required this.locationCoord,
//     required this.riderLocation,
//     required this.userId,
//     required this.riderId,
//   });

//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       id: json['_id'],
//       orderId: json['orderId'],
//       trackingId: json['trackingId'],
//       amount: (json['amount'] ?? 0).toDouble(),
//       price: (json['price'] ?? 0).toDouble(),
//       status: json['status'],
//       paymentStatus: json['paymentStatus'],
//       deliveryService: json['deliveryService'],
//       deliveryOption: json['deliveryOption'],
//       averageRating: (json['averageRating'] ?? 0).toDouble(),
//       deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
//       isDelete: json['isDelete'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       addressDetails: AddressDetails.fromJson(json['addressDetails']),
//       receiverDetails: ReceiverDetails.fromJson(json['receiverDetails']),
//       locationCoord: LocationCoord.fromJson(json['locationCoord']),
//       riderLocation: RiderLocation.fromJson(json['riderLocation']),
//       userId: User.fromJson(json['userId']),
//       riderId: Rider.fromJson(json['riderId']),
//     );
//   }
// }

// class AddressDetails {
//   final String? houseNumber;
//   final String landMark;
//   final String contactNumber;
//   final double lat;
//   final double lng;

//   AddressDetails({
//     this.houseNumber,
//     required this.landMark,
//     required this.contactNumber,
//     required this.lat,
//     required this.lng,
//   });

//   factory AddressDetails.fromJson(Map<String, dynamic> json) {
//     return AddressDetails(
//       houseNumber: json['houseNumber'],
//       landMark: json['landMark'],
//       contactNumber: json['contactNumber'],
//       lat: (json['lat'] ?? 0).toDouble(),
//       lng: (json['lng'] ?? 0).toDouble(),
//     );
//   }

    // Map<String, dynamic> toJson() => {
    //     "houseNumber": houseNumber,
    //     "landMark": landMark,
    //     "contactNumber": contactNumber,
    //     "lng": lng,
    //     "lat": lat,
    //   };

// }

// class ReceiverDetails {
//   final String name;
//   final String phone;
//   final String address;
//   final double lat;
//   final double lng;

//   ReceiverDetails({
//     required this.name,
//     required this.phone,
//     required this.address,
//     required this.lat,
//     required this.lng,
//   });

//   factory ReceiverDetails.fromJson(Map<String, dynamic> json) {
//     return ReceiverDetails(
//       name: json['name'],
//       phone: json['phone'],
//       address: json['address'],
//       lat: (json['lat'] ?? 0).toDouble(),
//       lng: (json['lng'] ?? 0).toDouble(),
//     );
//   }

    // Map<String, dynamic> toJson() => {
    //     "name": name,
    //     "phone": phone,
    //     "address": address,
    //     "lng": lng,
    //     "lat": lat,
    //   };
// }

// class LocationCoord {
//   final String type;
//   final List<double> coordinates;

//   LocationCoord({
//     required this.type,
//     required this.coordinates,
//   });

//   factory LocationCoord.fromJson(Map<String, dynamic> json) {
//     return LocationCoord(
//       type: json['type'],
//       coordinates:
//           List<double>.from(json['coordinates'].map((x) => x.toDouble())),
//     );
//   }
// }

// class RiderLocation {
//   final double lat;
//   final double lng;

//   RiderLocation({
//     required this.lat,
//     required this.lng,
//   });

//   factory RiderLocation.fromJson(Map<String, dynamic> json) {
//     return RiderLocation(
//       lat: (json['lat'] ?? 0).toDouble(),
//       lng: (json['lng'] ?? 0).toDouble(),
//     );
//   }
// }

// class User {
//   final String id;
//   final String fullName;
//   final String phone;
//   final String email;
//   final bool isDelete;
//   final bool isVerified;

//   User({
//     required this.id,
//     required this.fullName,
//     required this.phone,
//     required this.email,
//     required this.isDelete,
//     required this.isVerified,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['_id']??0,
//       fullName: json['fullName']??"",
//       phone: json['phone']??0,
//       email: json['email']??"",
//       isDelete: json['isDelete']??false,
//       isVerified: json['isVerified']??false,
//     );
//   }
// }

// class Rider {
//   final String id;
//   final String fullName;
//   final String phone;
//   final String profileImage;
//   final dynamic vehicle;

//   Rider({
//     required this.id,
//     required this.fullName,
//     required this.phone,
//     required this.profileImage,
//     required this.vehicle,
//   });

//   factory Rider.fromJson(Map<String, dynamic> json) {
//     return Rider(
//       id: json['_id']??0,
//       fullName: json['fullName']??"",
//       phone: json['phone']??0,
//       profileImage: json['profileImage']??"",
//       vehicle:json['vehicle']??"", 
//     );
//   }

//   //Vehicle.fromJson(json['vehicle']?? Vehicle(brand: "", plateNumber: "",image: "",vehicleType: "")
// }

// class Vehicle {
//   final String brand;
//   final String image;
//   final String plateNumber;
//   final String vehicleType;

//   Vehicle({
//     required this.brand,
//     required this.image,
//     required this.plateNumber,
//     required this.vehicleType,
//   });

//   factory Vehicle.fromJson(Map<String, dynamic> json) {
//     return Vehicle(
//       brand: json['brand']??"",
//       image: json['image']??"",
//       plateNumber: json['plateNumber']??"",
//       vehicleType: json['vehicleType']??"",
//     );
//   }
// }


// /*

//   factory AddressDetails.fromJson(Map<String, dynamic> json) {
//     return AddressDetails(
//       houseNumber: json["houseNumber"],
//       landMark: json["landMark"],
//       contactNumber: json["contactNumber"],
//       lng: json["lng"],
//       lat: json["lat"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "houseNumber": houseNumber,
//         "landMark": landMark,
//         "contactNumber": contactNumber,
//         "lng": lng,
//         "lat": lat,
//       };
// }


// class ReceiverDetails {
//   ReceiverDetails({
//     required this.name,
//     required this.phone,
//     required this.address,
//     required this.lng,
//     required this.lat,
//   });

//   final String? name;
//   final String? phone;
//   final String? address;
//   final num? lng;
//   final num? lat;

//   factory ReceiverDetails.fromJson(Map<String, dynamic> json) {
//     return ReceiverDetails(
//       name: json["name"],
//       phone: json["phone"],
//       address: json["address"],
//       lng: json["lng"],
//       lat: json["lat"],
//     );
//   }
// */


class Order {
  final AddressDetails? addressDetails;
  final ReceiverDetails? receiverDetails;
  final LocationCoord? locationCoord;
  final RiderLocation? riderLocation;
  final String? id;
  final String? orderId;
  final String? trackingId;
  final num? amount;
  final num? price;
  final UserId? userId;
  final String? status;
  final String? paymentStatus;
  final String? deliveryService;
  final String? deliveryOption;
  final num? averageRating;
  final num? deliveryFee;
  final bool? isDelete;
  final List<dynamic>? ratings;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final RiderId? riderId;

  Order({
    this.addressDetails,
    this.receiverDetails,
    this.locationCoord,
    this.riderLocation,
    this.id,
    this.orderId,
    this.trackingId,
    this.amount,
    this.price,
    this.userId,
    this.status,
    this.paymentStatus,
    this.deliveryService,
    this.deliveryOption,
    this.averageRating,
    this.deliveryFee,
    this.isDelete,
    this.ratings,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.riderId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      addressDetails: json['addressDetails'] != null
          ? AddressDetails.fromJson(json['addressDetails'])
          : null,
      receiverDetails: json['receiverDetails'] != null
          ? ReceiverDetails.fromJson(json['receiverDetails'])
          : null,
      locationCoord: json['locationCoord'] != null
          ? LocationCoord.fromJson(json['locationCoord'])
          : null,
      riderLocation: json['riderLocation'] != null
          ? RiderLocation.fromJson(json['riderLocation'])
          : null,
      id: json['_id'] as String?,
      orderId: json['orderId'] as String?,
      trackingId: json['trackingId'] as String?,
      amount: json['amount'],
      price: json['price'],
      userId: json['userId'] != null ? UserId.fromJson(json['userId']) : null,
      status: json['status'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      deliveryService: json['deliveryService'] as String?,
      deliveryOption: json['deliveryOption'] as String?,
      averageRating: json['averageRating'],
      deliveryFee: json['deliveryFee'],
      isDelete: json['isDelete'] as bool?,
      ratings: json['ratings'] as List<dynamic>?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      riderId:
          json['riderId'] != null ? RiderId.fromJson(json['riderId']) : null,
    );
  }
}

class AddressDetails {
  final String? houseNumber;
  final String? landMark;
  final String? contactNumber;
  final double? lng;
  final double? lat;

  AddressDetails({
    this.houseNumber,
    this.landMark,
    this.contactNumber,
    this.lng,
    this.lat,
  });

  factory AddressDetails.fromJson(Map<String, dynamic> json) {
    return AddressDetails(
      houseNumber: json['houseNumber'] as String?,
      landMark: json['landMark'] as String?,
      contactNumber: json['contactNumber'] as String?,
      lng: (json['lng'] as num?)?.toDouble(),
      lat: (json['lat'] as num?)?.toDouble(),
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

class ReceiverDetails {
  final String? name;
  final String? phone;
  final String? address;
  final double? lng;
  final double? lat;

  ReceiverDetails({
    this.name,
    this.phone,
    this.address,
    this.lng,
    this.lat,
  });

  factory ReceiverDetails.fromJson(Map<String, dynamic> json) {
    return ReceiverDetails(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      lng: (json['lng'] as num?)?.toDouble(),
      lat: (json['lat'] as num?)?.toDouble(),
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

class LocationCoord {
  final String? type;
  final List<dynamic>? coordinates;

  LocationCoord({
    this.type,
    this.coordinates,
  });

  factory LocationCoord.fromJson(Map<String, dynamic> json) {
    return LocationCoord(
      type: json['type'] as String?,
      coordinates: json['coordinates'] as List<dynamic>?,
    );
  }
}

class RiderLocation {
  final double? lat;
  final double? lng;

  RiderLocation({
    this.lat,
    this.lng,
  });

  factory RiderLocation.fromJson(Map<String, dynamic> json) {
    return RiderLocation(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }
}

class UserId {
  final String? id;
  final String? fullName;
  final String? phone;
  final num? wallet;
  final String? email;
  final String? password;
  final bool? isDelete;
  final bool? isVerified;
  final String? verified;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final String? verificationOtp;

  UserId({
    this.id,
    this.fullName,
    this.phone,
    this.wallet,
    this.email,
    this.password,
    this.isDelete,
    this.isVerified,
    this.verified,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.verificationOtp,
  });

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      wallet: json['wallet'],
      email: json['email'] as String?,
      password: json['password'] as String?,
      isDelete: json['isDelete'] as bool?,
      isVerified: json['isVerified'] as bool?,
      verified: json['verified'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      verificationOtp: json['verificationOtp'] as String?,
    );
  }
}

class RiderId {
  final Vehicle? vehicle;
  final String? id;
  final String? fullName;
  final String? phone;
  final String? profileImage;

  RiderId({
    this.vehicle,
    this.id,
    this.fullName,
    this.phone,
    this.profileImage,
  });

  factory RiderId.fromJson(Map<String, dynamic> json) {
    return RiderId(
      vehicle:
          json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      id: json['_id'] as String?,
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      profileImage: json['profileImage'] as String?,
    );
  }
}

class Vehicle {
  final String? brand;
  final String? image;
  final String? plateNumber;
  final String? vehicleType;

  Vehicle({
    this.brand,
    this.image,
    this.plateNumber,
    this.vehicleType,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      brand: json['brand'] as String?,
      image: json['image'] as String?,
      plateNumber: json['plateNumber'] as String?,
      vehicleType: json['vehicleType'] as String?,
    );
  }
}
