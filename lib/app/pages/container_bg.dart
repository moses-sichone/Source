import 'package:glass_kit/glass_kit.dart';
import 'package:flutter/material.dart';
import '../../common/common.dart';
import '../../config/colors.dart';

glassContainerGB({required child})=> GlassContainer.frostedGlass(
  color: appBarBg(),
  blur: 6,
  child: Stack(
    children: [
      SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset('assets/image/png/bg_image1.png', width: getSize().width * .50, fit: BoxFit.cover,),
            ),
            Positioned(
              top: getSize().height * 0.25,
              right: 0,
              child: Image.asset('assets/image/png/bg_image2.png', width: getSize().width * .50, fit: BoxFit.cover,),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset('assets/image/png/bg_image4.png', width: getSize().width * .50 , fit: BoxFit.cover,),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset('assets/image/png/bg_image3.png', width: getSize().width * .50 , fit: BoxFit.cover,),
            ),
          ],
        ),
      ),
      child,
    ],
  ),
);