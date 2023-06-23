import 'package:meu_financeiro/common/constants/routes.dart';
import 'package:meu_financeiro/models/transaction_model.dart';
import 'package:meu_financeiro/common/themes/default_theme.dart';
import 'package:meu_financeiro/views/home/home_page_view.dart';
import 'package:meu_financeiro/views/onboarding/onboarding_page.dart';
import 'package:meu_financeiro/views/profile/profile_page.dart';
import 'package:meu_financeiro/views/sign_in/sign_in_page.dart';
import 'package:meu_financeiro/views/sign_up/sign_up_page.dart';
import 'package:meu_financeiro/views/report/report_page.dart';
import 'package:meu_financeiro/views/transactions/transaction_page.dart';
import 'package:meu_financeiro/views/wallet/wallet_page.dart';
import 'package:flutter/material.dart';

import 'views/loading/loading_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme().defaultTheme,
      initialRoute: AppRoutes.loading,
      routes: {
        AppRoutes.initial: (context) => const OnboardingPage(),
        AppRoutes.loading: (context) => const LoadingPage(),
        AppRoutes.signUp: (context) => const SignUpPage(),
        AppRoutes.signIn: (context) => const SignInPage(),
        AppRoutes.home: (context) => const HomePageView(),
        AppRoutes.stats: (context) => const ReportsPage(),
        AppRoutes.wallet: (context) => const WalletPage(),
        AppRoutes.profile: (context) => const ProfilePage(),
        AppRoutes.transaction: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return TransactionPage(
            transaction: args != null ? args as TransactionModel : null,
          );
        },
      },
    );
  }
}
