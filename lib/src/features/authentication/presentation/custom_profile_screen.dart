import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/l10n/app_localizations.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/presentation/auth_providers.dart';
import 'package:starter_architecture_flutter_firebase/src/localization/locale_provider.dart';

class CustomProfileScreen extends ConsumerWidget {
  const CustomProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        // Remove const here
        title: Text(loc.profile),
        actions: [
          IconButton(
            // Use a non-const Text widget here
            icon: const Text('🇰🇭'),
            onPressed: () {
              ref.read(localeProvider.notifier).state = const Locale('km');
            },
          ),
          IconButton(
            // Or use a hardcoded emoji if you prefer
            icon: const Text('🇺🇸'),
            onPressed: () {
              ref.read(localeProvider.notifier).state = const Locale('en');
            },
          ),
        ],
      ),
      body: ProfileScreen(
        providers: authProviders,
      ),
    );
  }
}
