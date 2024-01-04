import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../constants/collection.dart';
import '../constants/colors.dart';
import '../constants/decoration.dart';

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
      backgroundColor: const Color(0xff2d2c7f),
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
                      child: SizedBox(
                        height: size.height,
                        child: IndexedStack(
                          index: currentDreamIndex,
                          children:
                              List.generate(mySnapshots!.docs.length, (index) {
                            final myDream = mySnapshots.docs[index].data();
                            print(myDream);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SfRadialGauge(
                                    title: GaugeTitle(
                                      text: myDream["goal_name"] ?? "",
                                      textStyle: verylargeTitle,
                                    ),
                                    enableLoadingAnimation: true,
                                    axes: <RadialAxis>[
                                      RadialAxis(
                                          minimum: 0,
                                          axisLineStyle: AxisLineStyle(
                                            color: greyColor,
                                          ),
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
                                                                color: Colors
                                                                    .grey
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
                                      (inx) => InkWell(
                                            onTap: () {
                                              currentDreamIndex = inx;
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Icon(
                                                Icons.circle,
                                                size: 12,
                                                color: inx == currentDreamIndex
                                                    ? Colors.white
                                                    : Colors.white
                                                        .withOpacity(0.1),
                                              ),
                                            ),
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
                                              color: greyColor))
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
                                        color: const Color(0xff006ef2),
                                        borderRadius:
                                            BorderRadius.circular(20)),
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
                                            Text(
                                                "Monthly Savings Projections :",
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
                                  height: size.height * 0.3,
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30))),
                                  child: Column(
                                    children: List.generate(
                                        myDream["contributions_history"]
                                                .length +
                                            1, (inx) {
                                      if (inx == 0) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
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
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
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
                                          ),
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
                    ),
                  );
                default:
                  return const Center(
                    child: Text("Default"),
                  );
              }
            }),
      ),
      // floatingActionButton: FloatingActionButton(

      //   onPressed: () {
      //   FirebaseFirestore.instance.collection(savingsGoalsCollection).add({
      //     "contributions_history": [
      //       {"amount": 10000, "date_time": "July 2023"},
      //       {"amount": 20000, "date_time": "August 2023"}
      //     ],
      //     "target_amount": 400000,
      //     "expected_date": "Jan 2030",
      //     "goal_name": "Buy a Home For Parents",
      //     "current_savings": 150000
      //   });
      // }),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) => setState(() {
                currentIndex = value;
              }),
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: Colors.grey,
          items: List.generate(
              myBottomBarList.length,
              (index) => BottomNavigationBarItem(
                  label: "", icon: Icon(myBottomBarList[index])))),
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

  List<IconData> myBottomBarList = [
    Icons.home,
    Icons.autorenew_rounded,
    Icons.savings,
    Icons.settings,
  ];
}
