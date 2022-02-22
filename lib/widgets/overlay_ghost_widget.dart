import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:spookypuzzle/main.dart';
import 'package:spookypuzzle/style/colors.dart';
import 'package:url_launcher/url_launcher.dart';




class OverlayGhostWidget extends StatefulWidget {

  final bool showsOverlay;
  final bool lastOverlay;
  final bool isPaused;
  final int currentLevel;
  final Function onContinue;
  final Function onPauseContinueClicked;


  const OverlayGhostWidget({Key? key, required this.showsOverlay, required this.currentLevel, required this.onContinue, required this.lastOverlay, required this.onPauseContinueClicked, required this.isPaused}) : super(key: key);


  @override
  _OverlayGhostWidgetState createState() => _OverlayGhostWidgetState();
}

class _OverlayGhostWidgetState extends State<OverlayGhostWidget> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin{


  late SimpleAnimation _fly_in, _idle, _fly_out, _pause_in, _pause_idle;
  var _riveArtboard;
  RiveAnimationController? _controller;
  late AnimationController animationController = AnimationController(duration: Duration(milliseconds: 1500), vsync: this, reverseDuration: const Duration(milliseconds: 700))..addStatusListener((status) => setState(() {}));
  late Animation<double> animationAnimation = CurvedAnimation(parent: animationController, curve: Curves.easeOutQuint);

  late AnimationController textAnimationController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this, reverseDuration: Duration(milliseconds: 450))..addStatusListener((status) => setState(() {}));
  late Animation<double> textAnimation = CurvedAnimation(parent: textAnimationController, curve: Curves.linear);


  late AnimationController riveFadeAnimationController = AnimationController(duration: const Duration(milliseconds: 450), vsync: this, reverseDuration: Duration(milliseconds: 300))..addStatusListener((status) => setState(() {}));
  late Animation<double> riveFadeAnimation = CurvedAnimation(parent: riveFadeAnimationController, curve: Curves.easeInOut);




  launchTwitter() async {
    const url = "https://twitter.com/intent/tweet?text=I%20have%20successfully%20completed%20the%20%23FlutterPuzzleHack%20%27Spooky%20Puzzle%27%20by%20Lenni%20Mikuszewski.%0A%23spookypuzzle";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    animationController.forward();
    textAnimationController.forward();
    riveFadeAnimationController.forward();

    rootBundle.load("assets/ghost_main.riv").then((data) async {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;

      _fly_in = SimpleAnimation("fly");
      _idle = SimpleAnimation("idle");
      _fly_out = SimpleAnimation("fly_out");
      _pause_in = SimpleAnimation("pause_in");
      _pause_idle = SimpleAnimation("pause_idle");
      setState(() => _riveArtboard = artboard);


      artboard.addController(_controller = widget.isPaused ? _pause_in : _fly_in);

      Future.delayed(Duration(milliseconds: widget.isPaused ? 1500 : 1300), () {
        _riveArtboard.artboard.addController(widget.isPaused ? _pause_idle : _idle);
      });
    });


  }

  @override
  dispose() {
    animationController.dispose();
    textAnimationController.dispose();
    riveFadeAnimationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String deviceSize(){
      if(size.width >= 1100){
        return "Desktop";
      } else {
        if(size.width >= 650){
          return "Tablet";
        } else {
          if(size.width <= 320){
            return "Mobile Small";

          } else {
            return "Mobile";
          }
        }

      }
    }

    return widget.showsOverlay ? FadeTransition(
      opacity: animationAnimation,
      child: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.8),
            width: size.width,
            height: size.height,
            child: _riveArtboard == null ? SizedBox() : FadeTransition(
                opacity: riveFadeAnimation,
                child: Rive(artboard: _riveArtboard,)
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Container(
                width: 800,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizeTransition(
                        sizeFactor: textAnimation,
                        axis: Axis.horizontal,
                        axisAlignment: -1,
                        child: Text(widget.isPaused ? "Do you want to continue?" : widget.lastOverlay ? "You have done it!" : widget.currentLevel == 1 ? "Are you ready?" : widget.currentLevel == 2 ? "Congratulations!" : widget.currentLevel == 3 ? "Ready for the last round?"  : "Are you ready?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width <= 280 ? 24 : deviceSize() == "Mobile" || deviceSize() == "Mobile Small" ? 32 : deviceSize() == "Tablet" ? 36 : 42,
                            fontFamily: "Regular",
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      !widget.lastOverlay ? FadeTransition(
                        opacity: riveFadeAnimation,
                        child: InkWell(
                          onTap: () {
                            animationController.reverse();
                            riveFadeAnimationController.reverse();
                            textAnimationController.reverse();
                            widget.isPaused ? null : _riveArtboard.artboard.addController(_fly_out);
                            Future.delayed(const Duration(milliseconds: 600), () {
                              widget.isPaused ? widget.onPauseContinueClicked() : widget.onContinue();
                              print("continue clicked");
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.6),
                                  spreadRadius: 2,
                                  blurRadius: 16,

                                )
                              ],
                            ),
                            child: Text(
                              widget.isPaused ? "Continue" : widget.lastOverlay ? "Repeat" : widget.currentLevel == 1 ? "Start" : widget.currentLevel == 2 ? "Continue" : widget.currentLevel == 3 ? "Go" : "Start",
                                style: TextStyle(
                                    color: SpookyColors.kTextColor,
                                    fontFamily: "Regular",
                                    fontSize: size.width <= 280 ? 18 : deviceSize() == "Mobile" || deviceSize() == "Mobile Small" ? 20 : deviceSize() == "Tablet" ? 24 : 28
                                ),
                            ),

                          ),
                        ),
                      ) : FadeTransition(
                        opacity: riveFadeAnimation,
                        child: InkWell(
                          onTap: launchTwitter,
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.6),
                                  spreadRadius: 2,
                                  blurRadius: 16,

                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text("SHARE ON TWITTER", style: TextStyle(
                                  color: SpookyColors.kTextColor,
                                ),),
                                SizedBox(width: 3),
                                Icon(Icons.exit_to_app, color: SpookyColors.kTextColor,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      )
    ) : Container();
  }
}


