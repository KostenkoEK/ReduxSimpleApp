import 'dart:convert';

import 'package:redux_transactions_app/models/auth_data.dart';
import 'package:redux_transactions_app/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/lazy.dart';

class AppState{
  int screenIndex;
  List<TransactionData> listTransactions;
  Map<String, double> counter;
  AuthData authData;

  AppState({
    required this.screenIndex,
    required this.listTransactions,
    required this.counter,
    required this.authData
  });

  AppState copyWith({
    int? screenIndex,
    Map<String, double>? counter,
    List<TransactionData>? listTransactions,
    AuthData? authData
  }) {
    return AppState(
        screenIndex: screenIndex ?? this.screenIndex,
        counter: counter ?? this.counter,
        listTransactions: listTransactions ?? this.listTransactions,
        authData: authData ?? this.authData
    );
  }

  factory AppState.initialState(SharedPreferences prefs) {
    List<TransactionData> listTransactions = List.empty(growable: true);
    String? listItems = prefs.getString('list_transactions_json');
    if (listItems != null && listItems != '') {
      listTransactions.addAll(ListTransactionsData.fromJson(jsonDecode(listItems)).list);
    } else {
      listTransactions.addAll(
          [
            TransactionData(
              id: 0,
              date: DateTime.now(),
              sum: 1000,
              commission: 1000*0.05,
              total: 1000 + 1000 * 0.05,
              type: 0
            ),
            TransactionData(
                id: 1,
                date: DateTime.now(),
                sum: 2000,
                commission: 2000*0.05,
                total: 2000 + 2000 * 0.05,
                type: 1
            ),
            TransactionData(
                id: 2,
                date: DateTime.now(),
                sum: 3000,
                commission: 3000*0.05,
                total: 3000 + 3000 * 0.05,
                type: 2
            ),
          ]
      );
      prefs.setInt('lastAddedId', 2);
    }

    return AppState(
        screenIndex: 0,
        counter: Lazy().getNewCounter(listTransactions),
        listTransactions: listTransactions,
        authData: AuthData(
          userName: '',
          password: '',
          isLoading: false,
          isError: false
        )
    );
  }
}