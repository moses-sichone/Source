import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webinar/app/models/textbook_model.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';
import 'package:webinar/app/pages/main_page/home_page/single_course_page/single_content_page/web_view_page.dart';
import 'package:webinar/app/pages/main_page/home_page/single_course_page/single_content_page/pdf_viewer_page.dart';

class TextbookBookPage extends StatefulWidget {
  static const String pageName = '/textbook_book';
  const TextbookBookPage({super.key});

  @override
  State<TextbookBookPage> createState() => _TextbookBookPageState();
}

class _TextbookBookPageState extends State<TextbookBookPage> with TickerProviderStateMixin {
  TextbookModel? textbook;
  ChapterModel? chapter;
  int chapterNumber = 0;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    _getArguments();
  }

  void _getArguments() {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      textbook = args['textbook'] as TextbookModel;
      chapter = args['chapter'] as ChapterModel;
      chapterNumber = args['chapterNumber'] as int;
      
      // Initialize tabs based on available content
      List<String> tabs = [];
      if (_hasVideos()) tabs.add('Videos');
      if (_hasImages()) tabs.add('Images');
      if (_hasPdfs()) tabs.add('PDFs');
      
      tabController = TabController(length: tabs.length, vsync: this);
    }
  }

  bool _hasVideos() {
    return chapter?.chapterMedia.isNotEmpty == true && 
           chapter!.chapterMedia.any((media) => media.hasVideos);
  }

  bool _hasImages() {
    return chapter?.chapterMedia.isNotEmpty == true && 
           chapter!.chapterMedia.any((media) => media.hasImages);
  }

  bool _hasPdfs() {
    return chapter?.chapterMedia.isNotEmpty == true && 
           chapter!.chapterMedia.any((media) => media.hasPdfs);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (textbook == null || chapter == null) {
      return Scaffold(
        backgroundColor: backgroundWhite(),
        appBar: AppBar(
          title: const Text('Content'),
          backgroundColor: purplePrimary(),
        ),
        body: const Center(
          child: Text('Content not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundWhite(),
      body: Column(
        children: [
          // App Bar
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
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
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    space(0, width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chapter $chapterNumber',
                            style: style14Regular().copyWith(color: Colors.white70),
                          ),
                          Text(
                            chapter!.title,
                            style: style18Bold().copyWith(color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                space(15),
                Text(
                  chapter!.description,
                  style: style14Regular().copyWith(color: Colors.white70),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Tabs
          if (tabController.length > 1) ...[
            Container(
              color: purplePrimary(),
              child: TabBar(
                controller: tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: [
                  if (_hasVideos()) const Tab(text: 'Videos'),
                  if (_hasImages()) const Tab(text: 'Images'),
                  if (_hasPdfs()) const Tab(text: 'PDFs'),
                ],
              ),
            ),
          ],

          // Content
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                if (_hasVideos()) _buildVideosTab(),
                if (_hasImages()) _buildImagesTab(),
                if (_hasPdfs()) _buildPdfsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideosTab() {
    final videos = <String>[];
    final durations = <String>[];
    
    for (final media in chapter!.chapterMedia) {
      videos.addAll(media.videos);
      durations.addAll(media.videoDurations);
    }

    if (videos.isEmpty) {
      return _buildEmptyState('No videos available');
    }

    return ListView.builder(
      padding: padding(),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return _buildVideoCard(videos[index], durations.length > index ? durations[index] : '', index + 1);
      },
    );
  }

  Widget _buildVideoCard(String videoUrl, String duration, int videoNumber) {
    return GestureDetector(
      onTap: () {
        nextRoute(WebViewPage.pageName, arguments: [videoUrl, 'Video Player', false, null]);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
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
            // Video Thumbnail
            Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                color: greyF0,
                borderRadius: borderRadius(radius: 8),
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: greyF0,
                      borderRadius: borderRadius(radius: 8),
                    ),
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 30,
                      color: purplePrimary(),
                    ),
                  ),
                  if (duration.isNotEmpty)
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: borderRadius(radius: 4),
                        ),
                        child: Text(
                          duration,
                          style: style10Regular().copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            space(0, width: 15),
            
            // Video Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Video $videoNumber',
                    style: style16Medium(),
                  ),
                  space(4),
                  Text(
                    'Tap to play',
                    style: style12Regular().copyWith(color: greyText()),
                  ),
                  space(8),
                  Row(
                    children: [
                      Icon(
                        Icons.play_arrow,
                        size: 16,
                        color: purplePrimary(),
                      ),
                      space(0, width: 4),
                      Text(
                        'Play Video',
                        style: style12Regular().copyWith(color: purplePrimary()),
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

  Widget _buildImagesTab() {
    final images = <String>[];
    
    for (final media in chapter!.chapterMedia) {
      images.addAll(media.images);
    }

    if (images.isEmpty) {
      return _buildEmptyState('No images available');
    }

    return GridView.builder(
      padding: padding(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return _buildImageCard(images[index], index);
      },
    );
  }

  Widget _buildImageCard(String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        _showImageViewer(imageUrl, index);
      },
      child: Container(
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
        child: ClipRRect(
          borderRadius: borderRadius(radius: 12),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: greyF0,
                      child: Icon(
                        Icons.image,
                        size: 30,
                        color: greyCC,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: borderRadius(radius: 4),
                  ),
                  child: Icon(
                    Icons.fullscreen,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPdfsTab() {
    final pdfs = <String>[];
    
    for (final media in chapter!.chapterMedia) {
      pdfs.addAll(media.pdfs);
    }

    if (pdfs.isEmpty) {
      return _buildEmptyState('No PDFs available');
    }

    return ListView.builder(
      padding: padding(),
      itemCount: pdfs.length,
      itemBuilder: (context, index) {
        return _buildPdfCard(pdfs[index], index);
      },
    );
  }

  Widget _buildPdfCard(String pdfUrl, int index) {
    final fileName = pdfUrl.split('/').last;
    
    return GestureDetector(
      onTap: () {
        nextRoute(PdfViewerPage.pageName, arguments: [pdfUrl, fileName]);
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
            // PDF Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: borderRadius(radius: 8),
              ),
              child: Icon(
                Icons.picture_as_pdf,
                size: 25,
                color: Colors.red,
              ),
            ),
            
            space(0, width: 15),
            
            // PDF Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: style16Medium(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  space(4),
                  Text(
                    'Tap to view PDF',
                    style: style12Regular().copyWith(color: greyText()),
                  ),
                ],
              ),
            ),
            
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: greyText(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/image/svg/noCourseEmptyState.svg',
            width: 120,
            height: 120,
          ),
          space(20),
          Text(
            message,
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

  void _showImageViewer(String imageUrl, int initialIndex) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.black.withOpacity(0.9),
                child: Center(
                  child: InteractiveViewer(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}