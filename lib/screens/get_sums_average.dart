import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhiwise_flutter_assigment/constants/collection.dart';
import 'package:flutter/material.dart';

class AverageSumAggregatoSample extends StatelessWidget {
  const AverageSumAggregatoSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                var countNumer = FirebaseFirestore.instance
                    .collection(savingsGoalsCollection)
                    .count();
                print(countNumer);
              },
              child: const Text("Count")),
          ElevatedButton(
              onPressed: () async {
                AggregateQuerySnapshot sumResult = await FirebaseFirestore
                    .instance
                    .collection(savingsGoalsCollection)
                    .aggregate(sum("current_savings"))
                    .get();
                print(sumResult.getSum("current_savings"));
              },
              child: const Text("Sum")),
          ElevatedButton(
              onPressed: () async {
                AggregateQuerySnapshot averageResult = await FirebaseFirestore
                    .instance
                    .collection(savingsGoalsCollection)
                    .aggregate(average("current_savings"))
                    .get();
                print((averageResult.getAverage("current_savings")));
              },
              child: const Text("Average")),
        ],
      ),
    );
  }
}
