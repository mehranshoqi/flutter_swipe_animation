//*  Style Helper
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class S {
  static BoxDecoration boxDecoration(BuildContext context) => BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: S.shadow(context),
      );
      
  static List<BoxShadow> shadow(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).shadowColor,
          spreadRadius: 7,
          blurRadius: 14,
          offset: const Offset(4, 9),
        ),
      ];

  static EdgeInsetsGeometry pAll(double p) => EdgeInsets.all(p);

  static EdgeInsetsGeometry pSymmetric([double h = 0, double v = 0]) =>
      EdgeInsets.symmetric(
        horizontal: h,
        vertical: v,
      );

  static BorderRadius rAll(double r) => BorderRadius.circular(r);

  static double w(Size s) => s.width;

  static double h(Size s) => s.height;

  static TextTheme t(BuildContext context) => Theme.of(context).textTheme;

  static double iconSize(Size s) => S.w(s) * .062;
}
