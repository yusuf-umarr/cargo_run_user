class DistanceModel {
  final List<Route> routes;

  DistanceModel({required this.routes});

  factory DistanceModel.fromJson(Map<String, dynamic> json) => DistanceModel(
        routes: (json['routes'] as List<dynamic>)
            .map((e) => Route.fromJson(e))
            .toList(),
      );
}

class Route {
  final List<Leg> legs;
  final int distanceMeters;
  final String duration;
  final String staticDuration;
  final Polyline polyline;
  final String description;
  final Viewport viewport;
  final List<String> routeLabels;

  Route({
    required this.legs,
    required this.distanceMeters,
    required this.duration,
    required this.staticDuration,
    required this.polyline,
    required this.description,
    required this.viewport,
    required this.routeLabels,
  });

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        legs: (json['legs'] as List<dynamic>)
            .map((e) => Leg.fromJson(e))
            .toList(),
        distanceMeters: json['distanceMeters'],
        duration: json['duration'],
        staticDuration: json['staticDuration'],
        polyline: Polyline.fromJson(json['polyline']),
        description: json['description'],
        viewport: Viewport.fromJson(json['viewport']),
        routeLabels: List<String>.from(json['routeLabels']),
      );
}

class Leg {
  final int distanceMeters;
  final String duration;
  final String staticDuration;
  final Polyline polyline;
  final Location startLocation;
  final Location endLocation;
  final List<Step> steps;

  Leg({
    required this.distanceMeters,
    required this.duration,
    required this.staticDuration,
    required this.polyline,
    required this.startLocation,
    required this.endLocation,
    required this.steps,
  });

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
        distanceMeters: json['distanceMeters'],
        duration: json['duration'],
        staticDuration: json['staticDuration'],
        polyline: Polyline.fromJson(json['polyline']),
        startLocation: Location.fromJson(json['startLocation']['latLng']),
        endLocation: Location.fromJson(json['endLocation']['latLng']),
        steps: (json['steps'] as List<dynamic>)
            .map((e) => Step.fromJson(e))
            .toList(),
      );
}

class Step {
  final int distanceMeters;
  final String staticDuration;
  final Polyline polyline;
  final Location startLocation;
  final Location endLocation;
  final NavigationInstruction navigationInstruction;
  final LocalizedValues localizedValues;
  final String travelMode;

  Step({
    required this.distanceMeters,
    required this.staticDuration,
    required this.polyline,
    required this.startLocation,
    required this.endLocation,
    required this.navigationInstruction,
    required this.localizedValues,
    required this.travelMode,
  });

  factory Step.fromJson(Map<String, dynamic> json) => Step(
        distanceMeters: json['distanceMeters'],
        staticDuration: json['staticDuration'],
        polyline: Polyline.fromJson(json['polyline']),
        startLocation: Location.fromJson(json['startLocation']['latLng']),
        endLocation: Location.fromJson(json['endLocation']['latLng']),
        navigationInstruction:
            NavigationInstruction.fromJson(json['navigationInstruction']),
        localizedValues: LocalizedValues.fromJson(json['localizedValues']),
        travelMode: json['travelMode'],
      );
}

class Polyline {
  final String encodedPolyline;

  Polyline({required this.encodedPolyline});

  factory Polyline.fromJson(Map<String, dynamic> json) =>
      Polyline(encodedPolyline: json['encodedPolyline']);
}

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json['latitude'],
        longitude: json['longitude'],
      );
}

class NavigationInstruction {
  final String maneuver;
  final String instructions;

  NavigationInstruction({required this.maneuver, required this.instructions});

  factory NavigationInstruction.fromJson(Map<String, dynamic> json) =>
      NavigationInstruction(
        maneuver: json['maneuver'],
        instructions: json['instructions'],
      );
}

class LocalizedValues {
  final LocalizedText distance;
  final LocalizedText staticDuration;

  LocalizedValues({required this.distance, required this.staticDuration});

  factory LocalizedValues.fromJson(Map<String, dynamic> json) => LocalizedValues(
        distance: LocalizedText.fromJson(json['distance']),
        staticDuration: LocalizedText.fromJson(json['staticDuration']),
      );
}

class LocalizedText {
  final String text;

  LocalizedText({required this.text});

  factory LocalizedText.fromJson(Map<String, dynamic> json) =>
      LocalizedText(text: json['text']);
}

class Viewport {
  final Location low;
  final Location high;

  Viewport({required this.low, required this.high});

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        low: Location.fromJson(json['low']),
        high: Location.fromJson(json['high']),
      );
}
