import 'package:flutter/material.dart';
import 'package:porsee/pages/home.dart';
import 'package:porsee/pages/loading.dart';
import 'package:porsee/pages/login.dart';
import 'package:porsee/pages/register.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: '/home',
  routes: {
    '/home': (content) => HomePage(),
    '/login': (content) => LoginPage(),
    '/register': (content) => RegisterPage(),
    'loading' : (context) => LoadingPage()
  },
));


