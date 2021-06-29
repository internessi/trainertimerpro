import 'package:circular_countdown/circular_countdown.dart';
import 'package:timer_controller/timer_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'basrutten_mp3.dart';

class TrainerPage extends StatelessWidget {
  const TrainerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Trainer Timer',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[900],
      body: const SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: _Countdowns(),
          ),
        ),
      ),
    );
  }
}

class _Countdowns extends StatefulWidget {
  const _Countdowns({
    Key? key,
  }) : super(key: key);

  @override
  __CountdownsState createState() => __CountdownsState();
}

class __CountdownsState extends State<_Countdowns> {

  final List<String> _mp3 = BasRuttenMp3().mp3;
  final List<int> _mp3duration = BasRuttenMp3().mp3duration;

  AudioCache audioCache= AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();

  int indexIsPlaying = 0;
  int timeStart = 0;
  int timeSoFar = 0;
  late final TimerController _controller;
  @override
  void initState() {
    super.initState();
    timeStart = 180;
    _controller = TimerController.seconds(timeStart);


  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TimerControllerListener(
      controller: _controller,
      listenWhen: (previousValue, currentValue) =>
      previousValue.remaining != currentValue.remaining,
      listener: (context, timerValue) {
        timeSoFar = timeStart - timerValue.remaining;
        // print(timeSoFar);
        if (timeSoFar == 3) {
          print(_mp3duration[1]);
          playSound(_mp3[1]);
        }
        if (timeSoFar == 6) {
          print(_mp3duration[2]);
          playSound(_mp3[2]);
        }
        if (timeSoFar == 9) {
          print(_mp3duration[3]);
          playSound(_mp3[3]);
        }
        if (timeSoFar == 12) {
          print(_mp3duration[4]);
          playSound(_mp3[4]);
        }

      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TimerControllerBuilder(
              controller: _controller,
              builder: (context, timerValue, _) {
                Color? timerColor;
                switch (timerValue.status) {
                  case TimerStatus.running:
                    timerColor = Colors.green;
                    break;
                  case TimerStatus.paused:
                    timerColor = Colors.grey;
                    break;
                  case TimerStatus.finished:
                    timerColor = Colors.red;
                    break;
                  default:
                }

                return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  spacing: 40,
                  runSpacing: 40,
                  children: <Widget>[
                CircularCountdown(
                      diameter: 250,
                      countdownTotal: _controller.initialValue.remaining,
                      countdownRemaining: timerValue.remaining,
                      countdownCurrentColor: timerColor,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 90,
                      ),
                    ),
                  ],
                );
              },
            ),
            const Gap(40),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _ActionButton(
                  title: 'Start',
                  onPressed: () => _controller.start(),
                ),
                _ActionButton(
                  title: 'Pause',
                  onPressed: () => _controller.pause(),
                ),
                _ActionButton(
                  title: 'Reset',
                  onPressed: () => _controller.reset(),
                ),
                _ActionButton(
                  title: 'Restart',
                  onPressed: () => _controller.restart(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void initSounds() async {
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioCache.loadAll(_mp3);
  }

  void playSound(_mp3) async {
    var fileName = _mp3;
    if ( audioPlayer.state.index == 1) {
      audioPlayer.stop();
    }
    audioPlayer = await audioCache.play(fileName);
  }

  void stopSound(_mp3) {
    audioPlayer.stop();
  }


}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.title,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(title),
    );
  }
}

class _StatusSnackBar extends SnackBar {
  _StatusSnackBar(
      String title,
      ) : super(
    content: Text(title),
    duration: const Duration(seconds: 1),
  );
}

