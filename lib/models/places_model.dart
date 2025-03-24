class SearchPlacesModel {
  final List<Suggestion> suggestions;

  SearchPlacesModel({required this.suggestions});

  factory SearchPlacesModel.fromJson(Map<String, dynamic> json) {
    return SearchPlacesModel(
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((x) => Suggestion.fromJson(x))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'suggestions': suggestions.map((x) => x.toJson()).toList(),
    };
  }
}

class Suggestion {
  final PlacePrediction placePrediction;

  Suggestion({required this.placePrediction});

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      placePrediction: PlacePrediction.fromJson(json['placePrediction'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placePrediction': placePrediction.toJson(),
    };
  }
}

class PlacePrediction {
  final String place;
  final String placeId;
  final PredictionText text;
  final StructuredFormat structuredFormat;
  final List<String> types;

  PlacePrediction({
    required this.place,
    required this.placeId,
    required this.text,
    required this.structuredFormat,
    required this.types,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      place: json['place'] ?? '',
      placeId: json['placeId'] ?? '',
      text: PredictionText.fromJson(json['text'] ?? {}),
      structuredFormat: StructuredFormat.fromJson(json['structuredFormat'] ?? {}),
      types: (json['types'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place': place,
      'placeId': placeId,
      'text': text.toJson(),
      'structuredFormat': structuredFormat.toJson(),
      'types': types,
    };
  }
}

class PredictionText {
  final String text;
  final List<TextMatch> matches;

  PredictionText({required this.text, required this.matches});

  factory PredictionText.fromJson(Map<String, dynamic> json) {
    return PredictionText(
      text: json['text'] ?? '',
      matches: (json['matches'] as List<dynamic>?)
              ?.map((x) => TextMatch.fromJson(x))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'matches': matches.map((x) => x.toJson()).toList(),
    };
  }
}

class StructuredFormat {
  final MainText mainText;
  final dynamic secondaryText;

  StructuredFormat({required this.mainText, required this.secondaryText});

  factory StructuredFormat.fromJson(Map<String, dynamic> json) {
    return StructuredFormat(
      mainText: MainText.fromJson(json['mainText'] ?? {}),
      secondaryText: json['secondaryText'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mainText': mainText.toJson(),
      'secondaryText': secondaryText,
    };
  }
}

class MainText {
  final String text;
  final List<TextMatch> matches;

  MainText({required this.text, required this.matches});

  factory MainText.fromJson(Map<String, dynamic> json) {
    return MainText(
      text: json['text'] ?? '',
      matches: (json['matches'] as List<dynamic>?)
              ?.map((x) => TextMatch.fromJson(x))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'matches': matches.map((x) => x.toJson()).toList(),
    };
  }
}

class TextMatch {
  final int? startOffset;
  final int endOffset;

  TextMatch({this.startOffset, required this.endOffset});

  factory TextMatch.fromJson(Map<String, dynamic> json) {
    return TextMatch(
      startOffset: json['startOffset'],
      endOffset: json['endOffset'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (startOffset != null) 'startOffset': startOffset,
      'endOffset': endOffset,
    };
  }
}
