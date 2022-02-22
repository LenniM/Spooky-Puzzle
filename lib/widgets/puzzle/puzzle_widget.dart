import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:spookypuzzle/layout/layout_wrapper.dart';
import 'package:spookypuzzle/main.dart';
import 'package:spookypuzzle/style/colors.dart';
import 'package:spookypuzzle/widgets/clock/clock_data.dart';
import 'package:spookypuzzle/widgets/clock/clock_widget.dart';
import 'package:spookypuzzle/widgets/puzzle/is_puzzle_solvable.dart';
import 'package:spookypuzzle/widgets/puzzle/tile_data.dart';
import 'package:spookypuzzle/widgets/puzzle/tile_widget.dart';
import 'dart:ui' as ui;


class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({
    Key? key,
    required this.size,
    this.imageProvider,
    required this.puzzleSize,
    required this.onSolved,
    required this.puzzleShuffleController,
    required this.onPausedClicked,
  }) : super(key: key);

  final int size;
  final Size puzzleSize;
  final ImageProvider? imageProvider;
  final Function onSolved;
  final Function onPausedClicked;
  final PuzzleShuffleController puzzleShuffleController;


  @override
  _PuzzleScreenState createState() => _PuzzleScreenState(puzzleShuffleController);
}

class _PuzzleScreenState extends State<PuzzleScreen> {

  _PuzzleScreenState(PuzzleShuffleController _controller){
    _controller.shuffle = shuffle;
    _controller.continueTimer = continueTimer;
  }



  late List<TileData> tiles;
  late Size tileSize;
  late bool solved;
  int moves = 0;
  bool tabable = true;

  StreamController<ui.Image> gifCtrl = StreamController();

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  bool isPuzzleSolvableBool = false;
  int shuffleCount = 0;

  void swap(TileData t1, TileData t2, [bool isMove = false]) {
    TileData t;
    if ((!t1.isBlank && !t2.isBlank) || isMove) {
      t = t1.copyWith();
      t1.offset = t2.offset;
      t2.offset = t.offset;
    }
  }

