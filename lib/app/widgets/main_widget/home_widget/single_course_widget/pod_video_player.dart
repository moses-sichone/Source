import 'package:pod_player/pod_player.dart';
import 'package:flutter/material.dart';
import 'package:webinar/common/common.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PodVideoPlayerDev extends StatefulWidget {
  final String type;
  final String url;
  final RouteObserver<ModalRoute<void>> routeObserver;

  const PodVideoPlayerDev(this.url,this.type, this.routeObserver, {super.key});

  @override
  State<PodVideoPlayerDev> createState() => _VimeoVideoPlayerState();
}

class _VimeoVideoPlayerState extends State<PodVideoPlayerDev> with RouteAware {
  late final PodPlayerController controller;

  YoutubePlayerController _controller = YoutubePlayerController(
    params: YoutubePlayerParams(
      mute: false,
      showControls: true,
      showFullscreenButton: true,
    ),
  );

  @override
  void initState() {
    
    if(widget.type == 'vimeo'){
      controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.vimeo(
          widget.url,
          videoPlayerOptions: VideoPlayerOptions(
            allowBackgroundPlayback: true,
          ),
        ),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: true,
          isLooping: false,
          wakelockEnabled: true,
          videoQualityPriority: [720, 360],
        ),
      );

      controller.initialise();

    }else{
      // widget.type == 'vimeo'
      //     ? PlayVideoFrom.vimeo(widget.url.split('/').last)
      //     : 

      // youtubePlayerController = YoutubePlayerController(
      //   initialVideoId:  YoutubePlayer.convertUrlToId(widget.url) ?? '',
      //   flags: const YoutubePlayerFlags(
      //     autoPlay: true,
      //   )
      // );

      if(widget.type == 'youtube'){
        _controller = YoutubePlayerController.fromVideoId(
          videoId: getYoutubeId(),
          autoPlay: false,
          params: const YoutubePlayerParams(showFullscreenButton: true),
        );

      }else{

        controller = PodPlayerController(
          playVideoFrom: widget.type == 'youtube'
              ? PlayVideoFrom.youtube(widget.url)
              : PlayVideoFrom.network(widget.url),

        )..initialise().then((value){
          setState(() {});
        },onError: (e){});
      }
    }

    
    super.initState();
  }

  getYoutubeId(){
    String? id = YoutubePlayerController.convertUrlToId(widget.url);

    if(id == null){
      getYoutubeId();
    }else{
      return id;
    }

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }


  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void didPush() {}

  @override
  void didPushNext() {
    // final route = ModalRoute.of(context)?.settings.name;
    controller.pause();
  } 

  @override
  void didPopNext() {
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    print('type : ${widget.url}');
    print('type : ${getYoutubeId()}');
    
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ClipRRect(
        borderRadius: borderRadius(),
        child: SizedBox(
          width: getSize().width,
          child: widget.type == 'youtube'
          ? YoutubePlayer(
              controller: _controller,
          )
          : PodVideoPlayer(controller: controller,),
        ),
      ),
    );
  }
}