
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webinar/app/models/list_quiz_model.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/common/utils/date_formater.dart';

import '../../../../common/badges.dart';
import '../../../../common/common.dart';
import '../../../../config/assets.dart';
import '../../../../config/colors.dart';
import '../../../../config/styles.dart';
import '../../../models/quize_model.dart';

class QuizzesWidget{

  static Widget item(Quiz data, Function onTap, {bool isMyResult=true, String? userGrade, String? status, bool isShowQuestionCount=false, bool isShowStatus=true, bool isShowQuizTime=false}){  
    
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        width: getSize().width,
        height: 100,
        padding: padding(horizontal: 8,vertical: 8),
        margin: const EdgeInsets.only(bottom: 16),
        
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius()
        ),

        child: Row(
          children: [
            ClipRRect(
              borderRadius: borderRadius(radius: 15),
              child: fadeInImage(data.webinar?.image ?? '', 80, 100),
            ),

            space(0, width: 12),

            Expanded(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      space(4),

                      Text(
                        data.title ?? '',
                        style: style14Bold().copyWith(fontWeight: FontWeight.w700),
                      ),

                      space(1),

                      Text(
                        data.webinar?.title ?? '',
                        style: style12Regular().copyWith(color: greyText()),
                        maxLines: 1,
                      ),

                      const Spacer(flex: 3),

                      Row(
                        children: [

                          // date
                          Row(
                            children: [
                              Image.asset( isShowQuizTime ? 'assets/image/png/clock-2.png' : 'assets/image/png/CalendarDots.png', width: 12,),

                              space(0,width: 4),

                              if(isShowQuizTime)...{

                                Text(
                                  '${data.time} ${appText.min}',
                                  style: style12Regular().copyWith(color: greyText()),
                                )
                              } else...{

                                Text(
                                  timeStampToDate((data.webinar?.createdAt ?? 0) * 1000),
                                  style: style12Regular().copyWith(color: greyText()),
                                )
                              }

                            ],
                          ),

                          if(isMyResult)...{
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 4, height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withOpacity(0.3)
                              ),
                            ),
                            // Grade
                            Row(
                              children: [
                                Image.asset(
                                  'assets/image/png/Trophy.png',
                                  color:
                                    status == 'passed'
                                    ? Colors.green
                                    : status == 'waiting'
                                      ? yellow29
                                      : status == 'failed'
                                        ? red49
                                        : yellow29,
                                  width: 13,
                                ),

                                space(0,width: 4),

                                Text(
                                  '$userGrade',
                                  style: style12Regular().copyWith(
                                    color: status == 'passed'
                                      ? Colors.green
                                      : status == 'waiting'
                                        ? yellow29
                                        : status == 'failed'
                                          ? red49
                                          : yellow29,
                                  ),
                                ),

                                space(0,width: 12),

                              ],
                            ),

                          },


                          if(isShowQuestionCount)...{
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 4, height: 4,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.3)
                              ),
                            ),
                            // question count
                            Row(
                              children: [

                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: greyB2
                                  ),
                                  alignment: Alignment.center,

                                  child: SvgPicture.asset(
                                    AppAssets.questionSvg,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn
                                    ),
                                    height: 6,
                                  ),
                                ),

                                space(0,width: 5),

                                Text(
                                  data.questioncount?.toString() ?? '',
                                  style: style12Regular().copyWith(color: greyText()),
                                ),


                              ],
                            ),

                            space(0,width: 12),
                          }



                        ],
                      ),

                      space(4),
                    ],
                  ),

                  // status
                  if(isShowStatus)...{
                    PositionedDirectional(
                      end: 6,
                      top: 6,
                      child: status == 'passed'
                          ? Badges.passed()
                          : status == 'waiting'
                          ? Badges.waiting()
                          : status == 'failed'
                          ? Badges.failed()
                          : const SizedBox(),
                    )
                  },
                ],
              ),
            ),

          ],
        ),

      ),
    );

  }
  
  
  static Widget listItem(ListQuizModel data, Function onTap){  
    
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius()
        ),
      
        width: getSize().width,
        height: 100,
        padding: padding(horizontal: 12,vertical: 8),
        margin: const EdgeInsets.only(bottom: 16),
        
        child: Row(
          children: [
            
            ClipRRect(
              borderRadius: borderRadius(radius: 15),
              child: fadeInImage(data.webinar?.thumbnail ?? '', 130, 100),
            ),
        
            space(0, width: 12),
        
            Expanded(
              child: Container(
                width: getSize().width,
                height: 100,
                margin: const EdgeInsets.only(bottom: 16),
                
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: borderRadius()
                ),
              
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                
                    space(4),
                    
                    Text(
                      data.getTitle(),
                      style: style14Bold(),
                      maxLines: 1,
                    ),
                
                    const Spacer(flex: 1),
                    
                    Text(
                      data.webinar?.getTitle() ?? '',
                      style: style10Regular().copyWith(color: greyText()), 
                    ),
                    
                    const Spacer(flex: 4),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                
                        // date
                        Row(
                          children: [
                            SvgPicture.asset( AppAssets.timeCircleSvg, width: 12,),
                            
                            space(0,width: 4),
                
                            Text(
                              '${data.time} ${appText.min}',
                              style: style10Regular().copyWith(color: greyText()), 
                            )
                           
                          ],
                        ),
                
                
                        Row(
                          children: [
                          
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: greyB2
                              ),
                              alignment: Alignment.center,
                              
                              child: SvgPicture.asset(
                                AppAssets.questionSvg, 
                                colorFilter: const ColorFilter.mode(
                                  Colors.white, 
                                  BlendMode.srcIn
                                ),
                                height: 6,
                              ),
                            ),
                            
                            space(0,width: 5),
                          
                            Text(
                              data.questionCount?.toString() ?? '-',
                              style: style12Regular().copyWith(color: greyText()), 
                            ),
                            
                            space(0,width: 12),
                          
                          ],
                        ),
                          
                        
                          
                
                          
                      ],
                    ),
                
                    space(4),
                  ],
                ),
              
              ),
            ),
          ],
        ),
      ),
    );

  }

  
}