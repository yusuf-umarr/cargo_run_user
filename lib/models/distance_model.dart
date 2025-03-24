class DistanceModel {
  final List<Route>? routes;

  DistanceModel({this.routes});

  factory DistanceModel.fromJson(Map<String, dynamic> json) => DistanceModel(
        routes: (json['routes'] as List<dynamic>?)
            ?.map((e) => Route.fromJson(e))
            .toList(),
      );
}

class Route {
  final List<Leg>? legs;
  final int? distanceMeters;
  final String? duration;
  final String? staticDuration;
  final Polyline? polyline;
  final String? description;
  final Viewport? viewport;
  final List<String>? routeLabels;

  Route({
    this.legs,
    this.distanceMeters,
    this.duration,
    this.staticDuration,
    this.polyline,
    this.description,
    this.viewport,
    this.routeLabels,
  });

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        legs: (json['legs'] as List<dynamic>?)
            ?.map((e) => Leg.fromJson(e))
            .toList(),
        distanceMeters: json['distanceMeters'],
        duration: json['duration'],
        staticDuration: json['staticDuration'],
        polyline: json['polyline'] != null
            ? Polyline.fromJson(json['polyline'])
            : null,
        description: json['description'],
        viewport: json['viewport'] != null
            ? Viewport.fromJson(json['viewport'])
            : null,
        routeLabels: (json['routeLabels'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
      );
}

class Leg {
  final int? distanceMeters;
  final String? duration;
  final String? staticDuration;
  final Polyline? polyline;
  final Location? startLocation;
  final Location? endLocation;
  final List<Step>? steps;

  Leg({
    this.distanceMeters,
    this.duration,
    this.staticDuration,
    this.polyline,
    this.startLocation,
    this.endLocation,
    this.steps,
  });

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
        distanceMeters: json['distanceMeters'],
        duration: json['duration'],
        staticDuration: json['staticDuration'],
        polyline: json['polyline'] != null
            ? Polyline.fromJson(json['polyline'])
            : null,
        startLocation: json['startLocation']?['latLng'] != null
            ? Location.fromJson(json['startLocation']['latLng'])
            : null,
        endLocation: json['endLocation']?['latLng'] != null
            ? Location.fromJson(json['endLocation']['latLng'])
            : null,
        steps: (json['steps'] as List<dynamic>?)
            ?.map((e) => Step.fromJson(e))
            .toList(),
      );
}

class Step {
  final int? distanceMeters;
  final String? staticDuration;
  final Polyline? polyline;
  final Location? startLocation;
  final Location? endLocation;
  final NavigationInstruction? navigationInstruction;
  final LocalizedValues? localizedValues;
  final String? travelMode;

  Step({
    this.distanceMeters,
    this.staticDuration,
    this.polyline,
    this.startLocation,
    this.endLocation,
    this.navigationInstruction,
    this.localizedValues,
    this.travelMode,
  });

  factory Step.fromJson(Map<String, dynamic> json) => Step(
        distanceMeters: json['distanceMeters'],
        staticDuration: json['staticDuration'],
        polyline: json['polyline'] != null
            ? Polyline.fromJson(json['polyline'])
            : null,
        startLocation: json['startLocation']?['latLng'] != null
            ? Location.fromJson(json['startLocation']['latLng'])
            : null,
        endLocation: json['endLocation']?['latLng'] != null
            ? Location.fromJson(json['endLocation']['latLng'])
            : null,
        navigationInstruction: json['navigationInstruction'] != null
            ? NavigationInstruction.fromJson(json['navigationInstruction'])
            : null,
        localizedValues: json['localizedValues'] != null
            ? LocalizedValues.fromJson(json['localizedValues'])
            : null,
        travelMode: json['travelMode'],
      );
}

class Polyline {
  final String? encodedPolyline;

  Polyline({this.encodedPolyline});

  factory Polyline.fromJson(Map<String, dynamic> json) =>
      Polyline(encodedPolyline: json['encodedPolyline']);
}

class Location {
  final double? latitude;
  final double? longitude;

  Location({this.latitude, this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: json['latitude'],
        longitude: json['longitude'],
      );
}

class NavigationInstruction {
  final String? maneuver;
  final String? instructions;

  NavigationInstruction({this.maneuver, this.instructions});

  factory NavigationInstruction.fromJson(Map<String, dynamic> json) =>
      NavigationInstruction(
        maneuver: json['maneuver'],
        instructions: json['instructions'],
      );
}

class LocalizedValues {
  final LocalizedText? distance;
  final LocalizedText? staticDuration;

  LocalizedValues({this.distance, this.staticDuration});

  factory LocalizedValues.fromJson(Map<String, dynamic> json) =>
      LocalizedValues(
        distance: json['distance'] != null
            ? LocalizedText.fromJson(json['distance'])
            : null,
        staticDuration: json['staticDuration'] != null
            ? LocalizedText.fromJson(json['staticDuration'])
            : null,
      );
}

class LocalizedText {
  final String? text;

  LocalizedText({this.text});

  factory LocalizedText.fromJson(Map<String, dynamic> json) =>
      LocalizedText(text: json['text']);
}

class Viewport {
  final Location? low;
  final Location? high;

  Viewport({this.low, this.high});

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        low: json['low'] != null ? Location.fromJson(json['low']) : null,
        high: json['high'] != null ? Location.fromJson(json['high']) : null,
      );
}
