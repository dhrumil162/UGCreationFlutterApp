// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ugbussinesscard/main.dart';
import 'package:ugbussinesscard/models/businesscards.dart';
import 'package:ugbussinesscard/models/user.dart';
import 'package:ugbussinesscard/ui/businesscard.dart';
import 'package:ugbussinesscard/utils/constants.dart';
import 'package:ugbussinesscard/utils/filestorage.dart';
import 'package:ugbussinesscard/utils/helper.dart';
import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatelessWidget {
  final String? title;
  const HomePage({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  User? user;
  bool isLoader = true;
  List<BusinessCards> folders = List<BusinessCards>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    initDirectory();
  }

  initDirectory() async {
    //removeKey("Card1");
    imageCache.clear();
    imageCache.clearLiveImages();
    setState(() {
      folders = [];
    });
    FileStorage fs = FileStorage();
    if (await fs.requestPermissions(Permission.storage)) {
      var directory = await fs.getDownloadDirectory();
      var cardDirectory = Directory("${directory?.path ?? ""}/Cards");
      if (!cardDirectory.existsSync()) {
        cardDirectory.createSync(recursive: true);
      }
      cardDirectory.listSync().forEach((filesytem) {
        setState(() {
          BusinessCards card =
              BusinessCards(basename(filesytem.path), filesytem.path);
          var files = Directory(filesytem.path).listSync();
          if (files.isNotEmpty) {
            for (var element in files) {
              card.cards
                  .add(BusinessCards(basename(element.path), element.path));
            }
          }
          folders.add(card);
        });
      });
    }
  }

  cardDetail(BuildContext context) {
    setState(() {
      user = getUserDetail();
      isLoader = true;
    });
    if (user != null) {
      emailController.text = user?.email ?? "";
      firstNameController.text = user?.firstname ?? "";
      lastNameController.text = user?.lastname ?? "";
      mobileNumberController.text = user?.phone ?? "";
      addressController.text = user?.address ?? "";
    }
    List<ImageObject> imgObjs = [];
    var configs = getImagePickerConfigs();
    showBarModalBottomSheet(
      expand: false,
      bounce: false,
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) => Scaffold(
          appBar: AppBar(
            toolbarHeight: const Size.fromHeight(65).height,
            backgroundColor: themeChangeProvider.darkTheme
                ? Colors.transparent
                : appMatColor,
            automaticallyImplyLeading: false,
            actions: [
              InkWell(
                child: const Icon(Icons.close),
                onTap: () {
                  finish(context);
                },
              ).paddingRight(const Size.fromWidth(15).width)
            ],
            title: Text("Card Details",
                    style:
                        TextStyle(fontSize: const Size.fromHeight(22).height))
                .paddingLeft(const Size.fromWidth(10).width),
          ),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    formCustomTextField(firstNameController, TextInputType.name,
                        icon: Icons.person_outline_rounded,
                        hintText: "Enter your First Name",
                        labelText: "First Name"),
                    20.height,
                    formCustomTextField(lastNameController, TextInputType.name,
                        icon: Icons.person_outline_rounded,
                        hintText: "Enter your Last Name",
                        labelText: "Last Name"),
                    20.height,
                    formCustomTextField(
                        emailController, TextInputType.emailAddress,
                        icon: Icons.email_outlined,
                        hintText: "Enter your Email ID",
                        labelText: "Email ID"),
                    20.height,
                    formCustomTextField(
                        mobileNumberController, TextInputType.phone,
                        icon: Icons.phonelink_lock_outlined,
                        hintText: "Enter your Mobile",
                        labelText: "Mobile"),
                    20.height,
                    formCustomTextField(
                        addressController, TextInputType.multiline,
                        icon: Icons.maps_home_work_outlined,
                        hintText: "Enter your Address",
                        minLines: 3,
                        labelText: "Address"),
                    15.height,
                    IconButton(
                        onPressed: () async {
                          final List<ImageObject>? objects =
                              await Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (context, animation, __) {
                            return ImagePicker(configs: configs, maxCount: 1);
                          }));
                          if ((objects?.length ?? 0) > 0) {
                            setState(() {
                              imgObjs = objects!;
                            });
                          }
                        },
                        icon: const Icon(Icons.image_outlined)),
                    15.height,
                    imgObjs.isNotEmpty
                        ? SizedBox(
                            width: context.width(),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Image.file(
                                        File(imgObjs[0].modifiedPath),
                                        height: 200,
                                        fit: BoxFit.cover))
                              ],
                            ),
                          )
                        : (user?.companyLogo.isEmptyOrNull ?? false
                            ? 0.height
                            : Padding(
                                padding: const EdgeInsets.all(2),
                                child: Image.file(File(user?.companyLogo ?? ""),
                                    height: 200, fit: BoxFit.cover))),
                    20.height,
                    isLoader
                        ? AppButton(
                            elevation: 5,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            width: context.width(),
                            onTap: () async {
                              setState(() {
                                isLoader = false;
                              });
                              setState(() {
                                user?.email = emailController.text;
                                user?.firstname = firstNameController.text;
                                user?.lastname = lastNameController.text;
                                user?.phone = mobileNumberController.text;
                                user?.address = addressController.text;
                              });

                              if (imgObjs.isNotEmpty) {
                                FileStorage fs = FileStorage();
                                if (await fs
                                    .requestPermissions(Permission.storage)) {
                                  var directory =
                                      await fs.getDownloadDirectory();
                                  if (!(directory?.existsSync() ?? false)) {
                                    directory?.createSync();
                                  }
                                  var newPath =
                                      '${directory?.path ?? ""}/${const Uuid().v1().toString().substring(0, 7)}.png';
                                  var capImage = File(imgObjs[0].modifiedPath);
                                  capImage.readAsBytes().then(
                                    (bytes) {
                                      File(newPath)
                                          .create(recursive: true)
                                          .then((newFile) {
                                        newFile
                                            .writeAsBytes(bytes)
                                            .then((value) {
                                          capImage.deleteSync();
                                          user?.companyLogo = newPath;
                                          setValue(
                                              "companydetail", user?.toJson());
                                          Loader().visible(false);
                                          finish(context);
                                          BusinessCard(
                                            user: user,
                                          ).launch(context).then((value) {
                                            initDirectory();
                                          });
                                        });
                                      });
                                    },
                                  );
                                }
                              } else {
                                setValue("companydetail", user?.toJson());
                                finish(context);
                                BusinessCard(
                                  user: user,
                                ).launch(context).then((value) {
                                  initDirectory();
                                });
                              }
                            },
                            text: "Generate Card",
                            textStyle: TextStyle(
                                fontSize: const Size.fromHeight(20).height,
                                color: white),
                            color: HexColor(appColor),
                          )
                        : const CircularProgressIndicator()
                  ],
                ).paddingOnly(
                    right: const Size.fromWidth(25).width,
                    left: const Size.fromWidth(25).width,
                    top: const Size.fromHeight(20).height,
                    bottom: const Size.fromHeight(25).height),
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: buildAppBar(context, "UG Business Card"),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: const Size.fromHeight(25).height),
              width: context.width(),
              child: Column(
                children: [
                  AppButton(
                    elevation: 5,
                    width: context.width(),
                    onTap: () {
                      cardDetail(context);
                    },
                    text: "Create Card",
                    textStyle: TextStyle(
                        fontSize: const Size.fromHeight(20).height,
                        color: white),
                    color: appMatColor,
                  ).paddingSymmetric(
                      horizontal: const Size.fromWidth(25).width),
                  folders.isNotEmpty
                      ? Column(
                          children: folders.map((folder) {
                            return Container(
                                padding: EdgeInsets.only(
                                  bottom: const Size.fromHeight(2).height,
                                ),
                                width: context.width(),
                                child: InkWell(
                                    onTap: () {
                                      // cardDetail(context);
                                      setState(() {
                                        user = getUserDetail();
                                      });
                                      finish(context);
                                      BusinessCard(
                                        user: user,
                                      ).launch(context).then((value) {
                                        initDirectory();
                                      });
                                    },
                                    child: Card(
                                        elevation: 5,
                                        child: Wrap(
                                          direction: Axis.vertical,
                                          children: [
                                            folder.cards.isNotEmpty
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children:
                                                        folder.cards.map((e) {
                                                      return Image.file(
                                                        File(e.filePath),
                                                        width: context.width() /
                                                            2.035,
                                                        fit: BoxFit.contain,
                                                      );
                                                    }).toList())
                                                : 0.height,
                                            Text(
                                              folder.cardName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      const Size.fromHeight(16)
                                                          .height),
                                            )
                                                .paddingOnly(
                                                  top: const Size.fromHeight(10)
                                                      .height,
                                                  bottom:
                                                      const Size.fromHeight(10)
                                                          .height,
                                                  left: const Size.fromWidth(15)
                                                      .width,
                                                  right:
                                                      const Size.fromWidth(15)
                                                          .width,
                                                )
                                                .center(),
                                          ],
                                        ))));
                          }).toList(),
                        ).paddingSymmetric(
                          vertical: const Size.fromHeight(15).height,
                        )
                      : 0.height
                ],
              )),
        ));
  }
}
