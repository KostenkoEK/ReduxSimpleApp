import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:redux/redux.dart';
import 'package:redux_transactions_app/redux/actions/main_actions.dart';
import 'package:redux_transactions_app/ui/transaction_info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/app_state.dart';
import '../../models/transaction.dart';
import '../lazy.dart';

class _ViewModel{
  final Function(int) changeScreenIndex;
  final Function(TransactionData) addTransaction;
  final Function(Map<String, double>) updateCounter;
  final List<TransactionData> items;
  final int screenIndex;
  final bool isListScreen;
  final Map<String, double> counter;

  _ViewModel({
    required this.changeScreenIndex,
    required this.addTransaction,
    required this.updateCounter,
    required this.items,
    required this.screenIndex,
    required this.isListScreen,
    required this.counter
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        changeScreenIndex: (index) =>
        store.dispatch(ChangeScreenIndexAction(index)),
        addTransaction: (transaction) async {
          store.dispatch(AddTransaction(transaction));
        },
        updateCounter: (map) {
          store.dispatch(UpdateCounter(map));
        },
        items: store.state.listTransactions,
        screenIndex: store.state.screenIndex,
        isListScreen: store.state.screenIndex == 0,
        counter: store.state.counter
    );
  }
}

class BaseScreen extends StatelessWidget {
  BaseScreen({Key? key}) : super(key: key);

  Map<String, double> counts = {};

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
            floatingActionButton: vm.isListScreen ? FloatingActionButton(
              onPressed: () {
                int? id = prefs.getInt('lastAddedId');
                id ??= 2;
                id = id + 1;
                prefs.setInt('lastAddedId', id);
                double sum = 10000 * id * 0.667;
                Random random = Random();
                TransactionData transactionData = TransactionData(
                    id: id,
                    date: DateTime.now(),
                    sum: sum,
                    commission: 0.15,
                    total: sum + sum * 0.15,
                    type: random.nextInt(3)
                );
                List<TransactionData> items = List.empty(growable: true);
                items.addAll(vm.items);
                items.add(transactionData);
                ListTransactionsData listData = ListTransactionsData(list: items);
                prefs.setString('list_transactions_json', jsonEncode(listData.toJson()));
                vm.addTransaction(transactionData);
                vm.updateCounter(Lazy().getNewCounter(vm.items));
              },
              foregroundColor: Colors.blue,
              backgroundColor: Colors.blue,
              child: const Icon(CupertinoIcons.add_circled, color: Colors.white,),
            ) : null,
        appBar: PreferredSize(
          preferredSize: Size(
              MediaQuery.of(context).size.width,
              50
          ),
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Container(
              alignment: Alignment.center,
              color: Colors.blue.withOpacity(0.6),
              child: Text(
                  vm.isListScreen ?
                  'Список (Всего - ${vm.items.length})' : 'Диаграмма'
              ),
            ),
          ),
        ),
        body: vm.isListScreen ?
            Container(
              color: Colors.blue.withOpacity(0.2),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: vm.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        top: index == 0 ? 16 : 8,
                        left: 16,
                        right: 16,
                        bottom: index == vm.items.length ? 16 : 8
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TransactionInfoScreen(transactionData: vm.items[vm.items.length - 1 - index])),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 32,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          color: Colors.blue.withOpacity(0.4)
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${Lazy().parseType(vm.items[vm.items.length - 1 - index].type)} (${vm.items[vm.items.length - 1 - index].id})'
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(100)),
                                color: Colors.blue.withOpacity(0.1),
                              ),
                              child: FittedBox(
                                child: Text(
                                  vm.items[vm.items.length - 1 - index].sum.toString()
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ) : Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.blue.withOpacity(0.2),
          child: Center(
            child: vm.counter.isNotEmpty ? Container(
              width: MediaQuery.of(context).size.width * 2 /3,
              height: MediaQuery.of(context).size.width * 2 /3,
              child: PieChart(
                chartType: ChartType.ring,
                legendOptions: const LegendOptions(legendPosition: LegendPosition.bottom),
                ringStrokeWidth: MediaQuery.of(context).size.width / 6 ,
                dataMap: vm.counter,
              )
            ): const Text(
                'Пока нечего показать :('
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: vm.screenIndex,
          fixedColor: Colors.blue.withOpacity(0.8),
          onTap: (index) {
            vm.changeScreenIndex(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Список',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.donut_large),
                label: 'Диаграма'
            ),
          ],
        ),
      );
    });
  }
}
