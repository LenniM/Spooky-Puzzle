import 'package:flutter/material.dart';
import 'package:spookypuzzle/style/colors.dart';
import 'package:spookypuzzle/widgets/clock/clock_data.dart';

class ClockWidget extends StatelessWidget {
  final StopWatchTimer stopWatchTimer;

  const ClockWidget({Key? key, required this.stopWatchTimer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.timer, color: SpookyColors.kTextColor,),
        const SizedBox(width: 5,),
        StreamBuilder<int>(
          stream: stopWatchTimer.rawTime,
          initialData: 0,
          builder: (context, snapshot){
            final displayTime = StopWatchTimer.getDisplayTime(snapshot.data!);
            return Text(displayTime, style: TextStyle(color: SpookyColors.kTextColor, fontSize: size.width <= 850 ? 14 : 16),);
          },
        ),
      ],
    );
  }
}
