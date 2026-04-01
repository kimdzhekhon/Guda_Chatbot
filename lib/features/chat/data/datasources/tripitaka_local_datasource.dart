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

  Future<void> _ensureLoaded() async {
    if (_cachedChunks != null) return;
    
    if (_isLoading) {
      return _loadCompleter?.future;
    }

    _isLoading = true;
    _loadCompleter = Completer<void>();
    
    try {
      debugPrint('📖 Loading Tripitaka chunks from assets...');
      final stopwatch = Stopwatch()..start();
      
      final String jsonString = await rootBundle.loadString('assets/data/tripitaka/tripitaka-chunks.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _cachedChunks = jsonList.map((e) => TripitakaChunkDto.fromJson(e)).toList();
      
      stopwatch.stop();
      debugPrint('✅ Loaded ${_cachedChunks!.length} chunks in ${stopwatch.elapsedMilliseconds}ms');
      _loadCompleter?.complete();
    } catch (e) {
      debugPrint('❌ Error loading Tripitaka chunks: $e');
      _cachedChunks = [];
      _loadCompleter?.completeError(e);
    } finally {
      _isLoading = false;
      _loadCompleter = null;
    }
  }

  Future<List<TripitakaChunkDto>> search(String query) async {
    await _ensureLoaded();
    
    if (_cachedChunks == null) {
      debugPrint('⚠️ Tripitaka chunks not loaded (cachedChunks is null)');
      return [];
    }
    
    debugPrint('🔎 Searching in ${_cachedChunks!.length} chunks for: "$query"');
    
    if (query.isEmpty) return [];

    final normalizedQuery = query.toLowerCase().trim();
    
    final results = _cachedChunks!.where((chunk) {
      // 너무 과격한 공백 제거를 지양하고 trim() 정도만 수행
      final content = chunk.content.toLowerCase();
      return content.contains(normalizedQuery);
    }).toList();

    debugPrint('🎯 Found ${results.length} matches');
    return results;
  }
}

@Riverpod(keepAlive: true)
TripitakaLocalDataSource tripitakaLocalDataSource(Ref ref) {
  return TripitakaLocalDataSource();
}
