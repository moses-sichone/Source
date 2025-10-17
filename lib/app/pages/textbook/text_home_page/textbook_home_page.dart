import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webinar/app/providers/drawer_provider.dart';
import 'package:webinar/app/models/textbook_model.dart';
import 'package:webinar/app/services/textbook_service/textbook_service.dart';
import 'package:webinar/app/pages/textbook/text_home_page/textbook_course_page.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';
import '../../../../locator.dart';
import '../../../providers/app_language_provider.dart';

class TextbookHomePage extends StatefulWidget {
  static const String pageName = '/textbook_home';
  const TextbookHomePage({super.key});

  @override
  State<TextbookHomePage> createState() => _TextbookHomePageState();
}

class _TextbookHomePageState extends State<TextbookHomePage> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();

  bool isLoadingTextbooks = false;
  List<TextbookModel> textbooks = [];
  List<TextbookModel> filteredTextbooks = [];
  List<SubjectModel> subjects = [];
  SubjectModel? selectedSubject;

  @override
  void initState() {
    super.initState();
    _getData();
    
    searchController.addListener(() {
      _filterTextbooks();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchNode.dispose();
    super.dispose();
  }

  Future<void> _getData() async {
    setState(() {
      isLoadingTextbooks = true;
    });

    try {
      final textbooksData = await TextbookService.getTextbooks();
      final subjectsData = await TextbookService.getSubjects();
      
      setState(() {
        textbooks = textbooksData;
        filteredTextbooks = textbooksData;
        subjects = subjectsData;
        isLoadingTextbooks = false;
      });
    } catch (e) {
      setState(() {
        isLoadingTextbooks = false;
      });
    }
  }

  void _filterTextbooks() {
    final query = searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        filteredTextbooks = textbooks;
      } else {
        filteredTextbooks = textbooks.where((textbook) {
          return textbook.title.toLowerCase().contains(query) ||
                 textbook.description.toLowerCase().contains(query) ||
                 textbook.standardName.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _filterBySubject(SubjectModel? subject) {
    setState(() {
      selectedSubject = subject;
      if (subject == null) {
        filteredTextbooks = textbooks;
      } else {
        filteredTextbooks = textbooks.where((textbook) {
          return textbook.subjectId == subject.id;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguageProvider>(
      builder: (context, languageProvider, _) {
        return Consumer<DrawerProvider>(
          builder: (context, drawerProvider, _) {
            return ClipRRect(
              borderRadius: borderRadius(radius: drawerProvider.isOpenDrawer ? 35 : 0),
              child: Scaffold(
                backgroundColor: backgroundWhite(),
                body: Column(
                  children: [
                    // App Bar
                    _buildAppBar(),

                    // Body
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _getData,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: padding(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Subject Filter
                              if (subjects.isNotEmpty) ...[
                                _buildSubjectFilter(),
                                space(20),
                              ],

                              // Textbooks Grid
                              _buildTextbooksGrid(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: getSize().width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: purplePrimary(),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          space(10),
          Text(
            'My Textbooks',
            style: style24Bold().copyWith(color: Colors.white),
          ),
          space(8),
          Text(
            'Access your digital learning materials',
            style: style14Regular().copyWith(color: Colors.white70),
          ),
          space(20),
          
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius(),
            ),
            child: input(
              searchController,
              searchNode,
              'Search textbooks...',
              iconPathLeft: AppAssets.searchSvg,
              leftIconSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Subject',
          style: style16Medium(),
        ),
        space(10),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // All Subjects
              GestureDetector(
                onTap: () => _filterBySubject(null),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selectedSubject == null ? purplePrimary() : greyF0,
                    borderRadius: borderRadius(radius: 20),
                  ),
                  child: Text(
                    'All',
                    style: style14Regular().copyWith(
                      color: selectedSubject == null ? Colors.white : greyText(),
                    ),
                  ),
                ),
              ),
              
              // Subject List
              ...subjects.map((subject) {
                return GestureDetector(
                  onTap: () => _filterBySubject(subject),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selectedSubject?.id == subject.id ? purplePrimary() : greyF0,
                      borderRadius: borderRadius(radius: 20),
                    ),
                    child: Text(
                      subject.title,
                      style: style14Regular().copyWith(
                        color: selectedSubject?.id == subject.id ? Colors.white : greyText(),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextbooksGrid() {
    if (isLoadingTextbooks) {
      return _buildShimmerGrid();
    }

    if (filteredTextbooks.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: filteredTextbooks.length,
      itemBuilder: (context, index) {
        return _buildTextbookCard(filteredTextbooks[index]);
      },
    );
  }

  Widget _buildTextbookCard(TextbookModel textbook) {
    return GestureDetector(
      onTap: () {
        nextRoute(TextbookCoursePage.pageName, arguments: textbook);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius(radius: 15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: greyF0,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: textbook.imageCover.isNotEmpty
                      ? Image.network(
                          textbook.imageCover,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: greyF0,
                              child: Icon(
                                Icons.book,
                                size: 40,
                                color: greyCC,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: greyF0,
                          child: Icon(
                            Icons.book,
                            size: 40,
                            color: greyCC,
                          ),
                        ),
                ),
              ),
            ),
            
            // Book Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textbook.title,
                      style: style14Medium(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    space(4),
                    Text(
                      textbook.standardName,
                      style: style12Regular().copyWith(color: greyText()),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        if (textbook.price == '0.00') ...[
                          Text(
                            'Free',
                            style: style12Bold().copyWith(color: Colors.green),
                          ),
                        ] else ...[
                          Text(
                            '\$${textbook.price}',
                            style: style12Bold().copyWith(color: purplePrimary()),
                          ),
                        ],
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: greyText(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius(radius: 15),
          ),
          child: Shimmer.fromColors(
            baseColor: greyE7,
            highlightColor: greyF8,
            child: Container(
              decoration: BoxDecoration(
                color: greyF0,
                borderRadius: borderRadius(radius: 15),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/image/svg/noCourseEmptyState.svg',
            width: 120,
            height: 120,
          ),
          space(20),
          Text(
            'No textbooks found',
            style: style18Bold(),
          ),
          space(8),
          Text(
            'Try adjusting your search or filters',
            style: style14Regular().copyWith(color: greyText()),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}