import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State class for the Molarity Calculator
class MolarityState {
  final Decimal? molecularWeight; // g/mol
  final Decimal? volumeL; // Liters
  final Decimal? molarity; // M (mol/L)
  final Decimal? massG; // Grams
  
  const MolarityState({
    this.molecularWeight,
    this.volumeL,
    this.molarity,
    this.massG,
  });

  MolarityState copyWith({
    Decimal? molecularWeight,
    Decimal? volumeL,
    Decimal? molarity,
    Decimal? massG,
  }) {
    return MolarityState(
      molecularWeight: molecularWeight ?? this.molecularWeight,
      volumeL: volumeL ?? this.volumeL,
      molarity: molarity ?? this.molarity,
      massG: massG ?? this.massG,
    );
  }
}

final molarityControllerProvider = StateNotifierProvider.autoDispose<MolarityController, MolarityState>((ref) {
  return MolarityController();
});

class MolarityController extends StateNotifier<MolarityState> {
  MolarityController() : super(const MolarityState());

  void setMolecularWeight(Decimal mw) {
    state = state.copyWith(molecularWeight: mw);
    _calculateMass();
  }

  void setVolume(Decimal volume, {bool inML = false}) {
    // Convert mL to L if needed
    final volumeL = inML ? (volume / Decimal.fromInt(1000)).toDecimal() : volume;
    state = state.copyWith(volumeL: volumeL);
    _calculateMass();
  }

  void setMolarity(Decimal molarity) {
    state = state.copyWith(molarity: molarity);
     _calculateMass();
  }
  
  // Calculate Mass: m = M * MW * V
  void _calculateMass() {
    if (state.molecularWeight != null && state.volumeL != null && state.molarity != null) {
      final mass = state.molarity! * state.molecularWeight! * state.volumeL!;
      state = state.copyWith(massG: mass);
    }
  }
}
