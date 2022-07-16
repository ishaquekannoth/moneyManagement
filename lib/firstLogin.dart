import 'package:flutter/material.dart';
import 'package:moneymanager/displayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstLogin extends StatefulWidget {
  const FirstLogin({Key? key}) : super(key: key);

  @override
  State<FirstLogin> createState() => _FirstLoginState();
}

class _FirstLoginState extends State<FirstLogin> {
  final TextEditingController _controller = TextEditingController();

  String UserName = 'UserName';
  String Currency = 'Currency';
  String setCurrency = 'AED';

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
                TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    hintText: 'This is where you tell us your Name',
                  ),
                  controller: _controller,
                  onChanged: (input) async {
                    setState(() {
                      name = input;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Choose Your  Currency'),
                      DropdownButton<String>(
                        menuMaxHeight: 100,
                          value: setCurrency,
                          items: const [
                            DropdownMenuItem<String>(
                                value: 'AED', child: Text('AED')),
                            DropdownMenuItem<String>(
                                value: 'BHD', child: Text('BHD')),
                            DropdownMenuItem<String>(
                                value: 'EUR', child: Text('EUR')),
                            DropdownMenuItem<String>(
                                value: 'GBP', child: Text('GBP')),
                            DropdownMenuItem<String>(
                                value: 'INR', child: Text('INR')),
                            DropdownMenuItem<String>(
                                value: 'KWD', child: Text('KWD')),
                            DropdownMenuItem<String>(
                                value: 'OMR', child: Text('OMR')),
                            DropdownMenuItem<String>(
                                value: 'QAR', child: Text('QAR')),
                            DropdownMenuItem<String>(
                                value: 'RUB', child: Text('RUB')),    
                            DropdownMenuItem<String>(
                                value: 'SAR', child: Text('SAR')),
                            DropdownMenuItem<String>(
                                value: 'USD', child: Text('USD')),
                      
                          ],
                          onChanged: (value) {
                            setState(() {
                              setCurrency = value!;
                            });
                          }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                FloatingActionButton.extended(
                    onPressed: () async {
                      final pref = await SharedPreferences.getInstance();
                      name.trim();
                      if (name != '') {
                        await pref.setString(UserName, name);
                        await pref.setString(Currency, setCurrency);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctx) => const MainDisplay()));
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
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
