import 'package:flutter/material.dart';
import 'package:moneymanager/displayer.dart';
import 'package:moneymanager/firstLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String name = '';
  @override
  void initState() {
    super.initState();
    checkLoggedInStatus();
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            Image.asset('Assets/images/loading.gif'),
            const Text('\n\nMoneyIsh',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
             const Text('\n\nVer 1.0.1')
          ],
        )),

    ));
  }
  Future<void> checkLoggedInStatus() async {
    final pref = await SharedPreferences.getInstance();
    final String? status = pref.getString('UserName');
    if (status != null) {
      await Future.delayed(const Duration(seconds: 3));
          if (!mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (conyext) => const MainDisplay()));
    } else {
      await Future.delayed(const Duration(seconds: 3));
       if (!mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const FirstLogin()));
    }
  }
}
