import 'package:flutter/material.dart';
import 'package:redux_transactions_app/redux/reducers.dart';
import 'package:redux_transactions_app/ui/base/base_screen.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_transactions_app/ui/login/login_screen.dart';

import 'models/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) => {
    runApp(MyApp(prefs: prefs,))
  });
}

class MyApp extends StatelessWidget {

  final SharedPreferences prefs;



  const MyApp({super.key, required this.prefs});
  @override
  Widget build(BuildContext context) {
     Store<AppState> store = Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(prefs),
    );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: checkIsAuthorized(),
      ),
    );
  }

  Widget checkIsAuthorized() {
    bool? isAuthorized = prefs.getBool('isAuthorized');
    if (isAuthorized != null && isAuthorized) {
      return BaseScreen();
    } else {
      return LoginScreen();
    }
  }
}
