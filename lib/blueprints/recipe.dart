import 'package:flutter/foundation.dart';

enum Complexity {
  Simple,
  Challenging,
  Hard,
}

enum Affordability {
  Affordable,
  Pricey,
  Luxurious,
}

class Recipe {
  final String id;
  final String title;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;
  final bool favorited;

  final Complexity complexity;
  final Affordability affordability;

  const Recipe(
      {@required this.id,
      @required this.title,
      @required this.ingredients,
      @required this.steps,
      @required this.duration,
      @required this.complexity,
      @required this.affordability,
      this.favorited});
}
