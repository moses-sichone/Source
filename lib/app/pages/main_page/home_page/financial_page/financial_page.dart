import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:webinar/app/models/offline_payment_model.dart';
import 'package:webinar/app/models/payout_model.dart';
import 'package:webinar/app/models/sales_model.dart';
import 'package:webinar/app/models/summary_model.dart';
import 'package:webinar/app/pages/main_page/home_page/payment_status_page/payment_status_page.dart';
import 'package:webinar/app/pages/main_page/home_page/single_course_page/single_content_page/web_view_page.dart';
import 'package:webinar/app/providers/user_provider.dart';
import 'package:webinar/app/services/user_service/financial_service.dart';
import 'package:webinar/app/widgets/main_widget/financial_widget.dart/financial_widget.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/data/api_public_data.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/locator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FinancialPage extends StatefulWidget {
  static const String pageName = '/financial';
  const FinancialPage({super.key});

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage>  with SingleTickerProviderStateMixin{

  late TabController tabController;
  SaleModel? saleData;
  SummaryModel? summaryData;
  PayoutModel? payoutData;
  List<OfflinePaymentModel> offlinePayments = [];

  bool isLoadingSummaryData = true;
  bool isLoadingOfflinePaymentData = true;
  bool isLoadingPayoutData = true;
  bool isLoadingSalesData = true;
 
  bool isLoadingCharge = false;

  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();

    if(locator<UserProvider>().profile?.roleName == PublicData.userRole){
      tabController = TabController(length: 3, vsync: this);
    }else{
      tabController = TabController(length: 4, vsync: this);
    }

    getSummaryData();
    getOfflinePaymentData();
    
    if(locator<UserProvider>().profile?.roleName != PublicData.userRole){
      getSalesData();
    }
    getPayoutData();

    initUniLinks();
  } 

  Future<void> initUniLinks() async {
    
    _sub = linkStream.listen((String? link) {
      if(link != null){
        
        if(link == 'academyapp://payment-success'){
          getSummaryData();
          nextRoute(PaymentStatusPage.pageName, arguments: 'success');
        }else if(link == 'academyapp://payment-failed'){
          nextRoute(PaymentStatusPage.pageName, arguments: 'failed');
        }

      }
    }, onError: (err) {});
    
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  getSummaryData() async {

    setState(() {
      isLoadingSummaryData = true;
    });
    
    summaryData = await FinancialService.getSummaryData();
    
    setState(() {
      isLoadingSummaryData = false;
    });
  }

  getPayoutData() async {

    setState(() {
      isLoadingPayoutData = true;
    });
    
    payoutData = await FinancialService.getPayoutData();
    
    setState(() {
      isLoadingPayoutData = false;
    });
  }

  getSalesData() async {

    setState(() {
      isLoadingSalesData = true;
    });
    
    saleData = await FinancialService.getSalesData();
    
    setState(() {
      isLoadingSalesData = false;
    });
  }

  getOfflinePaymentData() async {

    setState(() {
      isLoadingOfflinePaymentData = true;
    });
    
    offlinePayments = await FinancialService.getOfflinePayments();
    
    setState(() {
      isLoadingOfflinePaymentData = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return directionality(
      child: Scaffold(
        backgroundColor: backgroundWhite(),
        appBar: appbar(title: appText.financial, leftMargin: 16),

        body: Column(
          children: [

            tabBar(
              (i){

              }, 
              tabController,
              [
                Tab(text: appText.summary, height: 32),
                Tab(text: appText.offlinePayment, height: 32),
                
                if(locator<UserProvider>().profile?.roleName != PublicData.userRole)...{
                  Tab(text: appText.sales, height: 32),
                },

                Tab(text: appText.payout, height: 32),
              ]
            ),

            Expanded(
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                controller: tabController,
                children: [

                  isLoadingSummaryData
                  ? loading()
                  : FinancialWidget.summaryPage(summaryData, getSummaryData, isLoadingCharge, () async {
                      isLoadingCharge = true;
                      setState(() {});

                      String? link = await FinancialService.webLinkCharge();

                      isLoadingCharge = false;
                      setState(() {});

                      if(link != null){
                        bool? res = await nextRoute(WebViewPage.pageName, arguments: [link, appText.charge, true, LoadRequestMethod.get]);
                        
                        if(res ?? false){
                          getSummaryData();
                        }
                      }
                    }),

                  isLoadingOfflinePaymentData
                  ? loading()
                  : FinancialWidget.offlinePaymentPage(offlinePayments),

                  if(locator<UserProvider>().profile?.roleName != PublicData.userRole)...{
                    isLoadingSalesData
                    ? loading()
                    : FinancialWidget.salesPage(saleData),
                  },

                  isLoadingPayoutData
                  ? loading()
                  : FinancialWidget.payoutPage(payoutData, getPayoutData),

                ]
              )
            )

          ],
        ),
      )
    );
  }
}