class PremiumState {
  final bool isPremium;
  final DateTime? graceUntil;
  final bool loading;
  final String? error;

  const PremiumState({
    required this.isPremium,
    required this.graceUntil,
    required this.loading,
    required this.error,
  });

  const PremiumState.initial()
      : isPremium = false,
        graceUntil = null,
        loading = false,
        error = null;

  bool get hasGraceAccess {
    if (graceUntil == null) return false;
    return DateTime.now().isBefore(graceUntil!);
  }

  bool get hasAccess => isPremium || hasGraceAccess;

  PremiumState copyWith({
    bool? isPremium,
    DateTime? graceUntil,
    bool graceUntilSet = false,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return PremiumState(
      isPremium: isPremium ?? this.isPremium,
      graceUntil: graceUntilSet ? graceUntil : this.graceUntil,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

