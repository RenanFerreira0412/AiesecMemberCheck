import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget tabletLayout;
  final Widget desktopLayout;

  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    required this.tabletLayout,
    required this.desktopLayout,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      return mobileLayout; // Layout para dispositivos móveis
    } else if (screenWidth < 1200) {
      return tabletLayout; // Layout para tablets
    } else {
      return desktopLayout; // Layout para desktop
    }
  }
}
