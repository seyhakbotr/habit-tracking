import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:force_update_helper/force_update_helper.dart';
import 'package:starter_architecture_flutter_firebase/l10n/app_localizations.dart';
import 'package:starter_architecture_flutter_firebase/src/localization/locale_provider.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_router.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/app_startup.dart';
import 'package:starter_architecture_flutter_firebase/src/routing/go_router_delegate_listener.dart';
import 'package:starter_architecture_flutter_firebase/src/utils/alert_dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  static const primaryColor = Colors.indigo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final locale = ref.watch(localeProvider); // Watch the locale provider

    return MaterialApp.router(
      routerConfig: goRouter,
      // Add the locale property here
      locale: locale,
      // The rest of your code remains the same
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      builder: (_, child) {
        return AppStartupWidget(
          onLoaded: (_) => ForceUpdateWidget(
            navigatorKey: goRouter.routerDelegate.navigatorKey,
            forceUpdateClient: ForceUpdateClient(
              fetchRequiredVersion: () => Future.value('2.0.0'),
              iosAppStoreId: '6482293361',
            ),
            allowCancel: false,
            showForceUpdateAlert: (context, allowCancel) => showAlertDialog(
              context: context,
              title: 'App Update Required',
              content: 'Please update to continue using the app.',
              cancelActionText: allowCancel ? 'Later' : null,
              defaultActionText: 'Update Now',
            ),
            showStoreListing: (storeUrl) async {
              if (await canLaunchUrl(storeUrl)) {
                await launchUrl(
                  storeUrl,
                  mode: LaunchMode.externalApplication,
                );
              } else {
                log('Cannot launch URL: $storeUrl');
              }
            },
            onException: (e, st) {
              log(e.toString());
            },
            child: GoRouterDelegateListener(child: child!),
          ),
        );
      },
      theme: ThemeData(
        colorSchemeSeed: primaryColor,
        unselectedWidgetColor: Colors.grey,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2.0,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: Colors.grey[200],
        dividerColor: Colors.grey[400],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
