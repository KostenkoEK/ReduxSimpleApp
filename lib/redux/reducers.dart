import 'package:redux_transactions_app/models/auth_data.dart';
import 'package:redux_transactions_app/redux/actions/login_actions.dart';
import 'package:redux_transactions_app/redux/actions/main_actions.dart';

import '../models/app_state.dart';
import '../models/transaction.dart';

AppState appStateReducer(AppState state, action) {
  if (action is ChangeScreenIndexAction) {
    return AppState(
      counter: state.counter,
      screenIndex: action.screenIndex,
      listTransactions: listReducers(state.listTransactions, action),
      authData: authReducers(state.authData, action),
    );
  } else if (action is UpdateCounter) {
    return AppState(
      counter: action.counter,
      screenIndex: state.screenIndex,
      listTransactions: listReducers(state.listTransactions, action),
      authData: authReducers(state.authData, action),
    );
  } else {
    return AppState(
      counter: state.counter,
      screenIndex: state.screenIndex,
      listTransactions: listReducers(state.listTransactions, action),
      authData: authReducers(state.authData, action),
    );
  }
}

List<TransactionData> listReducers(List<TransactionData> state, action) {
  if (action is AddTransaction) {
    return state..add(action.transactionData);
  } else if (action is CancelTransaction) {
    return state..remove(action.transactionData);
  } else {
    return state;
  }
}

AuthData authReducers(AuthData state, action) {
  if (action is UpdateUsernameAction) {
    return AuthData(
        userName: action.username,
        password: state.password,
        isError: state.isError,
        isLoading: state.isLoading
    );
  } else if (action is UpdatePasswordAction) {
    return AuthData(
      userName: state.userName,
      password: action.password,
      isError: state.isError,
      isLoading: state.isLoading
    );
  } else if (action is LoginLoadingAction) {
    return AuthData(
        userName: state.userName,
        password: state.password,
        isError: false,
        isLoading: true
    );
  } else if (action is LoginFailureAction) {
    return AuthData(
        userName: state.userName,
        password: state.password,
        isError: true,
        isLoading: false
    );
  } else {
    return state;
  }
}