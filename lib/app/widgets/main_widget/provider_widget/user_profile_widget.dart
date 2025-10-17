import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:webinar/app/models/profile_model.dart';
import 'package:webinar/app/services/guest_service/providers_service.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/common/utils/currency_utils.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';

import '../../../../common/components.dart';
import '../../../../common/utils/tablet_detector.dart';
import '../../../pages/main_page/providers_page/user_profile_page/user_profile_page.dart';

class UserProfileWidget{

  static Widget profileItem(String name, String count, String iconPath, Color color, {int width = 24}){
    return Column(
      children: [

        iconPath.isEmpty? const SizedBox.shrink() : Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(.3),
            shape: BoxShape.circle
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(iconPath, colorFilter: ColorFilter.mode(color, BlendMode.srcIn), width: width.toDouble()),
        ),

        iconPath.isEmpty? const SizedBox.shrink() : space(8),

        Text(
          count,
          style: style14Bold().copyWith(fontSize: 20),
        ),


        Text(
          name,
          style: style12Regular().copyWith(color: greyText()),
        ),

      ],
    );
  }


  static Widget aboutPage(ProfileModel profile){
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: padding(vertical: 20),
      child: (profile.about?.isEmpty ?? true)
    ? Padding(
        padding: const EdgeInsets.only(top: 30),
        child: emptyState(AppAssets.bioEmptyStateSvg, appText.noBiography, appText.noBiographyDesc),
      )
    : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // space(10),


          if(profile.offline == 1)...{
            Container(
              width: getSize().width,
              decoration: BoxDecoration(
                borderRadius: borderRadius(radius: 18),
                color: Colors.white
              ),
              padding: padding(horizontal: 10, vertical: 10),
    
              child: Row(
                children: [

                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                        color: appBarBg(),
                        borderRadius: borderRadius(radius: 12)
                    ),
                    alignment: Alignment.center,
                    child: Image.asset('assets/image/png/video.png', width: 20,),
                  ),


                  space(0,width: 10),
    
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  
                        Text(
                          appText.instructorIsUnavailable,
                          style: style12Regular().copyWith(color: greyText()),
                        ),
                        
                        space(6),
                        
                        Text(
                          profile.offlineMessage ?? '',
                          style: style14Bold(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                  
                  
                      ],
                    ),
                  )
    
                ],
              ),
            ),
            space(10),
          },

          Text('About me', style: style16Bold().copyWith(height: 1),),

          space(10),
    
          HtmlWidget(
            profile.about ?? '',
            textStyle: style14Regular().copyWith(color: greyText()),
          ),
    
    
          HtmlWidget(
            profile.about ?? '',
            textStyle: style14Regular().copyWith(color: greyText()),
          ),
    
          space(20),

          // experiences
          Text(
            appText.experiences,
            style: style16Bold(),
          ),

          space(10),

          // experiences
          ...List.generate(profile.experience?.length ?? 0, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [

                  SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset('assets/image/png/CheckCircle.png', color: purplePrimary(),),
                  ),

                  space(0,width: 8),

                  Expanded(
                    child: Text(
                      profile.experience?[index] ?? '',
                      style: style14Regular().copyWith(color: greyText()),
                    ),
                  )
                ],
              ),
            );
          }),


          space(10),

          // education
          Text(
            appText.education,
            style: style16Bold(),
          ),

          space(16),

          // education
          ...List.generate(profile.education?.length ?? 0, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: Image.asset('assets/image/png/CheckCircle.png', color: purplePrimary(),),
                  ),

                  space(0,width: 8),

                  Expanded(
                    child: Text(
                      profile.education?[index] ?? '',
                      style: style14Regular().copyWith(color: greyText()),
                    ),
                  )
                ],
              ),
            );
          }),
    
          
          space(100),
        ],
      ),
    );
  }

  static Widget classesPage(ProfileModel profile){
    return (profile.webinars?.isEmpty ?? true)
  ? SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: emptyState(AppAssets.courseEmptyStateSvg, appText.noCourses, appText.noCoursesDesc),
      ),
    )
  : GridView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 40
      ),
      physics: const NeverScrollableScrollPhysics(),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisExtent: 190,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      
      children: List.generate(profile.webinars?.length ?? 0, (index) {
        // return courseItem(
        //     profile.webinars![index],
        //     width: getSize().width / 2,
        //
        //     endCardPadding: 0.0,
        //     height: 200.0
        // );
        return courseSliderItem(
          profile.webinars![index],
          horizontalPadding: 5
        );
      }),
    );
  }

  static Widget badgesPage(ProfileModel profile){
    return (profile.badges?.isEmpty ?? true)
  ? SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: emptyState(AppAssets.badgesEmptyStateSvg, appText.noBadges, appText.noBadgesDesc),
      ),
    )
  : GridView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 40
      ),
      physics: const NeverScrollableScrollPhysics(),

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: TabletDetector.isTablet() ? 3 : 2,
        mainAxisExtent: 165,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16
      ),
      
      children: List.generate(profile.badges?.length ?? 0, (index) {
        return Container(
          width: getSize().width,
          height: getSize().height,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius(radius: 18)
          ),

          child: Container(
            width: 155,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20), // Rounded corners for the whole container
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image at the top with rounded top corners
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)), // Rounded top corners only
                  child: Image.asset(
                    'assets/image/png/gold-texture.png',
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Column(
                    children: [
                      Text(
                        profile.badges?[index].title ?? '',
                        style: style14Regular().copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      space(4),
                      Text(
                        profile.badges?[index].description ?? '',
                        style: style10Regular().copyWith(color: greyText()),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  static Widget meetingPage(ProfileModel profile){
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: padding(),
      child: Column(
        children: [

          space(40),

          Image.asset(
            'assets/image/png/meeting-and-stuff.png'
          ),

          space(16),

          Text(
            '${appText.reserveMeetingDesc} ${CurrencyUtils.calculator(profile.meeting?.priceWithDiscount ?? 0)}',
            style: style14Regular().copyWith(color: greyText()),
            textAlign: TextAlign.center,
          ),

           if(profile.cashbackRules.isNotEmpty)...{
              space(16),

              helperBox(
                'assets/image/png/wallet.png',
                appText.getCashback, 
                '${appText.reserveAMeetingAndGet}${profile.cashbackRules.first.amountType == 'percent' ? '%${profile.cashbackRules.first.amount ?? 0}' : CurrencyUtils.calculator(profile.cashbackRules.first.amount ?? 0)} ${appText.cashback}',
                horizontalPadding: 0
              ),
            },

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              space(15),
              Text(
                appText.hourlyCharge,
                style: style14Regular().copyWith(color: greyText()),
              ),
              space(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  if(profile?.meeting?.discount != null)...{
                    Text(
                      CurrencyUtils.calculator(profile?.meeting?.price ?? 0),
                      style: style14Regular().copyWith(color: greyA5,decoration: TextDecoration.lineThrough),
                    ),

                    space(0,width: 8),
                  },

                  Text(
                    ((profile?.meeting?.priceWithDiscount ?? 0) == 0)
                        ? appText.free
                        : CurrencyUtils.calculator(profile?.meeting?.priceWithDiscount ?? 0),
                    style: style16Bold().copyWith(color: headerTextColor(), fontSize: 18),
                  ),

                ],
              )

            ],
          ),

        ],
      ),
    );
  }

  static Widget instructorPage(ProfileModel profile){
    return (profile.organizationTeachers?.isEmpty ?? true)
  ? SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: emptyState(AppAssets.providersEmptyStateSvg, appText.noInstructor, appText.noInstructorProfileDesc),
      ),
    )
  : GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: TabletDetector.isTablet() ? 3 : 2,
        mainAxisSpacing: 22,
        crossAxisSpacing: 22,
        mainAxisExtent: 195
      ), 
      padding: const EdgeInsets.only(
        right: 21,
        left: 21,
        bottom: 100,
        top: 80
      ),
      itemCount: profile.organizationTeachers?.length ?? 0,
      itemBuilder: (context, index) {
        return userProfileCard(profile.organizationTeachers![index], (){
          nextRoute(UserProfilePage.pageName, arguments: profile.organizationTeachers?[index].id);
        });
      },
    );
  }


  static Widget tabView(String title1,String title2, bool isOnTitle1, Function(bool value) onChangeTab){

    return Container(
      width: getSize().width,
      height: 52,
      padding: padding(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: greyE7),
        borderRadius: borderRadius()
      ),

      child: Stack(
        alignment: Alignment.center,
        children: [

          AnimatedAlign(
            alignment: isOnTitle1 ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd,
            duration: const Duration(milliseconds: 250),
            child: Container(
              width: (getSize().width - 45) / 2,
              height: 52,
              decoration: BoxDecoration(
                color: purplePrimary(),
                borderRadius: borderRadius(radius: 17)
              ),
            )
          ),
          
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                

                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      onChangeTab(true);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(
                        title1,
                        style: style14Regular().copyWith(color: isOnTitle1 ? Colors.white : greyText()),
                      ),
                    ),
                  ),
                ),
                
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      onChangeTab(false);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(
                        title2,
                        style: style14Regular().copyWith(color: !isOnTitle1 ? Colors.white : greyText()),
                      ),
                    ),
                  ),
                )
              

              ],
            )
          ),

        ],
      ),

    );
  }


  static showSendMessageDialog(int id){
    
    TextEditingController subjectController = TextEditingController();
    FocusNode subjectNode = FocusNode();
    
    TextEditingController emailController = TextEditingController();
    FocusNode emailNode = FocusNode();

    TextEditingController messageController = TextEditingController();
    FocusNode messageNode = FocusNode();

    bool isLoading = false;
    
    
    return baseBottomSheet(
      child: Builder(
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  right: 21,
                  left: 21
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              
                    space(25),
              
                    Text(
                      appText.newMessage,
                      style: style20Bold(),
                    ),
              
                    space(20),
              
                    input(subjectController, subjectNode, appText.subject, iconPathLeft: AppAssets.profileSvg, isBorder: true,),
              
                    space(16),
                    
                    input(emailController, emailNode, appText.email, iconPathLeft: AppAssets.mailSvg, isBorder: true,),
              
                    space(16),
              
                    descriptionInput(messageController, messageNode, appText.messageBody, isBorder: true,),
              
                    space(20),
              
                    Center(
                      child: button(
                        onTap: () async {
                          if(messageController.text.trim().isNotEmpty && emailController.text.trim().isNotEmpty && subjectController.text.trim().isNotEmpty){
                            
                            isLoading = true;
                            state((){});

                            bool res = await ProvidersService.sendMessage(
                              id, 
                              subjectController.text.trim().toEnglishDigit(), 
                              emailController.text.trim().toEnglishDigit(), 
                              messageController.text.trim().toEnglishDigit()
                            );
                      
                            isLoading = false;
                            state((){});

                            if(res){
                              backRoute();
                            }
                          }
                        }, 
                        width: getSize().width, 
                        height: 52, 
                        text: appText.send,
                        bgColor: purplePrimary(), 
                        textColor: Colors.white,
                        isLoading: isLoading
                      ),
                    ),
              
                    space(20),
              
                  ],
                ),
              );
            }
          );
        }
      )
    );
  }



}