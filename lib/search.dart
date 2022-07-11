import 'package:flutter/material.dart';
import 'package:moneymanager/controllers/category.dart';
import 'package:moneymanager/controllers/db_helper.dart';
import 'package:moneymanager/editScreen.dart';

// class BrutalSearch extends StatefulWidget {
//   const BrutalSearch({Key? key}) : super(key: key);

//   @override
//   State<BrutalSearch> createState() => _BrutalSearchState();
// }

// class _BrutalSearchState extends State<BrutalSearch> {
//   Dbhelper helper = Dbhelper();
//   CategoryBox category = CategoryBox();
//   List myList = [];
//   List _foundData = [];

//   Future<void> getRawMap() async {
//     Map unsorted = await helper.fetchAllData();
//     var sortMapByValue = Map.fromEntries(unsorted.entries.toList()
//       ..sort((e1, e2) => e2.value['date'].compareTo(e1.value['date'])));
//     List sortedList = [];
//     sortMapByValue.forEach((key, value) => sortedList.add(value));
//     myList.clear();
//     myList.addAll(sortedList);
//     _foundData = myList;
//     setState(() {});
//   }

//   @override
//   void initState() {
//     getRawMap();

//     super.initState();
//   }

//   void _runFilter(String enteredKeyword) {
//     List<dynamic> results = [];
//     if (enteredKeyword.isEmpty) {
//       results = myList;
//     } else {
//       results = myList.where((element) {
//       return (element['category']
//               .toString()
//               .toLowerCase()
//               .contains(enteredKeyword.toLowerCase()) ||
//           element['amount']
//               .toString()
//               .toLowerCase()
//               .startsWith(enteredKeyword.toLowerCase()) ||
//           element['note']
//               .toString()
//               .toLowerCase()
//               .contains(enteredKeyword.toLowerCase())||
//          element['date']
//               .toString()
//               .toLowerCase()
//               .contains(enteredKeyword.toLowerCase())
//               );
//     }).toList();

//     }
//     setState(() {
//       _foundData = results;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Find an Item'),centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             TextField(
//               style: TextStyle(fontSize: 25),
//               cursorHeight: 35,
//               onChanged: (value) => _runFilter(value),
//               decoration: const InputDecoration(
//                   labelText: 'Category/Amount/Note/Date', suffixIcon: Icon(Icons.search)),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Expanded(
//               child: _foundData.isNotEmpty
//                   ? ListView.builder(
//                       itemCount: _foundData.length,
//                       itemBuilder: (context, index) {
//                         if (_foundData[index]['type'] == 'Income') {
//                           return incomeTile(
//                               _foundData[index]['amount'],
//                               _foundData[index]['note'],
//                               _foundData[index]['date'],
//                               _foundData[index]['id'],
//                               _foundData[index]['category'],
//                               _foundData[index]['type'],
//                               helper,
//                               context);
//                         } else {
//                           return expenseTile(
//                               _foundData[index]['amount'],
//                               _foundData[index]['note'],
//                               _foundData[index]['date'],
//                               _foundData[index]['id'],
//                               _foundData[index]['category'],
//                               _foundData[index]['type'],
//                               helper,
//                               context);
//                         }
//                       })
//                   : const Text(
//                       'No results found',
//                       style: TextStyle(fontSize: 24),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget expenseTile(double value, String note, DateTime dateTime, int id,
//       String category, String type, Dbhelper dataBase, BuildContext context) {
//     return Card(
//       child: GestureDetector(
//         onTap: () {
//           Navigator.of(context)
//               .push(MaterialPageRoute(
//                   builder: (context) => (EditScreen(
//                       value: value,
//                       note: note,
//                       dateTime: dateTime,
//                       id: id,
//                       type: type,
//                       category: category))))
//               .whenComplete(() => getRawMap());
//         },
//         onLongPress: () {
//           showDialog(
//               context: context,
//               builder: (context) {
//                 return (AlertDialog(
//                   title: Text('Confirm Delete?'),
//                   actions: [
//                     ElevatedButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         child: Text("Cancel")),
//                     ElevatedButton(
//                         onPressed: () {
//                           dataBase
//                               .removeSingleItem(id)
//                               .whenComplete(() => getRawMap());
//                           Navigator.of(context).pop();
//                         },
//                         child: Text("OK"))
//                   ],
//                 ));
//               });
//         },
//         child: (Container(
//           // padding: EdgeInsets.all(15),
//           // margin: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15), color: Colors.white),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Icon(
//                     Icons.arrow_circle_up_outlined,
//                     size: 28,
//                     color: Colors.red,
//                   ),
//                   Text("Expense",
//                       style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.black87,
//                           fontWeight: FontWeight.bold)),
//                   Text('-$value AED',
//                       style: TextStyle(
//                           fontSize: 18,
//                           color: Color.fromARGB(255, 170, 20, 9),
//                           fontWeight: FontWeight.bold)),
//                   Text(
//                       '${dateTime.day}/${dateTime.month}/${dateTime.year % 100}',
//                       style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.black87,
//                           fontWeight: FontWeight.bold))
//                 ],
//               ),
//               Text(category,
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: Colors.black87,
//                   ))
//             ],
//           ),
//         )),
//       ),
//     );
//   }

