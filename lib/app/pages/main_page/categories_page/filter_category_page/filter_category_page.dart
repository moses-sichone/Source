import 'package:flutter/material.dart';
import 'package:webinar/app/models/category_model.dart';
import 'package:webinar/app/models/course_model.dart';
import 'package:webinar/app/models/filter_model.dart';
import 'package:webinar/app/pages/main_page/categories_page/filter_category_page/dynamiclly_filter.dart';
import 'package:webinar/app/pages/main_page/categories_page/filter_category_page/options_filter.dart';
import 'package:webinar/app/providers/filter_course_provider.dart';
import 'package:webinar/app/services/guest_service/categories_service.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/shimmer_component.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/common/utils/tablet_detector.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/locator.dart';

import '../../../../services/guest_service/course_service.dart';
import '../../../../../common/components.dart';
import '../../../../widgets/main_widget/home_widget/home_widget.dart';

class FilterCategoryPage extends StatefulWidget {
  static const String pageName = '/filter-caregory';
  const FilterCategoryPage({super.key});

  @override
  State<FilterCategoryPage> createState() => _FilterCategoryPageState();
}

class _FilterCategoryPageState extends State<FilterCategoryPage> {

  bool isLoading = false;
  bool isGrid=true;

  
  CategoryModel? category;

  List<CourseModel> data = [];
  List<CourseModel> featuredListData = [];
  List<FilterModel> filters = [];
  
  ScrollController scrollController = ScrollController();

  PageController sliderPageController = PageController();
  int currentSliderIndex = 0;




  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      // if(ModalRoute.of(context)!.settings.arguments != null){
        category = (ModalRoute.of(context)!.settings.arguments as CategoryModel?);

