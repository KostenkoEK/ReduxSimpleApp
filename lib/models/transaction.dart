
import 'package:json_annotation/json_annotation.dart';
part 'transaction.g.dart';

@JsonSerializable()
class TransactionData {
  TransactionData({
    required this.id,
    required this.date,
    required this.sum,
    required this.commission,
    required this.total,
    required this.type
  });

  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'date')
  DateTime date;
  @JsonKey(name: 'sum')
  double sum;
  @JsonKey(name: 'commission')
  double commission;
  @JsonKey(name: 'total')
  double total;
  @JsonKey(name: 'type')
  int type;


  factory TransactionData.fromJson(var json) => _$TransactionDataFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDataToJson(this);

}

@JsonSerializable()
class ListTransactionsData{
  ListTransactionsData({
    required this.list
  });
  @JsonKey(name: 'list')
  List<TransactionData> list;

  factory ListTransactionsData.fromJson(var json) => _$ListTransactionsDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListTransactionsDataToJson(this);
}
