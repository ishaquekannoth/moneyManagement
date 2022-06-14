import 'package:flutter/material.dart';
import 'package:moneymanager/addTransactions.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'static.dart' as customcolor;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Dbhelper dbhelper = Dbhelper();
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: customcolor.PrimaryColor,
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => AddTransactions()))),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Icon(
          Icons.add,
          size: 32.0,
        ),
      ),
      body: FutureBuilder<Map>(
          future: dbhelper.fetchData(),
          builder: (context, snapshot) {
            if (snapshot.error != null) {
              return (Center(
                child: Text('unexpected Expected Err'),
              ));
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No Data found'),
                );
              }
              return (ListView(
                children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(35)), 
                            child: 
                            CircleAvatar
                            (maxRadius: 25,child: Image.asset("Assets/images/face.png",width: 64,),),
                            ),
                                Text("Hei Man",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: customcolor.PrimaryColor
                                ),
                                
                                ),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.settings,
                              size: 32.0,
                              color: Colors.green,
                            )),
                         
                      ]),
                ),

                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  margin: EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      
                    ),
                    
                    child: Column(
                      children: [
                       Text('Total Balance',
                       textAlign: TextAlign.center,
                       style: TextStyle(
                        fontSize: 22,
                        fontWeight:FontWeight.w700
                       ),       
                       ),
                       

                      ],
                    ),      
                  ),
                )




              ]));
            } else {
              return (Center(
                child: Text('End Of list'),
              ));
            }
          }),
    ));
  }
}
