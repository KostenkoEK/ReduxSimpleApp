// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionData _$TransactionDataFromJson(Map<String, dynamic> json) =>
    TransactionData(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      sum: (json['sum'] as num).toDouble(),
      commission: (json['commission'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      type: json['type'] as int,
    );

Map<String, dynamic> _$TransactionDataToJson(TransactionData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'sum': instance.sum,
      'commission': instance.commission,
      'total': instance.total,
      'type': instance.type,
    };

ListTransactionsData _$ListTransactionsDataFromJson(
        Map<String, dynamic> json) =>
    ListTransactionsData(
      list: (json['list'] as List<dynamic>)
          .map(TransactionData.fromJson)
          .toList(),
    );

Map<String, dynamic> _$ListTransactionsDataToJson(
        ListTransactionsData instance) =>
    <String, dynamic>{
      'list': instance.list,
    };
