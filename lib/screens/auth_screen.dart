// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use, library_private_types_in_public_api, prefer_final_fields, prefer_const_constructors, unused_local_variable, unused_field, unused_field, duplicate_ignore

import 'dart:math';
import 'package:book_shop/models/http_exceptions.dart';
import 'package:book_shop/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode {
  signUp,
  login,
}

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/board2.png'),
              fit: BoxFit.cover,
            )
                // gradient: LinearGradient(
                //   colors: [
                //     const Color.fromARGB(255, 34, 13, 6),
                //     Colors.brown,
                //     const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                //   ],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
                ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 35.0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 30.0,
                      ),
                      //matrix 4 allows you to describe the rotation,scalling and offset of a container
                      transform: Matrix4.rotationZ(-15 * pi / 30)
                        //this translate call to offset the object
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(57, 5, 18, 20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'Bookish Store',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 220, 184)
                              .withOpacity(0.3),
                          fontSize: 35,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: AuthCard(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode myFocusNode = FocusNode();

  AnimationController? _controller;
  Animation<Size>? _heightAnimation;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    //we give the animation controller a pointer at the object
    //so only when thw widget is visible in the screen, the animation should work
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    //the tween class gives you an object which in the end knows how to animate
    //between two values
    _heightAnimation = Tween<Size>(
      begin: Size(double.infinity, 250),
      end: Size(double.infinity, 320),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeIn,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeIn,
      ),
    );
    // _heightAnimation!.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  AuthMode _authMode = AuthMode.login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("An Error Occurred!"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Okay!"),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } // we filter the errors that we wanna catch
    on HttpException catch (error) {
      var errorMessage = "Authentication failed";
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = "This email address is already in use";
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = "This is not a valid email address";
      } else if (errorMessage.toString().contains('WEAK_PASSWORD')) {
        errorMessage = "this password is too week";
      } else if (errorMessage.toString().contains("Email_NOT_Found")) {
        errorMessage = "could not find a user with that email";
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = "could not authenticate you, please try again later";
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
      //the forward starts the animation
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      //the reverse ends the animation
      _controller!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child:
          //  AnimatedBuilder(
          //   animation: _heightAnimation as Animation<Size>,
          //   builder: (context, ch) =>
          AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        color: Color.fromRGBO(255, 188, 117, 1).withOpacity(0.3),
        height: _heightAnimation!.value.height,

        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        //  _authMode == AuthMode.signUp ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _heightAnimation!.value.height,
          //  _authMode == AuthMode.signUp ? 320 : 260
        ),
        // child : ch

        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid   email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.signUp)
                  // AnimatedContainer(
                  //   duration: Duration(milliseconds: 300),
                  //   constraints: BoxConstraints(
                  //     minHeight: _authMode == AuthMode.signUp ? 100 : 0,
                  //     maxHeight: _authMode == AuthMode.signUp ? 120 : 0,
                  //   ),
                  //   curve: Curves.easeIn,
                  //   child: FadeTransition(
                  //     opacity: _opacityAnimation as Animation<double>,
                  //     child:
                  //  SlideTransition(
                  //   position: _slideAnimation as Animation<Offset>,
                  //   child:
                  TextFormField(
                    focusNode: myFocusNode,
                    enabled: _authMode == AuthMode.signUp,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.signUp
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                //   ),
                // ),
                // ),
                SizedBox(
                  height: _authMode == AuthMode.login ? 20 : 8,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8.0),
                      primary: Theme.of(context).colorScheme.primary,
                      foregroundColor:
                          Theme.of(context).primaryTextTheme.button!.color,
                    ),
                    child:
                        Text(_authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 4),
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(
                      '${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
