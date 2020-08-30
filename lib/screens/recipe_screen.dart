import 'package:finkirecipeapp/new_list.dart';

import '../widgets/recipe_item.dart';
import 'package:flutter/material.dart';
import '../dummy_data.dart';

class RecipeScreen extends StatelessWidget {
  static const String routeName = '/recipe';
  final Function toggleFavorite;
  final Function isRecipeFavorite;

  RecipeScreen(this.toggleFavorite, this.isRecipeFavorite);

  @override
  Widget build(BuildContext context) {
    //important
    final mealId = ModalRoute.of(context).settings.arguments as String;
    final selectedMeal = addedrecipes.firstWhere((meal) => meal.id == mealId);

    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        title: Text('${selectedMeal.title}',
            style: TextStyle(color: Colors.black)),
        actions: [
          //delete
          //favorite
          Tooltip(
            message: 'Favorite this recipe!',
            child: FloatingActionButton(
              onPressed: () => toggleFavorite(mealId),
              child: Icon(
                isRecipeFavorite(mealId)
                    ? Icons.favorite
                    : Icons.favorite_border,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          height: 500,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Ingredients (${selectedMeal.ingredients.length}):',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) => Card(
                      color: Colors.amber[50],
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Text(
                          selectedMeal.ingredients[index],
                        ),
                      ),
                    ),
                    itemCount: selectedMeal.ingredients.length,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Steps (${selectedMeal.steps.length}):',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) => Card(
                      color: Colors.amber[50],
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Text(
                          selectedMeal.steps[index],
                        ),
                      ),
                    ),
                    itemCount: selectedMeal.steps.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
