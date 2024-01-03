import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhiwise_flutter_assigment/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'constants/collection.dart';
import 'constants/decoration.dart';
import 'screens/login.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(
        isLogin: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  int currentDreamIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(savingsGoalsCollection)
                .snapshots(),
            builder: (_, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                  final mySnapshots = snapshot.data;
                  return SingleChildScrollView(
                    // Center is a layout widget. It takes a single child and positions it
                    // in the middle of the parent.
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: IndexedStack(
                        index: currentDreamIndex,
                        children:
                            List.generate(mySnapshots!.docs.length, (index) {
                          final myDream = mySnapshots.docs[index].data();
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SfRadialGauge(
                                  title: GaugeTitle(
                                    text: myDream["goal_name"] ?? "",
                                    textStyle: verylargeTitle,
                                  ),
                                  axes: <RadialAxis>[
                                    RadialAxis(
                                        minimum: 0,
                                        maximum: double.parse(
                                            "${myDream["target_amount"] ?? 0}"),
                                        labelOffset: 0,
                                        showLabels: false,
                                        showTicks: false,
                                        ranges: [
                                          GaugeRange(
                                              startValue: 0,
                                              endValue: double.parse(
                                                  "${myDream["current_savings"] ?? 0}"),
                                              color: Colors.white)
                                        ],
                                        majorTickStyle: const MajorTickStyle(
                                            color: Colors.transparent),
                                        annotations: <GaugeAnnotation>[
                                          GaugeAnnotation(
                                              widget: Column(
                                                children: [
                                                  const Icon(
                                                    Icons.home,
                                                    size: 100,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                      "\$ ${myDream["current_savings"] ?? 0}",
                                                      style: largeTitle),
                                                  Text('You Saved',
                                                      style:
                                                          largeTitle.copyWith(
                                                              color: Colors.grey
                                                                  .shade400)),
                                                ],
                                              ),
                                              angle: 90,
                                              positionFactor: 0.5)
                                        ])
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    mySnapshots.docs.length,
                                    (inx) => Icon(
                                          Icons.circle,
                                          size: 15,
                                          color: inx == currentDreamIndex
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.1),
                                        )),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                    const TextSpan(
                                        text: "Goal", style: midTitle),
                                    TextSpan(
                                        text:
                                            "\nBy ${myDream["expected_date"]}",
                                        style: semimidTitle.copyWith(
                                            color: Colors.grey.shade500))
                                  ])),
                                  Text(
                                    "\$ ${myDream["target_amount"] ?? 0}",
                                    style: midTitle,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                  height: size.height * 0.1,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Need More Savings :",
                                              style: semimidTitle),
                                          Text("Monthly Savings Projections :",
                                              style: semimidTitle),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "\$ ${(myDream["target_amount"] ?? 0) - myDream["current_savings"] ?? 0}",
                                            style: semimidTitle,
                                            textAlign: TextAlign.end,
                                          ),
                                          Text(
                                            "\$ ${calculateMonthlySavings(myDream["target_amount"] ?? 0, myDream["current_savings"] ?? 0, DateFormat("MMM yyyy").parse(myDream["expected_date"])).toStringAsFixed(2)}",
                                            style: semimidTitle,
                                            textAlign: TextAlign.right,
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                                child: Column(
                                  children: List.generate(
                                      myDream["contributions_history"].length +
                                          1, (inx) {
                                    if (inx == 0) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Contributions",
                                              style: verylargeTitle.copyWith(
                                                  color: Colors.black),
                                            ),
                                            const Text("View History")
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Amount \$${myDream["contributions_history"][inx - 1]["amount"]}",
                                            style: semimidTitle.copyWith(
                                                color: Colors.black),
                                          ),
                                          Text(
                                            myDream["contributions_history"]
                                                    [inx - 1]["date_time"]
                                                .toString(),
                                            style: semimidTitle.copyWith(
                                                color: Colors.black),
                                          )
                                        ],
                                      );
                                    }
                                  }),
                                ),
                              )
                            ],
                          );
                        }),
                      ),
                    ),
                  );
                default:
                  return const Center(
                    child: Text("Default"),
                  );
              }
            }),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) => setState(() {
                currentIndex = value;
              }),
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: Colors.grey,
          items: List.generate(
              4,
              (index) => const BottomNavigationBarItem(
                  label: "", icon: Icon(Icons.home)))),
    );
  }

  double calculateMonthlySavings(
      num targetGoal, num currentSave, DateTime expectedDate) {
    num remainSave = targetGoal - currentSave;
    Duration timeLeft = expectedDate.difference(DateTime.now());
    double daysPerYear = 365;
    double monthlySave = remainSave / (timeLeft.inDays / daysPerYear) / 12;
    return monthlySave;
  }
}
