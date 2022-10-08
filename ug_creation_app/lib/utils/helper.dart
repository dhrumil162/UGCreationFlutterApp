import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:ugbussinesscard/main.dart';
import 'package:ugbussinesscard/models/carddetail.dart';
import 'package:ugbussinesscard/models/user.dart';
import 'package:ugbussinesscard/utils/constants.dart';
import 'package:ugbussinesscard/utils/dark_theme_provider.dart';
import 'package:ugbussinesscard/utils/textformfield.dart';

ImagePickerConfigs? getImagePickerConfigs() {
  var configs = ImagePickerConfigs();
  configs.appBarBackgroundColor = Colors.transparent;
  configs.appBarDoneButtonColor = Colors.transparent;
  configs.cropFeatureEnabled = true;
  configs.stickerFeatureEnabled = true; // ON/OFF features
  configs.translateFunc = (name, value) => Intl.message(value, name: name);
  return configs;
}

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
        color: HexColor(appGreyColor),
        fontSize: const Size.fromHeight(15).height),
    obscureText: isPassword,
    minLines: minLines,
    decoration: InputDecoration(
      prefixIcon: Icon(icon,
          color: HexColor(appGreyColor),
          size: const Size.fromHeight(23).height),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      labelStyle: TextStyle(
          color: HexColor(appGreyColor),
          fontSize: const Size.fromHeight(16).height),
      hintText: hintText,
      hintStyle: TextStyle(
          color: HexColor(appGreyColor),
          fontSize: const Size.fromHeight(15).height),
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

CardDetail getCardDetail(cardName) {
  return CardDetail.fromJson(getJSONAsync(cardName));
}

Color getFontColor(){
  return themeChangeProvider.darkTheme ? white : black;
}