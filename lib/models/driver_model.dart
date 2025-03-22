class AvailableDriverModel {
  String? id;
  String? fullName;
  String? phone;
  String? email;
  bool? isDelete;
  bool? isVerified;
  String? verifiedCredentials;
  String? verified;
  String? createdAt;
  String? updatedAt;
  int? v;
  Vehicle? vehicle;
  Guarantors? guarantors;
  dynamic locationCoord;
  double? distance;

  AvailableDriverModel({
    this.id,
    this.fullName,
    this.phone,
    this.email,
    this.isDelete,
    this.isVerified,
    this.verifiedCredentials,
    this.verified,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.vehicle,
    this.guarantors,
    this.locationCoord,
    this.distance,
  });

  factory AvailableDriverModel.fromJson(Map<String, dynamic> json) {
    return AvailableDriverModel(
      id: json["_id"] ?? "",
      fullName: json["fullName"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      isDelete: json["isDelete"] ?? false,
      isVerified: json["isVerified"] ?? false,
      verifiedCredentials: json["verifiedCredentials"] ?? "",
      verified: json["verified"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"] ?? 0,
      vehicle: json["vehicle"] != null ? Vehicle.fromJson(json["vehicle"]) : null,
      guarantors: json["guarantors"] != null ? Guarantors.fromJson(json["guarantors"]) : null,
      locationCoord: json["locationCoord"] ??{},
      // locationCoord: json["locationCoord"] != null ? LocationCoord.fromJson(json["locationCoord"]) : null,
      distance: (json["distance"] ?? 0.0).toDouble(),
    );
  }
}

class Vehicle {
  String? brand;
  String? image;
  String? plateNumber;
  String? vehicleType;

  Vehicle({
    this.brand,
    this.image,
    this.plateNumber,
    this.vehicleType,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      brand: json["brand"] ?? "",
      image: json["image"] ?? "",
      plateNumber: json["plateNumber"] ?? "",
      vehicleType: json["vehicleType"] ?? "",
    );
  }
}

class Guarantors {
  String? nameOne;
  String? phoneOne;
  String? nameTwo;
  String? phoneTwo;

  Guarantors({
    this.nameOne,
    this.phoneOne,
    this.nameTwo,
    this.phoneTwo,
  });

  factory Guarantors.fromJson(Map<String, dynamic> json) {
    return Guarantors(
      nameOne: json["nameOne"] ?? "",
      phoneOne: json["phoneOne"] ?? "",
      nameTwo: json["nameTwo"] ?? "",
      phoneTwo: json["phoneTwo"] ?? "",
    );
  }
}

class LocationCoord {
  String? type;
  List<double>? coordinates;

  LocationCoord({
    this.type,
    this.coordinates,
  });

  factory LocationCoord.fromJson(Map<String, dynamic> json) {
    return LocationCoord(
      type: json["type"] ?? "",
      coordinates: (json["coordinates"] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ?? [],
    );
  }
}
