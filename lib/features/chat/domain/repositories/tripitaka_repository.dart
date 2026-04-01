import '../entities/tripitaka_chunk.dart';

abstract class TripitakaRepository {
  Future<List<TripitakaChunk>> search(String query);
}
