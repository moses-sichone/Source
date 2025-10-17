import 'package:flutter/material.dart';


/// Main Color
Color green77() => const Color(0xff43D477);
Color green91() => const Color(0xff9EFFC1);
Color blue64() => const Color(0xff1F3B64);

Color backgroundWhite() => const Color(0xfff5f7fb);
Color purpleLight() => const Color(0xffebebf8);
Color appBarBg() => const Color(0xffEBEBF8);
// Color purplePrimary() => const Color(0xff1267AE);
Color purplePrimary() => const Color(0xff1d4f9f);
<<<<<<< HEAD
Color bluePrimary() => const Color(0xff1267AE);
=======
>>>>>>> 300ef8f371d1837e2fcf1dac69a3aa58a3086832
Color greyE5() => const Color(0xffE5E5E5);
Color greyText() => const Color(0xff808080);
Color lightGrey() => const Color(0xffD9D9D9);
Color iconBg() => const Color(0xffEBEBF8);
Color headerTextColor() => const Color(0xff333333);
Color blueGrey() => const Color(0xffDAD9FB);
Color red() => const Color(0xffFF4948);
Color green() => const Color(0xff43D477);

Color supportedColor() => const Color(0xffC1BFF8);
Color downloadableColor() => const Color(0xffFFB167);

Color businessColor() => const Color(0xffC1BFF8);

LinearGradient greenGradint() => LinearGradient(
  colors: [
    purplePrimary(),
    green91()
  ],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter
);

// use in drawer background color
Color green63 = const Color(0xff00BA63);

// grey Shade
Color grey33 = const Color(0xff2F3133);
Color grey3A = const Color(0xff1D2D3A);
Color grey5E = const Color(0xff5E5E5E);
Color greyD0 = const Color(0xffABB7D0);
Color greyB2 = const Color(0xffA9AEB2);
Color greyA5 = const Color(0xffA5A5A5);
Color greyCF = const Color(0xffCFCFCF);
Color greyE7 = const Color(0xffE7E7E7);
<<<<<<< HEAD
Color greyF0 = const Color(0xffF0F0F0);
Color greyF8 = const Color(0xffF8F8F8);
Color greyFA = const Color(0xffFAFAFA);
Color greyCC = const Color(0xffCCCCCC);
=======
Color greyF8 = const Color(0xffF8F8F8);
Color greyFA = const Color(0xffFAFAFA);
>>>>>>> 300ef8f371d1837e2fcf1dac69a3aa58a3086832
LinearGradient greyGradint = LinearGradient(
  colors: [
    Colors.black.withOpacity(.8),
    Colors.black.withOpacity(0),
  ],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter
);



// Semantics
Color red49 = const Color(0xffFF4949);
Color yellow29 = const Color(0xffFFC529);
Color orange50 = const Color(0xffFE7950);



// Semantics
Color green50 = const Color(0xff8FBF50);
Color green4B = const Color(0xff218F48);
Color green9D = const Color(0xff50BF9D);
Color green7C = const Color(0xff32BA7C);

Color cyan50 = const Color(0xff50BF9D);
Color blueFE = const Color(0xff5090FE);
Color blueA4 = const Color(0xff2849A4);
Color yellow4C = const Color(0xffFFCD4C);




// Shadow
BoxShadow boxShadow(Color color,{int blur=20,int y=8,int x=0}){
  return BoxShadow(
    color: color,
    blurRadius: blur.toDouble(),
    offset: Offset(x.toDouble(), y.toDouble())
  );
}