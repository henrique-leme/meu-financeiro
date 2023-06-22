import 'package:meu_financeiro/common/constants/routes.dart';
import 'package:meu_financeiro/common/models/transaction_model.dart';
import 'package:meu_financeiro/common/themes/default_theme.dart';
import 'package:meu_financeiro/features/home/home_page_view.dart';
import 'package:meu_financeiro/features/onboarding/onboarding_page.dart';
import 'package:meu_financeiro/features/profile/profile_page.dart';
import 'package:meu_financeiro/features/sign_in/sign_in_page.dart';
import 'package:meu_financeiro/features/sign_up/sign_up_page.dart';
import 'package:meu_financeiro/features/stats/stats_page.dart';
import 'package:meu_financeiro/features/transactions/transaction_page.dart';
import 'package:meu_financeiro/features/wallet/wallet_page.dart';
import 'package:flutter/material.dart';

import 'features/splash/splash_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme().defaultTheme,
      initialRoute: NamedRoute.splash,
      routes: {
        NamedRoute.initial: (context) => const OnboardingPage(),
        NamedRoute.splash: (context) => const SplashPage(),
        NamedRoute.signUp: (context) => const SignUpPage(),
        NamedRoute.signIn: (context) => const SignInPage(),
        NamedRoute.home: (context) => const HomePageView(),
        NamedRoute.stats: (context) => const StatsPage(),
        NamedRoute.wallet: (context) => const WalletPage(),
        NamedRoute.profile: (context) => const ProfilePage(),
        NamedRoute.transaction: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return TransactionPage(
            transaction: args != null ? args as TransactionModel : null,
          );
        },
      },
    );
  }
}
