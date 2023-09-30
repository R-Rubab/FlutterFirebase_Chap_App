// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_application_11/auth/login.dart';
import 'package:flutter_chat_application_11/apis/apis_const.dart';
import 'package:flutter_chat_application_11/util/utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../model/chat_model.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _img;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  onBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.purple.shade100,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22), topRight: Radius.circular(22))),
      builder: (context) {
        return ListView(
          shrinkWrap: true,

          // scrollDirection: Axis.horizontal,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 26.0, bottom: 10),
                child: Text(
                  'Select Profile Picture',
                  style: TextStyle(
                      // color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery, imageQuality: 80);
                    if (image != null) {
                      log('show path: ${image.path},...Mimetype show:  ${image.mimeType}');
                      setState(() {
                        _img = image.path;
                      });
                      Apis.uploadingProfilePicture(File(_img!));
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    elevation: 10,
                    minimumSize: Size(mq.height * .02, mq.height * .02),
                    backgroundColor: Colors.purple.shade100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      image: const AssetImage('assets/images/google.png'),
                      width: mq.height * .12,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 80);
                    if (image != null) {
                      log('show path: ${image.path},...Mimetype show:  ${image.mimeType}');
                      setState(() {
                        _img = image.path;
                      });
                      Apis.uploadingProfilePicture(File(_img!));

                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    elevation: 10,
                    minimumSize: Size(mq.width * .2, mq.height * .2),
                    backgroundColor: Colors.purple.shade100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      image: const AssetImage('assets/images/camera.png'),
                      width: mq.height * .08,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile Screen',
            // style: TextStyle(fontSize: 29),
          ),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 40),
                    child: Center(
                      child: Stack(
                        children: [
                          _img != null
                              ? CircleAvatar(
                                  radius: mq.height * .1,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(mq.height * .3),
                                    child: Image.file(
                                      File(_img!),
                                      width: mq.height * .2,
                                      height: mq.height * .2,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: mq.height * .1,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(mq.height * .3),
                                    child: InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HeroImages(
                                                  user: widget.user))),
                                      child: Hero(
                                        tag: 'images',
                                        child: CachedNetworkImage(
                                          width: mq.height * .2,
                                          height: mq.height * .2,
                                          fit: BoxFit.fill,

                                          imageUrl: widget.user.image,
                                          // placeholder: (context, url) => const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const CircleAvatar(
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          // Positioned(
                          //   bottom: 0,
                          //   right: 0,
                          //   child: CircleAvatar(
                          //     radius: mq.height * .03,
                          //     backgroundColor:
                          //         const Color.fromARGB(255, 244, 223, 248),
                          //     child: const Icon(
                          //       Icons.edit,
                          //       // size: ,
                          //     ),
                          //   ),
                          // ),

                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: MaterialButton(
                              minWidth: 0,
                              elevation: 4,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(10),
                              onPressed: () {
                                onBottomSheet();
                              },
                              color: const Color.fromARGB(255, 245, 214, 250),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.height * .03),
                    child: Text(
                      widget.user.email,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: mq.height * .03,
                          color: const Color.fromARGB(255, 208, 143, 220)),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      TextFieldItems(
                        onSave: (val) {
                          Apis.me.name = val ?? '';
                        },
                        validation: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required name',
                        controller: emailController,
                        icon: Icons.email,
                        hintText: 'Name',
                        labetText: 'Name',
                      ),
                      TextFieldItems(
                        controller: passwordController,
                        icon: Icons.password,
                        hintText: 'About',
                        labetText: 'About',
                        onSave: (val) => Apis.me.about = val ?? '',
                        validation: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required about',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Button(
                    icon: Icons.edit,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        Apis.upDateUserInfo().then((value) {
                          Utils().toastmsg('Profile Update Successfully!');
                        });
                      }
                    },
                    title: 'UPDATE',
                    width: mq.height * .26,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 200, top: 60),
                  //   child: Button(
                  //     color: const Color.fromARGB(255, 245, 158, 151),
                  //     icon: Icons.logout,
                  //     onTap: () {},
                  //     title: 'Logout',
                  //     width: mq.height * .20,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding:
              EdgeInsets.only(bottom: mq.height * .008, right: mq.width * .02),
          child: FloatingActionButton.extended(
            backgroundColor: const Color.fromARGB(255, 245, 158, 151),
            icon: const Icon(Icons.logout, color: Colors.black),
            label: const Text(
              'Logout',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              Utils().showProgressBar(context);
              // await Apis.updateActiveStatus(false);
              await Apis.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Apis.auth = FirebaseAuth.instance;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                });
              });
            },
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final double width;
  final Color color;

  const Button({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.width,
    this.color = Colors.purple,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 10,
          shape: const StadiumBorder(),
          minimumSize: Size(width, mq.height * .07)),
      icon: Icon(icon),
      label: Text(
        title,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }
}

class TextFieldItems extends StatelessWidget {
  final String hintText;
  final String labetText;
  final TextEditingController controller;
  final IconData icon;
  final void Function(String?)? onSave;
  final String? Function(String?)? validation;

  const TextFieldItems({
    super.key,
    required this.hintText,
    required this.controller,
    required this.icon,
    required this.labetText,
    required this.onSave,
    required this.validation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
      child: TextFormField(
        onSaved: onSave,
        validator: validation,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labetText,
          suffixIcon: Icon(
            icon,
            color: Colors.purple,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(21)),
            // borderSide:
            //     BorderSide(color: Color.fromARGB(255, 24, 12, 26), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(21)),
            borderSide:
                BorderSide(color: Color.fromARGB(255, 116, 11, 134), width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(21)),
            borderSide:
                BorderSide(color: Color.fromARGB(255, 240, 120, 234), width: 2),
          ),
        ),
      ),
    );
  }
}

class HeroImages extends StatefulWidget {
  final ChatUser user;
  const HeroImages({super.key, required this.user});

  @override
  State<HeroImages> createState() => _HeroImagesState();
}

class _HeroImagesState extends State<HeroImages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Hero(
        tag: 'images',
        child: CachedNetworkImage(
          width: mq.height * .1,
          height: mq.height * .1,
          fit: BoxFit.contain,
          imageUrl: widget.user.image,
        ),
      ),
    );
  }
}
