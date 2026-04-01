import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_log.freezed.dart';

@freezed
abstract class TransactionLog with _$TransactionLog {
  const factory TransactionLog({
    required String id,
    required String productName,
    required int amount,
    required String status,
    required DateTime createdAt,
  }) = _TransactionLog;

  const TransactionLog._();

  /// 결제 상태 확인
  bool get isSuccess => status == 'success' || status == 'active';
}
