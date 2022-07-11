import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moneymanager/displayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstLogin extends StatefulWidget {
 FirstLogin({Key? key}) : super(key: key);

  @override
  State<FirstLogin> createState() => _FirstLoginState();
}

class _FirstLoginState extends State<FirstLogin> {
 final TextEditingController _controller = TextEditingController();

  String UserName = 'UserName';

  String name = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Column(
              children: [
                Center(
                  child: Image.asset(
                    'Assets/images/splash.gif',
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
            TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  hintText: 'This is where you tell us your Name',),
              controller: _controller,
              onChanged: (input) async {
                setState(() {
                  name = input;
                });
              },
            ),

            const SizedBox(
              height: 35,
            ),

            FloatingActionButton.extended(
                onPressed: () async {
                  final pref = await SharedPreferences.getInstance();
                  name.trim();
                  if (name != '') {
                   await pref.setString(UserName, name);
                    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => const MainDisplay()));
                  }
                },
                label: Container(
                  width: 200.0,
                  height: 42.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    
                  ),
                  child: const Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color: Colors.white,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                )
          ],
        ),
      ),
    );
    
  }
}