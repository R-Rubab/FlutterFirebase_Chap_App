import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_application_11/apis/apis_const.dart';
import 'package:flutter_chat_application_11/model/message_model.dart';

import '../helper/date_time.dart';

class MessageCardScreen extends StatefulWidget {
  final Message message;

  const MessageCardScreen({super.key, required this.message});

  @override
  State<MessageCardScreen> createState() => _MessageCardScreenState();
}

class _MessageCardScreenState extends State<MessageCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Apis.user.uid == widget.message.formId
        ? _blueMessage()
        : _greenMessage();

    // ? _greenMessage()
    // : _blueMessage();
  }

  // Widget _blueMessage() {
  //   return Container(
  //     // height: 200,
  //     // width: 100,
  //     padding: EdgeInsets.all(mq.height * .12),
  //     decoration: const BoxDecoration(color: Colors.purple),
  //     child: Text(
  //       widget.message.formId,
  //       style: TextStyle(fontSize: mq.height * .3),
  //     ),
  //   );
  // }

  // Widget _greenMessage() {
  //   return Row(
  //     children: [
  //       Row(
  //         children: const [],
  //       ),
  //       Flexible(
  //         child: Container(
  //           child: Text(widget.message.msg),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      Apis.updateMessageReadStatus(widget.message);
      log('update message read status');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .03
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: widget.message.type == Type.text
                ?
                //show text
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),

        //message time
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            // widget.message.msg,
            MyDateUtil.getDateTime(context: context, time: widget.message.send),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: mq.width * .04),

            if (widget.message.read.isNotEmpty)
              const Icon(Icons.done_all_rounded,
                  color: Colors.purple, size: 20),

            const SizedBox(width: 2),

            //sent time
            Text(
              // widget.message.msg,
              MyDateUtil.getDateTime(
                  context: context, time: widget.message.send),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),

        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .03
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 252, 176, 255),
                border: Border.all(color: Colors.purple),
                //making borders curved
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: widget.message.type == Type.text
                ?
                //show text
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 17, color: Colors.black87),
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
