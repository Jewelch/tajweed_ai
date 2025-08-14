import 'package:flutter/material.dart';

import '../../base/screens/exports.dart';

/// Analyse des problèmes de performance identifiés dans le code
class PerformanceAnalysis {
  static final PerformanceAnalysis _instance = PerformanceAnalysis._internal();
  factory PerformanceAnalysis() => _instance;
  PerformanceAnalysis._internal();

  /// Analyser les widgets et identifier les problèmes de performance
  Map<String, List<String>> analyzeWidgets() {
    return {
      'ShiftHandoverScreen': _analyzeShiftHandoverScreen(),
      'ReportViewWidget': _analyzeReportViewWidget(),
      'NoteCard': _analyzeNoteCard(),
      'BlocProviderWidget': _analyzeBlocProviderWidget(),
      'WidgetModifiers': _analyzeWidgetModifiers(),
    };
  }

  /// Analyser ShiftHandoverScreen
  List<String> _analyzeShiftHandoverScreen() {
    return [
      '✅ Utilise BlocBuilder avec listenWhen pour éviter les rebuilds inutiles',
      '✅ fullRebuildWhen retourne false pour éviter les rebuilds complets',
      '⚠️ BlocBuilder peut causer des rebuilds si pas de buildWhen',
      '💡 Considérer utiliser BlocSelector pour des rebuilds plus précis',
      '💡 Ajouter RepaintBoundary autour des widgets statiques',
    ];
  }

  /// Analyser ReportViewWidget
  List<String> _analyzeReportViewWidget() {
    return [
      '⚠️ ListView.separated peut causer des problèmes avec de grandes listes',
      '💡 Utiliser ListView.builder pour de meilleures performances',
      '💡 Implémenter RepaintBoundary pour NoteCard',
      '💡 Considérer la pagination pour de très grandes listes',
      '✅ Utilise const constructeurs pour les widgets statiques',
    ];
  }

  /// Analyser NoteCard
  List<String> _analyzeNoteCard() {
    return [
      '⚠️ DateFormat.jm() est recalculé à chaque build',
      '💡 Extraire DateFormat.jm() en variable statique',
      '💡 Utiliser const constructeurs pour les icônes et styles',
      '💡 Considérer utiliser AnimatedContainer pour les animations',
      '✅ Utilise des const constructeurs pour les widgets statiques',
    ];
  }

  /// Analyser BlocProviderWidget
  List<String> _analyzeBlocProviderWidget() {
    return [
      '⚠️ setState.execute peut causer des rebuilds inutiles',
      '💡 Optimiser la logique de fullRebuildWhen',
      '💡 Considérer utiliser BlocListener au lieu de BlocBuilder quand possible',
      '✅ Bloc est initialisé une seule fois dans initState',
      '✅ Gestion correcte du cycle de vie',
    ];
  }

  /// Analyser WidgetModifiers
  List<String> _analyzeWidgetModifiers() {
    return [
      '⚠️ Opacity est marqué comme déprécié pour les performances',
      '💡 Remplacer Opacity par AnimatedOpacity ou FadeTransition',
      '💡 Container avec BoxShadow peut être coûteux',
      '💡 BackdropFilter avec ImageFilter.blur est très coûteux',
      '✅ Utilise des const constructeurs quand possible',
    ];
  }

  /// Obtenir des recommandations d'optimisation générales
  List<String> getGeneralOptimizations() {
    return [
      '🚀 Utiliser const constructeurs partout où possible',
      '🚀 Implémenter RepaintBoundary pour les widgets complexes',
      '🚀 Utiliser ListView.builder au lieu de ListView.separated',
      '🚀 Éviter les opérations coûteuses dans build()',
      '🚀 Utiliser BlocSelector au lieu de BlocBuilder quand possible',
      '🚀 Implémenter la pagination pour les longues listes',
      '🚀 Utiliser AnimatedBuilder au lieu de setState',
      '🚀 Éviter les animations d\'Opacity, utiliser FadeTransition',
      '🚀 Optimiser les images et assets',
      '🚀 Utiliser des keys appropriées pour les listes',
    ];
  }

  /// Obtenir des recommandations spécifiques pour les frames de jank
  List<String> getJankFrameOptimizations() {
    return [
      '🎯 Identifié: DateFormat.jm() recalculé à chaque frame',
      '🎯 Solution: Extraire en variable statique ou utiliser const',
      '🎯 Identifié: ListView.separated peut causer des rebuilds',
      '🎯 Solution: Remplacer par ListView.builder avec itemBuilder',
      '🎯 Identifié: setState.execute dans BlocProviderWidget',
      '🎯 Solution: Optimiser la logique de rebuild conditionnel',
      '🎯 Identifié: Opacity déprécié pour les performances',
      '🎯 Solution: Remplacer par AnimatedOpacity ou FadeTransition',
      '🎯 Identifié: BackdropFilter avec blur très coûteux',
      '🎯 Solution: Limiter l\'utilisation ou optimiser les paramètres',
    ];
  }

  /// Créer un widget d'analyse de performance
  Widget buildPerformanceAnalysisWidget() {
    final analysis = analyzeWidgets();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🔍 Performance Analysis Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Analyse des widgets
            ...analysis.entries.map((entry) => _buildWidgetAnalysis(entry.key, entry.value)),

            const Divider(height: 32),

            // Recommandations générales
            _buildSection('🚀 General Optimizations', getGeneralOptimizations()),

            const Divider(height: 32),

            // Optimisations pour les frames de jank
            _buildSection('🎯 Jank Frame Optimizations', getJankFrameOptimizations()),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetAnalysis(String widgetName, List<String> issues) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widgetName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        ...issues.map(
          (issue) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Text(
              issue,
              style: TextStyle(
                fontSize: 12,
                color: issue.startsWith('✅')
                    ? Colors.green
                    : issue.startsWith('⚠️')
                    ? Colors.orange
                    : issue.startsWith('💡')
                    ? Colors.blue
                    : Colors.red,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Text(item, style: const TextStyle(fontSize: 12)),
          ),
        ),
      ],
    );
  }
}

/// Extension pour accéder facilement à l'analyse de performance
extension PerformanceAnalysisExtension on Widget {
  Widget withPerformanceAnalysis() {
    return Column(children: [this, PerformanceAnalysis().buildPerformanceAnalysisWidget()]);
  }
}
