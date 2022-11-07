// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:ugbussinesscard/main.dart';
import 'package:ugbussinesscard/models/carddetail.dart';
import 'package:ugbussinesscard/models/user.dart';
import 'package:ugbussinesscard/utils/constants.dart';
import 'package:ugbussinesscard/utils/dark_theme_provider.dart';
import 'package:ugbussinesscard/utils/filestorage.dart';
import 'package:ugbussinesscard/utils/imgutils.dart';
import 'package:ugbussinesscard/utils/textformfield.dart';
import 'package:firebase_storage/firebase_storage.dart';

double getDCardHeight() => const Size.fromHeight(270).height;

getCardWidth(BuildContext context) => context.width();

double? getCalculatedUnit(double? unit, double? cardWidth, double? conWidth) {
  return (unit! * conWidth!) / cardWidth!;
}

TextStyle? getFontStyle(TextStyle? style, CardDetail? cardDetail,
    double? conWidth, double? conHeight) {
  return style?.copyWith(
      height:
          getCalculatedUnit(style.height, cardDetail?.deviceHeight, conHeight)!,
      letterSpacing: getCalculatedUnit(
          style.letterSpacing, cardDetail?.deviceWidth, conWidth)!,
      fontSize: getCalculatedUnit(
          style.fontSize, cardDetail?.deviceHeight, conHeight));
}

ImagePickerConfigs? getImagePickerConfigs() {
  var configs = ImagePickerConfigs();
  configs.appBarBackgroundColor = Colors.transparent;
  configs.appBarDoneButtonColor = Colors.transparent;
  configs.cropFeatureEnabled = true;
  configs.stickerFeatureEnabled = true; // ON/OFF features
  configs.translateFunc = (name, value) => Intl.message(value, name: name);
  return configs;
}

final defaultCards = FirebaseStorage.instance.ref("defaultCards");
final defaultCardRef = FirebaseDatabase.instance.ref("defaultCards");
final box = Hive.box("cards");

Widget formCustomTextField(
    TextEditingController controller, TextInputType textFieldType,
    {IconData? icon,
    BuildContext? context,
    String labelText = "",
    String hintText = "",
    bool isPassword = false,
    int? minLines = 1}) {
  return CustomTextField(
    keyboardType: textFieldType,
    textStyle: TextStyle(
        color: getFontColor(), fontSize: const Size.fromHeight(15).height),
    obscureText: isPassword,
    minLines: minLines,
    decoration: InputDecoration(
      prefixIcon: Icon(icon,
          color: getFontColor(), size: const Size.fromHeight(23).height),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      labelStyle: TextStyle(
          color: getFontColor(), fontSize: const Size.fromHeight(16).height),
      hintText: hintText,
      hintStyle: TextStyle(
          color: getFontColor(), fontSize: const Size.fromHeight(15).height),
      contentPadding: EdgeInsets.symmetric(
          horizontal: const Size.fromWidth(20).width,
          vertical: const Size.fromHeight(12).height),
    ),
    textEditingController: controller,
  );
}

AppBar buildAppBar(BuildContext context, String title,
    {List<Widget>? actions}) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  if (actions?.isEmpty == true || actions == null) {
    actions = List<Widget>.empty(growable: true);
  }
  actions.add(
    Switch(
      value: themeChange.darkTheme,
      onChanged: (value) {
        themeChange.darkTheme = value;
      },
    ),
  );
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
          color: whiteColor, fontSize: const Size.fromHeight(20).height),
    ),
    actions: actions,
  );
}

User getUserDetail() {
  return User.fromJson(getJSONAsync("companydetail"));
}

CardDetail? getCardDetail(cardName) {
  return CardDetail.fromJson(box.get(cardName));
}

saveCardDetail(String cardName, CardDetail? cardDetail) {
  box.put(cardName, cardDetail?.toJson());
}

List<dynamic> getCardKeys() {
  return box.keys.toList();
}

Color getFontColor() {
  return themeChangeProvider.darkTheme ? white : black;
}

