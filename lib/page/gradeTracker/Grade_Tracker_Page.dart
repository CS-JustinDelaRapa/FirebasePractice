import 'package:flutter/material.dart';
import 'package:simplify/page/gradeTracker/gradeTrackerScreens/courseScreen.dart';

class GradeTrackerPage extends StatefulWidget {
  const GradeTrackerPage({Key? key}) : super(key: key);

  @override
  _GradeTrackerPageState createState() => _GradeTrackerPageState();
}

class _GradeTrackerPageState extends State<GradeTrackerPage> {
  String? courseName;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/testing/testing.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Row(children: [
            Icon(Icons.menu_book_rounded),
            SizedBox(
              width: 10,
            ),
            Text('Grade Tracker',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500))
          ]),
        ),
        body: Container(
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CourseScreenPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.amber.shade300,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 2,
                                offset: Offset(0, 4)),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListTile(
                            title: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    'Science',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              "Grade: 81%",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                })),
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.blueGrey[900],
          child: Icon(
            Icons.add,
            size: 30.0,
          ),
          onPressed: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) => Form(
                        // key: calculateKey1,
                        child: AlertDialog(
                            title: Text("Add course name"),
                            actions: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: TextFormField(
                              autofocus: true,
                              decoration:
                                  InputDecoration(hintText: "Course name"),
                              onChanged: (value) {
                                setState(() {
                                  courseName = value;
                                });
                              },
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                print(courseName);
                                Navigator.pop(context);
                              },
                              child: Text('Confirm'))
                        ])));
          },
        ),
      ),
    );
  }
}
