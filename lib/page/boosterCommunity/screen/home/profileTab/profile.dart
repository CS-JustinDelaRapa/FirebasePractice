import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplify/page/boosterCommunity/screen/home/changeUserIcon/changeUserIcon.dart';
import 'package:simplify/page/boosterCommunity/screen/home/homeTab/threadItem.dart';
import 'package:simplify/page/boosterCommunity/service/firebaseHelper.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userId;
  late Timer timer;
  bool counting = true;

  Map<String, dynamic>? myLikeList;
  bool futureDone = false;

  @override
  void initState() {
    userId = _auth.currentUser!.uid.toString();
    var likeListRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('myLikeList')
        .doc(userId);
    super.initState();
    likeListRef.get().then((value) {
      myLikeList = value.data();
      futureDone = true;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (futureDone == true) {

        if (myLikeList == null){
          print('MyLikeList == Null');
        }
        setState(() {
          counting = false;
          timer.cancel();
        });
      }
    });
    super.initState();
  }

  Future refreshState() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return counting? 
    Center(
            child: CircularProgressIndicator(),
          )
    :Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          FutureBuilder<DocumentSnapshot>(
              future: userCollection.doc(userId).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }
                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document does not exist");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: <Widget>[
                      Padding(
                        // user profile the nasa box
                        //the box
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 2)),
                            ],
                          ),
                          child: Row(
                            //profile image
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                          height: 60,
                                          width: 60,
                                          child: Image.asset(
                                              'assets/images/${data['userIcon']}')),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => ChangeUserIcon(
                                              uid: data['uid'],
                                              userIcon: data['userIcon']),
                                          barrierDismissible: true,
                                        ).then((value) => refreshState());
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                //user profile data
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${data['first-name']} ${data['last-name']}',
                                    textAlign: TextAlign.left,
                                  ),
                                  Text('${data['school']}'),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  //loading
                  return Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              }),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('thread')
                    .where('publisher-Id', isEqualTo: userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  return Stack(
                    children: <Widget>[
                      snapshot.data!.docs.length > 0
                          ? ListView(
                              shrinkWrap: true,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot postInfo) {
                                return ThreadItem(
                                    postInfo: postInfo, userId: userId, myLikeList: myLikeList);
                              }).toList(),
                            )
                          : Container(
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.error,
                                    color: Colors.grey[700],
                                    size: 64,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Text(
                                      'You haven\'t posted yet',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700]),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              )),
                            ),
                    ],
                  );
                }),
          ),
          Padding(
            //signout button
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:  MaterialStateProperty.all<Color>(Colors.indigo.shade600),
              ),
              onPressed: () {
                AuthService().signOut();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
