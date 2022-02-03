import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:flutter/material.dart';

final double profileImageSize = Sizescaleconfig.scalehightfactor(100);

double kVerticalSizeSmall = Sizescaleconfig.scalehightfactor(10);
double kVerticalSizeMedium = Sizescaleconfig.scalehightfactor(17);
double kVerticalSizeLarge = Sizescaleconfig.scalehightfactor(25);

double kImageSizeSmall = 24;
double kImageSizeMedium = 34;
double kImageSizeLarge = 50;

const double kVerticalSizeSmallConstant = 10;
const double kVerticalSizeMediumConstant = 17;
const double kVerticalSizeLargeConstant = 25;

final double kIconSizeSmall = Sizescaleconfig.scalehightfactor(18);
const double kIconSizeSmallConstant = 18;
const double kIconSizeMediumConstant = 35;
const double kIconSizeLargeConstant = 47;
const double kIconSizeExtraLargeConstant = 65;
double kIconSizeExtraLarge = Sizescaleconfig.scalehightfactor(65);

const double kPaddingSmallConstant = 10;
const double kPaddingMediumConstant = 20;
const double kPaddingLargeConstant = 30;
const double kListPaddingConstant = 16;

const double kBorderRadiusSmallConstant = 8;
const double kBorderRadiusMediumConstant = 20;
const double kBorderRadiusLargeConstant = 30;

const double kBorderSideWidthSmallConstant = 1;
const double kBorderSideWidthMediumConstant = 3;
const double kBorderSideWidthLargeConstant = 5;

const double kButtonPaddingSmall = 5;
const double kButtonPaddingMedium = 10;
const double kButtonPaddingLarge = 15;

const double kAppBarIconSize = 50;

const double kElevation = 1;

double kItemsSpacingSmall =
    Sizescaleconfig.scalehightfactor(kItemsSpacingSmallConstant);
double kItemsSpacingMedium =
    Sizescaleconfig.scalehightfactor(kItemsSpacingMediumConstant);
double kItemsSpacingLarge =
    Sizescaleconfig.scalehightfactor(kItemsSpacingLargeConstant);

const double kItemsSpacingSmallConstant = 10;
const double kItemsSpacingMediumConstant = 20;
const double kItemsSpacingLargeConstant = 30;

const double kButtonHeightSmall = 36;
const double kButtonHeightMedium = 45;
const double kButtonHeightLarge = 65;

const double kFontSizeExtraSmallConstant = 15;
const double kFontSizeSmallConstant = 18;
const double kFontSizeMediumConstant = 22;
const double kFontSizeLargeConstant = 28;

double kFontSizeExtraSmall =
    Sizescaleconfig.scaletextfactor(kFontSizeSmallConstant);
double kFontSizeSmall = Sizescaleconfig.scaletextfactor(kFontSizeSmallConstant);
double kFontSizeMedium =
    Sizescaleconfig.scaletextfactor(kFontSizeMediumConstant);
double kFontSizeLarge = Sizescaleconfig.scaletextfactor(kFontSizeLargeConstant);

final callToActionButtonStyle = ElevatedButton.styleFrom(
  maximumSize: Size(
    Sizescaleconfig.screenwidth! * 0.8,
    50,
  ),
  fixedSize: Size.fromHeight(50),
);
