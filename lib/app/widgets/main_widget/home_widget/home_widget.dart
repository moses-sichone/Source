import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:provider/provider.dart';
import 'package:webinar/app/pages/main_page/home_page/notification_page.dart';
import 'package:webinar/app/pages/main_page/home_page/search_page/suggested_search_page.dart';
import 'package:webinar/app/providers/user_provider.dart';
import 'package:webinar/app/services/authentication_service/authentication_service.dart';
import 'package:webinar/common/components.dart';

import '../../../../common/common.dart';
import '../../../../common/utils/app_text.dart';
import '../../../../common/utils/object_instance.dart';
import '../../../../config/assets.dart';
import '../../../../config/colors.dart';
import '../../../../config/styles.dart';
import '../../../pages/main_page/home_page/cart_page/cart_page.dart';
import '../main_widget.dart';





class HomeWidget{

  static Widget homeAppBar(AnimationController appBarController, Animation appBarAnimation,String token,TextEditingController searchController,FocusNode searchNode,String name){
    return AnimatedBuilder(
      animation: appBarAnimation,
      builder: (context, child) {

        return Consumer<UserProvider>(
          builder: (context, userProvider, _) {

            return GlassContainer.clearGlass(
              blur: 3,
              width: getSize().width,
              height: appBarAnimation.value,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(40),
                  bottom: Radius.circular(40)
              ),
              color: appBarBg().withOpacity(0.8),
              child: Padding(
                padding: padding(),
                child: Column(
                  children: [
                    // app bar
                    Container(
                      width: getSize().width,
                      margin: EdgeInsets.only(top: (!kIsWeb && Platform.isIOS) ? MediaQuery.of(context).viewPadding.top + 6 : MediaQuery.of(context).viewPadding.top + 12),
                      child: Row(
                        children: [

                          // menu
                          GestureDetector(
                            onTap: () async {

                              drawerController.showDrawer();

                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle
                              ),
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 5),
                              alignment: Alignment.center,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..scale(-1.0, 1.0),
                                child: SvgPicture.asset(AppAssets.menuSvg, color: Colors.black,),),
                            ),
                          ),
                          space(0,width: 4),
                          // title
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                // username
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: getSize().width * .4,
                                          minWidth: getSize().width * .1
                                      ),
                                      child: Text(
                                        token.isEmpty
                                            ? appText.webinar
                                            : 'Welcome Back! ',
                                        style: TextStyle(color: greyText(), fontWeight: FontWeight.w400),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // if(token.isNotEmpty)...{
                                    //   SvgPicture.asset(AppAssets.hiSvg),
                                    // }
                                  ],
                                ),
                                const SizedBox(height: 2,),
                                Text(
                                  token.isEmpty?
                                  appText.letsStartLearning:name,
                                  style: const TextStyle(color: Colors.black, height: 1, fontWeight: FontWeight.w600),
                                ),

                              ],
                            ),
                          ),

                          // basket and notification
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              // basket
                              MainWidget.menuButton(
                                  'assets/image/svg/ShoppingCart.svg',
                                  userProvider.cartData?.items?.isNotEmpty ?? false,
                                  Colors.black,
                                  Colors.white,
                                      (){
                                    nextRoute(CartPage.pageName);
                                  }
                              ),

                              space(0,width: 12),

                              // notification
                              MainWidget.menuButton(
                                  'assets/image/svg/Bell.svg',
                                  userProvider.notification.where((element) => element.status == 'unread').isNotEmpty,
                                  Colors.black,
                                  Colors.white,
                                      (){
                                    nextRoute(NotificationPage.pageName);
                                  }
                              )
                            ],
                          )


                        ],
                      ),
                    ),

                    const Spacer(),

                    AnimatedCrossFade(
                      firstChild: Column(
                        children: [

                          input(searchController, searchNode, appText.searchInputDesc, iconPathLeft: AppAssets.searchSvg, isReadOnly: true, onTap: (){
                            nextRoute(SuggestedSearchPage.pageName);
                          }),
                          space(16)
                        ],
                      ),
                      secondChild: SizedBox(width: getSize().width),

                      crossFadeState: (appBarAnimation.value < (140 + MediaQuery.of(navigatorKey.currentContext!).viewPadding.top))
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,

                      duration: const Duration(milliseconds: 200),
                    ),
                    space(2)
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }


  static Widget titleAndMore(String title,{bool isViewAll=true,Function? onTapViewAll}){
    return Padding(
      padding: padding(vertical: 16),
      child: Row(
        children: [
          
          Text(
            ' $title',
            style: style20Regular().copyWith(color: headerTextColor(), fontWeight: FontWeight.w600),
          ),

          const Spacer(),

          if(isViewAll)...{
            GestureDetector(
              onTap: (){
                if(onTapViewAll != null) {
                  onTapViewAll();
                }
              },
              behavior: HitTestBehavior.opaque,
              child: SvgPicture.asset('assets/image/svg/ArrowRight.svg', color: Colors.black,),
            )
          }

        ],
      ),
    );
  }


  static Future showFinalizeRegister(int userId) async {

    TextEditingController nameController = TextEditingController();
    FocusNode nameNode = FocusNode();

    TextEditingController referralController = TextEditingController();
    FocusNode referralNode = FocusNode();

    bool isLoading = false;

    return await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: navigatorKey.currentContext!, 
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {

            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  directionality(
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(navigatorKey.currentContext!).viewInsets.bottom
                      ),
                      width: getSize().width,
                      padding: padding(vertical: 21),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30))
                      ),
                  
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Text(
                            appText.finalizeYourAccount,
                            style: style16Bold(),
                          ),
                  
                          space(16),
                  
                          input(nameController, nameNode, appText.yourName, iconPathLeft: AppAssets.profileSvg, leftIconSize: 14,isBorder: true),
                          
                          space(16),
                  
                          input(referralController, referralNode, appText.refCode, iconPathLeft: AppAssets.ticketSvg, leftIconSize: 14,isBorder: true),
                          
                          space(24),
            
                          Center(
                            child: button(
                              onTap: () async {
                                if(nameController.text.length > 3){
                                  setState((){
                                    isLoading = true;
                                  });
                                  
                                  bool res = await AuthenticationService.registerStep3(
                                    userId, 
                                    nameController.text.trim(), 
                                    referralController.text.trim()
                                  );
            
                                  if(res){
                                    backRoute(arguments: res);
                                  }
                                  
                                  setState((){
                                    isLoading = false;
                                  });
                                }
                              }, 
                              width: getSize().width, 
                              height: 52, 
                              text: appText.continue_, 
                              bgColor: purplePrimary(), 
                              textColor: Colors.white, 
                              isLoading: isLoading
                            ),
                          ),
            
                          space(24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );

          },
        );
      },
    );
  }
}