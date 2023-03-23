import 'dart:convert';

import 'package:another_crud/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Register.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  bool isLoading = false;
  TextEditingController UserName = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/images/tennos_favicon.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: UserName,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  SignIn(UserName.text, password.text);
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext contex) => Register()),
                    (Route<dynamic> route) => false);
              },
              child: Text('New User? Create Account'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> SignIn(String User, String Password) async {
    try {
      SharedPreferences.setMockInitialValues({});
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var Data = null;
      const url = 'https://192.168.100.221:7248/api/User/Login';
      final body = jsonEncode({"userName": User, "password": Password});
      final uri = Uri.parse(url);
      final response = await http
          .post(uri, body: body, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        Data = json.decode(response.body);
        sharedPreferences.setString("token", Data['result']);
        print('aqui es ${sharedPreferences.getString('token')}');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext contex) => home()),
            (Route<dynamic> route) => false);
      }

      if (response.statusCode == 400) {
        UserName.clear();
        password.clear();
        showErrorMessage("Usuario o contraseña es incorrecta");
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void showErrorMessage(String message) {
    final SnackBarMessage = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBarMessage);
  }
}
