import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/tripitaka_chunk_dto.dart';

part 'tripitaka_local_datasource.g.dart';

class TripitakaLocalDataSource {
  List<TripitakaChunkDto>? _cachedChunks;
  bool _isLoading = false;
  Completer<void>? _loadCompleter;

  /// 역인덱스: 단어 → 청크 인덱스 목록 (O(1) 검색)
  Map<String, List<int>>? _invertedIndex;

  Future<void> _ensureLoaded() async {
    if (_cachedChunks != null) return;

    if (_isLoading) {
      return _loadCompleter?.future;
    }

    _isLoading = true;
    _loadCompleter = Completer<void>();

    try {
      debugPrint('[Tripitaka] Loading chunks from assets...');
      final stopwatch = Stopwatch()..start();

      final String jsonString = await rootBundle.loadString('assets/data/tripitaka/tripitaka-chunks.json');

      // JSON 파싱을 별도 Isolate에서 수행 (15MB 파싱이 UI 스레드를 차단하지 않도록)
      _cachedChunks = await compute(_parseChunks, jsonString);

      // 역인덱스 구축
      _buildInvertedIndex();

      stopwatch.stop();
      debugPrint('[Tripitaka] Loaded ${_cachedChunks!.length} chunks + index in ${stopwatch.elapsedMilliseconds}ms');
      _loadCompleter?.complete();
    } catch (e) {
      debugPrint('[Tripitaka] Load error: $e');
      _cachedChunks = [];
      _loadCompleter?.completeError(e);
    } finally {
      _isLoading = false;
      _loadCompleter = null;
    }
  }

  /// Isolate에서 실행되는 JSON 파싱 함수
  static List<TripitakaChunkDto> _parseChunks(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => TripitakaChunkDto.fromJson(e)).toList();
  }

  /// 역인덱스 구축: 2글자 이상 토큰 → 청크 인덱스 매핑
  void _buildInvertedIndex() {
    final index = <String, List<int>>{};
    final splitter = RegExp(r'\s+');

    for (var i = 0; i < _cachedChunks!.length; i++) {
      final words = _cachedChunks![i].content.toLowerCase().split(splitter);
      for (final word in words) {
        if (word.length < 2) continue;
        (index[word] ??= []).add(i);
      }
    }
    _invertedIndex = index;
  }

  Future<List<TripitakaChunkDto>> search(String query) async {
    await _ensureLoaded();

    if (_cachedChunks == null || _cachedChunks!.isEmpty) return [];
    if (query.isEmpty) return [];

    final normalizedQuery = query.toLowerCase().trim();

    // 역인덱스가 있으면 사용, 없으면 폴백
    if (_invertedIndex != null && _invertedIndex!.isNotEmpty) {
      final queryWords = normalizedQuery.split(RegExp(r'\s+'));
      final hitCounts = <int, int>{}; // 청크 인덱스 → 매칭 단어 수

      for (final word in queryWords) {
        if (word.length < 2) continue;

        // 1단계: 정확한 키 매칭 (O(1))
        final exactHits = _invertedIndex![word];
        if (exactHits != null) {
          for (final idx in exactHits) {
            hitCounts[idx] = (hitCounts[idx] ?? 0) + 2; // 정확 매칭 가중치
          }
        }

        // 2단계: 접두사 매칭 (정확 매칭이 부족할 때만)
        if ((exactHits?.length ?? 0) < 3) {
          for (final entry in _invertedIndex!.entries) {
            if (entry.key != word && entry.key.startsWith(word)) {
              for (final idx in entry.value) {
                hitCounts[idx] = (hitCounts[idx] ?? 0) + 1;
              }
            }
          }
        }
      }

      if (hitCounts.isNotEmpty) {
        // 매칭 수 기준 정렬, 최대 50개로 제한 (메모리 + 전송량 절약)
        final sorted = hitCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return sorted.take(50).map((e) => _cachedChunks![e.key]).toList();
      }
    }

    // 폴백: 전체 문자열 매칭 (최대 50개)
    return _cachedChunks!.where((chunk) {
      return chunk.content.toLowerCase().contains(normalizedQuery);
    }).take(50).toList();
  }
}

@Riverpod(keepAlive: true)
TripitakaLocalDataSource tripitakaLocalDataSource(Ref ref) {
  return TripitakaLocalDataSource();
}
