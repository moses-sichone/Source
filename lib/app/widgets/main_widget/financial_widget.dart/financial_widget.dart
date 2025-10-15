import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webinar/app/models/payout_model.dart';
import 'package:webinar/app/models/sales_model.dart';
import 'package:webinar/app/models/summary_model.dart';
import 'package:webinar/app/services/user_service/financial_service.dart';
import 'package:webinar/common/badges.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/common/utils/currency_utils.dart';
import 'package:webinar/common/utils/date_formater.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';

import '../../../models/offline_payment_model.dart';

class FinancialWidget{

  
  static Widget summaryPage(SummaryModel? summary, Function getData, bool isLoadingCharge, Function onTapCharge){
    
    return summary == null
  ? const SizedBox()
  : SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.hardEdge,

      child: Column(
        children: [

          space(20),

          financialCard(
            CurrencyUtils.calculator(
              summary.balance ?? 0, 
              // fractionDigits: int.tryParse(PublicData.apiConfigData['currency_decimal'].toString()) ?? 0
            ), 
            appText.accountBalance, 
            appText.charge, 
            () async { // charge
            
              onTapCharge();

            }, 
            AppAssets.walletSvg, 
            purplePrimary(),
            isLoading: isLoadingCharge
          ),

          space(35),


          Padding(
            padding: padding(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  appText.balancesHistory,
                  style: style16Bold(),
                ),

                space(16),

                (summary.history?.isEmpty ?? true)
              ? Container(
                  margin: const EdgeInsets.only(top: 60),
                  child: emptyState(AppAssets.noBalanceEmptyStateSvg, appText.noBalance, appText.noBadgesDesc)
                )
              : Column(
                  children: List.generate(summary.history?.length ??0, (index) {
                    return historyItem(
                      summary.history?[index].description ?? '', 
                      timeStampToDateHour((summary.history?[index].createdAt ?? 0) * 1000), 
                      CurrencyUtils.calculator(summary.history?[index].amount), 
                      summary.history?[index].balanceType == 'addition' // addition | deduction
                    );
                  }),
                )
              ],
            ),
          )


        ],
      ),
    );
    
  }

  static Widget offlinePaymentPage(List<OfflinePaymentModel> offlinePayments){
    return (offlinePayments.isEmpty)
  ? Center(child: emptyState(AppAssets.offlinePaymentEmptyStateSvg, appText.noOfflinePayments, appText.noOfflinePaymentsDesc))
  : Padding(
      padding: padding(),
      child: SingleChildScrollView(
        child: Column(
          children: [
          
            space(12),
          
            ...List.generate(offlinePayments.length, (index) {
              return offlinePaymentItem(offlinePayments[index]);
            }),
            
            space(12),
          ],
        ),
      ),
    );
  }
  
  static Widget payoutPage(PayoutModel? payout, Function getData){
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [

          space(20),

          financialCard(
            CurrencyUtils.calculator(
              payout?.currentPayout?.withdrawableAmount ?? 0, 
              // fractionDigits: int.tryParse(PublicData.apiConfigData['currency_decimal'].toString()) ?? 0
            ),
            appText.readyToPayout, 
            (payout?.currentPayout?.withdrawableAmount ?? 0) == 0.0 ? '' : appText.requestPayout, 
            () async { // request
              bool? res = await payoutRequestSheet(payout!.currentPayout!);

              if(res != null && res){
                getData();
              }
            }, 
            AppAssets.walletSvg, 
            blue64()
          ),

          space(35),


          Padding(
            padding: padding(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  appText.payoutHistory,
                  style: style16Bold(),
                ),
                
                
                (payout?.payouts?.isEmpty ?? true)
              ? Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 60),
                  child: emptyState('assets/image/png/empty-box.png', appText.noPayout, appText.noPayoutDesc)
                )
              : Column(
                  children: [

                    space(12),

                    ...List.generate(payout?.payouts?.length ?? 0, (index) {
                      return payoutItem(
                        payout?.payouts?[index].accountBankName?.getTitle() ?? '', 
                        timeStampToDateHour((payout?.payouts?[index].createdAt ?? 0) * 1000), 
                        CurrencyUtils.calculator(double.parse(payout?.payouts?[index].amount?.toString() ?? '0.0')), 
                        payout?.payouts?[index].status ?? '', 
                      );
                    })
                  ],
                ),


              ]
            )
          ),


        ],
      ),
    );
  }

  static Widget salesPage(SaleModel? data){
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: padding(vertical: 20),
      
      child: Column(
        children: [

          // 3 item
          Container(
            width: getSize().width,
            padding: padding(horizontal: 4,vertical: 18),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: borderRadius(),
              border: Border.all(color: greyE7)
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                // pending
                Column(
                  children: [

                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: green50.withOpacity(.3),
                        shape: BoxShape.circle
                      ),
                      alignment: Alignment.center,

                      child: SvgPicture.asset(AppAssets.videoSvg, colorFilter:  ColorFilter.mode(green50, BlendMode.srcIn), width: 20,),
                    ),

                    space(8),

                    Text(
                      data?.webinarsCount?.toString() ?? '0',
                      style: style14Bold(),
                    ),

                    space(4),

                    Text(
                      appText.classSales,
                      style: style12Regular().copyWith(color: greyB2),
                    ),
                    
                    space(4),
                    
                    Text(
                      CurrencyUtils.calculator(double.tryParse(data?.classSales?.toString() ?? '0') ?? 0),
                      style: style12Regular().copyWith(color: green50),
                    ),

                  ],
                ),

                // Passed
                Column(
                  children: [

                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: blueFE.withOpacity(.3),
                        shape: BoxShape.circle
                      ),
                      alignment: Alignment.center,

                      child: SvgPicture.asset(AppAssets.provideresSvg, colorFilter:  ColorFilter.mode(blueFE, BlendMode.srcIn), width: 20,),
                    ),

                    space(8),

                    Text(
                      data?.meetingsCount?.toString() ?? '0',
                      style: style14Bold(),
                    ),

                    space(4),

                    Text(
                      appText.meetingSales,
                      style: style12Regular().copyWith(color: greyB2),
                    ),

                    space(4),
                    
                    Text(
                      CurrencyUtils.calculator(double.tryParse(data?.meetingSales?.toString() ?? '0') ?? 0),
                      style: style12Regular().copyWith(color: blueFE),
                    ),

                  ],
                ),

                // Total Sales
                Column(
                  children: [

                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: yellow4C.withOpacity(.3),
                        shape: BoxShape.circle
                      ),
                      alignment: Alignment.center,

                      child: SvgPicture.asset(AppAssets.walletSvg, colorFilter:  ColorFilter.mode(yellow4C.withOpacity(.6), BlendMode.srcIn), width: 20,),
                    ),

                    space(8),

                    Text(
                      ((data?.meetingsCount ?? 0) + (data?.webinarsCount ?? 0)).toString(),
                      style: style14Bold(),
                    ),

                    space(4),

                    Text(
                      appText.totalSales,
                      style: style12Regular().copyWith(color: greyB2),
                    ),

                    space(4),
                    
                    Text(
                      CurrencyUtils.calculator(double.tryParse(data?.totalSales?.toString() ?? '0') ?? 0),
                      style: style12Regular().copyWith(color: yellow4C),
                    ),

                  ],
                ),

              ],
            ),
          ),
          
          space(16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              space(0,width: getSize().width),
              
              Text(
                appText.salesHistory,
                style: style16Bold(),
              ),

              space(16),

              (data?.sales?.isEmpty ?? true)
            ? Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 60),
                child: emptyState(AppAssets.salesEmptyStateSvg, appText.noSales, appText.noSalesDesc)
              )
            : Column(
                children: [

                  ...List.generate(data?.sales?.length ?? 0, (index) {
                    return userCard(
                      data!.sales![index].buyer?.avatar ?? '', 
                      data.sales![index].buyer?.fullName ?? '', 
                      data.sales![index].webinar?.title ?? '', 
                      timeStampToDateHour((data.sales![index].createdAt ?? 0) * 1000), 
                      CurrencyUtils.calculator(double.tryParse(data.sales![index].amount ?? '0') ?? 0), 
                      data.sales![index].type ?? '', 
                      (){

                      }
                    );
                  }),

                  space(12),
                ],
              )
            ],
          ),


        ],
      ),

    );
  }

  



  static Widget financialCard(String amount, String subtitle, String buttonText, Function onTapButton, String icon, Color iconBgColor, {bool isBg=false, Function? onTapBox, bool isLoading=false}){
    return GestureDetector(
      onTap: (){
        onTapBox!();
      },
      child: Container(
        padding: padding(),
        
        width: getSize().width / 1.0,
        height: 80,
        decoration: const BoxDecoration(),
        child: Container(
          width: getSize().width,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius(radius: 18),
            boxShadow: [boxShadow(Colors.black.withOpacity(.03), blur: 15 ,y: 3)]
          ),
          clipBehavior: Clip.hardEdge,

          padding: const EdgeInsetsDirectional.only(
            start: 10,
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,

                    decoration: BoxDecoration(
                        color: backgroundWhite(),
                        borderRadius: borderRadius(radius: 14)
                    ),
                    alignment: Alignment.center,
                    child: Image.asset('assets/image/png/wallet.png', width: 35, height: 35,),
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      Text(
                        amount,
                        style: style22Bold(),
                      ),

                      space(2),

                      Text(
                        subtitle,
                        style: style14Regular().copyWith(color: greyB2),
                      ),

                    ],
                  ),
                ],
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: button(
                      onTap: () {
                        onTapButton();
                      },
                      width: 100,
                      height: 40,
                      text: buttonText,
                      bgColor: purplePrimary(),
                      textColor: Colors.white,
                      borderColor: purplePrimary(),
                      raduis: 30,
                      horizontalPadding: 18,
                      isLoading: isLoading,
                      loadingColor: purplePrimary()
                  ),
                ),
              ),

            ],
          ),

        ),
      ),
    );
  }


  static Widget historyItem(String title, String date, String amount, bool isUp){
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: getSize().width,
      height: 85,
      padding: padding(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius(radius: 18),
      ),

      child: Row(
        children: [

          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: isUp ? green() : red(),
              borderRadius: borderRadius(radius: 16)
            ),

            child: Icon(
              isUp ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.white,
              size: 40,
            ),
          ),

          space(0, width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: style16Bold().copyWith(color: headerTextColor()),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                space(8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    Text(
                      date,
                      style: style12Regular().copyWith(color: greyText()),
                    ),


                    Text(
                      '${isUp ? '+' : '-'}$amount',
                      style: style16Bold().copyWith(color: isUp ? green() : red()),
                    ),
                  ],
                )
              ],
            )
          ),
        ],
      ),
    );
  } 

  static Widget offlinePaymentItem(OfflinePaymentModel data){
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: getSize().width,
        height: 85,
        padding: padding(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.only(bottom: 16),
        
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius(radius: 16)
        ),

        child: Row(
          children: [
          
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: data.status == 'approved'
                  ? green()
                  : data.status == 'waiting'
                    ? yellow29
                    : red(),
                borderRadius: borderRadius(radius: 10) 
              ),
              alignment: Alignment.center,

              child: Image.asset('assets/image/png/wallet.png', width: 30),
            ),

            space(0, width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
            
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${appText.ref}: ${data.referenceNumber}',
                        style: style14Bold().copyWith(color: headerTextColor()),
                        maxLines: 1,
                      ),


                      if(data.status == 'waiting' )...{
                        Badges.pending(),
                      }else if(data.status == 'rejected' )...{
                        Badges.rejected(),
                      }
                    ],
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // date
                      Text(
                        timeStampToDateHour((int.parse(data.payDate ?? '0')) * 1000),
                        style:style10Regular().copyWith(color: greyText()),
                      ),


                      Text(
                        CurrencyUtils.calculator(data.amount),
                        style: style16Regular().copyWith(color: purplePrimary()), 
                      )
                    ],
                  )

            
                ],
              ),
            )
          ],
        ),

      ),
    );

  } 

  static Widget payoutItem(String title, String date, String amount, String status){
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: getSize().width,
      height: 100,
      padding: padding(horizontal: 16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius(),
      ),

      child: Row(
        children: [

          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: status == 'done' 
                ? purplePrimary() 
                : status == 'waiting'
                  ? yellow29
                  : red49,
              borderRadius: borderRadius(radius: 10) 
            ),
            alignment: Alignment.center,

            child: SvgPicture.asset(AppAssets.walletSvg, width: 20),
          ),

          space(0, width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      title,
                      style: style14Bold(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),


                    status == 'done' 
                    ? const SizedBox()
                    : status == 'waiting'
                      ? Badges.pending()
                      : Badges.rejected(),

                  ],
                ),

                space(8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    Text(
                      date,
                      style: style12Regular().copyWith(color: greyA5),
                    ),


                    Text(
                      amount,
                      style: style16Bold().copyWith(color: purplePrimary()),
                    )
                    
                  ],
                )
              ],
            )
          ),



        ],
      ),
    );
  } 




  static payoutRequestSheet(CurrentPayout data) async {
    bool isLoading = false;
    
    return await baseBottomSheet(
      child: Padding(
        padding: padding(),
        child: StatefulBuilder(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
      
                space(16),
                
                Text(
                  appText.requestPayout,
                  style: style16Bold(),
                ),
      
                space(6),
                
                Text(
                  appText.requestPayoutDesc,
                  style: style12Regular().copyWith(color: greyA5),
                ),
      
                space(32),
      
                Center(
                  child: Column(
                    children: [
                      
                      Image.network(data.bank?.logo ?? '', width: 70,),
                      
                      space(4),
                      
                      Text(
                        data.bank?.name ?? '',
                        style: style16Bold(),
                      ),
                    ],
                  ),
                ),

                space(30),

                // amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      appText.amount,
                      style: style14Bold(),
                    ),
                    
                    Text(
                      CurrencyUtils.calculator(data.withdrawableAmount),
                      style: style14Regular().copyWith(color: greyB2),
                    ),
                  ],
                ),

                space(14),

                ...List.generate(data.bankSpecifications?.length ?? 0, (index){
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      
                          Text(
                            data.bankSpecifications?[index].name ?? '',
                            style: style14Bold(),
                          ),
                          
                          Text(
                            data.bankSpecifications?[index].value ?? '',
                            style: style14Regular().copyWith(color: greyB2),
                          ),
                        ],
                      ),

                      space(14),

                    ],
                  );

                }),


                Center(
                  child: button(
                    onTap: () async {
                      isLoading = true;
                      state((){});
                      
                      bool res = await FinancialService.requestPayout(data.withdrawableAmount);
                      
                      isLoading = false;
                      state((){});

                      if(res){
                        backRoute(arguments: true);
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

                space(40),
      
              ],
            );
          }
        ),
      )
    );
  }

}