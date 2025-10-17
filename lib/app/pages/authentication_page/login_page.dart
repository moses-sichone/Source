import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webinar/app/pages/authentication_page/forget_password_page.dart';
import 'package:webinar/app/pages/authentication_page/register_page.dart';
import 'package:webinar/app/pages/main_page/home_page/single_course_page/single_content_page/web_view_page.dart';
import 'package:webinar/app/pages/main_page/main_page.dart';
import 'package:webinar/app/providers/page_provider.dart';
import 'package:webinar/app/services/authentication_service/authentication_service.dart';
import 'package:webinar/app/widgets/authentication_widget/auth_widget.dart';
import 'package:webinar/app/widgets/authentication_widget/register_widget/register_widget.dart';
import 'package:webinar/app/widgets/main_widget/main_widget.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/data/api_public_data.dart';
import 'package:webinar/common/enums/page_name_enum.dart';
import 'package:webinar/common/utils/constants.dart';
import 'package:webinar/locator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common/utils/app_text.dart';
import '../../../config/assets.dart';
import '../../../config/colors.dart';
import '../../../config/styles.dart';
import '../../widgets/authentication_widget/country_code_widget/code_country.dart';
import '../container_bg.dart';
<<<<<<< HEAD
import '../textbook/textbook_login_page.dart';
=======
import '../textbook/textbook_main_page.dart';
>>>>>>> 300ef8f371d1837e2fcf1dac69a3aa58a3086832

class LoginPage extends StatefulWidget {
  static const String pageName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController mailController = TextEditingController();
  FocusNode mailNode = FocusNode();
  // TextEditingController phoneController = TextEditingController();
  // FocusNode phoneNode = FocusNode();
  
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordNode = FocusNode();

  String? otherRegisterMethod;
  bool isEmptyInputs=true;
  bool isPhoneNumber=true;
  bool isSendingData=false;

  CountryCode countryCode = CountryCode(
    code: "US",
    dialCode: "+1",
    flagUri: "${AppAssets.flags}en.png",
    name: "United States"
  );

