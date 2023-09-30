import 'package:flutter/material.dart';
import 'package:flutter_chat_application_11/Screens/profile.dart';
import 'package:flutter_chat_application_11/apis/apis_const.dart';
import 'package:flutter_chat_application_11/model/chat_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widget/chat_user_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  final List<ChatUser> searchingList = [];

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    Apis.getSelfInfo();
    //    SystemChannels.lifecycle.setMessageHandler((message) {
    //   log('Message: $message');

    //   if (APIs.auth.currentUser != null) {
    //     if (message.toString().contains('resume')) {
    //       APIs.updateActiveStatus(true);
    //     }
    //     if (message.toString().contains('pause')) {
    //       APIs.updateActiveStatus(false);
    //     }
    //   }

    //   return Future.value(message);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (isSearching) {
            setState(() {
              isSearching != isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: isSearching
                ? TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                        border: InputBorder.none,
                        hintText: 'searching....'),
                    style: const TextStyle(
                        fontSize: 20, color: Colors.white, letterSpacing: 0.3),
                    onChanged: (value) {
                      searchingList.clear();
                      for (var i in list) {
                        if (i.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          searchingList.add(i);
                        }
                        setState(() {
                          searchingList;
                        });
                      }
                    },
                  )
                : const Text(
                    'Chat App',
                    // style: TextStyle(fontSize: mq.height * .03),
                  ),
            leading: Icon(
              Icons.home,
              size: mq.height * .04,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
                icon: Icon(
                  isSearching ? Icons.clear : Icons.search,
                  size: mq.height * .04,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(user: Apis.me),
                      ));
                },
                icon: Icon(
                  Icons.more_vert,
                  size: mq.height * .04,
                ),
              )
            ],
          ),
          body: StreamBuilder(
            // stream: Apis.firestore.collection('User').snapshots(),
            // stream: Apis.getMyUsersId(),
            stream: Apis.getAllUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

                case ConnectionState.active:
                case ConnectionState.done:
                  // return StreamBuilder(
                  //   stream: Apis.getAllUser(
                  //       snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                  //   builder: (context, snapshot) {
                  //     switch (snapshot.connectionState) {
                  //       //if data is loading
                  //       case ConnectionState.waiting:
                  //       case ConnectionState.none:
                  //       // return const Center(
                  //       //     child: CircularProgressIndicator());

                  //       //if some or all data is loaded then show it
                  //       case ConnectionState.active:
                  //       case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];
                  if (list.isNotEmpty) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: mq.height * .01),
                      itemCount:
                          isSearching ? searchingList.length : list.length,
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user:
                              isSearching ? searchingList[index] : list[index],
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text(
                      'connection not found!',
                      style: TextStyle(fontSize: 30),
                    ));
                  }
              }
            },
            // );
            // }
            // if (snapshot.hasData) {
            //   final data = snapshot.data?.docs;
            //   print('Data: $data');
            //   for (var i in data!) {
            //     print('**** Data: ${jsonEncode(i.data())}');
            //     // list.add(i.data()['index']);
            //   }
            // }
            // return ListView.builder(
            //   physics: const BouncingScrollPhysics(),
            //   padding: EdgeInsets.only(top: mq.height * .01),
            //   itemCount: 10,
            //   itemBuilder: (context, index) {
            //     return Card(
            //       elevation: 5,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(22)),
            //       color: Colors.purple.shade100,
            //       shadowColor: Colors.purple,
            //       margin: EdgeInsets.symmetric(
            //           horizontal: mq.height * .02, vertical: mq.height * .008),
            //       child: InkWell(
            //         splashColor: const Color.fromARGB(255, 132, 19, 152),
            //         onTap: () {},
            //         child: ListTile(
            //           title: Text(
            //             'Aish',
            //             style: TextStyle(
            //                 fontSize: mq.height * .03,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //           subtitle: const Text('last seen user...'),
            //           trailing: const Text('2:00 pm'),
            //           leading: const CircleAvatar(
            //             child: Icon(Icons.person),
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // );
            // },
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(
                bottom: mq.height * .008, right: mq.width * .02),
            child: FloatingActionButton(
              onPressed: () async {
                await Apis.auth.signOut();
                await GoogleSignIn().signOut();
              },
              child: const Icon(
                Icons.add_comment_rounded,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
