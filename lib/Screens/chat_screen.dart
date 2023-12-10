import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_application_11/Screens/message_card.dart';
import 'package:flutter_chat_application_11/model/chat_model.dart';
import 'package:flutter_chat_application_11/model/message_model.dart';

import '../apis/apis_const.dart';

class ChatScreenn extends StatefulWidget {
  final ChatUser user;
  const ChatScreenn({super.key, required this.user});

  @override
  State<ChatScreenn> createState() => _ChatScreennState();
}

class _ChatScreennState extends State<ChatScreenn> {
  final textController = TextEditingController();
  List<Message> _list = [];
  bool showEmohi = false, isuploading = false;
  // @override
  // void dispose() {
  //   super.dispose();
  //   textController.dispose();
  // }

  Widget appbarr() {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (_) => ViewProfileScreen(user: widget.user)));
      },
      child: StreamBuilder(
        stream: Apis.getAllUser(),
        builder: (context, snapshot) {
          //  final data = snapshot.data?.docs;
          //   final list =
          //       data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

          return Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 33,
                ),
              ),
              // const SizedBox(width: 55),
              ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .3),
                child: CachedNetworkImage(
                  width: mq.height * .06,
                  height: mq.height * .06,
                  fit: BoxFit.fill,

                  imageUrl:
                      //  list.isNotEmpty ? list[0].image :
                      widget.user.image,
                  // placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // list.isNotEmpty ? list[0].name :
                    widget.user.name,
                    style: const TextStyle(
                        fontSize: 23,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Last Seen not avaliable',
                    //  list.isNotEmpty
                    //       ? list[0].isOnline
                    //           ? 'Online'
                    //           : MyDateUtil.getLastActiveTime(
                    //               context: context,
                    //               lastActive: list[0].lastActive)
                    //       : MyDateUtil.getLastActiveTime(
                    //           context: context,
                    //           lastActive: widget.user.lastActive),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget chatInput() {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      // FocusScope.of(context).unfocus();
                      // setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      size: 30,
                      color: Colors.purple,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onTap: () {
                        // if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                      },
                      controller: textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type Something...',
                          hintStyle: TextStyle(
                              fontSize: 20, color: Colors.purple.shade200)),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      //  final ImagePicker picker = ImagePicker();

                      // // Picking multiple images
                      // final List<XFile> images =
                      //     await picker.pickMultiImage(imageQuality: 70);

                      // // uploading & sending image one by one
                      // for (var i in images) {
                      //   log('Image Path: ${i.path}');
                      //   setState(() => _isUploading = true);
                      //   await APIs.sendChatImage(widget.user, File(i.path));
                      //   setState(() => _isUploading = false);
                      // }
                    },
                    icon: const Icon(
                      Icons.image,
                      size: 30,
                      color: Colors.purple,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // final ImagePicker picker = ImagePicker();

                      // // Pick an image
                      // final XFile? image = await picker.pickImage(
                      //     source: ImageSource.camera, imageQuality: 70);
                      // if (image != null) {
                      //   log('Image Path: ${image.path}');
                      //   setState(() => _isUploading = true);

                      //   await APIs.sendChatImage(
                      //       widget.user, File(image.path));
                      //   setState(() => _isUploading = false);
                      // }
                    },
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      size: 30,
                      color: Colors.purple,
                    ),
                  ),
                ]),
          ),
        ),
        MaterialButton(
          onPressed: () {
            if (textController.text.isNotEmpty) {
              //   if (_list.isEmpty) {
              //     //on first message (add user to my_user collection of chat user)
              Apis.sendMessage(widget.user, textController.text, Type.text);
              //   } else {
              //     //simply send message
              //     APIs.sendMessage(
              //         widget.user, _textController.text, Type.text);
              //   }
              textController.text = '';
            }
          },
          minWidth: 0,
          elevation: 10,
          padding:
              const EdgeInsets.only(top: 10.0, bottom: 10, right: 5, left: 10),
          color: Colors.purple,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.send,
            size: 30,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: true,
        onPopInvoked: (pop)async {
          if (showEmohi) {
            setState(() {
              showEmohi = !showEmohi;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: appbarr(),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: Apis.getAllMessages(widget.user),
                  // stream: Apis.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();

                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        // log('Data: ${jsonEncode(data![0].data())}');
                        // _list.clear();
                        // _list.add(Message(
                        //     formId: Apis.user.uid,
                        //     msg: 'hello',
                        //     read: 'hey',
                        //     told: 'abc',
                        //     type: Type.text,
                        //     send: '2:00 pm'));
                        // _list.add(Message(
                        //     formId: Apis.user.uid,
                        //     msg: 'hey',
                        //     read: '',
                        //     told: Apis.user.uid,
                        //     type: Type.text,
                        //     send: '3:00 pm'));

                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];
                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(top: mq.height * .01),
                            itemCount: _list.length,
                            itemBuilder: (context, index) {
                              return MessageCardScreen(message: _list[index]);
                            },
                          );
                        } else {
                          return const Center(
                              child: Text(
                            'Say Hey!👋',
                            style: TextStyle(fontSize: 30),
                          ));
                        }
                    }
                  },
                ),
              ),
              //progress indicator for showing uploading
              // if (_isUploading)
              //   const Align(
              //       alignment: Alignment.centerRight,
              //       child: Padding(
              //           padding:
              //               EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              //           child: CircularProgressIndicator(strokeWidth: 2))),

              chatInput(),
              // if (showEmohi)
              //   SizedBox(
              //     height: mq.height * .35,
              //     child:EmojiPicker(
              //       textEditingController: _textController,
              //       config: Config(
              //         bgColor: const Color.fromARGB(255, 234, 248, 255),
              //         columns: 8,
              //         emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
              //       ),
              //     ) ,
              //   )
              SizedBox(height: mq.height * .03)
            ],
          ),
        ),
      ),
    );
  }
}
