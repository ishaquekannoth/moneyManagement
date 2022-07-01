import 'package:flutter/material.dart';
import 'package:moneymanager/displayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TextEditingController _controller = TextEditingController();
  String UserName = 'UserName';
  String name = '';
  @override
  void initState() {
    checkLoggedInStatus();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Column(
              children: [
                Image.asset(
                  'Assets/images/splash.gif',
                  alignment: Alignment.center,
                ),
              ],
            ),
            TextFormField(
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  hintText: 'This is where you tell us your Name',hintStyle: TextStyle(fontSize: 22)),
              controller: _controller,
              onChanged: (input) async {
                setState(() {
                  name = input;
                });
              },
            ),

            SizedBox(
              height: 35,
            ),

            FloatingActionButton.extended(
                onPressed: () async {
                  final pref = await SharedPreferences.getInstance();
                  name.trim();
                  if (name != '') {
                   await pref.setString(UserName, name);
                    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => MainDisplay()));
                  }
                },
                label: Container(
                  width: 200.0,
                  height: 42.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 22,
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
  Future<void> checkLoggedInStatus() async {
    final pref = await SharedPreferences.getInstance();
    final String? status = pref.getString('UserName');
    if (status != null) {
       Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => MainDisplay()));
    }
  }
}
