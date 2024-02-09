import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:meditate/widgets/value_scroll.dart';
import 'package:provider/provider.dart';
import 'package:clock/clock.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:wakelock/wakelock.dart';

import 'constants.dart' as Constants;
import 'utils.dart' as Utils;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TimerProvider(),
      child: const MyApp(),
    ),
  );
}

int STARTING_SECONDS = Constants.DEFAULT_TIMER_SECONDS;

class TimerProvider with ChangeNotifier {
  Duration _startingTime = Duration(
      seconds: Constants.DEFAULT_TIMER_SECONDS,
      minutes: Constants.DEFAULT_TIMER_MINUTES,
      hours: Constants.DEFAULT_TIMER_HOURS);
  final _stopwatch = clock.stopwatch();
  bool _isPaused = true;
  bool _isFinished = false;
  bool _hasStarted = false;
  bool _elementsHidden = false;
  Timer? _timer;
  final player = AudioPlayer();

  bool get isPaused => _isPaused;
  bool get isFinished => _isFinished;
  bool get elementsHidden => _elementsHidden;
  Duration get elapsed => _stopwatch.elapsed;
  bool get hasStarted => _hasStarted;
  Duration get startingTime => _startingTime;

  void setStartingTime(Duration startingTime) {
    _startingTime = startingTime;
    notifyListeners();
  }

  void hideElements() {
    _elementsHidden = true;
    notifyListeners();
  }

  void showElements() {
    _elementsHidden = false;
    notifyListeners();
  }

  void reset() {
    Wakelock.disable();
    _isPaused = true;
    _isFinished = false;
    _hasStarted = false;
    _stopwatch.stop();
    _stopwatch.reset();
    _timer?.cancel();
    player.stop();
    notifyListeners();
  }

  void pauseTimer() {
    Wakelock.disable();
    _timer?.cancel();
    _isPaused = true;
    _stopwatch.stop();
    player.pause();
    notifyListeners();
  }

  void resumeTimer() {
    Wakelock.enable();
    _hasStarted = true;
    if (player.state == PlayerState.paused) {
      player.resume();
    }
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if ((_startingTime.inSeconds - _stopwatch.elapsed.inSeconds) <= 0 &&
          !_isFinished) {
        _isFinished = true;
        _elementsHidden = false;
        await player.play(AssetSource('windchime1-7065.mp3'));
      }
      notifyListeners();
    });
    _isPaused = false;
    _stopwatch.start();
    notifyListeners();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer?.cancel();
    super.dispose();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Meditate',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(), // standard dark theme
        themeMode: ThemeMode.system, // device controls theme
        home: const MyHomePage(title: 'Meditate'),
        scrollBehavior: MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // backgroundColor: Colors.amber,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Consumer<TimerProvider>(builder: (context, timerProvider, child) {
          return GestureDetector(
              key: const Key('AppBody'),
              onTap: () {
                if (!timerProvider.isPaused && !timerProvider._isFinished) {
                  if (timerProvider._elementsHidden) {
                    timerProvider.showElements();
                  } else {
                    timerProvider.hideElements();
                  }
                }
              },
              child: Stack(
                children: [
                  // Background
                  Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  // UI elements that should appear
                  if (!timerProvider._elementsHidden)
                    Center(
                      // Center is a layout widget. It takes a single child and positions it
                      // in the middle of the parent.
                      child: Column(
                        // Column is also a layout widget. It takes a list of children and
                        // arranges them vertically. By default, it sizes itself to fit its
                        // children horizontally, and tries to be as tall as its parent.
                        //
                        // Column has various properties to control how it sizes itself and
                        // how it positions its children. Here we use mainAxisAlignment to
                        // center the children vertically; the main axis here is the vertical
                        // axis because Columns are vertical (the cross axis would be
                        // horizontal).
                        //
                        // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
                        // action in the IDE, or press "p" in the console), to see the
                        // wireframe for each widget.
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 200,
                                        width: 50,
                                        child: ValueScroll(
                                            length: 100,
                                            setValue: (value) => timerProvider
                                                .setStartingTime(Duration(
                                                    hours: value,
                                                    minutes: timerProvider
                                                        .startingTime.inMinutes
                                                        .remainder(60),
                                                    seconds: timerProvider
                                                        .startingTime.inSeconds
                                                        .remainder(60))),
                                            value: timerProvider
                                                .startingTime.inHours)),
                                    Container(
                                        height: 200,
                                        width: 50,
                                        child: ValueScroll(
                                            length: 60,
                                            setValue: (value) => timerProvider
                                                .setStartingTime(Duration(
                                                    hours: timerProvider
                                                        .startingTime.inHours,
                                                    minutes: value,
                                                    seconds: timerProvider
                                                        .startingTime.inSeconds
                                                        .remainder(60))),
                                            value: timerProvider
                                                .startingTime.inMinutes
                                                .remainder(60))),
                                    Container(
                                        height: 200,
                                        width: 50,
                                        child: ValueScroll(
                                            length: 60,
                                            setValue: (value) => timerProvider
                                                .setStartingTime(Duration(
                                                    hours: timerProvider
                                                        .startingTime.inHours,
                                                    minutes: timerProvider
                                                        .startingTime.inMinutes
                                                        .remainder(60),
                                                    seconds: value)),
                                            value: timerProvider
                                                .startingTime.inSeconds
                                                .remainder(60))),
                                  ]),
                              Text(
                                'Elapsed Time: ${timerProvider.elapsed.inSeconds} seconds',
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                Utils.formatDuration(Duration(
                                    seconds:
                                        timerProvider.startingTime.inSeconds -
                                            timerProvider.elapsed.inSeconds)),
                                style: const TextStyle(fontSize: 30),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // SizedBox(width: 20),
                                  Visibility(
                                    maintainState: true,
                                    maintainAnimation: true,
                                    maintainSize: true,
                                    visible: timerProvider.hasStarted &&
                                            timerProvider.isPaused ||
                                        timerProvider.isFinished,
                                    child: TextButton(
                                      onPressed: timerProvider.reset,
                                      child: const Text(Constants.RESET_TEXT),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              timerProvider.isPaused
                                  ? TextButton(
                                      onPressed: timerProvider.resumeTimer,
                                      child: const Icon(Icons.play_arrow),
                                    )
                                  : TextButton(
                                      onPressed: timerProvider.pauseTimer,
                                      child: const Icon(Icons.pause),
                                    )
                            ],
                          )
                        ],
                      ),
                    ),
                ],
              ));
        }),
        floatingActionButton:
            Consumer<TimerProvider>(builder: (context, timerProvider, child) {
          return timerProvider._isPaused || timerProvider._isFinished
              ? FloatingActionButton(
                  foregroundColor: colorScheme.primary,
                  backgroundColor: colorScheme.surface,
                  onPressed: () => {},
                  elevation: 0.0, // No shadow
                  child: const Icon(Icons.more_horiz),
                )
              : const SizedBox.shrink();
        }));
  }
}
