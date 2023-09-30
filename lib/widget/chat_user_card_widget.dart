import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_application_11/model/message_model.dart';

import '../Screens/chat_screen.dart';
import '../apis/apis_const.dart';
import '../model/chat_model.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({
    super.key,
    required this.user,
  });

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;
  List list = [];
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      color: Colors.purple.shade100,
      shadowColor: Colors.purple,
      margin: EdgeInsets.symmetric(
          horizontal: mq.height * .02, vertical: mq.height * .008),
      child: InkWell(
        splashColor: const Color.fromARGB(255, 132, 19, 152),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreenn(user: widget.user)));
        },
        child: StreamBuilder(
          stream: Apis.getLastMessages(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (data!.isNotEmpty) {
              _message = list[0];
            }
            return ListTile(
              title: Text(
                widget.user.name,
                style: TextStyle(
                    fontSize: mq.height * .03, fontWeight: FontWeight.bold),
              ),
              subtitle:
                  Text(_message != null ? _message!.msg : widget.user.about),
              trailing: _message == null
                  ? null
                  : _message!.read.isEmpty && _message!.formId != Apis.user.uid
                      ? CircleAvatar(
                          radius: mq.height * .01,
                        )
                      : Text(_message!.send),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .3),
                child: CachedNetworkImage(
                  width: mq.height * .060,
                  height: mq.height * .060,
                  fit: BoxFit.fitHeight,

                  imageUrl: widget.user.image,
                  // placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
              ),
              // leading: const CircleAvatar(
              //   child: Icon(Icons.person),
              // ),
            );
          },
        ),
      ),
    );
  }
}
