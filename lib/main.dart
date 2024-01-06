import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TimerProvider(),
      child: const MyApp(),
    ),
  );
}

int STARTING_SECONDS = 5;

class TimerProvider with ChangeNotifier {
  final _stopwatch = Stopwatch();
  int _seconds = STARTING_SECONDS;
  bool _isPaused = true;
  bool _isFinished = false;
  bool _elementsHidden = false;
  late Timer _timer;

  int get seconds => _seconds;
  bool get isPaused => _isPaused;
  bool get isFinished => _isFinished;
  bool get elementsHidden => _elementsHidden;
  Duration get elapsed => _stopwatch.elapsed;

  TimerProvider();

  void hideElements() {
    _elementsHidden = true;
    notifyListeners();
  }

  void showElements() {
    _elementsHidden = false;
    notifyListeners();
  }

  void reset() {
    _isPaused = true;
    _isFinished = false;
    _seconds = STARTING_SECONDS;
    _stopwatch.reset();
    _timer.cancel();
    notifyListeners();
  }

  void pauseTimer() {
    _timer.cancel();
    _isPaused = true;
    _stopwatch.stop();
    notifyListeners();
  }

  void resumeTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _seconds = STARTING_SECONDS - _stopwatch.elapsed.inSeconds;
      if (seconds <= 0) {
        _isFinished = true;
        _elementsHidden = false;
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
    _timer.cancel();
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
    );
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
  String formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

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
                              Text(
                                'Elapsed Time: ${timerProvider.elapsed.inSeconds} seconds',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                formatDuration(timerProvider.seconds),
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
                                    visible: timerProvider.isPaused ||
                                        timerProvider.isFinished,
                                    child: TextButton(
                                      onPressed: timerProvider.reset,
                                      child: const Text('Reset'),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: timerProvider.isPaused
                                    ? timerProvider.resumeTimer
                                    : timerProvider.pauseTimer,
                                child: timerProvider._isPaused
                                    ? const Icon(Icons.play_arrow)
                                    : const Icon(Icons.pause),
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
                  tooltip: 'settings',
                  elevation: 0.0, // No shadow
                  child: const Icon(Icons.more_horiz),
                )
              : const SizedBox.shrink();
        }));
  }
}
