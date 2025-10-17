import 'package:flutter/material.dart';
import 'package:webinar/app/models/profile_model.dart';
import 'package:webinar/app/pages/main_page/providers_page/user_profile_page/select_date_page.dart';
import 'package:webinar/app/providers/user_provider.dart';
import 'package:webinar/app/services/guest_service/providers_service.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/common/utils/currency_utils.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';
import 'package:webinar/locator.dart';

import '../../../../widgets/main_widget/provider_widget/user_profile_widget.dart';

class UserProfilePage extends StatefulWidget {
  static const String pageName = '/user-profile';
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> with TickerProviderStateMixin{

  bool isLoading = true;

  ProfileModel? profile;
  late TabController tabController;

  int currentTab=0;

  bool isShowAboutButton = true;
  bool isShowMeetingButton = false;

  ScrollController scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    

    tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      int? id = ModalRoute.of(context)!.settings.arguments as int;

      getData(id);
    });


    tabController.addListener(() {
      onChangeTab(tabController.index);
    });
    
  }


  getData(int id) async {
    setState(() {
      isLoading = true;
    });
    
    profile = await ProvidersService.getUserProfile(id);
    
    
    if(profile?.roleName == 'organization'){
      tabController = TabController(length: (profile?.meetingStatus == 'no') ? 4 : 5, vsync: this);
    }else{
      tabController = TabController(length: (profile?.meetingStatus == 'no') ? 3 : 4, vsync: this);
    }
    
    setState(() {
      isLoading = false;
    });
  }

  offAllButton(){
    isShowAboutButton = false;
    isShowMeetingButton = false;
  }

  onChangeTab(int tab){
    offAllButton();

    if(tab == 0){
      offAllButton();
      isShowAboutButton = true;
    }
    
    if(tab == 3){
      offAllButton();
      isShowMeetingButton = true;
    }

    setState(() {
      currentTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return directionality(
      child: Scaffold(
        appBar: appbar(title: 'Instructor Details', leftMargin: 15),
        backgroundColor: backgroundWhite(),
        body: isLoading
      ? loading()
      : Stack(
          children: [

            Positioned.fill(
              child: NestedScrollView(
                headerSliverBuilder: (_,__) {
                  return [
                    
                    // image + name + 3 item
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          space(20),

                          // image
                          Stack(
                            children: [
                              ClipRRect(  
                                borderRadius: borderRadius(radius: 20),
                                child: fadeInImage(profile?.avatar ?? '', 120, 120),
                              ),  

                              // if(profile?.verified == 1)...{
                              //   PositionedDirectional(
                              //     end: 0,
                              //     top: 12,
                              //     child: Container(
                              //       width: 20,
                              //       height: 20,
                              //       decoration: BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         color: blueFE
                              //       ),
                              //       child: const Icon(Icons.check, color: Colors.white, size: 14),
                              //     )
                              //   ),
                              // }

                            ],
                          ),

                          space(10),

                          Text(
                            profile?.fullName ?? '',
                            style: style20Bold(),
                          ),

                          space(6),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ratingBar(profile?.rate ?? '0', itemSize: 15),
                              space(0, width: 4),
                              Text(profile?.rate ?? '0', style: style12Bold().copyWith(color: Colors.black),),
                            ],
                          ),

                          space(24),

                          // classes + students + followers
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              const SizedBox(),

                              // classes
                              UserProfileWidget.profileItem(appText.classes, profile?.webinars?.length.toString() ?? '0', '', green50),
                              
                              // students
                              UserProfileWidget.profileItem(appText.students, profile?.students?.length.toString() ?? '0', '', blueFE, width: 25),
                              
                              // followers
                              UserProfileWidget.profileItem(appText.followers, profile?.followersCount.toString() ?? '0', '', yellow29, width: 25),

                              const SizedBox(),

                            ],
                          ),
                          
                          space(12),

                        ],
                      ),
                    ),

                    // tab
                    SliverAppBar(
                      pinned: true,
                      titleSpacing: 25,
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      backgroundColor: backgroundWhite(),
                      shadowColor: Colors.grey.withOpacity(.12),
                      elevation: 8,
                      title: SizedBox(
                        width: getSize().width,
                        child: tabBar(
                          (i) {
                            onChangeTab(i);
                          }, 
                          tabController, 
                          [
                            Tab(
                              height: 32,
                              child: Text(
                                appText.about,
                              ),
                            ),

                            Tab(
                              height: 32,
                              child: Text(
                                appText.classes
                              ),
                            ),

                            Tab(
                              height: 32,
                              child: Text(
                                appText.badges
                              ),
                            ),

                            if((profile?.meetingStatus != 'no'))...{

                              Tab(
                                height: 32,
                                child: Text(
                                  appText.meeting
                                ),
                              ),
                            },

                            if(profile?.roleName == 'organization')...{
                              Tab(
                                height: 32,
                                child: Text(
                                  appText.instrcutors
                                ),
                              ),
                            }
                            
                          ],
                          horizontalPadding: 24
                        )
                      ),
                    ),

                  ];
                }, 
                body: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  controller: tabController,
                  children: [

                    UserProfileWidget.aboutPage(profile ?? ProfileModel()),

                    UserProfileWidget.classesPage(profile ?? ProfileModel()),

                    UserProfileWidget.badgesPage(profile ?? ProfileModel()),

                    if((profile?.meetingStatus != 'no'))...{
                      UserProfileWidget.meetingPage(profile ?? ProfileModel()),
                    },

                    if(profile?.roleName == 'organization')...{
                      UserProfileWidget.instructorPage(profile  ?? ProfileModel(),),
                    }

                  ]
                )
              )
            ),


            // about button
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: isShowAboutButton ? 0 : -150,
              child: Container(
                width: getSize().width * .9,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: purplePrimary().withOpacity(0.08),
                    boxShadow: [
                      boxShadow(Colors.black.withOpacity(.1),blur: 15,y: -3)
                    ],
                    borderRadius: BorderRadius.circular(35)
                ),

                child: Row(
                  children: [

                    Expanded(
                      child: button(
                        onTap: (){

                          if(locator<UserProvider>().profile != null){
                            
                            profile?.authUserIsFollower = !(profile?.authUserIsFollower ?? false);
                            ProvidersService.follow(profile!.id!, (profile?.authUserIsFollower ?? false));

                            setState(() {});
                          }
                        }, 
                        width: getSize().width, 
                        height: 51, 
                        text: (profile?.authUserIsFollower ?? false) ? appText.unFollow : appText.follow, 
                        bgColor: purplePrimary(),
                        textColor: Colors.white,
                        borderColor: purplePrimary()
                      )
                    ),

                    if(profile?.publicMessage == 1)...{
                      space(0,width: 20),
                      
                      Expanded(
                        child: button(
                          onTap: (){
                            UserProfileWidget.showSendMessageDialog(profile!.id!);
                          }, 
                          width: getSize().width, 
                          height: 51, 
                          text: appText.sendMessage, 
                          bgColor: purplePrimary(), 
                          textColor: Colors.white
                        )
                      ),

                    }

                  ],
                ),
              ),
            ),

            // meeting button
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: isShowMeetingButton ? 0 : -150,
              child: Container(
                width: getSize().width * .9,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: purplePrimary().withOpacity(0.08),
                    boxShadow: [
                      boxShadow(Colors.black.withOpacity(.1),blur: 15,y: -3)
                    ],
                    borderRadius: BorderRadius.circular(35)
                ),

                child: button(
                  onTap: (){
                    baseBottomSheet(child: SelectDatePage(profile!.id!, profile!));
                  },
                  width: getSize().width,
                  height: 51,
                  text: appText.reserveMeeting,
                  bgColor: purplePrimary(),
                  textColor: Colors.white
                ),
              ),
            ),


          ],
        ),
      )
    );
  }
}