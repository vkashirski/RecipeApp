import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './your_recipes.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main_screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              height: 150,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    'Pick an Image',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  FlatButton(
                    textColor: Colors.black,
                    child: Text('Use camera'),
                    onPressed: () {
                      _getImage(context, ImageSource.camera);
                    },
                  ),
                  FlatButton(
                    textColor: Colors.black,
                    child: Text('Open Gallery'),
                    onPressed: () {
                      _getImage(context, ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400).then((File image) {
      Navigator.pop(context);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
      ),
      backgroundColor: Colors.amber[200],
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          height: 490,
          width: 210,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amber[100],
                ),
                width: 190,
                child: InkWell(
                  splashColor: Colors.amber[200],
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {},
                  child: Container(
                    alignment: FractionalOffset.center,
                    padding: EdgeInsets.all(5),
                    child: Text('Recipes online',
                        style: TextStyle(
                          fontFamily: 'BalsamiqSans',
                          fontSize: 25,
                          color: Colors.black12,
                        )),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amber[100],
                ),
                width: 190,
                child: InkWell(
                  splashColor: Colors.amber[200],
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {},
                  child: Container(
                    alignment: FractionalOffset.center,
                    padding: EdgeInsets.all(5),
                    child: Text('Fridge Chef',
                        style: TextStyle(
                          fontFamily: 'BalsamiqSans',
                          fontSize: 25,
                          color: Colors.black12,
                        )),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amber[100],
                ),
                width: 190,
                child: InkWell(
                  splashColor: Colors.amber[200],
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.of(context).pushNamed(RecipesScreen.routeName);
                  },
                  child: Container(
                    alignment: FractionalOffset.center,
                    padding: EdgeInsets.all(5),
                    child: Text('Saved Recipes',
                        style: TextStyle(
                          fontFamily: 'BalsamiqSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        )),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Tooltip(
                message: 'Take a photo of a Recipe and transcribe it later',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber[100],
                  ),
                  width: 60,
                  child: InkWell(
                    splashColor: Colors.amber[200],
                    onTap: () => _openImagePicker(context),
                    child: Icon(Icons.camera_enhance, size: 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
