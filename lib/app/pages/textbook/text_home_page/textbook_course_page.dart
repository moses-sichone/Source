import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webinar/app/models/textbook_model.dart';
import 'package:webinar/app/services/textbook_service/textbook_service.dart';
import 'package:webinar/app/pages/textbook/text_home_page/textbook_book_page.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';

class TextbookCoursePage extends StatefulWidget {
  static const String pageName = '/textbook_course';
  const TextbookCoursePage({super.key});

  @override
  State<TextbookCoursePage> createState() => _TextbookCoursePageState();
}

class _TextbookCoursePageState extends State<TextbookCoursePage> {
  TextbookModel? textbook;
  TextbookDetailModel? textbookDetail;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future<void> _getData() async {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      textbook = ModalRoute.of(context)!.settings.arguments as TextbookModel;
      setState(() {
        isLoading = true;
      });

      try {
        final detail = await TextbookService.getTextbookChapters(textbook!.id);
        setState(() {
          textbookDetail = detail;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (textbook == null) {
      return Scaffold(
        backgroundColor: backgroundWhite(),
        appBar: AppBar(
          title: const Text('Textbook'),
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: const Center(
          child: Text('Textbook not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundWhite(),
      body: CustomScrollView(
        slivers: [
          // App Bar with Book Cover
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    // Background Pattern
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.1,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/image/png/splash-bg.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Book Cover
                    Center(
                      child: Container(
                        width: 120,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: borderRadius(radius: 10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: borderRadius(radius: 10),
                          child: textbook!.imageCover.isNotEmpty
                              ? Image.network(
                                  textbook!.imageCover,
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
                  ],
                ),
              ),
            ),
            title: Text(
              textbook!.title,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: padding(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Info
                  _buildBookInfo(),
                  space(20),

                  // Chapters
                  if (isLoading) ...[
                    _buildChaptersShimmer(),
                  ] else if (textbookDetail != null) ...[
                    _buildChaptersList(),
                  ] else ...[
                    _buildNoChaptersState(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Text(
            textbook!.title,
            style: style20Bold(),
          ),
          space(8),
          Text(
            textbook!.standardName,
            style: style14Regular().copyWith(color: greyText()),
          ),
          space(12),
          Text(
            textbook!.description,
            style: style14Regular(),
          ),
          space(15),
          Row(
            children: [
              if (textbook!.price == '0.00') ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: borderRadius(radius: 20),
                  ),
                  child: Text(
                    'Free Access',
                    style: style12Medium().copyWith(color: Colors.green),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: green77().withOpacity(0.1),
                    borderRadius: borderRadius(radius: 20),
                  ),
                  child: Text(
                    '\$${textbook!.price}',
                    style: style12Medium().copyWith(color: green77()),
                  ),
                ),
              ],
              
              if (textbookDetail != null) ...[
                space(0, width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: greyE5().withOpacity(0.5),
                    borderRadius: borderRadius(radius: 20),
                  ),
                  child: Text(
                    '${textbookDetail!.chapters.length} Chapters',
                    style: style12Medium().copyWith(color: greyText()),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChaptersList() {
    if (textbookDetail!.chapters.isEmpty) {
      return _buildNoChaptersState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chapters',
          style: style18Bold(),
        ),
        space(15),
        ...textbookDetail!.chapters.asMap().entries.map((entry) {
          int index = entry.key;
          ChapterModel chapter = entry.value;
          return _buildChapterCard(index + 1, chapter);
        }).toList(),
      ],
    );
  }

  Widget _buildChapterCard(int chapterNumber, ChapterModel chapter) {
    return GestureDetector(
      onTap: () {
        nextRoute(TextbookBookPage.pageName, arguments: {
          'textbook': textbook,
          'chapter': chapter,
          'chapterNumber': chapterNumber,
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius(radius: 12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Chapter Number
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: greyF0,
                borderRadius: borderRadius(radius: 10),
              ),
              child: Center(
                child: Text(
                  '$chapterNumber',
                  style: style16Bold().copyWith(color: grey33),
                ),
              ),
            ),
            
            space(0, width: 15),
            
            // Chapter Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.title,
                    style: style16Medium(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  space(4),
                  Text(
                    chapter.description,
                    style: style12Regular().copyWith(color: greyText()),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  space(8),
                  Row(
                    children: [
                      if (chapter.chapterMedia.isNotEmpty) ...[
                        _buildMediaIcon(chapter.chapterMedia.first.hasVideos, Icons.video_library, 'Videos'),
                        space(0, width: 10),
                        _buildMediaIcon(chapter.chapterMedia.first.hasImages, Icons.image, 'Images'),
                        space(0, width: 10),
                        _buildMediaIcon(chapter.chapterMedia.first.hasPdfs, Icons.picture_as_pdf, 'PDFs'),
                      ],
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: greyText(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaIcon(bool hasMedia, IconData icon, String label) {
    if (!hasMedia) return const SizedBox.shrink();
    
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: grey5E,
        ),
        space(0, width: 4),
        Text(
          label,
          style: style10Regular().copyWith(color: grey5E),
        ),
      ],
    );
  }

  Widget _buildChaptersShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chapters',
          style: style18Bold(),
        ),
        space(15),
        ...List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius(radius: 12),
            ),
            child: Shimmer.fromColors(
              baseColor: greyE7,
              highlightColor: greyF8,
              child: Container(
                decoration: BoxDecoration(
                  color: greyF0,
                  borderRadius: borderRadius(radius: 12),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNoChaptersState() {
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
            'No chapters available',
            style: style18Bold(),
          ),
          space(8),
          Text(
            'Check back later for new content',
            style: style14Regular().copyWith(color: greyText()),
          ),
        ],
      ),
    );
  }
}