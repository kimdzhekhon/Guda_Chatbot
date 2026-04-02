import 'package:freezed_annotation/freezed_annotation.dart';

part 'tripitaka_chunk.freezed.dart';

@freezed
abstract class TripitakaChunk with _$TripitakaChunk {
  const factory TripitakaChunk({
    String? id,
    required String content,
    required TripitakaMetadata metadata,
  }) = _TripitakaChunk;
}

@freezed
abstract class TripitakaMetadata with _$TripitakaMetadata {
  const factory TripitakaMetadata({
    int? volume,
    String? chapter,
    String? source,
  }) = _TripitakaMetadata;
}
