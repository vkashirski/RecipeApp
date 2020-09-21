
import 'package:flutter/material.dart';
import '../new_list.dart';
import '../screens/recipe_screen.dart';
import '../blueprints/recipe.dart';

class RecipeItem extends StatefulWidget {
  final String id;
  final String title;
  final int duration;
  List<String> ingredients;
  List<String> steps;
  final Complexity complexity;
  final Affordability affordability;
  bool favorited;

  RecipeItem({
    @required this.id,
    @required this.title,
    @required this.ingredients,
    @required this.steps,
    @required this.duration,
    @required this.complexity,
    @required this.affordability,
    @required this.favorited,
  });

  @override
  _RecipeItemState createState() => _RecipeItemState();
}

class _RecipeItemState extends State<RecipeItem> {
  String get complexityText {
    // if (complexity == Complexity.Simple) return 'Simple';
    // if (complexity == Complexity.Challenging) return 'Challenging';
    // if (complexity == Complexity.Hard) return 'Hard';

    switch (widget.complexity) {
      case Complexity.Simple:
        return 'Simple';
        break;
      case Complexity.Challenging:
        return 'Challenging';
        break;
      case Complexity.Hard:
        return 'Hard';
        break;
      default:
        return 'Unknown';
    }
  }

  String get affordabilityText {
    switch (widget.affordability) {
      case Affordability.Affordable:
        return 'Affordable';
        break;
      case Affordability.Pricey:
        return 'Pricey';
        break;
      case Affordability.Luxurious:
        return 'Expensive';
        break;
      default:
        return 'Unknown';
    }
  }

  void selectMeal(BuildContext context) {
    Navigator.of(context)
        .pushNamed(
      RecipeScreen.routeName,
      arguments: widget.id,
    )
        .then((result) {
      if (result != null) {
        //removeItem(result);
      }
    });
  }

  void _deleteRecipe(String id) {
    setState(() {
      addedrecipes.removeWhere((element) => element.id == id);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => selectMeal(context),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.amber[50],
              ),
              child: Container(
                width: 300,
                height: 33,
                padding: EdgeInsets.all(6),
                child: Text('${widget.title}, $complexityText',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            return showDialog(
              context: context,
              child: AlertDialog(
                title: Text('Delete Recipe'),
                content: Text('Are you sure you want to delete this Recipe?'),
                actions: [
                  FlatButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: Text('No.',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                  FlatButton(
                    onPressed: () => _deleteRecipe(widget.id),
                    child: Text('Yes.',
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                ],
                elevation: 5,
                backgroundColor: Colors.white,
              ),
            );
          },
          child: Icon(Icons.delete, color: Colors.red,),
        ),
      ],
    );
  }
}
