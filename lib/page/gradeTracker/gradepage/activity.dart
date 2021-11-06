// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import '../Grade_Tracker_Page.dart';

class activity extends StatefulWidget {
  final int activitypercent;
  final int totalActivity;
  const activity(
      {Key? key, required this.activitypercent, required this.totalActivity})
      : super(key: key);
  @override
  _activity createState() => _activity();
}

final calculateKey = GlobalKey<FormState>();
double total = 0;
double items = 0;
double average = 0;
String remarks = "";
double activityTotalPercentage = 0;
String? activityPercentage;

class _activity extends State<activity> with AutomaticKeepAliveClientMixin {
  late List<String> totalScore;
  late List<String> totalItems;
  @override
  void initState() {
    totalScore = List.generate(widget.totalActivity, (index) => "");
    totalItems = List.generate(widget.totalActivity, (index) => "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(title: Text("GPA Calculator")),
        body: Column(
          children: [
            Expanded(
              child: Form(
                key: calculateKey,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.totalActivity,
                  itemBuilder: (context, index) => Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  totalScore[index] = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Activity # ${index + 1} :',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.lightBlueAccent,
                                      width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.lightBlueAccent,
                                      width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                              ),
                              validator: (value) =>
                                  value != null && value.isEmpty
                                      ? 'Required A Number'
                                      : null,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  totalItems[index] = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Total Items',
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.lightBlueAccent,
                                      width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.lightBlueAccent,
                                      width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                              ),
                              validator: (value) =>
                                  value != null && value.isEmpty
                                      ? 'Required A Number'
                                      : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
                child: Text('Calculate'),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.teal,
                  onSurface: Colors.grey,
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontStyle: FontStyle.italic),
                ),
                onPressed: () async {
                  if (calculateKey.currentState!.validate()) {
                    for (int x = 0; x < totalScore.length; x++) {
                      total += double.parse(totalScore[x]);
                      items += double.parse(totalItems[x]);
                    }
                    activityTotalPercentage = (total / items) * 100;
                    average = activityTotalPercentage *
                        (widget.activitypercent / 100);
                    if (average == 65) {
                      remarks = "Let’s raise this grade! ";
                    } else if (average < 75) {
                      remarks = "Let’s bring this up.";
                    } else if (average == 75 || average <= 79) {
                      remarks = "Perhaps try to do still better? ";
                    } else if (average >= 80 || average <= 89) {
                      remarks = "Good work. Keep at it. ";
                    } else {
                      remarks = "Excellent! Keep it up.";
                    }

                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text("Average: " + average.toString()),
                              content: Text("Remarks: " + remarks),
                              actions: [
                                Row(
                                  children: [
                                    ElevatedButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        setState(() {
                                          activityPercentage =
                                              average.toString();
                                        });
                                        Navigator.pop(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                GradeTrackerPage(
                                              totalActivity1: double.parse(
                                                  activityPercentage!),
                                            ),
                                          ),
                                        );
                                        setState(() {
                                          activityTotalPercentage = 0;
                                          average = 0;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ));
                  }
                }),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}