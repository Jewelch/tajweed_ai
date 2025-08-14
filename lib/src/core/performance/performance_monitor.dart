import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Moniteur de performance pour détecter les frames de jank
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  Timer? _frameTimer;
  int _frameCount = 0;
  int _jankFrameCount = 0;
  final List<double> _frameTimes = [];
  final List<double> _jankFrameTimes = [];

  // Seuil pour considérer un frame comme "jank" (en millisecondes)
  static const double _jankThresholdMs = 16.67; // 60 FPS = 16.67ms par frame

  // Seuil pour considérer un frame comme "severe jank"
  static const double _severeJankThresholdMs = 33.33; // 30 FPS = 33.33ms par frame

  /// Démarrer le monitoring de performance
  void startMonitoring() {
    if (kReleaseMode) return; // Seulement en mode debug

    _frameTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _analyzeFramePerformance();
    });

    // Utiliser addPostFrameCallback au lieu de addPersistentFrameCallback
    // pour éviter les conflits avec le système d'événements
    _scheduleNextFrame();

    developer.log('🚀 Performance monitoring started', name: 'PerformanceMonitor');
  }

  /// Arrêter le monitoring de performance
  void stopMonitoring() {
    _frameTimer?.cancel();
    _frameTimer = null;

    developer.log('⏹️ Performance monitoring stopped', name: 'PerformanceMonitor');
  }

  /// Programmer le prochain frame de manière sûre
  void _scheduleNextFrame() {
    if (!kDebugMode) return;

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _onFrameCallback(timeStamp);
      // Programmer le prochain frame seulement si le monitoring est actif
      if (_frameTimer != null) {
        _scheduleNextFrame();
      }
    });
  }

  /// Callback appelé à chaque frame
  void _onFrameCallback(Duration timeStamp) {
    try {
      final frameTime = timeStamp.inMicroseconds / 1000.0; // Convertir en millisecondes

      _frameCount++;
      _frameTimes.add(frameTime);

      // Garder seulement les 100 derniers frames pour l'analyse
      if (_frameTimes.length > 100) {
        _frameTimes.removeAt(0);
      }

      // Détecter le jank
      if (frameTime > _jankThresholdMs) {
        _jankFrameCount++;
        _jankFrameTimes.add(frameTime);

        // Garder seulement les 50 derniers frames de jank
        if (_jankFrameTimes.length > 50) {
          _jankFrameTimes.removeAt(0);
        }

        // Log des frames sévères
        if (frameTime > _severeJankThresholdMs) {
          developer.log(
            '⚠️ SEVERE JANK DETECTED: ${frameTime.toStringAsFixed(2)}ms',
            name: 'PerformanceMonitor',
            level: 900, // Warning level
          );
        } else {
          developer.log(
            '⚠️ JANK DETECTED: ${frameTime.toStringAsFixed(2)}ms',
            name: 'PerformanceMonitor',
            level: 800, // Info level
          );
        }
      }
    } catch (e) {
      // Gérer les erreurs de manière gracieuse
      developer.log('❌ Error in performance monitoring: $e', name: 'PerformanceMonitor');
    }
  }

  /// Analyser la performance des frames
  void _analyzeFramePerformance() {
    if (_frameTimes.isEmpty) return;

    try {
      final avgFrameTime = _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
      final jankPercentage = (_jankFrameCount / _frameCount) * 100;

      // Calculer le FPS moyen
      final avgFPS = 1000 / avgFrameTime;

      developer.log(
        '📊 Performance Stats:\n'
        '  Frames: $_frameCount\n'
        '  Jank Frames: $_jankFrameCount (${jankPercentage.toStringAsFixed(1)}%)\n'
        '  Avg Frame Time: ${avgFrameTime.toStringAsFixed(2)}ms\n'
        '  Avg FPS: ${avgFPS.toStringAsFixed(1)}',
        name: 'PerformanceMonitor',
      );
    } catch (e) {
      developer.log('❌ Error analyzing performance: $e', name: 'PerformanceMonitor');
    }
  }

  /// Obtenir un rapport de performance
  Map<String, dynamic> getPerformanceReport() {
    try {
      if (_frameTimes.isEmpty) {
        return {
          'status': 'No data available',
          'frames_analyzed': 0,
          'jank_frames': 0,
          'jank_percentage': 0.0,
          'avg_frame_time_ms': 0.0,
          'avg_fps': 0.0,
        };
      }

      final avgFrameTime = _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
      final jankPercentage = (_jankFrameCount / _frameCount) * 100;
      final avgFPS = 1000 / avgFrameTime;

      return {
        'status': 'Active',
        'frames_analyzed': _frameCount,
        'jank_frames': _jankFrameCount,
        'jank_percentage': jankPercentage,
        'avg_frame_time_ms': avgFrameTime,
        'avg_fps': avgFPS,
        'jank_threshold_ms': _jankThresholdMs,
        'severe_jank_threshold_ms': _severeJankThresholdMs,
      };
    } catch (e) {
      developer.log('❌ Error generating performance report: $e', name: 'PerformanceMonitor');
      return {
        'status': 'Error',
        'error': e.toString(),
        'frames_analyzed': 0,
        'jank_frames': 0,
        'jank_percentage': 0.0,
        'avg_frame_time_ms': 0.0,
        'avg_fps': 0.0,
      };
    }
  }

  /// Réinitialiser les statistiques
  void resetStats() {
    _frameCount = 0;
    _jankFrameCount = 0;
    _frameTimes.clear();
    _jankFrameTimes.clear();

    developer.log('🔄 Performance stats reset', name: 'PerformanceMonitor');
  }

  /// Vérifier si l'application a des problèmes de performance
  bool get hasPerformanceIssues {
    try {
      if (_frameTimes.isEmpty) return false;

      final avgFrameTime = _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
      final jankPercentage = (_jankFrameCount / _frameCount) * 100;

      // Considérer qu'il y a des problèmes si:
      // - Le temps de frame moyen est > 20ms (50 FPS)
      // - Plus de 10% de frames sont en jank
      return avgFrameTime > 20.0 || jankPercentage > 10.0;
    } catch (e) {
      developer.log('❌ Error checking performance issues: $e', name: 'PerformanceMonitor');
      return false;
    }
  }

  /// Obtenir des recommandations d'optimisation
  List<String> getOptimizationRecommendations() {
    final recommendations = <String>[];

    try {
      if (_frameTimes.isEmpty) {
        recommendations.add('Collect more performance data to provide recommendations');
        return recommendations;
      }

      final avgFrameTime = _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
      final jankPercentage = (_jankFrameCount / _frameCount) * 100;

      if (avgFrameTime > 20.0) {
        recommendations.add(
          'Average frame time is high (${avgFrameTime.toStringAsFixed(1)}ms). Consider optimizing widget rebuilds.',
        );
      }

      if (jankPercentage > 10.0) {
        recommendations.add(
          'High jank percentage (${jankPercentage.toStringAsFixed(1)}%). Review animations and heavy operations.',
        );
      }

      if (jankPercentage > 5.0) {
        recommendations.add(
          'Moderate jank detected. Check for expensive operations in build methods.',
        );
      }

      if (avgFrameTime > 16.67) {
        recommendations.add('Frame time exceeds 60 FPS target. Optimize rendering pipeline.');
      }

      // Recommandations générales
      recommendations.addAll([
        'Use const constructors where possible',
        'Implement RepaintBoundary for complex widgets',
        'Avoid expensive operations in build methods',
        'Use ListView.builder for long lists',
        'Consider using AnimatedBuilder instead of setState',
      ]);
    } catch (e) {
      developer.log(
        '❌ Error generating optimization recommendations: $e',
        name: 'PerformanceMonitor',
      );
      recommendations.add('Error generating recommendations. Check logs for details.');
    }

    return recommendations;
  }
}

/// Mixin pour ajouter le monitoring de performance aux widgets
mixin PerformanceMonitoringMixin<T extends StatefulWidget> on State<T> {
  PerformanceMonitor get _performanceMonitor => PerformanceMonitor();

  @override
  void initState() {
    super.initState();
    _performanceMonitor.startMonitoring();
  }

  @override
  void dispose() {
    _performanceMonitor.stopMonitoring();
    super.dispose();
  }
}

/// Extension pour ajouter des informations de performance aux widgets
extension PerformanceWidgetExtension on Widget {
  /// Ajouter un RepaintBoundary avec monitoring de performance
  Widget withPerformanceMonitoring({String? debugLabel}) {
    return RepaintBoundary(child: this);
  }

  /// Ajouter un RepaintBoundary conditionnel
  Widget withConditionalRepaintBoundary(bool shouldRepaintBoundary) {
    return shouldRepaintBoundary ? RepaintBoundary(child: this) : this;
  }
}
