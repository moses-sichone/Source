import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webinar/app/models/register_config_model.dart';
import 'package:webinar/app/pages/authentication_page/login_page.dart';
import 'package:webinar/app/pages/authentication_page/verify_code_page.dart';
import 'package:webinar/app/pages/main_page/home_page/single_course_page/single_content_page/web_view_page.dart';
import 'package:webinar/app/pages/main_page/main_page.dart';
import 'package:webinar/app/services/authentication_service/authentication_service.dart';
import 'package:webinar/app/services/guest_service/guest_service.dart';
import 'package:webinar/app/widgets/authentication_widget/auth_widget.dart';
import 'package:webinar/app/widgets/authentication_widget/country_code_widget/code_country.dart';
import 'package:webinar/app/widgets/authentication_widget/register_widget/register_widget.dart';
import 'package:webinar/app/widgets/main_widget/main_widget.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/data/api_public_data.dart';
import 'package:webinar/common/enums/error_enum.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/common/utils/constants.dart';
import 'package:webinar/config/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../common/enums/page_name_enum.dart';
import '../../../config/assets.dart';
import '../../../config/colors.dart';
import '../../../common/components.dart';
import '../../../locator.dart';
import '../../providers/page_provider.dart';
import '../container_bg.dart';

class RegisterPage extends StatefulWidget {
  static const String pageName = '/register';
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController mailController = TextEditingController();
  FocusNode mailNode = FocusNode();
  TextEditingController phoneController = TextEditingController();
  FocusNode phoneNode = FocusNode();
  
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordNode = FocusNode();
  // TextEditingController retypePasswordController = TextEditingController();
  // FocusNode retypePasswordNode = FocusNode();

  bool isEmptyInputs=true;
  bool isPhoneNumber=true;
  bool isSendingData=false;


  CountryCode countryCode = CountryCode(
    code: "US",
    dialCode: "+1",
    flagUri: "${AppAssets.flags}en.png",
    name: "United States"
  );

  // user
  // teacher
  // organization
  String accountType = 'user';
  bool isLoadingAccountType = false;

  String? otherRegisterMethod;
  RegisterConfigModel? registerConfig;

  List<dynamic> selectRolesDuringRegistration = [];

