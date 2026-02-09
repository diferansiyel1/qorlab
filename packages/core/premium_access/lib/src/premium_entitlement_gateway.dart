import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Boundary for store entitlement checks.
///
/// App layer can override this provider with App Store / Play Store backed
/// implementation.
abstract class PremiumEntitlementGateway {
  Future<bool> refreshEntitlement();
  Future<bool> restorePurchases();
}

class NoopPremiumEntitlementGateway implements PremiumEntitlementGateway {
  const NoopPremiumEntitlementGateway();

  @override
  Future<bool> refreshEntitlement() async => false;

  @override
  Future<bool> restorePurchases() async => false;
}

final premiumEntitlementGatewayProvider = Provider<PremiumEntitlementGateway>(
  (ref) => const NoopPremiumEntitlementGateway(),
);

