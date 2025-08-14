import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'performance_monitor.dart';

/// Overlay de performance pour afficher les métriques en temps réel
class PerformanceOverlay extends StatefulWidget {
  const PerformanceOverlay({super.key});

  @override
  State<PerformanceOverlay> createState() => _PerformanceOverlayState();
}

class _PerformanceOverlayState extends State<PerformanceOverlay> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final PerformanceMonitor _monitor = PerformanceMonitor();
  Map<String, dynamic> _performanceData = {};
  bool _isVisible = true;
  bool _isExpanded = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();

    // Mettre à jour les données de performance toutes les 500ms
    _startPerformanceUpdates();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startPerformanceUpdates() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        try {
          setState(() {
            _performanceData = _monitor.getPerformanceReport();
            _hasError = false;
          });
        } catch (e) {
          setState(() {
            _hasError = true;
          });
        }
        _startPerformanceUpdates();
      }
    });
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });

    if (_isVisible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    return Positioned(
      top: 100,
      right: 16,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isExpanded ? 280 : 200,
          child: Card(
            elevation: 8,
            color: _hasError ? Colors.red.shade900 : Colors.black87,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                if (_isExpanded) _buildDetailedStats(),
                _buildQuickStats(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _hasError
            ? Colors.red
            : _monitor.hasPerformanceIssues
            ? Colors.orange
            : Colors.green,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _hasError
                ? Icons.error
                : _monitor.hasPerformanceIssues
                ? Icons.warning
                : Icons.check_circle,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _hasError ? 'Performance Error' : 'Performance Monitor',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _toggleExpansion,
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                  size: 16,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
              IconButton(
                onPressed: _toggleVisibility,
                icon: const Icon(Icons.close, color: Colors.white, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    if (_hasError) {
      return Container(
        padding: const EdgeInsets.all(8),
        child: const Text(
          'Error loading performance data',
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      );
    }

    final status = _performanceData['status'] ?? 'No data';
    final avgFPS = _performanceData['avg_fps'] ?? 0.0;
    final jankPercentage = _performanceData['jank_percentage'] ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          _buildStatRow('Status', status, _getStatusColor(status)),
          _buildStatRow('FPS', '${avgFPS.toStringAsFixed(1)}', _getFPSColor(avgFPS)),
          _buildStatRow(
            'Jank',
            '${jankPercentage.toStringAsFixed(1)}%',
            _getJankColor(jankPercentage),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStats() {
    if (_hasError) {
      return Container(
        padding: const EdgeInsets.all(8),
        child: const Text(
          'Cannot display detailed stats due to error',
          style: TextStyle(color: Colors.white70, fontSize: 10),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          _buildStatRow('Frames', '${_performanceData['frames_analyzed'] ?? 0}'),
          _buildStatRow('Jank Frames', '${_performanceData['jank_frames'] ?? 0}'),
          _buildStatRow(
            'Avg Frame Time',
            '${(_performanceData['avg_frame_time_ms'] ?? 0.0).toStringAsFixed(2)}ms',
          ),
          _buildStatRow(
            'Threshold',
            '${(_performanceData['jank_threshold_ms'] ?? 16.67).toStringAsFixed(2)}ms',
          ),
          const Divider(color: Colors.white24, height: 16),
          _buildOptimizationSection(),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizationSection() {
    try {
      final recommendations = _monitor.getOptimizationRecommendations();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Optimizations:',
            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          ...recommendations
              .take(3)
              .map(
                (rec) => Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Text('• $rec', style: const TextStyle(color: Colors.white70, fontSize: 9)),
                ),
              ),
        ],
      );
    } catch (e) {
      return const Text(
        'Cannot load optimization recommendations',
        style: TextStyle(color: Colors.white70, fontSize: 9),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'no data available':
        return Colors.orange;
      case 'error':
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  Color _getFPSColor(double fps) {
    if (fps >= 55) return Colors.green;
    if (fps >= 45) return Colors.orange;
    return Colors.red;
  }

  Color _getJankColor(double jankPercentage) {
    if (jankPercentage <= 5) return Colors.green;
    if (jankPercentage <= 10) return Colors.orange;
    return Colors.red;
  }
}

/// Extension pour ajouter facilement l'overlay de performance
extension PerformanceOverlayExtension on Widget {
  Widget withPerformanceOverlay() {
    return Stack(children: [this, const PerformanceOverlay()]);
  }

  Widget withPerformanceOverlayIf(bool condition) {
    return condition
        ? Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(children: [this, const PerformanceOverlay()]),
          )
        : this;
  }
}
