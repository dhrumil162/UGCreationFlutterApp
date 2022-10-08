import 'dart:ui';

import 'package:ugbussinesscard/models/item_style.dart';

class CardDetail {
  int? backcardcolor;
  int? frontcardcolor;
  Size? frontImageSize;
  Size? backImageSize;
  ItemStyle? frontImagePosition;
  ItemStyle? frontTitleStyle;
  ItemStyle? backImagePosition;
  ItemStyle? backTitleStyle;
  ItemStyle? backAddressStyle;
  ItemStyle? backEmailStyle;
  ItemStyle? backMobileStyle;

  CardDetail(this.backcardcolor, this.frontcardcolor);

  //constructor that convert json to object instance
  CardDetail.fromJson(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      frontcardcolor = json['frontcardcolor'];
      backcardcolor = json['backcardcolor'];
      if (json['frontImageSize'] != null) {
        frontImageSize = Size(json['frontImageSize']['width'].toDouble(),
            json['frontImageSize']['height'].toDouble());
      }
      if (json['backImageSize'] != null) {
        backImageSize = Size(json['backImageSize']['width'].toDouble(),
            json['backImageSize']['height'].toDouble());
      }
      frontImagePosition = ItemStyle.fromJson(json['frontImagePosition']);
      frontTitleStyle = ItemStyle.fromJson(json['frontTitleStyle']);
      backImagePosition = ItemStyle.fromJson(json['backImagePosition']);
      backTitleStyle = ItemStyle.fromJson(json['backTitleStyle']);
      backAddressStyle = ItemStyle.fromJson(json['backAddressStyle']);
      backEmailStyle = ItemStyle.fromJson(json['backEmailStyle']);
      backMobileStyle = ItemStyle.fromJson(json['backMobileStyle']);
    }
  }

  //a method that convert object to json
  Map<String, dynamic> toJson() => {
        'frontcardcolor': frontcardcolor,
        'backcardcolor': backcardcolor,
        'frontImageSize': {
          "height": frontImageSize?.height,
          "width": frontImageSize?.width
        },
        'backImageSize': {
          "height": backImageSize?.height,
          "width": backImageSize?.width
        },
        'frontImagePosition': frontImagePosition?.toJson(),
        'frontTitleStyle': frontTitleStyle?.toJson(),
        'backImagePosition': backImagePosition?.toJson(),
        'backTitleStyle': backTitleStyle?.toJson(),
        'backAddressStyle': backAddressStyle?.toJson(),
        'backEmailStyle': backEmailStyle?.toJson(),
        'backMobileStyle': backMobileStyle?.toJson()
      };
}
