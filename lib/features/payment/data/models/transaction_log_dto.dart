import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guda_chatbot/features/payment/domain/entities/transaction_log.dart';

part 'transaction_log_dto.freezed.dart';
part 'transaction_log_dto.g.dart';

@freezed
abstract class TransactionLogDto with _$TransactionLogDto {
  const factory TransactionLogDto({
    required String id,
    @JsonKey(name: 'product_name') required String productName,
    required int amount,
    required String status,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _TransactionLogDto;

  factory TransactionLogDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionLogDtoFromJson(json);

  const TransactionLogDto._();

  TransactionLog toDomain() => TransactionLog(
        id: id,
        productName: productName,
        amount: amount,
        status: status,
        createdAt: DateTime.parse(createdAt),
      );
}
