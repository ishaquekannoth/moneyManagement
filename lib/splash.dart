import 'package:flutter/material.dart';
import 'package:moneymanager/controllers/settings.dart';
import 'package:moneymanager/displayer.dart';
import 'package:moneymanager/firstLogin.dart';
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
      body: Center(child: Image.asset('Assets/images/loading.gif')),
    ));
  }

  Future<void> checkLoggedInStatus() async {
    final pref = await SharedPreferences.getInstance();
    final String? status = pref.getString('UserName');
    if (status != null) {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (conyext) => const MainDisplay()));
    } else {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => FirstLogin()));
    }
  }
}
