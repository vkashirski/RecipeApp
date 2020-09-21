import 'package:finkirecipeapp/new_list.dart';
import 'package:flutter/material.dart';
import './screens/all_recipes.dart';
import './screens/favorite_recipes.dart';
import './screens/recipe_screen.dart';
import './screens/your_recipes.dart';
import 'screens/main_list.dart';
import './blueprints/recipe.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Recipe> _favoriteRecipes = [];

  void _toggleFavorite(String mealId) {
    final existingIndex =
        _favoriteRecipes.indexWhere((element) => element.id == mealId);
    if (existingIndex >= 0) {
      setState(() {
        _favoriteRecipes.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favoriteRecipes
            .add(addedrecipes.firstWhere((element) => element.id == mealId));
      });
    }
  }

  bool _isRecipeFavorite(String id) {
    return _favoriteRecipes.any((element) => element.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecipeApp',
      theme: ThemeData(
        primarySwatch: Colors.amber[150],
        fontFamily: 'BalsamiqSans',
        textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
              fontSize: 20,
              fontFamily: 'BalsamiqSans',
              fontWeight: FontWeight.bold,
            )),
      ),
      home: MyHomePage(),
      routes: {
        //important, routenames for changing pages
        MainScreen.routeName: (ctx) => MainScreen(),
        AllRecipesScreen.routeName: (ctx) => AllRecipesScreen(addedrecipes),
        RecipeScreen.routeName: (ctx) =>
            RecipeScreen(_toggleFavorite, _isRecipeFavorite),
        FavoriteRecipesScreen.routeName: (ctx) =>
            FavoriteRecipesScreen(_favoriteRecipes),
        RecipesScreen.routeName: (ctx) =>
            RecipesScreen(_favoriteRecipes, addedrecipes),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//main
class _MyHomePageState extends State<MyHomePage> {
  bool _isLoggedIn = false;
  bool _isLoggedInFacebook = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();
  _loginWithFB() async {
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          userProfile = profile;
          _isLoggedInFacebook = true;
          Navigator.of(context).pushNamed(MainScreen.routeName);
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedInFacebook = false);
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedInFacebook = false);
        break;
    }
  }

  _logoutFacebook() {
    facebookLogin.logOut();
    setState(() {
      _isLoggedInFacebook = false;
    });
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _login() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
        Navigator.of(context).pushNamed(MainScreen.routeName);
      });
    } catch (err) {
      print(err);
    }
  }

  _logout() {
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            height: 450,
            width: 210,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    color: Colors.black54,
                    child: Image.asset(
                      // IMAGE HERE
                      'assets/images/recipe.png',
                      fit: BoxFit.cover, //SO IT FITS THE PARENT i think
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white70,
                    ),
                    width: 190,
                    child: InkWell(
                      splashColor: Colors.amber[200],
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {},
                      child: Container(
                        alignment: FractionalOffset.center,
                        padding: EdgeInsets.all(5),
                        child: Text('Login with e-mail',
                            style: TextStyle(
                              fontFamily: 'BalsamiqSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black12,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white70,
                    ),
                    width: 190,
                    child: InkWell(
                      splashColor: Colors.amber[200],
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                          alignment: FractionalOffset.center,
                          padding: EdgeInsets.all(5),
                          child: _isLoggedInFacebook
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.network(
                                      userProfile["picture"]["data"]["url"],
                                      height: 50.0,
                                      width: 50.0,
                                    ),
                                    Text(userProfile["name"]),
                                    OutlineButton(
                                      child: Text("Logout"),
                                      onPressed: () {
                                        _logoutFacebook();
                                      },
                                    )
                                  ],
                                )
                              : Center(
                                  child: Text("Login with Facebook",
                                      style: TextStyle(
                                        fontFamily: 'BalsamiqSans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black,
                                      )),
                                )),
                      onTap: () {
                        _loginWithFB();
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white70,
                    ),
                    width: 190,
                    child: InkWell(
                      splashColor: Colors.amber[200],
                      borderRadius: BorderRadius.circular(15),
                      //onTap: () => _googleSignIn,
                      child: Container(
                          alignment: FractionalOffset.center,
                          padding: EdgeInsets.all(5),
                          child: _isLoggedIn
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.network(
                                      _googleSignIn.currentUser.photoUrl,
                                      height: 50.0,
                                      width: 50.0,
                                    ),
                                    Text(_googleSignIn.currentUser.displayName),
                                    OutlineButton(
                                      child: Text("Logout"),
                                      onPressed: () {
                                        _logout();
                                      },
                                    )
                                  ],
                                )
                              : Center(
                                  child: Text("Login with Google",
                                      style: TextStyle(
                                        fontFamily: 'BalsamiqSans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black,
                                      )),
                                )),
                      onTap: () {
                        _login();
                      },
                    ),
                  ),
                  SizedBox(height: 90),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white70,
                    ),
                    width: 60,
                    child: InkWell(
                      splashColor: Colors.amber[200],
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Navigator.of(context).pushNamed(MainScreen.routeName);
                      },
                      child: Container(
                        alignment: FractionalOffset.center,
                        padding: EdgeInsets.all(5),
                        child: Text('Skip',
                            style: TextStyle(
                              fontFamily: 'BalsamiqSans',
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
