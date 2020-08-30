import 'package:flutter/material.dart';
import '../blueprints/recipe.dart';
import '../dummy_data.dart';
import '../widgets/recipe_item.dart';
import './your_recipes.dart';

// class AllRecipesScreen extends StatefulWidget {
//   @override
//   _AllRecipesScreenState createState() => _AllRecipesScreenState();
// }

class AllRecipesScreen extends StatelessWidget {
  static const routeName = '/all_recipes_screen';
  final List<Recipe> allRecipes;
  AllRecipesScreen(this.allRecipes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return RecipeItem(
            id: allRecipes[index].id,
            title: allRecipes[index].title,
            ingredients: allRecipes[index].ingredients,
            steps: allRecipes[index].steps,
            duration: allRecipes[index].duration,
            affordability: allRecipes[index].affordability,
            complexity: allRecipes[index].complexity,
            favorited: allRecipes[index].favorited,
          );
        },
        itemCount: allRecipes.length,
      ),
    );
  }
}
