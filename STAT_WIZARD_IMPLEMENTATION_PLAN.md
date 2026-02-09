# StatWizard Implementation Plan

## Scope
Implement a new "Statistical Test Selector Wizard" in `in_vitro` as an offline, decision-tree-based tool with Riverpod state and route integration in `apps/mobile`.

## Architecture
1. Add a domain model for wizard answers, question IDs, and recommendation output.
2. Add a pure logic engine that:
   - Returns next question from current answers.
   - Computes final recommendation.
   - Provides short rationale and pro tip.
3. Add a Riverpod `StateNotifier` controller to:
   - Track answers and current step.
   - Handle selection, back, restart.
4. Build presentation with:
   - Reusable `QuestionStep` widget.
   - Card-based option selection.
   - Progress bar + step indicator.
   - Final result card with test name, why, and pro tip.
5. Integrate into app:
   - Export page from `in_vitro`.
   - Add route in `apps/mobile/lib/main.dart`.
   - Add entry card in lab tools page.
6. Localize all newly introduced user-facing strings in `app_en.arb` and `app_tr.arb`.

## Files to Add
- `packages/features/in_vitro/lib/src/domain/stat_wizard.dart`
- `packages/features/in_vitro/lib/src/domain/stat_wizard_engine.dart`
- `packages/features/in_vitro/lib/src/application/stat_wizard_controller.dart`
- `packages/features/in_vitro/lib/src/presentation/widgets/question_step.dart`
- `packages/features/in_vitro/lib/src/presentation/stat_wizard_page.dart`

## Files to Update
- `packages/features/in_vitro/lib/in_vitro.dart`
- `apps/mobile/lib/main.dart`
- `apps/mobile/lib/features/tools/lab_tools_page.dart`
- `packages/core/localization/lib/l10n/app_en.arb`
- `packages/core/localization/lib/l10n/app_tr.arb`

## Safety Checks
- Keep decision logic in pure Dart (no UI dependencies).
- Keep UI decoupled from logic via controller + engine.
- No schema migration required.
- Preserve offline behavior (no network calls).
- Run `flutter gen-l10n`, `flutter analyze`, and `flutter test` for `apps/mobile`.
