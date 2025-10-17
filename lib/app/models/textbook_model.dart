class TextbookModel {
  int id;
  String title;
  String price;
  int subjectId;
  int standardId;
  String standardName;
  String description;
  String imageCover;
  String thumbnail;

  TextbookModel({
    required this.id,
    required this.title,
    required this.price,
    required this.subjectId,
    required this.standardId,
    required this.standardName,
    required this.description,
    required this.imageCover,
    required this.thumbnail,
  });

  factory TextbookModel.fromJson(Map<String, dynamic> json) {
    return TextbookModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: json['price'] ?? '0.00',
      subjectId: json['subject_id'] ?? 0,
      standardId: json['standard_id'] ?? 0,
      standardName: json['standard_name'] ?? '',
      description: json['description'] ?? '',
      imageCover: json['image_cover'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'subject_id': subjectId,
      'standard_id': standardId,
      'standard_name': standardName,
      'description': description,
      'image_cover': imageCover,
      'thumbnail': thumbnail,
    };
  }
}

class ChapterModel {
  int id;
  String title;
  String description;
  int mediaCount;
  List<ChapterMediaModel> chapterMedia;

  ChapterModel({
    required this.id,
    required this.title,
    required this.description,
    required this.mediaCount,
    required this.chapterMedia,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    var mediaList = <ChapterMediaModel>[];
    if (json['chapter_media'] != null) {
      json['chapter_media'].forEach((v) {
        mediaList.add(ChapterMediaModel.fromJson(v));
      });
    }

    return ChapterModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      mediaCount: json['media_count'] ?? 0,
      chapterMedia: mediaList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'media_count': mediaCount,
      'chapter_media': chapterMedia.map((v) => v.toJson()).toList(),
    };
  }
}

class ChapterMediaModel {
  int id;
  bool downloadAllowed;
  String description;
  List<String> images;
  List<String> pdfs;
  List<String> videos;
  List<String> videoDurations;
  bool hasImages;
  bool hasPdfs;
  bool hasVideos;

  ChapterMediaModel({
    required this.id,
    required this.downloadAllowed,
    required this.description,
    required this.images,
    required this.pdfs,
    required this.videos,
    required this.videoDurations,
    required this.hasImages,
    required this.hasPdfs,
    required this.hasVideos,
  });

  factory ChapterMediaModel.fromJson(Map<String, dynamic> json) {
    return ChapterMediaModel(
      id: json['id'] ?? 0,
      downloadAllowed: json['download_allowed'] ?? false,
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      pdfs: List<String>.from(json['pdfs'] ?? []),
      videos: List<String>.from(json['videos'] ?? []),
      videoDurations: List<String>.from(json['video_durations'] ?? []),
      hasImages: json['has_images'] ?? false,
      hasPdfs: json['has_pdfs'] ?? false,
      hasVideos: json['has_videos'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'download_allowed': downloadAllowed,
      'description': description,
      'images': images,
      'pdfs': pdfs,
      'videos': videos,
      'video_durations': videoDurations,
      'has_images': hasImages,
      'has_pdfs': hasPdfs,
      'has_videos': hasVideos,
    };
  }
}

class TextbookDetailModel {
  int textbookId;
  String textbookTitle;
  String textbookDescription;
  String imageCover;
  String thumbnail;
  List<ChapterModel> chapters;

  TextbookDetailModel({
    required this.textbookId,
    required this.textbookTitle,
    required this.textbookDescription,
    required this.imageCover,
    required this.thumbnail,
    required this.chapters,
  });

  factory TextbookDetailModel.fromJson(Map<String, dynamic> json) {
    var chapterList = <ChapterModel>[];
    if (json['chapters'] != null) {
      json['chapters'].forEach((v) {
        chapterList.add(ChapterModel.fromJson(v));
      });
    }

    return TextbookDetailModel(
      textbookId: json['textbook_id'] ?? 0,
      textbookTitle: json['textbook_title'] ?? '',
      textbookDescription: json['textbook_description'] ?? '',
      imageCover: json['image_cover'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      chapters: chapterList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'textbook_id': textbookId,
      'textbook_title': textbookTitle,
      'textbook_description': textbookDescription,
      'image_cover': imageCover,
      'thumbnail': thumbnail,
      'chapters': chapters.map((v) => v.toJson()).toList(),
    };
  }
}

class SubjectModel {
  int id;
  String title;

  SubjectModel({
    required this.id,
    required this.title,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}