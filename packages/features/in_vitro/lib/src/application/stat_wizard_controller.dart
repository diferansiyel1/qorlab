import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/stat_wizard.dart';
import '../domain/stat_wizard_engine.dart';

class StatWizardState {
  const StatWizardState({
    required this.answers,
    required this.history,
    required this.currentQuestion,
    required this.recommendation,
    required this.currentStep,
    required this.totalSteps,
  });

  factory StatWizardState.initial(StatWizardEngine engine) {
    final answers = const StatWizardAnswers.empty();
    return _build(engine, <StatWizardAnswers>[answers]);
  }

  final StatWizardAnswers answers;
  final List<StatWizardAnswers> history;
  final StatWizardQuestion? currentQuestion;
  final StatWizardRecommendation? recommendation;
  final int currentStep;
  final int totalSteps;

  bool get canGoBack => history.length > 1;
  bool get isComplete => recommendation != null;

  double get progressValue {
    if (totalSteps <= 0) return 0;
    final current = currentStep.clamp(1, totalSteps);
    return current / totalSteps;
  }

  static StatWizardState _build(
    StatWizardEngine engine,
    List<StatWizardAnswers> history,
  ) {
    final answers = history.last;
    final question = engine.nextQuestion(answers);
    final recommendation = question == null ? engine.recommend(answers) : null;
    final totalSteps = engine.totalSteps(answers);
    final answered = engine.answeredSteps(answers);
    final currentStep = recommendation != null
        ? totalSteps
        : (answered + 1).clamp(1, totalSteps);
    return StatWizardState(
      answers: answers,
      history: history,
      currentQuestion: question,
      recommendation: recommendation,
      currentStep: currentStep,
      totalSteps: totalSteps,
    );
  }
}

final statWizardControllerProvider =
    StateNotifierProvider.autoDispose<StatWizardController, StatWizardState>(
  (ref) => StatWizardController(const StatWizardEngine()),
);

class StatWizardController extends StateNotifier<StatWizardState> {
  StatWizardController(this._engine) : super(StatWizardState.initial(_engine));

  final StatWizardEngine _engine;

  void selectOption(StatWizardOption option) {
    final question = state.currentQuestion;
    if (question == null) {
      return;
    }

    final updated = _engine.applyAnswer(
      state.answers,
      question.id,
      option,
    );

    final history = List<StatWizardAnswers>.from(state.history)..add(updated);
    state = StatWizardState._build(_engine, history);
  }

  void goBack() {
    if (!state.canGoBack) {
      return;
    }
    final history = List<StatWizardAnswers>.from(state.history)..removeLast();
    state = StatWizardState._build(_engine, history);
  }

  void restart() {
    state = StatWizardState.initial(_engine);
  }
}
