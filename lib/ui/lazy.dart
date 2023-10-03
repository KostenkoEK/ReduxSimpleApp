import 'package:flutter/material.dart';
import 'package:redux_transactions_app/models/transaction.dart';

class Lazy{
  String parseType(int type) {
    switch (type) {
      case 0:
        return 'Перевод';
      case 1:
        return 'Пополнение';
      case 2:
        return 'Списание';
      default:
        return 'Операция';
    }
  }

  Map<String, double> getNewCounter(List<TransactionData> listItems) {
    Map<String, double> initCounter = {};
    initCounter = listItems.fold<Map<String, double>>(
        {},
            (map, element) {
          map[Lazy().parseType(element.type)] = (map[Lazy().parseType(element.type)] ?? 0) + 1;
          return map;
        }
    );
    return initCounter;
  }
  
  Widget getTransactionFieldWidget(BuildContext context, String name, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.blue.withOpacity(0.6)
        ),
        child: Text(
          '$name: $value'
        ),
      ),
    );
  }
}