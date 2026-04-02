import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/tripitaka_chunk.dart';
import '../../domain/repositories/tripitaka_repository.dart';
import '../datasources/tripitaka_local_datasource.dart';
import '../models/tripitaka_chunk_dto.dart';

part 'tripitaka_repository_impl.g.dart';

class TripitakaRepositoryImpl implements TripitakaRepository {
  final TripitakaLocalDataSource _localDataSource;

  TripitakaRepositoryImpl(this._localDataSource);

  @override
  Future<List<TripitakaChunk>> search(String query) async {
    final results = await _localDataSource.search(query);
    return results.map((dto) => _mapDtoToEntity(dto)).toList();
  }

  TripitakaChunk _mapDtoToEntity(TripitakaChunkDto dto) {
    return TripitakaChunk(
      id: dto.id,
      content: dto.content,
      metadata: TripitakaMetadata(
        volume: dto.metadata.volume,
        chapter: dto.metadata.chapter,
        source: dto.metadata.source,
      ),
    );
  }
}

@riverpod
TripitakaRepository tripitakaRepository(Ref ref) {
  final localDataSource = ref.watch(tripitakaLocalDataSourceProvider);
  return TripitakaRepositoryImpl(localDataSource);
}
