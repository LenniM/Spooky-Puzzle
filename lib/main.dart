import 'package:flutter/material.dart';
import 'package:spookypuzzle/widgets/level_widget.dart';
import 'package:spookypuzzle/widgets/overlay_ghost_widget.dart';
import 'widgets/puzzle/puzzle_widget.dart';
import 'package:rive/rive.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Spooky Puzzle",
      debugShowCheckedModeBanner: false,
      home: MainPage(key: key,),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int moveCount = 0;
  bool isSolved = false;
  bool shouldReset = false;
  bool shouldShuffle = false;
  int currentLevel = 1;
  bool showsOverlay = true;
  bool lastOverlay = false;
  bool isPaused = false;


  late Image lvlOnePuzzleImage;
  late Image lvlTwoPuzzleImage;
  late Image lvlThreePuzzleImage;


  @override
  void initState() {
      lvlOnePuzzleImage = Image.asset("assets/ghost_number_one.gif");
      lvlTwoPuzzleImage = Image.asset("assets/ghost_number_two.gif");
      lvlThreePuzzleImage = Image.asset("assets/ghost_number_three.gif");
      currentLevel = 1;
      showsOverlay = true;
      super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(lvlOnePuzzleImage.image, context);
    precacheImage(lvlTwoPuzzleImage.image, context);
    precacheImage(lvlThreePuzzleImage.image, context);
  }

  final PuzzleShuffleController puzzleShuffleController = PuzzleShuffleController();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF142343),
      body: Stack(
        children: [
          ///Background
          Container(
            width: size.width,
            height: size.height,
            child: const RiveAnimation.asset(
              'assets/backgroundspooky.riv',
              fit: BoxFit.cover,
            ),
          ),
          ///Main content
          Column(
            children: [
              LevelWidget(
                currentLevel: currentLevel,
              ),
              SizedBox(height: size.width >= 400 ? size.height * 0.1 : size.height * 0.03),
              currentLevel == 3 ? PuzzleScreen(
                puzzleSize: size.width >= 1200 ? Size(550, 550) : size.width >= 800 ? Size(400, 400) : Size(350, 350),
                puzzleShuffleController: puzzleShuffleController,
                imageProvider: lvlThreePuzzleImage.image,
                onPausedClicked: () {
                  setState(() {
                    isPaused = true;
                    showsOverlay = true;
                  });
                },
                size: 1 + currentLevel,
                onSolved: () async{
                  await Future.delayed(Duration(milliseconds: 700), () {
                    if(currentLevel < 3){
                      setState(() {
                        currentLevel += 1;
                        showsOverlay = true;
                      });
                    } else {
                      setState(() {
                        lastOverlay = true;
                        showsOverlay = true;
                      });
                    }
                  });
                },
              ) : Container(),
              currentLevel == 2 ? PuzzleScreen(
                  puzzleSize: size.width >= 1200 ? Size(550, 550) : size.width >= 800 ? Size(400, 400) : Size(350, 350),
                  puzzleShuffleController: puzzleShuffleController,
                  imageProvider: lvlTwoPuzzleImage.image,
                  onPausedClicked: () {
                  setState(() {
                    isPaused = true;
                    showsOverlay = true;
                    });
                  },
                  size: 1 + currentLevel,
                  onSolved: () async{
                  await Future.delayed(Duration(milliseconds: 700), () {
                    if(currentLevel < 3){
                      setState(() {
                        currentLevel += 1;
                        showsOverlay = true;
                      });
                    } else {
                      setState(() {
                        showsOverlay = true;
                      });
                    }
                  });
                  },
              ) : Container(),
              currentLevel == 1 ? PuzzleScreen(
                puzzleSize: size.width >= 1200 ? Size(550, 550) : size.width >= 800 ? Size(400, 400) : Size(350, 350),
                puzzleShuffleController: puzzleShuffleController,
                imageProvider: lvlOnePuzzleImage.image,
                onPausedClicked: () {
                  setState(() {
                    isPaused = true;
                    showsOverlay = true;
                  });
                },
                size: 1 + currentLevel,
                onSolved: () async{
                  await Future.delayed(Duration(milliseconds: 700), () {
                    if(currentLevel < 3){
                      setState(() {
                        currentLevel += 1;
                        showsOverlay = true;
                      });
                    } else {
                      setState(() {
                        showsOverlay = true;
                      });
                    }
                  });

                },
              ) : Container(),
            ],
          ),
          showsOverlay ? OverlayGhostWidget(showsOverlay: showsOverlay, currentLevel: currentLevel,
            onContinue: () {
              puzzleShuffleController.shuffle();
              setState(() {
                showsOverlay = false;
                lastOverlay = false;
              });
            },
            lastOverlay: lastOverlay,
            isPaused: isPaused,
            onPauseContinueClicked: () {
              setState(() {
                showsOverlay = false;
                isPaused = false;
              });
              puzzleShuffleController.continueTimer();
            },
          ) : Container(),

        ],
      )
    );
  }
}


class PuzzleShuffleController {
  late void Function() shuffle;
  late void Function() continueTimer;
}






