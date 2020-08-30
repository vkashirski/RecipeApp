import '../widgets/recipe_item.dart';
import 'package:flutter/material.dart';
import '../blueprints/recipe.dart';

class FavoriteRecipesScreen extends StatelessWidget {
  static const routeName = '/favorite_recipes_screen';
  final List<Recipe> favoriteRecipes;
  FavoriteRecipesScreen(this.favoriteRecipes);
  @override
  Widget build(BuildContext context) {
    if (favoriteRecipes.isEmpty) {
      return Center(
        child: Text('You have no favorites'),
      );
    } else {
      return ListView.builder(
        itemBuilder: (ctx, index) {
          return RecipeItem(
            id: favoriteRecipes[index].id,
            title: favoriteRecipes[index].title,
            ingredients: favoriteRecipes[index].ingredients,
            steps: favoriteRecipes[index].steps,
            duration: favoriteRecipes[index].duration,
            affordability: favoriteRecipes[index].affordability,
            complexity: favoriteRecipes[index].complexity,
            favorited: favoriteRecipes[index].favorited,
          );
        },
        itemCount: favoriteRecipes.length,
      );
    }
  }
}