  bool checkSolved() {
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i].offset != tiles[i].initOffset) return false;
    }
    moves > 0 ? widget.onSolved() : null;
    setState(() {
      reset();
    });
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    return true;
  }

  void reset() {
    moves = 0;
    solved = true;
    tiles = List.generate(
      widget.size * widget.size,
          (i) {
        final col = i ~/ widget.size,
            row = (i % widget.size),
            _dx = col * tileSize.width,
            _dy = row * tileSize.height,
            imgL = col / widget.size,
            imgT = row / widget.size;

        return TileData(
          key: ValueKey(i),
          size: tileSize,
          body: "${i + 1}",
          initOffset: Offset(_dx, _dy),
          offset: Offset(_dx, _dy),
          imageRect: Rect.fromLTRB(
            imgL,
            imgT,
            imgL + (1 / widget.size),
            imgT + (1 / widget.size),
          ),
          isBlank: (i) == (widget.size * widget.size - 1),
        );
      },
    );
  }

  void shuffle() async {
    setState(() {
      tabable = false;
    });
    for(int i = 0; !isPuzzleSolvableBool; i++){
      setState(() {
        for (int i = 0; i < tiles.length * 10; i++) {
          TileData t1 = tiles[math.Random().nextInt(tiles.length)],
              t2 = tiles[math.Random().nextInt(tiles.length)];
          shuffleMove(t1);
          shuffleMove(t2);
        }
      });
      moves = 0;
      shuffleCount++;
      List<int> tileList = [];
      int tileIndexdX = 0;
      int tileIndexdY = 0;
      tiles.forEach((element) {
        tileIndexdX = element.offset.dx == 0.0 ? (tileSize.width / tileSize.width).round() : ((element.offset.dx / tileSize.width) + 1).round();
        tileIndexdY = element.offset.dy == 0.0 ? (tileSize.height / tileSize.height).round() : ((element.offset.dy / tileSize.height) + 1).round();
        tileList.add(((tileIndexdY - 1) * widget.size) + tileIndexdX);
      });

      if(isPuzzleSolvable(tileList) && shuffleCount >= 2){
        isPuzzleSolvableBool = true;
        setState(() {
          tabable = true;
        });
      } else {
        await Future.delayed(Duration(milliseconds: 800));
      }
    }
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    setState(() {
      isPuzzleSolvableBool = false;
      shuffleCount = 0;
    });
  }

  void continueTimer() async {
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }
  void shuffleMove(TileData tile) {
    TileData blankTile = tiles.firstWhere((t) => t.isBlank);
    if (((tile.offset.dx - blankTile.offset.dx).abs() == tileSize.width &&
        tile.offset.dy == blankTile.offset.dy) ||
        ((tile.offset.dy - blankTile.offset.dy).abs() == tileSize.height &&
            tile.offset.dx == blankTile.offset.dx)) {
      setState(() {
        swap(tile, blankTile, true);
      });
    }
  }

  void move(TileData tile) {
    TileData blankTile = tiles.firstWhere((t) => t.isBlank);
    if (((tile.offset.dx - blankTile.offset.dx).abs() == tileSize.width &&
        tile.offset.dy == blankTile.offset.dy) ||
        ((tile.offset.dy - blankTile.offset.dy).abs() == tileSize.height &&
            tile.offset.dx == blankTile.offset.dx)) {
      setState(() {
        swap(tile, blankTile, true);
        moves++;
        solved = checkSolved();
      });


    }
  }

  @override
  void initState() {
    super.initState();

    tileSize = Size(widget.puzzleSize.width / widget.size,
        widget.puzzleSize.width / widget.size);

    reset();
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

    setState(() {
      tileSize = Size(widget.puzzleSize.width / widget.size,
          widget.puzzleSize.width / widget.size);

      tiles = List.generate(
        widget.size * widget.size,
            (i) {
          final col = i ~/ widget.size,
              row = (i % widget.size),
              _dx = col * tileSize.width,
              _dy = row * tileSize.height,
              imgL = col / widget.size,
              imgT = row / widget.size;

          return TileData(
            key: ValueKey(i),
            size: tileSize,
            body: "${i + 1}",
            initOffset: tiles[i].initOffset * (1 + ((tileSize.width - tiles[i].size.width) / tiles[i].size.width)),
            offset: tiles[i].offset * (1 + ((tileSize.width - tiles[i].size.width) / tiles[i].size.width)),
            imageRect: Rect.fromLTRB(
              imgL,
              imgT,
              imgL + (1 / widget.size),
              imgT + (1 / widget.size),
            ),
            isBlank: tiles[i].isBlank,
          );
        },
      );
    });

    return LayoutWrapper(
        puzzel_widget: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(2),
          child: SizedBox(
            height: widget.puzzleSize.height,
            width: widget.puzzleSize.width,
            child: Stack(
              children: tiles
                  .map(
                    (t) => TileWidget(
                  key: t.key,
                  tileData: t,
                  onTap: () => tabable ? move(t) : null,
                  imageProvider: widget.imageProvider,
                ),
              ).toList(),
            ),
          ),
        ),
        data_widget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClockWidget(stopWatchTimer: _stopWatchTimer),
            SizedBox(height: size.width <= 850 ? size.height * 0.015 :  size.height * 0.04,),
            Text("Spooky Puzzle", style: TextStyle(color: SpookyColors.kTextColor, fontFamily: "Regular", fontSize: size.width <= 280 ? 17 : deviceSize() == "Mobile" || deviceSize() == "Mobile Small" ? 18 : deviceSize() == "Tablet" ? 22 : 24,),),
            Text("Puzzle\nChallenge", style: TextStyle(color: SpookyColors.kTextColor, fontFamily: "Bold", fontSize: size.width <= 280 ? 35 : deviceSize() == "Mobile" || deviceSize() == "Mobile Small" ? 44 : deviceSize() == "Tablet" ? 56 : 68,),),
            SizedBox(height: size.width <= 850 ? size.height * 0.025 : size.height * 0.05,),
            Text(moves.toString() + " Moves | " + (widget.size * widget.size).toString() + " Tiles", style: TextStyle(color: SpookyColors.kLightTextColor, fontFamily: "Regular", fontSize: size.width <= 280 ? 17 : deviceSize() == "Mobile" || deviceSize() == "Mobile Small" ? 18 : deviceSize() == "Tablet" ? 22 : 24),),
            SizedBox(height: size.width <= 850 ? size.height * 0.01 : size.height * 0.02,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                reuseableButton(size, "Pause", () {
                  _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                  widget.onPausedClicked();
                }),
                SizedBox(width: size.width <= 850 ? 12 :  18,),
                reuseableButton(size, "Reset", () async{
                  _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                  setState(() => reset());
                  await Future.delayed(Duration(milliseconds: 1000));
                  shuffle();
                }),
              ],
            )
          ],
        ),
    );
  }

  Widget reuseableButton(Size size, String text, Function onClicked) {
    return InkWell(
      onTap: () {
        onClicked();
      },
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      child: Container(
        height: size.height * 0.035,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: const BoxDecoration(
          color: SpookyColors.kLightColor,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: SpookyColors.kLightTextColor, fontFamily: "Regular"),
          ),
        ),
      ),
    );
  }
}