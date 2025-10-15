import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';
import 'package:webinar/locator.dart';
import 'package:webinar/app/pages/textbook/textbook_main_page.dart';
import 'package:webinar/app/providers/page_provider.dart';
import 'package:webinar/common/enums/page_name_enum.dart';
import 'package:webinar/app/services/textbook_service/textbook_auth_service.dart';

class TextbookLoginPage extends StatefulWidget {
  static const String pageName = '/textbook_login';
  const TextbookLoginPage({super.key});

  @override
  State<TextbookLoginPage> createState() => _TextbookLoginPageState();
}

class _TextbookLoginPageState extends State<TextbookLoginPage> {
  TextEditingController emailController = TextEditingController();
  FocusNode emailNode = FocusNode();
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordNode = FocusNode();

  bool isEmptyInputs = true;
  bool isSendingData = false;
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();

    emailController.addListener(() {
      if ((emailController.text.trim().isNotEmpty) && passwordController.text.trim().isNotEmpty) {
        if (isEmptyInputs) {
          isEmptyInputs = false;
          setState(() {});
        }
      } else {
        if (!isEmptyInputs) {
          isEmptyInputs = true;
          setState(() {});
        }
      }
    });

    passwordController.addListener(() {
      if ((emailController.text.trim().isNotEmpty) && passwordController.text.trim().isNotEmpty) {
        if (isEmptyInputs) {
          isEmptyInputs = false;
          setState(() {});
        }
      } else {
        if (!isEmptyInputs) {
          isEmptyInputs = true;
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (emailController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty) {
      setState(() {
        isSendingData = true;
      });

      try {
        bool success = await TextbookAuthService.login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        if (success) {
          // Navigate to textbook main page
          nextRoute(TextBookMainPage.pageName, isClearBackRoutes: true);
        } else {
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login failed. Please check your credentials.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isSendingData = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          locator<PageProvider>().setPage(PageNames.home);
          nextRoute('/login');
        }
      },
      child: directionality(
        child: Scaffold(
          backgroundColor: purplePrimary(),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: padding(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  space(getSize().height * .1),

                  // Title
                  Text(
                    'Textbook Login',
                    style: style24Bold().copyWith(color: Colors.white),
                  ),
                  space(8),

                  // Subtitle
                  Text(
                    'Access your digital textbooks',
                    style: style14Regular().copyWith(color: Colors.white70),
                  ),

                  space(50),

                  // Login Form Container
                  Container(
                    width: getSize().width,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius(radius: 20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email Field
                        Text(
                          'Email',
                          style: style14Medium().copyWith(color: greyText()),
                        ),
                        space(8),
                        input(
                          emailController,
                          emailNode,
                          'Enter your email',
                          iconPathLeft: 'assets/image/svg/mail.svg',
                          leftIconSize: 14,
                        ),

                        space(20),

                        // Password Field
                        Text(
                          'Password',
                          style: style14Medium().copyWith(color: greyText()),
                        ),
                        space(8),
                        input(
                          passwordController,
                          passwordNode,
                          'Enter your password',
                          iconPathLeft: 'assets/image/svg/password.svg',
                          leftIconSize: 14,
                          isPassword: !passwordVisible,
                          rightIconPath: passwordVisible ? 'assets/image/svg/visibility.svg' : 'assets/image/svg/visibility_off.svg',
                          onTapRightIcon: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),

                        space(30),

                        // Login Button
                        button(
                          onTap: _login,
                          width: getSize().width,
                          height: 52,
                          text: 'Login',
                          bgColor: isEmptyInputs ? greyCF : purplePrimary(),
                          raduis: 12,
                          textColor: Colors.white,
                          borderColor: Colors.transparent,
                          isLoading: isSendingData,
                        ),

                        space(20),

                        // Back to Main Login
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              locator<PageProvider>().setPage(PageNames.home);
                              nextRoute('/login');
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Text(
                              'Back to Main Login',
                              style: style14Regular().copyWith(
                                color: purplePrimary(),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  space(30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}