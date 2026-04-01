import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/tripitaka_repository.dart';
import '../../data/repositories/tripitaka_repository_impl.dart';
import '../entities/tripitaka_chunk.dart';

part 'search_tripitaka_local_usecase.g.dart';

class SearchTripitakaLocalUseCase {
  final TripitakaRepository _repository;

  SearchTripitakaLocalUseCase(this._repository);

  Future<List<TripitakaChunk>> execute(String query) async {
    return await _repository.search(query);
  }
}

@riverpod
SearchTripitakaLocalUseCase searchTripitakaLocalUseCase(Ref ref) {
  final repository = ref.watch(tripitakaRepositoryProvider);
  return SearchTripitakaLocalUseCase(repository);
}
