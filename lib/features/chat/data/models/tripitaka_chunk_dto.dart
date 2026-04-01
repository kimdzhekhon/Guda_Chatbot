import 'package:freezed_annotation/freezed_annotation.dart';

part 'tripitaka_chunk_dto.freezed.dart';
part 'tripitaka_chunk_dto.g.dart';

@freezed
abstract class TripitakaChunkDto with _$TripitakaChunkDto {
  const factory TripitakaChunkDto({
    String? id,
    required String content,
    required TripitakaMetadataDto metadata,
  }) = _TripitakaChunkDto;

  factory TripitakaChunkDto.fromJson(Map<String, dynamic> json) =>
      _$TripitakaChunkDtoFromJson(json);
}

@freezed
abstract class TripitakaMetadataDto with _$TripitakaMetadataDto {
  const factory TripitakaMetadataDto({
    int? volume,
    String? chapter,
    String? source,
  }) = _TripitakaMetadataDto;

  factory TripitakaMetadataDto.fromJson(Map<String, dynamic> json) =>
      _$TripitakaMetadataDtoFromJson(json);
}
