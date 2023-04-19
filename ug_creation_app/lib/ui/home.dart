// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ugbussinesscard/cardelements/cardaddress.dart';
import 'package:ugbussinesscard/cardelements/cardemail.dart';
import 'package:ugbussinesscard/cardelements/cardmobile.dart';
import 'package:ugbussinesscard/cardelements/cardtitle.dart';
import 'package:ugbussinesscard/cardelements/companylogo.dart';
import 'package:ugbussinesscard/cardshapes/card2shape.dart';
import 'package:ugbussinesscard/cardshapes/card3shape.dart';
import 'package:ugbussinesscard/cardshapes/card4shape.dart';
import 'package:ugbussinesscard/cardshapes/card5shape.dart';
import 'package:ugbussinesscard/main.dart';
import 'package:ugbussinesscard/models/carddetail.dart';
import 'package:ugbussinesscard/models/user.dart';
import 'package:ugbussinesscard/ui/defaultcard.dart';
import 'package:ugbussinesscard/utils/ad_helper.dart';
import 'package:ugbussinesscard/utils/constants.dart';
import 'package:ugbussinesscard/utils/filestorage.dart';
import 'package:ugbussinesscard/utils/helper.dart';
import 'package:advance_image_picker/advance_image_picker.dart';

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
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  User? user;
  bool isLoader = true;
  // List<dynamic> folders = List<dynamic>.empty(growable: true);
  // BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    // initDirectory();
    // initAd();
  }

  @override
  void dispose() {
    // if (_bannerAd != null) {
    //   _bannerAd?.dispose();
    // }
    super.dispose();
  }

  initAd() async {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // setState(() {
          //   _bannerAd = ad as BannerAd;
          // });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
  }

  cardDetail(BuildContext context, {bool isProfile = false}) {
    setState(() {
      user = getUserDetail();
      isLoader = true;
    });
    if (user != null) {
      emailController.text = user?.email ?? "";
      nameController.text = user?.name ?? "";
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
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Scaffold(
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
                        style: TextStyle(
                            fontSize: const Size.fromHeight(22).height))
                    .paddingLeft(const Size.fromWidth(10).width),
              ),
              resizeToAvoidBottomInset: true,
              body: SingleChildScrollView(
                  controller: ModalScrollController.of(context),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        formCustomTextField(nameController, TextInputType.name,
                            icon: Icons.person_outline_rounded,
                            hintText: "Enter your Name",
                            labelText: "Name"),
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
                                  await Navigator.of(context).push(
                                      PageRouteBuilder(pageBuilder:
                                          (context, animation, __) {
                                return ImagePicker(
                                    configs: configs, maxCount: 1);
                              }));
                              if ((objects?.length ?? 0) > 0) {
                                setState(() {
                                  imgObjs = objects!;
                                  user?.companyLogo = "";
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
                                    child: Image.file(
                                        File(user?.companyLogo ?? ""),
                                        height: 200,
                                        fit: BoxFit.cover))),
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
                                    user?.email =
                                        emailController.text.isEmptyOrNull
                                            ? "abc@xyz.com"
                                            : emailController.text;
                                    user?.name =
                                        nameController.text.isEmptyOrNull
                                            ? "Your name"
                                            : nameController.text;
                                    user?.phone = mobileNumberController
                                            .text.isEmptyOrNull
                                        ? "9999999999"
                                        : mobileNumberController.text;
                                    user?.address =
                                        addressController.text.isEmptyOrNull
                                            ? "Your address"
                                            : addressController.text;
                                  });

                                  FileStorage fs = FileStorage();
                                  if (imgObjs.isNotEmpty) {
                                    if (await fs.requestPermissions(
                                        Permission.storage)) {
                                      var cardDirectory =
                                          await fs.getDownloadDirectory();
                                      var directory =
                                          Directory("$cardDirectory/Cards");
                                      if (!(directory.existsSync() == true)) {
                                        directory.createSync();
                                      }
                                      var newPath =
                                          '${directory.path}/$appFolderName/companylogo/company_logo_default.png';
                                      var capImage =
                                          File(imgObjs[0].modifiedPath);
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
                                              setValue("companydetail",
                                                  user?.toJson());
                                              Loader().visible(false);
                                              setState(() {
                                                imgObjs = [];
                                              });
                                              if (!isProfile) {
                                                finish(context);
                                                const DefaultCard(
                                                  cardName: "New",
                                                ).launch(context).then((value) {
                                                  // initDirectory();
                                                });
                                              }
                                            });
                                          });
                                        },
                                      );
                                    }
                                  } else {
                                    var cardDirectory =
                                        await fs.getDownloadDirectory();
                                    var directory =
                                        Directory("$cardDirectory/Cards");
                                    if (!(directory.existsSync() == true)) {
                                      directory.createSync();
                                    }
                                    setState(() {
                                      user?.companyLogo =
                                          "${directory.path}/$appFolderName/companylogo/company_logo_default.png";
                                    });
                                    setValue("companydetail", user?.toJson());
                                    finish(context);
                                    if (!isProfile) {
                                      const DefaultCard(
                                        cardName: "New",
                                      ).launch(context).then((value) {
                                        // initDirectory();
                                      });
                                    } else {
                                      snackBar(context,
                                          title: 'Company detail saved');
                                    }
                                  }
                                },
                                text: isProfile
                                    ? "Save Company Detail"
                                    : "Generate Card",
                                textStyle: TextStyle(
                                    fontSize: const Size.fromHeight(20).height,
                                    color: white),
                                color: appMatColor,
                              )
                            : const CircularProgressIndicator()
                      ],
                    ).paddingOnly(
                        right: const Size.fromWidth(25).width,
                        left: const Size.fromWidth(25).width,
                        top: const Size.fromHeight(20).height,
                        bottom: const Size.fromHeight(25).height),
                  )));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: buildAppBar(context, "UG Visiting Card", actions: [
          IconButton(
              onPressed: () {
                cardDetail(context, isProfile: true);
              },
              icon: Icon(
                Icons.manage_accounts_rounded,
                size: const Size.fromHeight(29).height,
              ))
        ]),
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
                  15.height,
                  // _bannerAd != null
                  //     ? Align(
                  //         alignment: Alignment.topCenter,
                  //         child: Container(
                  //           margin: EdgeInsets.only(
                  //               bottom: const Size.fromHeight(15).height),
                  //           width: _bannerAd!.size.width.toDouble(),
                  //           height: _bannerAd!.size.height.toDouble(),
                  //           child: AdWidget(ad: _bannerAd!),
                  //         ),
                  //       )
                  //     : 0.height,
                   ],
              )),
        ));
  }
}
