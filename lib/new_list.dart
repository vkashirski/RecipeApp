import 'package:finkirecipeapp/dummy_data.dart';

import './blueprints/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Recipe> addedrecipes = DUMMY_Recipes + [];

_readData() async {
  final prefs = await SharedPreferences.getInstance();

  final recipes = prefs.getStringList('recipes');

  if (recipes.isEmpty)
    return null;
  else
    return recipes;
}

List<Recipe> _readDataFinal() {
  if (_readData() == null)
    return null;
  else {
    List<String> strings = _readData();
    List<Recipe> recipes = [];

    for (int i = 0; i < strings.length; i++) {
      var parts = strings[i].split('@');
      Recipe r = new Recipe(
        id: parts[0],
        title: parts[1],
        ingredients: parts[2].split(','),
        steps: parts[3].split(','),
        affordability: Affordability.Affordable,
        complexity: Complexity.Simple,
        duration: int.parse(parts[6]),
      );
      recipes.add(r);
    }
    return recipes;
  }
}

List<Recipe> newRecipes = _readDataFinal();

void addToAdded() {
  for (int i = addedrecipes.length; i < newRecipes.length; i++) {
    addedrecipes.add(newRecipes[i]);
  }
}
