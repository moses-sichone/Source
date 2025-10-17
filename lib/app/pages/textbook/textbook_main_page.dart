import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
import 'package:webinar/app/pages/textbook/text_home_page/textbook_home_page.dart';
=======
import 'package:webinar/app/pages/textbook/text_home_page/home_page.dart';
>>>>>>> 300ef8f371d1837e2fcf1dac69a3aa58a3086832
import 'package:webinar/app/providers/drawer_provider.dart';
import 'package:webinar/app/providers/page_provider.dart';
import 'package:webinar/app/services/guest_service/course_service.dart';
import 'package:webinar/app/services/user_service/cart_service.dart';
import 'package:webinar/app/services/user_service/rewards_service.dart';
import 'package:webinar/app/services/user_service/user_service.dart';
import 'package:webinar/app/widgets/main_widget/main_drawer.dart';
import 'package:webinar/app/widgets/main_widget/main_widget.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/data/app_data.dart';
import 'package:webinar/common/data/app_language.dart';
import 'package:webinar/common/database/app_database.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/locator.dart';

import '../../../common/enums/page_name_enum.dart';
import '../../../common/utils/object_instance.dart';
import '../../../config/assets.dart';
import '../../providers/app_language_provider.dart';
import '../../widgets/textbook_widget/text_main_drawer.dart';
import '../container_bg.dart';



class TextBookMainPage extends StatefulWidget {
  static const String pageName = '/textbook_main';
  const TextBookMainPage({super.key});

  @override
  State<TextBookMainPage> createState() => _TextBookMainPageState();
}

class _TextBookMainPageState extends State<TextBookMainPage> {
  late Future<int> future;

  double bottomNavHeight = 90;
  
  @override
  void initState() {
    super.initState();

    future = Future<int>(() {
      return 0;
    });

    FlutterNativeSplash.remove();
    locator<DrawerProvider>().isOpenDrawer = false;


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      
      addListener();

      FirebaseMessaging.instance.getToken().then((value) {
        try{
          print('token : ${value}');
          UserService.sendFirebaseToken(value!);
        }catch(_){}
      });
    });

    getData();
  }


  getData() {

  }

  @override
  void dispose() {
    drawerController.dispose();
    super.dispose();
  }

  addListener() {
    drawerController.addListener(() { 
      if(locator<DrawerProvider>().isOpenDrawer != drawerController.value.visible){

        Future.delayed(const Duration(milliseconds: 300)).then((value) {          
          if(mounted){
            locator<DrawerProvider>().setDrawerState(drawerController.value.visible);
          }
        });
      }
      
    });
  }
  
  @override
  Widget build(BuildContext context) {
    bottomNavHeight = 90;
    

    if( !kIsWeb ){
      if(Platform.isIOS){

        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
          SystemUiOverlay.top
        ]);
      }
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (v){
        if(locator<PageProvider>().page == PageNames.home){
          MainWidget.showExitDialog();
        }else{
          locator<PageProvider>().setPage(PageNames.home);
        }
      },
      child: Consumer<AppLanguageProvider>(
        builder: (context, languageProvider, _) {
          
          drawerController = AdvancedDrawerController();
          if(locator<DrawerProvider>().isOpenDrawer){
            drawerController.showDrawer();
          }else{
            drawerController.hideDrawer();
          }
          
          addListener();
      
          return directionality(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: purplePrimary(),
              body: AdvancedDrawer(
                key: UniqueKey(),
                backdropColor: Colors.transparent,
      
                drawer: const TextbookMainDrawer(),
                
                openRatio: .6,
                openScale: .75,
                
                animationDuration: const Duration(milliseconds: 150),
                
                animateChildDecoration: false,
                animationCurve: Curves.linear,
      
                controller: drawerController,
                
                childDecoration: BoxDecoration(                 
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.12),
                      blurRadius: 30,
                      offset: const Offset(0, 10)
                    )
                  ]
                ),
      
                rtlOpening: locator<AppLanguage>().isRtl(),

                  backdrop: glassContainerGB(child: Container()),
                child: Consumer<PageProvider>(
                  builder: (context, pageProvider, _) {
                    return SafeArea(
                      bottom: !kIsWeb && Platform.isAndroid,
                      top: false,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        resizeToAvoidBottomInset: false,
                        extendBody: true,
      
                        body: TextbookHomePage(),
                    
                      ),
                    );
                  }
                )
              ),
            )
          );
        }
      ),
    );
  }
}

class BottomNavClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    
    double height = size.height;
    double width = size.width;

    Path path = Path();

    path.lineTo(0, 0);
    path.lineTo(0, height);
    path.lineTo(width, height);

    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
      width, 
      45, 
      width - 45,
      45
    );
    
    path.lineTo(45, 45);

    path.quadraticBezierTo(
      0, 
      45, 
      0,
      0
    );

    // path.moveTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
  
}
