import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:webinar/app/models/blog_model.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/app/widgets/main_widget/blog_widget/blog_widget.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/data/app_data.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/common/utils/date_formater.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';


Future<BlogModel> blogCommentProcess(BlogModel blogData) async {

  BlogModel data = BlogModel.fromJson(blogData.toJson());

  for (var comment in blogData.comments ?? []) {
    for (var replay in comment.replies!) {
      data.comments!.removeWhere((element) => element.id == replay.id);
    }
  }

  return data;
} 


class DetailsBlogPage extends StatefulWidget {
  static const String pageName = '/details-blog';
  const DetailsBlogPage({super.key});

  @override
  State<DetailsBlogPage> createState() => _DetailsBlogPageState();
}

class _DetailsBlogPageState extends State<DetailsBlogPage> {

  BlogModel? blogData;

  bool userIsLogin = false;
  bool readData=true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      blogData = ModalRoute.of(context)!.settings.arguments as BlogModel;

      isLogin();

      if(blogData != null){
        compute(blogCommentProcess, blogData!).then((value) {
          blogData = value;

          setState(() {});
        });
      }

    });
  }

  isLogin() async {

    await Future.delayed(const Duration(seconds: 1));
    
    AppData.getAccessToken().then((value) {
      if(value.toString().isNotEmpty){
        setState(() {
          userIsLogin = true;
        });
      } 
    });
  }

  @override
  Widget build(BuildContext context) {

    if(readData){
      blogData = ModalRoute.of(context)!.settings.arguments as BlogModel;
      readData = false;
    }

    return directionality(
      child: Scaffold(
        backgroundColor: backgroundWhite(),
        body: blogData == null
      ? const SizedBox()
      : Stack(
          children: [

            // details
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsetsDirectional.all(10),
                      padding: const EdgeInsetsDirectional.only(bottom: 5, top: 10, end: 5, start: 5),
                      decoration: BoxDecoration(
                          color: appBarBg(),
                          borderRadius: borderRadius(radius: 30)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25,),
                          Row(
                            children: [
                              space(0,width: 15),
                              GestureDetector(
                                onTap: (){
                                  backRoute();
                                },
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: borderRadius()
                                  ),

                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(AppAssets.backSvg, colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
                                ),
                              ),

                              space(0,width: 14),

                              Expanded(
                                child: Text(
                                  appText.blogPost,
                                  textAlign: TextAlign.center,
                                  style: style16Bold().copyWith(color: headerTextColor(), fontSize: 18),
                                ),
                              ),
                              space(0,width: 75),

                            ],
                          ),
                          const SizedBox(height: 15,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              blogData!.title ?? '',
                              textAlign: TextAlign.left,
                              style: style16Bold(),
                            ),
                          ),
                          const SizedBox(height: 15,),
                        ],
                      ),
                    ),

                    space(20),
                    Container(
                      padding: padding(),
                      child: Column(
                        children: [
                          Hero(
                            tag: blogData!.id!,
                            child: ClipRRect(
                                borderRadius: borderRadius(radius: 25),
                                child: fadeInImage(blogData!.image ?? '', getSize().width, 210)
                            ),
                          ),

                          space(20),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if(blogData!.author != null)...{
                                ClipRRect(
                                    borderRadius: borderRadius(radius: 35),
                                    child: fadeInImage(blogData!.author!.avatar ?? '', 35, 35)),
                                space(0,width: 5),
                                Text(
                                  blogData!.author!.fullName ?? '',
                                  style: style14Regular().copyWith(color: greyText()),
                                  overflow: TextOverflow.ellipsis,
                                )
                              },
                              // date
                              Row(
                                children: [
                                  space(0,width: 15),
                                  SvgPicture.asset(AppAssets.calendarSvg, width: 12,),

                                  space(0,width: 5),

                                  Text(
                                    timeStampToDate((blogData?.createdAt ?? 0) * 1000),
                                    style: style14Regular().copyWith(color: greyText()),
                                  ),

                                ],
                              ),
                            ],
                          ),


                          space(20),

                          HtmlWidget(
                            blogData!.content ?? '',
                            textStyle: style14Regular().copyWith(color: greyText()),
                          ),

                          space(20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                appText.comments,
                                style: style16Bold().copyWith(fontSize: 18),
                              ),
                            ],
                          ),

                          space(35),

                          if(blogData!.comments?.isEmpty ?? true)...{

                            Center(
                              child: emptyState(
                                  'assets/image/png/no-comments.png',
                                  appText.noComments,
                                  appText.noCommentsDesc
                              ),
                            ),

                          }else ...{

                            // comments
                            ...List.generate(blogData!.comments?.length ?? 0, (index) {

                              return commentUi(blogData!.comments![index], (){
                                BlogWidget.showOptionDialog(blogData!.id!, blogData!.comments![index].id!,userIsLogin);
                              });
                            }),
                          },



                          space(120),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: userIsLogin ? 0 : -150,
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
                    BlogWidget.showReplayDialog(blogData!.id!, null);
                  }, 
                  width: getSize().width, 
                  height: 52, 
                  text: appText.leaveAComment, 
                  bgColor: purplePrimary(), 
                  textColor: Colors.white
                ),
              )
            )
          ],
        ),

      )
    );
  }
}