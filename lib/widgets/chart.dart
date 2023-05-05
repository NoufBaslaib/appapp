import 'package:appapp/models/transaction.dart';
import 'package:appapp/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recenteTransitions;
  Chart(this.recenteTransitions);

  List<Map<String, Object>> get groupedTransitionValue {
    return List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(Duration(days: index));
        double totalSum = 0.0;
        for (var i = 0; i < recenteTransitions.length; i++) {
          if (recenteTransitions[i].date.day == weekDay.day &&
              recenteTransitions[i].date.month == weekDay.month &&
              recenteTransitions[i].date.year == weekDay.year) {
            totalSum += recenteTransitions[i].amount;
          }
        }
        return {'day': DateFormat.E().format(weekDay), 'amount': totalSum};
      },
    );
  }

  double get totalSpending {
    return groupedTransitionValue.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
            children: groupedTransitionValue.map((data) {
          return Flexible(
            fit: FlexFit.tight,
            child: ChartBar(
                (data['day'] as String),
                (data['amount'] as double),
                totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpending),
          );
        }).toList()),
      ),
    );
  }
}
