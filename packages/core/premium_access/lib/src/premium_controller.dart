import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'premium_entitlement_gateway.dart';
import 'premium_state.dart';

part 'premium_controller.g.dart';

const _kPremiumKey = 'premium_access.active';
const _kPremiumGraceUntilKey = 'premium_access.grace_until_iso';

@Riverpod(keepAlive: true)
class PremiumController extends _$PremiumController {
  @override
  PremiumState build() {
    _loadFromPrefs();
    return const PremiumState.initial();
  }

  Future<void> refresh() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final gateway = ref.read(premiumEntitlementGatewayProvider);
      final hasEntitlement = await gateway.refreshEntitlement();
      await _persist(isPremium: hasEntitlement, graceUntil: state.graceUntil);
      state = state.copyWith(
        isPremium: hasEntitlement,
        loading: false,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> restore() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final gateway = ref.read(premiumEntitlementGatewayProvider);
      final restored = await gateway.restorePurchases();
      await _persist(isPremium: restored, graceUntil: state.graceUntil);
      state = state.copyWith(
        isPremium: restored,
        loading: false,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> activateLocalPremium() async {
    state = state.copyWith(loading: true, clearError: true);
    await _persist(isPremium: true, graceUntil: null);
    state = state.copyWith(
      isPremium: true,
      graceUntil: null,
      graceUntilSet: true,
      loading: false,
      clearError: true,
    );
  }

  Future<void> revokePremium() async {
    state = state.copyWith(loading: true, clearError: true);
    await _persist(isPremium: false, graceUntil: state.graceUntil);
    state = state.copyWith(
      isPremium: false,
      loading: false,
      clearError: true,
    );
  }

  Future<void> startOfflineGrace({Duration duration = const Duration(days: 7)}) async {
    final until = DateTime.now().add(duration);
    await _persist(isPremium: state.isPremium, graceUntil: until);
    state = state.copyWith(graceUntil: until, graceUntilSet: true, clearError: true);
  }

  Future<void> clearOfflineGrace() async {
    await _persist(isPremium: state.isPremium, graceUntil: null);
    state = state.copyWith(graceUntil: null, graceUntilSet: true, clearError: true);
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isPremium = prefs.getBool(_kPremiumKey) ?? false;
      final graceIso = prefs.getString(_kPremiumGraceUntilKey);
      final graceUntil = (graceIso == null || graceIso.isEmpty)
          ? null
          : DateTime.tryParse(graceIso);
      state = state.copyWith(
        isPremium: isPremium,
        graceUntil: graceUntil,
        graceUntilSet: true,
        loading: false,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(error: error.toString(), loading: false);
    }
  }

  Future<void> _persist({
    required bool isPremium,
    required DateTime? graceUntil,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPremiumKey, isPremium);
    if (graceUntil == null) {
      await prefs.remove(_kPremiumGraceUntilKey);
    } else {
      await prefs.setString(_kPremiumGraceUntilKey, graceUntil.toIso8601String());
    }
  }
}

