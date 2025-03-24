import 'dart:math';

class DistanceCalculator {
  static const double earthRadiusKm = 6371.0;

  // Helper method to convert degrees to radians
  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  // Method to calculate the distance in meters
  double calculateDistance({
    required double sourceLat,
    required double sourceLng,
    required double destinationLat,
    required double destinationLng,
  }) {
    // Convert latitude and longitude from degrees to radians
    final double sourceLatRad = _toRadians(sourceLat);
    final double sourceLngRad = _toRadians(sourceLng);
    final double destinationLatRad = _toRadians(destinationLat);
    final double destinationLngRad = _toRadians(destinationLng);

    // Haversine formula
    final double dLat = destinationLatRad - sourceLatRad;
    final double dLng = destinationLngRad - sourceLngRad;

    final double a = pow(sin(dLat / 2), 2) +
        cos(sourceLatRad) * cos(destinationLatRad) * pow(sin(dLng / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Distance in meters (km * 1000)
    double totalDistanceMeters = (earthRadiusKm * c) * 1000;

    return totalDistanceMeters;
  }
}
