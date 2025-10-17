import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webinar/app/models/blog_model.dart';
import 'package:webinar/app/services/user_service/comments_service.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';

import '../../../../widgets/main_widget/comments_widget/comments_widget.dart';

class CommentDetailsPage extends StatefulWidget {
  static const String pageName = '/comment-details';
  const CommentDetailsPage({super.key});

  @override
  State<CommentDetailsPage> createState() => _CommentDetailsPageState();
}

class _CommentDetailsPageState extends State<CommentDetailsPage> {

  Comments? comment;
  bool isUser=true;

  bool isDeleting = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      comment = (ModalRoute.of(context)!.settings.arguments as List)[0];
      isUser = (ModalRoute.of(context)!.settings.arguments as List)[1];

      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    return directionality(
      child: Scaffold(
        backgroundColor: backgroundWhite(),
        appBar: appbar(title: appText.commentDetails, leftMargin: 15),

        body: comment == null
      ? const SizedBox()
      : Stack(
          children: [

            // details
            Positioned.fill(
              child: Padding(
                padding: padding(),
                child: Column(
                  children: [
              
                    space(20),

                    if(isUser)...{

                      Container(
                        width: getSize().width,
                        padding: padding(horizontal: 5, vertical: 5),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: borderRadius(radius: 18)
                        ),

                        child: Row(
                          children: [

                            // video
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

                            space(0, width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                            
                                  Text(
                                    appText.thisCommentIsFor,
                                    style: style12Regular().copyWith(color: greyB2),
                                  ),
                            
                                  space(4),
                                  
                                  Text(
                                    comment?.webinar?.title ?? '',
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

                      space(16),
                    },
              
                    userProfile(comment!.user!),
              
                    space(16),
              
                    SizedBox(
                      width: getSize().width,
                      child: Text(
                        comment?.comment ?? '',
                        style: style14Regular().copyWith(color: greyText()),
                      ),
                    ),
              
                  ],
                ),
              )
            ),



            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              bottom: 0,
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
                child: isUser
              ? Row(
                  children: [

                    Expanded(
                      child: button(
                        onTap: () async {
                          String? res = await CommentsWidget.showEditDialog(comment!.id!, comment!.comment!);

                          if(res != null){
                            comment!.comment = res;
                            setState(() {});
                          }
                        },
                        width: getSize().width, 
                        height: 52, 
                        text: appText.edit, 
                        bgColor: purplePrimary(), 
                        textColor: Colors.white,
                        raduis: 35
                      ),
                    ),

                    space(0, width: 20),

                    Expanded(
                      child: button(
                        onTap: () async {
                          
                          setState(() {
                            isDeleting = true;
                          });

                          bool res = await CommentsService.delete(comment!.id!);

                          setState(() {
                            isDeleting = false;
                          });

                          if(res){
                            backRoute();
                          }

                        },
                        width: getSize().width, 
                        height: 52, 
                        text: appText.delete, 
                        bgColor: red49, 
                        textColor: Colors.white,
                        raduis: 35,
                        isLoading: isDeleting
                      ),
                    ),
                    
                  ],
                )
              : Row(
                  children: [

                    Expanded(
                      child: button(
                        onTap: () async {
                          CommentsWidget.showReplayDialog(comment!.id!);
                        },
                        width: getSize().width, 
                        height: 52, 
                        text: appText.reply, 
                        bgColor: purplePrimary(), 
                        textColor: Colors.white,
                        raduis: 35
                      ),
                    ),

                    space(0, width: 20),

                    Expanded(
                      child: button(
                        onTap: () async {
                          CommentsWidget.showReportDialog(comment!.id!);           
                        },
                        width: getSize().width, 
                        height: 52, 
                        text: appText.report, 
                        bgColor: Colors.white, 
                        textColor: purplePrimary(),
                        borderColor: purplePrimary(),
                        raduis: 35
                      ),
                    ),
                    
                  ],
                ),
              )
            ),
              

          ],

        ),

      )
    );
  }
}