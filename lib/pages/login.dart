import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'dart:convert' as convert;
import 'package:porsee/pages/register.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class MyRoute extends MaterialPageRoute {
  MyRoute({required WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);
}

class _LoginPageState extends State<LoginPage> {

  bool pressed = true;
  bool isEmail(String input) => EmailValidator.validate(input);
  bool isPhone(String input) => RegExp(
      r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$'
  ).hasMatch(input);
  var _emailPhoneController = TextEditingController();
  var _passwordController = TextEditingController();

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? get _errorTextEmailPhone {

    final textEmailPhone = _emailPhoneController.value.text;

    if (textEmailPhone.isEmpty) {
      return null;
    }
    if (textEmailPhone.length < 10 && !isEmail(textEmailPhone) && !isPhone(textEmailPhone)) {
      return 'Please enter a valid email or phone number';
    }
    return null;
  }

  set emailPhoneController(value) {
    _emailPhoneController = value;
  }

  String? get _errorTextPassword {

    final textPassword = _passwordController.value.text;

    if (textPassword.isEmpty) {
      return null;
    }
    if (textPassword.length < 8 || textPassword.length > 25) {
      return 'Password length should be 8-24 characters';
    }
    return null;
  }

  void _submit() {
    String emailPhone = _emailPhoneController.value.text.replaceAll(' ', '');
    String password = _passwordController.value.text;
    if (_errorTextEmailPhone == null && _errorTextPassword == null) {
      postRequest(emailPhone, password);
    }
  }

  Future<void> postRequest (String emailPhone, String password) async {
    var url ='http://porsee.site/server.php?apicall=login';
    Map<String, String> data = {
      'emailPhone': emailPhone,
      'password' : password
    };

    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        encoding: convert.Encoding.getByName("utf-8"),
        body: data
    );
    if (response.body.isNotEmpty) {
      final body = convert.jsonDecode(response.body);
      bool error = body['error'];
      if ( error == false ){
        Navigator.push(context, MyRoute(builder: (_) => HomePage()));
        _emailPhoneController.clear();
        _passwordController.clear();
      }else{
        const invalidCredential = SnackBar(
          content: Text('Invalid email, phone number, or password'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(invalidCredential);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              // Image.asset('assets/images/banner_login.png'),
              Expanded(
                child: Container(
                  height: screenHeight,
                  width: screenWidth,
                  color: Colors.white,
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (OverscrollIndicatorNotification overscroll){
                      overscroll.disallowGlow();
                      return true;
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.1, top: screenHeight * 0.075, right: screenWidth * 0.1, bottom: screenHeight * 0.05),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: const Text('Welcome!', style: TextStyle(letterSpacing: 1, fontSize: 35, fontWeight: FontWeight.bold, color: Color(0xff402D7C))),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.zero,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child : Padding(
                                padding: EdgeInsets.only(left: screenWidth * 0.1, top: screenHeight * 0.001, right: screenWidth * 0.1),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    // const Align(
                                    //   alignment: Alignment.centerLeft,
                                    //   child: Text("Email or Phone", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffF3F3F3), letterSpacing: 1),
                                    //   ),
                                    // ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: screenHeight * 0.02),
                                        child: SizedBox(
                                          height: screenHeight * 0.1,
                                          child: TextFormField(
                                            controller: _emailPhoneController,
                                            style: const TextStyle(fontSize: 14),
                                            cursorColor: const Color(0xff402D7C),
                                            decoration: InputDecoration(
                                              errorText: _errorTextEmailPhone,
                                              errorStyle: const TextStyle(fontSize: 13),
                                              fillColor: Color(0xffF3F3F3),
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: BorderSide(color: Color(0xff402D7C)),
                                              ),
                                              hintText: "Email or phone number",
                                              contentPadding: EdgeInsets.only(left: screenWidth * 0.025),
                                            ),
                                            onChanged: (_) => setState(() {}),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // const Align(
                                    //   alignment: Alignment.centerLeft,
                                    //   child: Padding(
                                    //     padding: EdgeInsets.zero,
                                    //     child: Text("Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffF3F3F3), letterSpacing: 1),
                                    //     ),
                                    //   ),
                                    // ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.zero,
                                        child: SizedBox(
                                          height: screenHeight * 0.1,
                                          child: TextFormField(
                                            controller: _passwordController,
                                            obscureText: pressed,
                                            style: const TextStyle(fontSize: 14),
                                            cursorColor: const Color(0xff402D7C),
                                            decoration: InputDecoration(
                                              errorText: _errorTextPassword,
                                              errorStyle: const TextStyle(fontSize: 13),
                                              fillColor: const Color(0xffF3F3F3),
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(color: Color(0xff402D7C)),
                                              ),
                                              hintText: "Password",
                                              contentPadding: EdgeInsets.only(left: screenWidth * 0.025),
                                              suffixIcon: Transform.scale(
                                                scale: 2,
                                                child: IconButton(
                                                    icon: Padding(
                                                        padding: EdgeInsets.zero,
                                                        child: pressed == true ?
                                                        (SvgPicture.asset('assets/images/eye_closed.svg', height: screenHeight * 0.02, width: screenWidth * 0.02,)):SvgPicture.asset('assets/images/eye.svg', height: screenHeight * 0.02, width: screenWidth * 0.02,)
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        pressed = !pressed;
                                                      });
                                                    }
                                                ),
                                              ),
                                            ),
                                            onChanged: (_) => setState(() {}),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.zero,
                                        child: ClipRRect(
                                          child: Stack(
                                            children: <Widget>[
                                              Positioned.fill(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border : Border.all(
                                                      color: Colors.white,
                                                    ),
                                                    color: const Color(0xff402D7C),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: screenWidth,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: const Color(0xffF3F3F3),
                                                    padding: EdgeInsets.only(left: screenWidth * 0.075, right: screenWidth * 0.075),
                                                    textStyle: const TextStyle(fontSize: 15),
                                                  ),
                                                  onPressed: (){
                                                    if(_emailPhoneController.value.text.isEmpty){
                                                      const invalidEmailPhone = SnackBar(
                                                        content: Text('Email cannot be empty'),
                                                        backgroundColor: Colors.red,
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(invalidEmailPhone);
                                                    }else if(_passwordController.value.text.isEmpty){
                                                      const invalidPassword = SnackBar(
                                                        content: Text('Password cannot be empty'),
                                                        backgroundColor: Colors.red,
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(invalidPassword);
                                                    }else{
                                                      _submit();
                                                    }
                                                  },
                                                  child: const Text('Sign In', style: TextStyle(letterSpacing: 1, color: Colors.white),),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: screenHeight * 0.01),
                                            child: const Text("New to Porsee?", style: TextStyle(fontSize: 15, color: Colors.black, letterSpacing: 1),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: const Color(0xffF3F3F3),
                                              padding: EdgeInsets.only(top: screenHeight * 0.01, left: screenWidth * 0.02),
                                              textStyle: const TextStyle(fontSize: 15, decoration: TextDecoration.underline, letterSpacing: 1),

                                            ),
                                            onPressed: () {
                                              Navigator.push(context, MyRoute(builder: (_) => RegisterPage()));
                                            },
                                            child: const Text('Sign Up', style: TextStyle(fontSize: 15, color: Colors.black, letterSpacing: 1),),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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