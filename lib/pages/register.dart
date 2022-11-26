import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:porsee/pages/login.dart';
import 'dart:convert' as convert;

import 'home.dart';

class RegisterPage extends StatefulWidget {

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class MyRoute extends MaterialPageRoute {
  MyRoute({required WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);
}

class _RegisterPageState extends State<RegisterPage> {

  bool pressed = true;
  bool isEmail(String input) => EmailValidator.validate(input);
  bool isPhone(String input) => RegExp(
      r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$'
  ).hasMatch(input);
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  String? get _errorTextName {

    final textName = _nameController.value.text;

    if (textName.isEmpty) {
      return null;
    }
    if (textName.length < 3) {
      return 'Name must be 3 letters or more';
    }
    return null;
  }

  String? get _errorTextEmail {

    final textEmail = _emailController.value.text;

    if (textEmail.isEmpty) {
      return null;
    }
    if (textEmail.length < 10 && !isEmail(textEmail)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? get _errorTextPhone {

    final textPhone = _phoneController.value.text;

    if (textPhone.isEmpty) {
      return null;
    }
    if (!isPhone(textPhone)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? get _errorTextPassword {

    final textPassword = _passwordController.value.text;

    if (textPassword.isEmpty) {
      return null;
    }
    if (textPassword.contains(" ")){
      return "Password can't contain space";
    }
    if (textPassword.length < 8 || textPassword.length > 25) {
      return 'Password length should be 8-24 characters';
    }
    return null;
  }

  String? get _errorTextRePassword {

    final textRePassword = _rePasswordController.value.text;
    final textCheck = _passwordController.value.text;

    if (textRePassword.isEmpty) {
      return null;
    }
    if (textRePassword.contains(" ")){
      return "Password can't contain space";
    }
    if (textRePassword.length < 8 || textRePassword.length > 25) {
      return 'Password length should be 8-24 characters';
    }
    if (textRePassword != textCheck) {
      return "Password doesn't match";
    }
    return null;
  }

  void _submit() {
    final space = RegExp(r"\s+");
    String name = _nameController.value.text.split(space).join(" ");
    String email = _emailController.value.text.replaceAll(' ', '');
    String phone = _phoneController.value.text;
    String password = _passwordController.value.text;
    if (_errorTextName == null && _errorTextEmail == null && _errorTextPhone == null
        && _errorTextPassword == null && _errorTextRePassword == null) {
      postRequest(name, email, phone, password);
    }
  }

  Future<void> postRequest (String name, String email, String phone, String password) async {
    var url ='http://porsee.site/server.php?apicall=register';
    Map<String, String> data = {
      'name': name,
      'email' : email,
      'phone' : phone,
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
        Navigator.push(context, MyRoute(builder: (_) => LoginPage()));
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _passwordController.clear();
        _rePasswordController.clear();
      }else{
        const invalidEmailPhone = SnackBar(
          content: Text('Phone number is already registered'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(invalidEmailPhone);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
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
                              child: const Text('Become a\nSeekers!', style: TextStyle(letterSpacing: 1, fontSize: 35, fontWeight: FontWeight.bold, color: Color(0xff402D7C))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child : Padding(
                                padding: EdgeInsets.only(left: screenWidth * 0.1, right: screenWidth * 0.1),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.zero,
                                        child: SizedBox(
                                          height: screenHeight * 0.1,
                                          child: TextFormField(
                                            controller: _nameController,
                                            style: const TextStyle(fontSize: 14),
                                            cursorColor: const Color(0xff402D7C),
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                                            ],
                                            decoration: InputDecoration(
                                              errorText: _errorTextName,
                                              errorStyle: const TextStyle(fontSize: 13),
                                              fillColor: Color(0xffF3F3F3),
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: BorderSide(color: Color(0xff402D7C)),
                                              ),
                                              hintText: "Full name",
                                              contentPadding: EdgeInsets.only(left: screenWidth * 0.025),
                                            ),
                                            onChanged: (_) => setState(() {}),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.zero,
                                        child: SizedBox(
                                          height: screenHeight * 0.1,
                                          child: TextFormField(
                                            controller: _emailController,
                                            style: const TextStyle(fontSize: 14),
                                            cursorColor: const Color(0xff402D7C),
                                            decoration: InputDecoration(
                                              errorText: _errorTextEmail,
                                              errorStyle: const TextStyle(fontSize: 13),
                                              fillColor: Color(0xffF3F3F3),
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: BorderSide(color: Color(0xff402D7C)),
                                              ),
                                              hintText: "Email",
                                              contentPadding: EdgeInsets.only(left: screenWidth * 0.025),
                                            ),
                                            onChanged: (_) => setState(() {}),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.zero,
                                        child: SizedBox(
                                          height: screenHeight * 0.1,
                                          child: TextFormField(
                                            controller: _phoneController,
                                            style: const TextStyle(fontSize: 14),
                                            cursorColor: const Color(0xff402D7C),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              errorText: _errorTextPhone,
                                              errorStyle: const TextStyle(fontSize: 13),
                                              fillColor: Color(0xffF3F3F3),
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: BorderSide(color: Color(0xff402D7C)),
                                              ),
                                              hintText: "Phone number",
                                              contentPadding: EdgeInsets.only(left: screenWidth * 0.025),
                                            ),
                                            onChanged: (_) => setState(() {}),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
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
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.zero,
                                        child: SizedBox(
                                          height: screenHeight * 0.1,
                                          child: TextFormField(
                                            controller: _rePasswordController,
                                            obscureText: pressed,
                                            style: const TextStyle(fontSize: 14),
                                            cursorColor: const Color(0xff402D7C),
                                            decoration: InputDecoration(
                                              errorText: _errorTextRePassword,
                                              errorStyle: const TextStyle(fontSize: 13),
                                              fillColor: const Color(0xffF3F3F3),
                                              filled: true,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  borderSide: BorderSide(color: Color(0xff402D7C)),
                                              ),
                                              hintText: "Re-enter your password",
                                              contentPadding: EdgeInsets.only(left: screenWidth * 0.025),
                                              suffixIcon: Transform.scale(
                                                scale: 2,
                                                child: IconButton(
                                                    icon: Padding(
                                                        padding: EdgeInsets.zero,
                                                        child: pressed == true ?
                                                        (SvgPicture.asset('assets/images/eye_closed.svg', height: 15, width: 15,)):SvgPicture.asset('assets/images/eye.svg', height: 15, width: 15,)
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
                                                    if(_nameController.value.text.isEmpty){
                                                      const invalidName = SnackBar(
                                                        content: Text('Name cannot be empty'),
                                                        backgroundColor: Colors.red,
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(invalidName);
                                                    }else if(_emailController.value.text.isEmpty){
                                                      const invalidEmail = SnackBar(
                                                        content: Text('Email cannot be empty'),
                                                        backgroundColor: Colors.red,
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(invalidEmail);
                                                    }else if(_phoneController.value.text.isEmpty){
                                                      const invalidPhone = SnackBar(
                                                        content: Text('Phone number cannot be empty'),
                                                        backgroundColor: Colors.red,
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(invalidPhone);
                                                    }else if(_passwordController.value.text.isEmpty){
                                                      const invalidPassword = SnackBar(
                                                        content: Text('Password cannot be empty'),
                                                        backgroundColor: Colors.red,
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(invalidPassword);
                                                    }else if(_rePasswordController.value.text.isEmpty){
                                                      const invalidRePassword = SnackBar(
                                                        content: Text('Password cannot be empty'),
                                                        backgroundColor: Colors.red,
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(invalidRePassword);
                                                    }else{
                                                      _submit();
                                                    }
                                                  },
                                                  child: const Text('Sign Up', style: TextStyle(letterSpacing: 1, color: Colors.white),),
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
                                            child: const Text("Already have an account?", style: TextStyle(fontSize: 15, color: Colors.black, letterSpacing: 1),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: screenHeight * 0.01),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: const Color(0xffF3F3F3),
                                                padding: EdgeInsets.zero,
                                                textStyle: const TextStyle(fontSize: 15, decoration: TextDecoration.underline, letterSpacing: 1),

                                              ),
                                              onPressed: () {
                                                Navigator.push(context, MyRoute(builder: (_) => LoginPage()));
                                              },
                                              child: const Text("Sign In", style: TextStyle(fontSize: 15, color: Colors.black, letterSpacing: 1),),

                                              ),
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
    );
  }
}