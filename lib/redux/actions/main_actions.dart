import '../../models/transaction.dart';

class ChangeScreenIndexAction {
  final int screenIndex;
  ChangeScreenIndexAction(this.screenIndex);
}

class AddTransaction{
  final TransactionData transactionData;
  AddTransaction(this.transactionData);
}

class CancelTransaction{
  final TransactionData transactionData;
  CancelTransaction(this.transactionData);
}

class UpdateCounter{
  final Map<String, double> counter;
  UpdateCounter(this.counter);
}