//   Widget incomeTile(double value, String note, DateTime dateTime, int id,
//       String category, String type, Dbhelper dataBase, BuildContext context) {
//     return Card(
//       child: GestureDetector(
//         onTap: () {
//           Navigator.of(context)
//               .push(MaterialPageRoute(
//                   builder: (context) => (EditScreen(
//                         value: value,
//                         note: note,
//                         dateTime: dateTime,
//                         id: id,
//                         category: category,
//                         type: type,
//                       ))))
//               .whenComplete(() => getRawMap());
//         },
//         onLongPress: () {
//           showDialog(
//               context: context,
//               builder: (context) {
//                 return (AlertDialog(
//                   title: Text('Confirm Delete?'),
//                   actions: [
//                     ElevatedButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         child: Text("Cancel")),
//                     ElevatedButton(
//                         onPressed: () {
//                           dataBase
//                               .removeSingleItem(id)
//                               .whenComplete(() => getRawMap());
//                           Navigator.of(context).pop();
//                         },
//                         child: Text("OK"))
//                   ],
//                 ));
//               });
//         },
//         child: (Container(
//           // padding: EdgeInsets.all(15),
//           // margin: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15), color: Colors.white),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Icon(
//                     Icons.arrow_circle_down_outlined,
//                     size: 28,
//                     color: Color.fromARGB(255, 5, 231, 5),
//                   ),
//                   Text("Income",
//                       style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.black87,
//                           fontWeight: FontWeight.bold)),
//                   Text('+$value AED',
//                       style: TextStyle(
//                           fontSize: 18,
//                           color: Color.fromARGB(255, 4, 112, 8),
//                           fontWeight: FontWeight.bold)),
//                   Text(
//                       '${dateTime.day}/${dateTime.month}/${dateTime.year % 100}',
//                       style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.black87,
//                           fontWeight: FontWeight.bold))
//                 ],
//               ),
//               Text(category,
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: Colors.black87,
//                   )),
//             ],
//           ),
//         )),
//       ),
//     );
//   }
// }

