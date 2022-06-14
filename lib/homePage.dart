import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  color: Colors.red,
                  width: MediaQuery.of(context).size.width*0.9,
                  margin: EdgeInsets.all(20.0),
                  child: Container(
                    
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        customcolor.PrimaryColor,
                        Colors.blueAccent
                      ])
                    ,
                    borderRadius: BorderRadius.all(Radius.circular(25)     )
                    ),
                    
                    padding: EdgeInsets.symmetric(vertical: 30,),
                    child: Column(
                      children: [
                       Text('Total Balance',
                       textAlign: TextAlign.center,
                       style: TextStyle(
                        fontSize: 22,
                        fontWeight:FontWeight.w700,
                        color: Colors.white
                       ),       
                       ),
                       Text('Rs 34000',
                       textAlign: TextAlign.center,
                       style: TextStyle(
                        fontSize: 26,
                        fontWeight:FontWeight.w700,
                        color: Colors.white
                       ),       
                       ),
                      Padding(padding: EdgeInsets.all(8.0),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          cardIncome('1200'),
                          cardExpense('500')
                        ],
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
  Widget cardIncome(String value){

    return(
      Row(children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
          color: Colors.white),
          child: Icon(Icons.arrow_downward,
          color: Colors.green,
          ),
          margin: EdgeInsets.only(right: 10),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Income',
            style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
    
            ),
             Text(value,  style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
    ),
          ],
        )
      ],)
    );
  }
Widget cardExpense(String value){

    return(
      Row(children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
          color: Colors.white),
          child: Icon(Icons.arrow_upward,
          color: Color.fromARGB(255, 216, 11, 11),
          ),
          margin: EdgeInsets.only(right: 10),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expense',
            style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
    
            ),
             Text(value,  style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
    ),
          ],
        )
      ],)
    );
  }



  
}
