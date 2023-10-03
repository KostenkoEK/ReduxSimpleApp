import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_transactions_app/models/app_state.dart';
import 'package:redux_transactions_app/models/transaction.dart';
import 'package:redux_transactions_app/redux/actions/main_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lazy.dart';

class _ViewModel {
  final Function(TransactionData) deleteTransaction;
  final Function(Map<String, double>) updateCounter;
  final List<TransactionData> items;

  _ViewModel({
    required this.deleteTransaction,
    required this.updateCounter,
    required this.items
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        deleteTransaction: (transaction) {
          store.dispatch(CancelTransaction(transaction));
        },
        updateCounter: (map) {
          store.dispatch(UpdateCounter(map));
        },
      items: store.state.listTransactions
    );
  }
}

class TransactionInfoScreen extends StatelessWidget {
  TransactionInfoScreen({Key? key, required this.transactionData}) : super(key: key);

  final TransactionData transactionData;


  late SharedPreferences prefs;

  configurePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }


  @override
  Widget build(BuildContext context) {
    configurePrefs();
    return StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(
                  MediaQuery.of(context).size.width,
                  50
              ),
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: Colors.blue.withOpacity(0.6),
                      child: Text(
                          'Транзакция #${transactionData.id}'
                      ),
                    ),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: GestureDetector(
                        onTap: () {Navigator.pop(context);},
                          child: Icon(CupertinoIcons.back, color: Colors.white,size: 30,)
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Lazy().getTransactionFieldWidget(context, 'Номер транзакции', transactionData.id.toString()),
                    Lazy().getTransactionFieldWidget(context, 'Дата', transactionData.date.toString().split('.')[0]),
                    Lazy().getTransactionFieldWidget(context, 'Сумма', transactionData.sum.toString()),
                    Lazy().getTransactionFieldWidget(context, 'Коммисия', transactionData.commission.toString() + '% (${transactionData.sum * 0.15})'),
                    Lazy().getTransactionFieldWidget(context, 'Итого', transactionData.total.toString()),
                    Lazy().getTransactionFieldWidget(context, 'Тип транзакции', Lazy().parseType(transactionData.type)),
                    ElevatedButton(
                        onPressed: () {
                          List<TransactionData> items = List.empty(growable: true);
                          items.addAll(vm.items);
                          items.remove(transactionData);
                          ListTransactionsData listData = ListTransactionsData(list: items);
                          prefs.setString('list_transactions_json', jsonEncode(listData.toJson()));
                          vm.deleteTransaction(transactionData);
                          vm.updateCounter(Lazy().getNewCounter(vm.items));
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red.withOpacity(0.7),
                          backgroundColor: Colors.red.withOpacity(0.7),
                          elevation: 0,
                          fixedSize: Size(MediaQuery.of(context).size.width, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                        const Text(
                          'Отменить',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
      }
    );
  }
}
