import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_transactions_app/redux/actions/login_actions.dart';
import 'package:redux_transactions_app/ui/base/base_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/app_state.dart';

class _ViewModel {
  final Function(String) onUsernameChanged;
  final Function(String) onPasswordChanged;
  final Function onLogin;
  final bool isLoading;
  final bool isError;
  
  _ViewModel({
    required this.onUsernameChanged,
    required this.onPasswordChanged,
    required this.onLogin,
    required this.isLoading,
    required this.isError
  });
  
  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        onUsernameChanged: (username) =>
          store.dispatch(UpdateUsernameAction(username)),
        onPasswordChanged: (password) =>
          store.dispatch(UpdatePasswordAction(password)),
        onLogin: (context) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          store.dispatch(LoginLoadingAction());
          Timer(
            const Duration(seconds: 1),
            () {
              if (store.state.authData.userName == 'admin' &&
              store.state.authData.password == 'password') {
                prefs.setBool('isAuthorized', true);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BaseScreen()),
                );
              } else {
                store.dispatch(LoginFailureAction());
              }
            }
           );
        },
        isLoading: store.state.authData.isLoading,
        isError: store.state.authData.isError
    );
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: FittedBox(
              child: Container(
                width: MediaQuery.of(context).size.width - 32,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.blue.withOpacity(0.2)
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.transparent,
                                  width: 1),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12))),
                          child: TextField(
                            controller: usernameController,
                            keyboardType: TextInputType.text,
                            onChanged: (value) => vm.onUsernameChanged(value),
                            decoration: const InputDecoration(
                                contentPadding:
                                EdgeInsets.all(16),
                                fillColor: Color.fromARGB(
                                    255, 240, 241, 243),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 0),
                                    borderRadius: BorderRadius.all(Radius.circular(12))),
                                hintText: 'Логин',
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(
                                      255, 136, 136, 136),
                                )),
                          )),
                      Container(
                          padding: const EdgeInsets.only(top: 16),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.transparent,
                                  width: 1),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12))),
                          child: TextField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            onChanged: (value) => vm.onPasswordChanged(value),
                            obscureText: true,
                            decoration: const InputDecoration(
                                contentPadding:
                                EdgeInsets.all(16),
                                fillColor: Color.fromARGB(
                                    255, 240, 241, 243),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 0),
                                    borderRadius: BorderRadius.all(Radius.circular(12))),
                                hintText: 'Пароль',
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(
                                      255, 136, 136, 136),
                                )),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: ElevatedButton(
                            onPressed: () {
                              vm.onLogin(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blue.withOpacity(0.7),
                              backgroundColor: Colors.blue.withOpacity(0.7),
                              elevation: 0,
                              fixedSize: Size(MediaQuery.of(context).size.width, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: vm.isLoading ?
                            Container(
                              width: 20,
                              height: 20,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            ) :
                            const Text(
                              'Авторизоваться',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            )
                        ),
                      ),
                      if (vm.isError)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                              'Неверный логин или пароль',
                            style: TextStyle(
                              color: Colors.red
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