  @override
  void initState() {
    
    super.initState();

    if(PublicData.apiConfigData['selectRolesDuringRegistration'] != null){
      selectRolesDuringRegistration = ((PublicData.apiConfigData['selectRolesDuringRegistration']) as List<dynamic>).toList();
    }

    if((PublicData.apiConfigData?['register_method'] ?? '') == 'email'){
      isPhoneNumber = false;
      otherRegisterMethod = 'email';
    }else{
      isPhoneNumber = true;
      otherRegisterMethod = 'phone';
    }

    mailController.addListener(() {
      if( (mailController.text.trim().isNotEmpty || phoneController.text.trim().isNotEmpty) && passwordController.text.trim().isNotEmpty
          //&& retypePasswordController.text.trim().isNotEmpty
      ){
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

    phoneController.addListener(() {
      if( (mailController.text.trim().isNotEmpty || phoneController.text.trim().isNotEmpty) && passwordController.text.trim().isNotEmpty
         // && retypePasswordController.text.trim().isNotEmpty
      ){
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
      if( (mailController.text.trim().isNotEmpty || phoneController.text.trim().isNotEmpty) && passwordController.text.trim().isNotEmpty
          // && retypePasswordController.text.trim().isNotEmpty
      ){
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

    // retypePasswordController.addListener(() {
    //   if( (mailController.text.trim().isNotEmpty || phoneController.text.trim().isNotEmpty) && passwordController.text.trim().isNotEmpty && retypePasswordController.text.trim().isNotEmpty){
    //     if(isEmptyInputs){
    //       isEmptyInputs = false;
    //       setState(() {});
    //     }
    //   }else{
    //     if(!isEmptyInputs){
    //       isEmptyInputs = true;
    //       setState(() {});
    //     }
    //   }
    // });
    
    getAccountTypeFileds();

  }

  
  getAccountTypeFileds() async {
    
    setState(() {
      isLoadingAccountType = true;
    });

    registerConfig = await GuestService.registerConfig(accountType);

    setState(() {
      isLoadingAccountType = false;
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  space(getSize().height * .10),

                  // title
                  Center(
                    child: Text(
                      appText.createAccount,
                      style: style24Bold(),
                    ),
                  ),

                  // desc
                  Center(
                    child: Text(
                      appText.createAccountDesc,
                      style: style14Regular().copyWith(color: greyText()),
                    ),
                  ),

                  space(25),



                  if(selectRolesDuringRegistration.contains(PublicData.teacherRole) && selectRolesDuringRegistration.contains(PublicData.organizationRole))...{
                    Center(
                      child: Text(
                        appText.accountType,
                        style: style14Regular().copyWith(color: greyB2),
                      ),
                    ),


                    space(12),

                    // account types
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: borderRadius(radius: 25)
                      ),

                      width: getSize().width,
                      height:  52,

                      child: Row(
                        children: [

                          // student
                          AuthWidget.accountTypeWidget(appText.student, accountType, PublicData.userRole, (){
                            setState(() {
                              accountType = PublicData.userRole;
                            });
                            getAccountTypeFileds();
                          }),



                          // instructor
                          if(selectRolesDuringRegistration.contains(PublicData.teacherRole))...{
                            AuthWidget.accountTypeWidget(appText.instrcutor, accountType, PublicData.teacherRole, (){
                              setState(() {
                                accountType = PublicData.teacherRole;
                              });
                              getAccountTypeFileds();
                            }),
                          },


                          // organization
                          if(selectRolesDuringRegistration.contains(PublicData.organizationRole))...{
                            AuthWidget.accountTypeWidget(appText.organization, accountType, PublicData.organizationRole, (){
                              setState(() {
                                accountType = PublicData.organizationRole;
                              });
                              getAccountTypeFileds();
                            }),
                          }


                        ],
                      ),
                    ),
                  },


                  // Other Register Method
                  if(registerConfig?.showOtherRegisterMethod != null)...{
                    space(30),

                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: borderRadius(radius: 25)
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
                              });
                            }),

                            // email
                            AuthWidget.accountTypeWidget(appText.phone, otherRegisterMethod ?? '', 'phone', (){
                              setState(() {
                                otherRegisterMethod = 'phone';
                                isPhoneNumber = true;
                              });
                            }),

                          ],
                        )
                    )
                  },

                  space(30),

                  if(isPhoneNumber)...{

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

                        space(0,width: 10),

                        Expanded(child: input(phoneController, phoneNode, appText.phoneNumber))
                      ],
                    )
                  }else...{
                    input(mailController, mailNode, appText.yourEmail, iconPathLeft: AppAssets.mailSvg,leftIconSize: 14),
                  },

                  space(10),

                  input(passwordController, passwordNode, appText.password, iconPathLeft: AppAssets.passwordSvg,leftIconSize: 14,isPassword: true),

                  // space(10),
                  //
                  // input(retypePasswordController, retypePasswordNode, appText.retypePassword, iconPathLeft: AppAssets.passwordSvg,leftIconSize: 14,isPassword: true),
                  //

                  isLoadingAccountType
                      ? loading()
                      : Column(
                    children: [

                      ...List.generate(registerConfig?.formFields?.fields?.length ?? 0, (index) {
                        return registerConfig?.formFields?.fields?[index].getWidget() ?? const SizedBox();
                      })
                    ],
                  ),

                  space(25),

                  Center(
                    child: button(
                        onTap: () async {

                          if(!isEmptyInputs){

                            if(registerConfig?.formFields?.fields != null){
                              for (var i = 0; i < (registerConfig?.formFields?.fields?.length ?? 0); i++) {
                                if(registerConfig?.formFields?.fields?[i].isRequired == 1 && registerConfig?.formFields?.fields?[i].userSelectedData == null){

                                  if(registerConfig?.formFields?.fields?[i].type != 'toggle') {

                                    showSnackBar(ErrorEnum.alert, '${appText.pleaseReview} ${registerConfig?.formFields?.fields?[i].getTitle()}');
                                    return;
                                  }

                                }
                              }
                            }


                            if(passwordController.text.trim().compareTo(
                                passwordController.text.trim()) == 0
                                //retypePasswordController.text.trim()) == 0

                            ){

                              setState(() {
                                isSendingData = true;
                              });

                              if(registerConfig?.registerMethod == 'email'){
                                Map? res = await AuthenticationService.registerWithEmail( // email
                                    registerConfig?.registerMethod ?? '',
                                    mailController.text.trim(),
                                    passwordController.text.trim(),
                                    passwordController.text.trim(),
                                    //retypePasswordController.text.trim(),
                                    accountType,
                                    registerConfig?.formFields?.fields
                                );


                                if(res != null){
                                  if(registerConfig?.disableRegistrationVerification ?? false){
                                    locator<PageProvider>().setPage(PageNames.home);
                                    nextRoute(MainPage.pageName, arguments: res['user_id']);
                                  }else{

                                    if(res['step'] == 'stored' || res['step'] == 'go_step_2'){
                                      nextRoute(VerifyCodePage.pageName, arguments: {
                                        'user_id' : res['user_id'],
                                        'email': mailController.text.trim(),
                                        'password': passwordController.text.trim(),
                                        'retypePassword': passwordController.text.trim()
                                        // retypePasswordController.text.trim(),
                                      });

                                    }else if(res['step'] == 'go_step_3'){
                                      locator<PageProvider>().setPage(PageNames.home);
                                      nextRoute(MainPage.pageName, arguments: res['user_id']);
                                    }
                                  }

                                }

                              }else{

                                Map? res = await AuthenticationService.registerWithPhone( // mobile
                                    registerConfig?.registerMethod ?? '',
                                    countryCode.dialCode.toString(),
                                    phoneController.text.trim(),
                                    passwordController.text.trim(),
                                    passwordController.text.trim(),
                                    // retypePasswordController.text.trim(),
                                    accountType,
                                    registerConfig?.formFields?.fields
                                );

                                if(res != null){
                                  if(registerConfig?.disableRegistrationVerification ?? false){
                                    locator<PageProvider>().setPage(PageNames.home);
                                    nextRoute(MainPage.pageName, arguments: res['user_id']);
                                  }else{
                                    if(res['step'] == 'stored' || res['step'] == 'go_step_2'){

                                      nextRoute(VerifyCodePage.pageName, arguments: {
                                        'user_id' : res['user_id'],
                                        'countryCode': countryCode.dialCode.toString(),
                                        'phone': phoneController.text.trim(),
                                        'password': passwordController.text.trim(),
                                        'retypePassword': passwordController.text.trim()
                                        // retypePasswordController.text.trim()
                                      });

                                    }else if(res['step'] == 'go_step_3'){
                                      locator<PageProvider>().setPage(PageNames.home);
                                      nextRoute(MainPage.pageName, arguments: res['user_id']);
                                    }
                                  }
                                }
                              }

                              setState(() {
                                isSendingData = false;
                              });
                            }

                          }

                        },
                        width: getSize().width,
                        height: 52,
                        text: appText.createAnAccount,
                        bgColor: isEmptyInputs ? greyCF : purplePrimary(),
                        textColor: Colors.white,
                        raduis: 35,
                        borderColor: Colors.transparent,
                        isLoading: isSendingData
                    ),
                  ),

                  space(15),

                  // termsPoliciesDesc
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        nextRoute(WebViewPage.pageName, arguments: ['${Constants.dommain}/pages/app-terms', appText.webinar, false, LoadRequestMethod.get]);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        appText.termsPoliciesDesc,
                        style: style14Regular().copyWith(color: greyText()),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  space(25),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.white, height: 1, thickness: 0.8,)),
                      Text('  Or  ', style: style14Regular().copyWith(color: Colors.black),),
                      const Expanded(child: Divider(color: Colors.white, height: 1, thickness: 0.8,))
                    ],
                  ),
                  space(25),

                  // google and facebook auth
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      if(PublicData.apiConfigData?['show_google_login_button'] ?? false)...{

                        socialWidget(AppAssets.googleSvg, 'Google', () async {
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

                      if(PublicData.apiConfigData?['show_facebook_login_button'] ?? false)...{
                        socialWidget(AppAssets.facebookSvg, 'Facebook', () async {
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

                      }
                    ],
                  ),

                  space(25),

                  // haveAnAccount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        appText.haveAnAccount,
                        style: style16Regular(),
                      ),

                      space(0,width: 2),

                      GestureDetector(
                        onTap: () {
                          nextRoute(LoginPage.pageName, isClearBackRoutes: true);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          appText.login,
                          style: style16Bold().copyWith(color: purplePrimary()),
                        ),
                      )
                    ],
                  ),

                  space(25),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  socialWidget(String icon, String text, Function onTap){
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: getSize().width * .44,
        height: 50,
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