        getData();
        getFilters();
        getFeatured();
      // }
    });

    scrollController.addListener(() {
      var min = scrollController.position.pixels;
      var max = scrollController.position.maxScrollExtent;

      if((max - min) < 300){
        if(!isLoading){
          getData();
        }
      }

    });

    
  }

  getData() async {

    setState(() {
      isLoading = true;
    });
    

    data += await CourseService.getAll(
      offset: data.length, 
      cat: category?.id?.toString(),
      filterOption: locator<FilterCourseProvider>().filterSelected,
      upcoming: locator<FilterCourseProvider>().upcoming,
      free: locator<FilterCourseProvider>().free,
      discount: locator<FilterCourseProvider>().discount,
      downloadable: locator<FilterCourseProvider>().downloadable,
      sort: locator<FilterCourseProvider>().sort,
      bundle: locator<FilterCourseProvider>().bundleCourse,
      reward: locator<FilterCourseProvider>().rewardCourse
    );
    
    setState(() {
      isLoading = false;
    });
  }

  getFilters() async {
    if(category != null){
      filters = await CategoriesService.getFilters(category!.id!);

      locator<FilterCourseProvider>().filters = filters;

      setState(() {});
    }
  }

  getFeatured(){
    if(category != null){
      CourseService.featuredCourse(cat: category!.id!.toString()).then((value) {
        setState(() {
          featuredListData = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
        
    return directionality(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [

              // app bar
              Container(
                decoration: BoxDecoration(
                    color: appBarBg().withOpacity(0.8),
                    borderRadius: borderRadius(radius: 40)
                ),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appbar(
                        title: category?.title ?? appText.courses,
                        leftIcon: AppAssets.backSvg,
                        onTapLeftIcon: () {
                          backRoute();
                        },
                        isBasket: true
                    ),
                    space(20),
                    // filters
                    Padding(
                      padding: padding(vertical: 0, horizontal: 5),
                      child: Row(
                        children: [

                          // options
                          Expanded(
                            child: button(
                                onTap: () async {

                                  var res = await baseBottomSheet(
                                      child: const OptionsFilter()
                                  );

                                  if(res != null && res){
                                    data.clear();
                                    getData();
                                  }

                                },
                                width: getSize().width,
                                height: 45,
                                text: appText.options,
                                bgColor: Colors.white,
                                textColor: Colors.black,
                                borderColor: Colors.white,
                                iconPath: 'assets/image/png/options.png',
                                icWidth: 15,
                                raduis: 30
                            ),
                          ),

                          space(0,width: 10),

                          // filters
                          Expanded(
                            child: button(
                                onTap: () async {

                                  if(filters.isNotEmpty){
                                    var res = await baseBottomSheet(
                                        child: const DynamicllyFilter()
                                    );

                                    if(res != null && res){
                                      data.clear();
                                      getData();
                                    }
                                  }

                                },
                                width: getSize().width,
                                height: 48,
                                text: appText.filters,
                                bgColor: Colors.white,
                                textColor: Colors.black,
                                borderColor: Colors.white,
                                iconPath: 'assets/image/png/filter.png',
                                icWidth: 15,
                                raduis: 30
                            ),
                          ),

                          space(0,width: 10),

                          button(
                              onTap: (){
                                setState(() {
                                  isGrid = !isGrid;
                                });
                              },
                              width: 40,
                              height: 40,
                              text: '',
                              bgColor: Colors.white,
                              textColor: Colors.black,
                              borderColor: Colors.white,
                              iconColor: Colors.black,
                              iconPath: isGrid ? AppAssets.gridSvg : AppAssets.listSvg,
                              raduis: 30
                          )

                        ],
                      ),
                    ),
                    space(10),
                  ],
                ),
              ),

              space(8),

              // List

              Expanded(
                child: data.isEmpty && featuredListData.isEmpty && !isLoading
                  ? emptyState(AppAssets.filterEmptyStateSvg, appText.dataNotFound, appText.dataNotFoundDesc)
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          if(featuredListData.isNotEmpty)...{

                            // Featured Classes
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HomeWidget.titleAndMore(appText.featuredClasses, isViewAll: false),

                                SizedBox(
                                  width: getSize().width,
                                  height: 215,
                                  child: PageView(
                                    controller: sliderPageController,
                                    onPageChanged: (value) async {

                                      await Future.delayed(const Duration(milliseconds: 500));

                                      setState(() {
                                        currentSliderIndex = value;
                                      });
                                    },
                                    physics: const BouncingScrollPhysics(),
                                    children: List.generate(featuredListData.length, (index) {
                                      return courseItem2(
                                        featuredListData[index]
                                      );
                                    }),
                                  ),
                                ),

                                space(18),

                                // indecator
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ...List.generate(featuredListData.length, (index) {
                                      return AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: currentSliderIndex == index ? 16 : 7,
                                        height: 7,
                                        margin: padding(horizontal: 2),
                                        decoration: BoxDecoration(
                                          color: purplePrimary(),
                                          borderRadius: borderRadius()
                                        ),
                                      );

                                    }),
                                  ],
                                ),

                                space(14),
                              ],
                            ),

                          },

                          space(14),


                          // list data
                          SizedBox(
                            width: getSize().width,
                            child: isGrid
                          ? ListView(
                              shrinkWrap: true,
                              padding: padding(vertical: 0, horizontal: 0),
                              physics: const NeverScrollableScrollPhysics(),
                              // shrinkWrap: true,
                              // padding: const EdgeInsets.only(
                              //   left: 20,
                              //   right: 20,
                              //   bottom: 40
                              // ),
                              // physics: const NeverScrollableScrollPhysics(),
                              //
                              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              //   crossAxisCount: 1,
                              //   mainAxisExtent: 190,
                              //   crossAxisSpacing: 16,
                              //   mainAxisSpacing: 16
                              // ),

                              children: List.generate((isLoading && data.isEmpty) ? 8 : data.length, (index) {
                                return (isLoading && data.isEmpty)
                                  ? courseItem2Shimmer()
                                  : courseItem2(
                                      data[index],
                                      // width: getSize().width / 2,
                                      //
                                      // endCardPadding: 0.0,
                                      // height: 200.0,
                                      // isShowReward: locator<FilterCourseProvider>().rewardCourse
                                    );
                              }),
                            )

                          : ListView(
                              shrinkWrap: true,
                              padding: padding(vertical: 0, horizontal: 0),
                              physics: const NeverScrollableScrollPhysics(),
                              children: List.generate((isLoading && data.isEmpty) ? 8 : data.length, (index) {

                                return (isLoading && data.isEmpty)
                                  ? courseItemVerticallyShimmer()
                                  : courseItemVertically(
                                      data[index],
                                      isShowReward: locator<FilterCourseProvider>().rewardCourse
                                    );

                              }),
                            ),

                          ),

                        ],
                      ),
                    )
              )

            ],
          ),
        ),

      )
    );
  }


  @override
  void dispose() {
    locator<FilterCourseProvider>().clearFilter();
    super.dispose();
  }
}


