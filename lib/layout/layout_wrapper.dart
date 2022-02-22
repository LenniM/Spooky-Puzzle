import 'package:flutter/material.dart';
import 'package:spookypuzzle/layout/breakpoints.dart';
import 'globals.dart' as globals;

class LayoutWrapper extends StatelessWidget {

  final Widget data_widget;
  final Widget puzzel_widget;

  const LayoutWrapper({Key? key, required this.data_widget, required this.puzzel_widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ///Getting the screen size
    Size size = MediaQuery.of(context).size;

    ///Building the layout depended on the screen size
    if(size.width <= PuzzleBreakpoints.small){
      globals.isSmallScreen = true;
      globals.isMediumScreen = false;
      globals.isLargeScreen = false;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          data_widget,
          SizedBox(height: size.height * 0.02,),
          puzzel_widget
        ],
      );
    }

    if(size.width <= PuzzleBreakpoints.medium){
      globals.isSmallScreen = false;
      globals.isMediumScreen = true;
      globals.isLargeScreen = false;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
//          level_widget,
//          SizedBox(height: size.height * 0.05,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                puzzel_widget,
                SizedBox(width: size.width * 0.03,),
                data_widget,
              ],
            ),
          ),
        ],
      );
    }


    if(size.width <= PuzzleBreakpoints.large){
      globals.isSmallScreen = false;
      globals.isMediumScreen = false;
      globals.isLargeScreen = true;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
//          level_widget,
//          SizedBox(height: size.height * 0.05,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                puzzel_widget,
                SizedBox(width: size.width * 0.03,),
                data_widget,
              ],
            ),
          ),
        ],
      );
    }

    ///Otherwise return the large layout
    globals.isSmallScreen = false;
    globals.isMediumScreen = false;
    globals.isLargeScreen = true;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
//          level_widget,
//          SizedBox(height: size.height * 0.05,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              puzzel_widget,
              SizedBox(width: size.width * 0.03,),
              data_widget,
            ],
          ),
        ],
      ),
    );

  }


}