  @override
  void initState() {
    super.initState();

    if((PublicData.apiConfigData?['register_method'] ?? '') == 'email'){
      isPhoneNumber = false;
      otherRegisterMethod = 'email';
    }else{
      isPhoneNumber = true;
      otherRegisterMethod = 'phone';
    }


    mailController.addListener(() {
      if( (mailController.text.trim().isNotEmpty) && passwordController.text.trim().isNotEmpty){
        if(isEmptyInputs){
          isEmptyInputs = false;
          setState(() {});
        }
      }else{
        if(!isEmptyInputs){
          isEmptyInputs = true;
          setState(() {});
        }
      }
    });

    passwordController.addListener(() {
      if( (mailController.text.trim().isNotEmpty) && passwordController.text.trim().isNotEmpty){
        if(isEmptyInputs){
          isEmptyInputs = false;
          setState(() {});
        }
      }else{
        if(!isEmptyInputs){
          isEmptyInputs = true;
          setState(() {});
        }
      }
    });



  }


  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      onPopInvoked: (re){
        MainWidget.showExitDialog();
      },
      child: directionality(
        child: Scaffold(
          body: glassContainerGB(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: padding(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  space(getSize().height * .12),

                  // title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        appText.welcomeBack,
                        style: style24Bold(),
                      ),
                    ],
                  ),
                  space(5),
                  // desc
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        appText.welcomeBackDesc,
                        style: style14Regular().copyWith(color: greyText()),
                      ),
                    ],
                  ),

                  space(10),

                  // Other Register Method
                  if(PublicData.apiConfigData?['showOtherRegisterMethod'] == '1')...{
                    space(15),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: borderRadius(radius: 30)
                        ),

                        width: getSize().width,
                        height:  52,

                        child: Row(
                          children: [

                            // email
                            AuthWidget.accountTypeWidget(appText.email, otherRegisterMethod ?? '', 'email', (){
                              setState(() {
                                otherRegisterMethod = 'email';
                                isPhoneNumber = false;
                                mailController.clear();
                              });
                            }),

                            // email
                            AuthWidget.accountTypeWidget(appText.phone, otherRegisterMethod ?? '', 'phone', (){
                              setState(() {
                                otherRegisterMethod = 'phone';
                                isPhoneNumber = true;
                                mailController.clear();
                              });
                            }),

                          ],
                        )
                    ),

                    space(30),

                  },

                  // input
                  Column(
                    children: [

                      if(isPhoneNumber)...{
                        // phone input
                        Row(
                          children: [

                            // country code
                            GestureDetector(
                              onTap: () async {
                                CountryCode? newData = await RegisterWidget.showCountryDialog();

                                if(newData != null){
                                  countryCode = newData;
                                  setState(() {});
                                }
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: borderRadius()
                                ),
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius: borderRadius(radius: 50),
                                  child: Image.asset(
                                    countryCode.flagUri ?? '',
                                    width: 21,
                                    height: 19,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            space(0,width: 15),

                            Expanded(child: input(mailController, mailNode, appText.phoneNumber))
                          ],
                        )
                      }else ...{
                        input(mailController, mailNode, appText.email, iconPathLeft: AppAssets.mailSvg,leftIconSize: 14),
                      },

                      space(12),

                      input(passwordController, passwordNode, appText.password, iconPathLeft: AppAssets.passwordSvg,leftIconSize: 14,isPassword: true),

                    ],
                  ),

                  space(15),

                  // button
                  Center(
                    child: button(
                        onTap: () async {

                          FocusScope.of(context).unfocus();

                          if( mailController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty){
                            setState(() {
                              isSendingData=true;
                            });

                            bool res = await AuthenticationService.login(
                                '${isPhoneNumber ? countryCode.dialCode!.replaceAll('+', '') : ''}${mailController.text.trim()}',
                                passwordController.text.trim()
                            );

                            if(res){

                              if(Platform.isAndroid){ // for ios, firebase not configured
                                try{
                                  await FirebaseMessaging.instance.deleteToken();
                                }catch(_){}
                              }

                              locator<PageProvider>().setPage(PageNames.home);
                              nextRoute(MainPage.pageName,isClearBackRoutes: true);
                            }

                            setState(() {
                              isSendingData=false;
                            });
                          }
                        },
                        width: getSize().width,
                        height: 52,
                        text: appText.license,
                        bgColor: isEmptyInputs ? greyCF : purplePrimary(),
                        raduis: 55,
                        textColor: Colors.white,
                        borderColor: Colors.transparent,
                        isLoading: isSendingData
                    ),
                  ),

                  space(16),

                  // termsPoliciesDesc
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        nextRoute(WebViewPage.pageName, arguments: ['${Constants.dommain}/pages/app-terms', appText.webinar, false, LoadRequestMethod.get]);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        appText.termsPoliciesDesc,
                        style: style12Regular().copyWith(color: greyText()),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),


                  space(25),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.white, height: 1, thickness: 0.9,)),
                      Text('  Or  ', style: style14Regular().copyWith(color: Colors.black),),
                      const Expanded(child: Divider(color: Colors.white, height: 1, thickness: 0.9,))
                    ],
                  ),
                  space(20),

                  // google and facebook auth
                  if(PublicData.apiConfigData?['show_google_login_button'] ?? false)...{

                    socialWidget(AppAssets.googleSvg, 'Google', width: getSize().width, () async {
                      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
                      final GoogleSignInAuthentication gAuth = await gUser!.authentication;


                      if(gAuth.accessToken != null){

                        setState(() {
                          isSendingData = true;
                        });

                        try{
                          bool res = await AuthenticationService.google(
                              gUser.email,
                              gAuth.accessToken ?? '',
                              gUser.displayName ?? ''
                          );

                          if(res){
                            await FirebaseMessaging.instance.deleteToken();

                            nextRoute(MainPage.pageName,isClearBackRoutes: true);
                          }
                        }catch(_){}

                        setState(() {
                          isSendingData = false;
                        });


                      }
                    }),

                    space(0,width: 10),
                  },
                  space(10),
                  if(PublicData.apiConfigData?['show_facebook_login_button'] ?? false)...{
                    socialWidget(AppAssets.facebookSvg, 'Facebook', width: getSize().width, () async {
                      // try{
                      final LoginResult result = await FacebookAuth.instance.login(permissions: ['email']);

                      if (result.status == LoginStatus.success) {
                        final AccessToken accessToken = result.accessToken!;

                        setState(() {
                          isSendingData = true;
                        });

                        FacebookAuth.instance.getUserData().then((value) async {

                          String email = value['email'];
                          String name = value['name'] ?? '';

                          try{
                            bool res = await AuthenticationService.facebook(email, accessToken.tokenString, name);

                            if(res){
                              await FirebaseMessaging.instance.deleteToken();

                              nextRoute(MainPage.pageName,isClearBackRoutes: true);
                            }
                          }catch(_){}

                          setState(() {
                            isSendingData = false;
                          });
                        });

                      } else {}
                      // }catch(e){}
                    }),
                  },
                  space(10),
                  // login with textbook
                  socialWidget(AppAssets.facebookSvg, 'Log in for textbook', width: getSize().width, () async {
<<<<<<< HEAD
                    nextRoute(TextbookLoginPage.pageName);
=======
                    // try{
                    nextRoute(TextBookMainPage.pageName,isClearBackRoutes: true);
                    // }catch(e){}
>>>>>>> 300ef8f371d1837e2fcf1dac69a3aa58a3086832
                  }),


                  space(20),

                  // haveAnAccount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        appText.dontHaveAnAccount,
                        style: style16Regular(),
                      ),

                      space(0,width: 4),

                      GestureDetector(
                        onTap: (){
                          nextRoute(RegisterPage.pageName,isClearBackRoutes: true);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          appText.signup,
                          style: style16Regular().copyWith(color: purplePrimary(), fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),

                  space(20),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        nextRoute(ForgetPasswordPage.pageName);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        appText.forgetPassword,
                        style: style14Regular().copyWith(color: greyB2),
                      ),
                    ),
                  ),

                  space(15),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }


  socialWidget(String icon, String text, Function onTap, {double? width}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: width ?? getSize().width * .44,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius(radius: 35),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon,width: 26,),
            space(0, width: 8),
            Text(text, style: style16Regular().copyWith(fontWeight: FontWeight.w600, fontSize: 14),)
          ],
        ),
      ),
    );
  }

}