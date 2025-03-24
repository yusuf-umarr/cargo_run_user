class LocationFromAddressModel {
  final List<Result>? results;
  final String? status;

  LocationFromAddressModel({this.results, this.status});

  factory LocationFromAddressModel.fromJson(Map<String, dynamic> json) {
    return LocationFromAddressModel(
      results: (json['results'] as List?)?.map((e) => Result.fromJson(e)).toList(),
      status: json['status'],
    );
  }
}

class Result {
  final List<AddressComponent>? addressComponents;
  final String? formattedAddress;
  final Geometry? geometry;
  final List<NavigationPoint>? navigationPoints;
  final String? placeId;
  final List<String>? types;

  Result({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.navigationPoints,
    this.placeId,
    this.types,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      addressComponents: (json['address_components'] as List?)?.map((e) => AddressComponent.fromJson(e)).toList(),
      formattedAddress: json['formatted_address'],
      geometry: json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null,
      navigationPoints: (json['navigation_points'] as List?)?.map((e) => NavigationPoint.fromJson(e)).toList(),
      placeId: json['place_id'],
      types: (json['types'] as List?)?.map((e) => e as String).toList(),
    );
  }
}

class AddressComponent {
  final String? longName;
  final String? shortName;
  final List<String>? types;

  AddressComponent({this.longName, this.shortName, this.types});

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(
      longName: json['long_name'],
      shortName: json['short_name'],
      types: (json['types'] as List?)?.map((e) => e as String).toList(),
    );
  }
}

class Geometry {
  final Bounds? bounds;
  final Location? location;
  final String? locationType;
  final Bounds? viewport;

  Geometry({this.bounds, this.location, this.locationType, this.viewport});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      bounds: json['bounds'] != null ? Bounds.fromJson(json['bounds']) : null,
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      locationType: json['location_type'],
      viewport: json['viewport'] != null ? Bounds.fromJson(json['viewport']) : null,
    );
  }
}

class Bounds {
  final Location? northeast;
  final Location? southwest;

  Bounds({this.northeast, this.southwest});

  factory Bounds.fromJson(Map<String, dynamic> json) {
    return Bounds(
      northeast: json['northeast'] != null ? Location.fromJson(json['northeast']) : null,
      southwest: json['southwest'] != null ? Location.fromJson(json['southwest']) : null,
    );
  }
}

class Location {
  final double? lat;
  final double? lng;

  Location({this.lat, this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }
}

class NavigationPoint {
  final NavLocation? location;
  final String? roadName;

  NavigationPoint({this.location, this.roadName});

  factory NavigationPoint.fromJson(Map<String, dynamic> json) {
    return NavigationPoint(
      location: json['location'] != null ? NavLocation.fromJson(json['location']) : null,
      roadName: json['road_name'],
    );
  }
}

class NavLocation {
  final double? latitude;
  final double? longitude;

  NavLocation({this.latitude, this.longitude});

  factory NavLocation.fromJson(Map<String, dynamic> json) {
    return NavLocation(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}
