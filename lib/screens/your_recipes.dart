import 'dart:math';

import 'package:finkirecipeapp/new_list.dart';
import 'package:flutter/material.dart';
import './all_recipes.dart';
import './favorite_recipes.dart';
import '../blueprints/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipesScreen extends StatefulWidget {
  static const routeName = '/recipes_screen';
  final List<Recipe> favoriteRecipes;
  final List<Recipe> allRecipes;
  RecipesScreen(this.favoriteRecipes, this.allRecipes);

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  TextEditingController titleInputController = TextEditingController();
  TextEditingController ingredientsInputController = TextEditingController();
  TextEditingController stepsInputController = TextEditingController();
  int _selectedPageIndex = 0;
  List<Widget> _pages;

  void _saveData(Recipe r) async {
    final prefs = await SharedPreferences.getInstance();
    addedrecipes.add(r);
    List<String> finaleList = [];
    String s = '';
    for (int i = 0; i < addedrecipes.length; i++) {
      s = addedrecipes[i].id +
          '@' +
          addedrecipes[i].title +
          '@' +
          addedrecipes[i].ingredients.toString() +
          '@' +
          addedrecipes[i].steps.toString() +
          '@' +
          addedrecipes[i].affordability.toString() +
          '@' +
          addedrecipes[i].complexity.toString() +
          '@' +
          addedrecipes[i].duration.toString();
      finaleList[i] = s;
    }

    prefs.setStringList('recipes', finaleList);
  }

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

  void _startAddNewRecipe(BuildContext ctx) {
    String titleInput;
    List<String> ingredientsInput;
    List<String> stepsInput;

    int checkId(String id) {
      var rng = new Random();
      var rnm = rng.nextInt(100);
      for (int i = 0; i < addedrecipes.length; i++) {
        if (addedrecipes[i].id == id) rnm = rng.nextInt(1000);
      }
      return rnm;
    }

    void addItemToList(
        String title, List<String> ingredients, List<String> steps) {
      var rng = new Random();
      var rnm = rng.nextInt(100);
      if (title.isEmpty || ingredients.isEmpty || steps.isEmpty) {
        return;
      } else {
        setState(() {
          Recipe r1 = new Recipe(
            id: checkId(rnm.toString()).toString(),
            title: title,
            ingredients: ingredients,
            steps: steps,
            affordability: Affordability.Affordable,
            complexity: Complexity.Simple,
            duration: 10,
            favorited: false,
          );
          addedrecipes.add(r1);
          _saveData(r1);
          addToAdded();
          print(r1);
        });
        Navigator.pop(context);
      }
    }

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: Card(
            elevation: 5,
            child: Container(
              height: 550,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: titleInputController,
                    onChanged: (val) {
                      titleInput = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Ingredients, seperate with comma(,)'),
                    controller: ingredientsInputController,
                    onChanged: (val) {
                      ingredientsInput = val.split(',');
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Steps, seperate with comma(,)'),
                    controller: stepsInputController,
                    onChanged: (val) {
                      stepsInput = val.split(',');
                    },
                  ),
                  RaisedButton(
                    child: Text('Add Recipe'),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).textTheme.button.color,
                    onPressed: () =>
                        addItemToList(titleInput, ingredientsInput, stepsInput),
                  ),
                ],
              ),
            ),
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  void initState() {
    _pages = [
      AllRecipesScreen(widget.allRecipes),
      FavoriteRecipesScreen(widget.favoriteRecipes),
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: 15,
              bottom: 5,
              top: 5,
            ),
            child: InkWell(
              onTap: () => _startAddNewRecipe(context),
              child: Row(
                children: [
                  Text(
                    'Add a new Recipe',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  Icon(
                    Icons.add,
                    size: 28.0,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ],
        backgroundColor: Colors.amber[300],
      ),
      backgroundColor: Colors.amber[200],
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        unselectedItemColor: Colors.blue,
        selectedItemColor: Colors.black,
        selectedFontSize: 20,
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.amber[300],
            icon: Icon(Icons.list),
            title: Text(
              'All Recipes',
              style: TextStyle(fontSize: 16),
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.amber[300],
            icon: Icon(Icons.favorite),
            title: Text(
              'Favorite Recipes',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