downloadCard(BuildContext context, String cardName, CardDetail? cardDetail,
    GlobalKey? key1, GlobalKey? key2, BoxConstraints? constraints) async {
  FileStorage fs = FileStorage();
  if (await fs.requestPermissions(Permission.storage)) {
    var directory = await fs.getDownloadDirectory();
    var cardDirectory =
        Directory("${directory?.path}/$appFolderName/Cards/$cardName");
    if (!cardDirectory.existsSync()) {
      cardDirectory.createSync(recursive: true);
    }
    var newPath = '${cardDirectory.path}/back-card.png';
    var newFile = File(newPath);
    if (!newFile.existsSync()) {
      newFile.createSync(recursive: true);
    } else {
      newFile.deleteSync(recursive: true);
      newFile.createSync(recursive: true);
    }
    final bytes1 = await Utils.capture(key1);
    newFile.writeAsBytesSync(bytes1);

    var newPath1 = '${cardDirectory.path}/front-card.png';
    var newFile1 = File(newPath1);
    if (!newFile1.existsSync()) {
      newFile1.createSync(recursive: true);
    } else {
      newFile1.deleteSync(recursive: true);
      newFile1.createSync(recursive: true);
    }
    final bytes2 = await Utils.capture(key2);
    newFile1.writeAsBytesSync(bytes2);
    cardDetail?.deviceHeight = constraints?.constrainHeight();
    cardDetail?.deviceWidth = constraints?.constrainWidth();
    box.put(cardName, cardDetail?.toJson());
    snackBar(context, title: 'Card is downloaded to ${cardDirectory.path}');
    // defaultCards.child(cardName).child("front-card.png").putFile(newFile1);
    // defaultCards.child(cardName).child("back-card.png").putFile(newFile);
    defaultCardRef.child(cardName).set(cardDetail?.toJson());
  }
}

syncCards(Function callBack) async {
  var permission = Permission.storage.request();
  bool result = await InternetConnectionChecker().hasConnection;

  if (result) {
    permission.then((value) async {
      if (value.isDenied || value.isPermanentlyDenied || value.isRestricted) {
        toast("You need to provide permission for download cards",
            gravity: ToastGravity.CENTER);
      } else {
        final cards = await defaultCardRef.once();
        final parsed = cards.snapshot.value as Map<dynamic, dynamic>;
        FileStorage fs = FileStorage();
        var directory = await fs.getDownloadDirectory();
        parsed.forEach((key, value) async {
          var cardDetail = CardDetail.fromJson(value);
          cardDetail.user?.companyLogo =
              "${directory?.path}/$appFolderName/companylogo/company_logo_default.png";
          if (box.get(key) == null) {
            box.put(key, cardDetail.toJson());
          }
        });

        var defaultImageDirectory =
            Directory("${directory?.path}/$appFolderName/companylogo");
        if (!defaultImageDirectory.existsSync()) {
          defaultImageDirectory.createSync(recursive: true);
        }
        var defaultImagePath =
            '${defaultImageDirectory.path}/company_logo_default.png';
        var defaultImage = File(defaultImagePath);
        try {
          if (!defaultImage.existsSync()) {
            final defaultImageRef =
                FirebaseStorage.instance.ref("company_logo_default.png");
            await defaultImageRef.writeToFile(defaultImage);
          }
          // ignore: empty_catches
        } catch (e) {}
        // parsed.forEach((key, value) async {
        //   var cardDirectory =
        //       Directory("${directory?.path}/$appFolderName/Cards/$key");
        //   if (!cardDirectory.existsSync()) {
        //     cardDirectory.createSync(recursive: true);
        //     var cardImages = await defaultCards.child(key).listAll();
        //     cardImages.items.forEach((element) async {
        //       var imagePath = '${cardDirectory.path}/${element.name}';
        //       var newFile = File(imagePath);
        //       try {
        //         if (!newFile.existsSync()) {
        //           final Reference ref = FirebaseStorage.instance
        //               .refFromURL(await element.getDownloadURL());
        //           newFile.createSync(recursive: true);
        //           await ref.writeToFile(newFile);
        //         }
        //         // ignore: empty_catches
        //       } catch (e) {}
        //     });
        //   }
        // });
        callBack();
      }
    });
  }
}
