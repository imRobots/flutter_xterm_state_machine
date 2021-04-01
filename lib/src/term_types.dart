import 'package:flutter/material.dart';

enum ColorTag {
  Default,
  Black,
  Red,
  Green,
  Yellow,
  Blue,
  Magenta,
  Cyan,
  White,
  BrightBlack,
  BrightRed,
  BrightGreen,
  BrightYellow,
  BrightBlue,
  BrightMagenta,
  BrightCyan,
  BrightWhite
}

enum ColorType { TagColor, RGBColor, IndexColor }

enum XTermMode {
  KAM,
  IRM,
  SRM,
  LNM,
  DECCKM,
  DECANM,
  DECCOLM,
  DECSCLM,
  DECSCNM,
  DECOM,
  DECAWM,
  DECARM,
  DECNKM,
  DECBKM,
  DECLRMM,
  DECNCSM
}

class XTermModes {
  bool mKAM = true;
  bool mIRM = false;
  bool mSRM = false;
  bool mLNM = false;

  bool mDECCKM = false;
  bool mDECANM = false;
  bool mDECCOLM = false;
  bool mDECSCLM = false;
  bool mDECSCNM = false;
  bool mDECOM = false;
  bool mDECAWM = false;
  bool mDECARM = false;
  bool mDECNKM = false;
  bool mDECBKM = false;
  bool mDECLRMM = false;
  bool mDECNCSM = false;
}

class XTermFontStyle {
  bool bold = false;
  bool faint = false;
  bool italicized = false;
  bool underlined = false;
  bool blink = false;
  bool inverse = false;
  bool invisible = false;
  bool crossout = false;
  bool doubleunderlined = false;

  ColorType colorType = ColorType.TagColor;
  ColorTag foreColorTag = ColorTag.Default;
  ColorTag backColorTag = ColorTag.Default;
  int foreColorIndex = 0, backColorIndex = 0;
  int forecColorR = 0, foreColorG = 0, foreColorB = 0;
  int backColorR = 0, backColorG = 0, backColorB = 0;

  void reset() {
    bold = false;
    faint = false;
    italicized = false;
    underlined = false;
    blink = false;
    inverse = false;
    invisible = false;
    crossout = false;
    doubleunderlined = false;
  }

  void setForeColorByTag(ColorTag tag) {
    colorType = ColorType.TagColor;
    foreColorTag = tag;
  }

  void setForeColorByIndex(int index) {
    colorType = ColorType.IndexColor;
    foreColorIndex = index;
  }

  void setForeColorByRGB(int r, int g, int b) {
    colorType = ColorType.RGBColor;
    forecColorR = r;
    foreColorG = g;
    foreColorB = b;
  }

  void setBackColorByTag(ColorTag tag) {
    colorType = ColorType.TagColor;
    backColorTag = tag;
  }

  void setBackColorByIndex(int index) {
    colorType = ColorType.IndexColor;
    backColorIndex = index;
  }

  void setBackColorByRGB(int r, int g, int b) {
    colorType = ColorType.RGBColor;
    backColorR = r;
    backColorG = g;
    backColorB = b;
  }
}
