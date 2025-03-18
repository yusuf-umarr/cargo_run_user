import 'dart:convert';

class AvailableDriverModel {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final bool isDelete;
  final bool isVerified;
  final String verifiedCredentials;
  final DateTime verified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final Vehicle vehicle;
  final Guarantors guarantors;
  final LocationCoord locationCoord;
  final double distance;

  AvailableDriverModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.isDelete,
    required this.isVerified,
    required this.verifiedCredentials,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.vehicle,
    required this.guarantors,
    required this.locationCoord,
    required this.distance,
  });

  factory AvailableDriverModel.fromJson(Map<String, dynamic> json) {
    return AvailableDriverModel(
      id: json['_id'],
      fullName: json['fullName'],
      phone: json['phone'],
      email: json['email'],
      isDelete: json['isDelete'],
      isVerified: json['isVerified'],
      verifiedCredentials: json['verifiedCredentials'],
      verified: DateTime.parse(json['verified']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
      vehicle: Vehicle.fromJson(json['vehicle']),
      guarantors: Guarantors.fromJson(json['guarantors']),
      locationCoord: LocationCoord.fromJson(json['locationCoord']),
      distance: (json['distance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'isDelete': isDelete,
      'isVerified': isVerified,
      'verifiedCredentials': verifiedCredentials,
      'verified': verified.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'vehicle': vehicle.toJson(),
      'guarantors': guarantors.toJson(),
      'locationCoord': locationCoord.toJson(),
      'distance': distance,
    };
  }
}

class Vehicle {
  final String brand;
  final String image;
  final String plateNumber;
  final String vehicleType;

  Vehicle({
    required this.brand,
    required this.image,
    required this.plateNumber,
    required this.vehicleType,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      brand: json['brand'],
      image: json['image'],
      plateNumber: json['plateNumber'],
      vehicleType: json['vehicleType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'image': image,
      'plateNumber': plateNumber,
      'vehicleType': vehicleType,
    };
  }
}

class Guarantors {
  final String nameOne;
  final String phoneOne;
  final String nameTwo;
  final String phoneTwo;

  Guarantors({
    required this.nameOne,
    required this.phoneOne,
    required this.nameTwo,
    required this.phoneTwo,
  });

  factory Guarantors.fromJson(Map<String, dynamic> json) {
    return Guarantors(
      nameOne: json['nameOne'],
      phoneOne: json['phoneOne'],
      nameTwo: json['nameTwo'],
      phoneTwo: json['phoneTwo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nameOne': nameOne,
      'phoneOne': phoneOne,
      'nameTwo': nameTwo,
      'phoneTwo': phoneTwo,
    };
  }
}

class LocationCoord {
  final String type;
  final List<double> coordinates;

  LocationCoord({
    required this.type,
    required this.coordinates,
  });

  factory LocationCoord.fromJson(Map<String, dynamic> json) {
    return LocationCoord(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