class SearchScreen extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Category/Amount/Note/Date to search';

  @override
  ThemeData appBarTheme(BuildContext context) {
    var superThemeData = super.appBarTheme(context);
    return superThemeData.copyWith(
      textTheme: superThemeData.textTheme.copyWith(
        headline6: const TextStyle(fontSize: 14),
      ),
    );
  }

  Dbhelper helper = Dbhelper();
  CategoryBox category = CategoryBox();
  ValueNotifier<List> myList = ValueNotifier([]);

  Future<void> getRawMap() async {
    Map unsorted = await helper.fetchAllData();
    var sortMapByValue = Map.fromEntries(unsorted.entries.toList()
      ..sort((e1, e2) => e2.value['date'].compareTo(e1.value['date'])));
    List sortedList = [];
    sortMapByValue.forEach((key, value) => sortedList.add(value));
    myList.value.clear();
    myList.value.addAll(sortedList);
    myList.notifyListeners();
  }

  SearchScreen() {
    getRawMap();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: (const Icon(Icons.clear)))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: (const Icon(Icons.arrow_back)));
  }

  @override
  Widget buildResults(BuildContext context) {
    final List suggestion = myList.value.where((element) {
      return (element['category']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          element['amount']
              .toString()
              .toLowerCase()
              .startsWith(query.toLowerCase()) ||
          element['note']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          element['date']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()));
    }).toList();

    return (ValueListenableBuilder(
      valueListenable: myList,
      builder: (context, list, widget) {
        return (ListView.builder(
          itemBuilder: (context, index) {
            final item = suggestion[index];
            String temp = item['type'];
            if (temp == 'Expense') {
              return ((expenseTile(
                  item['amount'],
                  item['note'],
                  item['date'],
                  item['id'],
                  item['category'],
                  item['type'],
                  helper,
                  context)));
            } else {
              return ((incomeTile(
                  item['amount'],
                  item['note'],
                  item['date'],
                  item['id'],
                  item['category'],
                  item['type'],
                  helper,
                  context)));
            }
          },
          itemCount: suggestion.length,
        ));
      },
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List suggestion = myList.value.where((element) {
      return (element['category']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          element['amount']
              .toString()
              .toLowerCase()
              .startsWith(query.toLowerCase()) ||
          element['note']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          element['date']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()));
    }).toList();

    return (ValueListenableBuilder(
      valueListenable: myList,
      builder: (context, list, widget) {
        return (ListView.builder(
          itemBuilder: (context, index) {
            final item = suggestion[index];
            String temp = item['type'];
            if (temp == 'Expense') {
              return ((expenseTile(
                  item['amount'],
                  item['note'],
                  item['date'],
                  item['id'],
                  item['category'],
                  item['type'],
                  helper,
                  context)));
            } else {
              return ((incomeTile(
                  item['amount'],
                  item['note'],
                  item['date'],
                  item['id'],
                  item['category'],
                  item['type'],
                  helper,
                  context)));
            }
          },
          itemCount: suggestion.length,
        ));
      },
    ));
  }

  Widget expenseTile(
      double value,
      String note,
      DateTime dateTime,
      int id,
      String category,
      String type,
      Dbhelper dataBase,
      BuildContext context,
      ) {
    return Card(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => (EditScreen(
                      value: value,
                      note: note,
                      dateTime: dateTime,
                      id: id,
                      type: type,
                      category: category))))
              .whenComplete(() => getRawMap());
        },
        onLongPress: () {
         
            showDialog(
                context: context,
                builder: (context) {
                  return (AlertDialog(
                    title: const Text('Confirm Delete?',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    actions: [
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Cancel")),
                      ElevatedButton(
                          onPressed: () async {
                            dataBase
                                .removeSingleItem(id)
                                .whenComplete(() => getRawMap()).then((value) => query=query);

                            Navigator.of(context).pop();
                            myList.notifyListeners();
                          },
                          child: const Text("OK"))
                    ],
                  ));
                });
          
        },
        child: (Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.arrow_circle_up_outlined,
                    size: 28,
                    color: Colors.red,
                  ),
                  const Text("Expense",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
                  Text('-$value AED',
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 170, 20, 9),
                          fontWeight: FontWeight.bold)),
                  Text(
                      '${dateTime.day}/${dateTime.month}/${dateTime.year % 100}',
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Category: $category',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      )),
                  Text('Note: $note',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ))
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget incomeTile(double value, String note, DateTime dateTime, int id,
      String category, String type, Dbhelper dataBase, BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () 
        {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => (EditScreen(
                        value: value,
                        note: note,
                        dateTime: dateTime,
                        id: id,
                        category: category,
                        type: type,
                      ))))
              .whenComplete(() => getRawMap());
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return (AlertDialog(
                  title: const Text(
                    'Confirm Delete?',
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancel")),
                    ElevatedButton(
                        onPressed: () {
                          dataBase
                              .removeSingleItem(id)
                              .whenComplete(() => getRawMap()).then((value) => query=query);
                          Navigator.of(context).pop();
                          myList.notifyListeners();
                        },
                        child: const Text("OK"))
                  ],
                ));
              });
      
        },
        child: (Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.arrow_circle_down_outlined,
                    size: 28,
                    color: Color.fromARGB(255, 5, 231, 5),
                  ),
                  const Text("Income",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
                  Text('+$value AED',
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 4, 112, 8),
                          fontWeight: FontWeight.bold)),
                  Text(
                      '${dateTime.day}/${dateTime.month}/${dateTime.year % 100}',
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Category: $category',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      )),
                  Text('Note: $note',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ))
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
