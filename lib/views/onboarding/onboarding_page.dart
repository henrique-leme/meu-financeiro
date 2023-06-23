// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:meu_financeiro/common/constants/app_colors.dart';
import 'package:meu_financeiro/common/constants/app_text_styles.dart';
import 'package:meu_financeiro/common/constants/routes.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/primary_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.iceWhite,
      body: Column(
        children: [
          const SizedBox(height: 106.0),
          Expanded(
            flex: 1,
            child: Image.asset(
              'assets/images/onboarding_image.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 48.0),
          Text(
            'Meu',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText36.copyWith(
              color: AppColors.primaryGreen,
            ),
          ),
          Text(
            'Financeiro',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText36.copyWith(
              color: AppColors.primaryGreen,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 32.0,
              right: 32.0,
              top: 16.0,
              bottom: 4.0,
            ),
            child: PrimaryButton(
              text: 'Entrar',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.signIn,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 32.0,
              right: 32.0,
              top: 16.0,
              bottom: 4.0,
            ),
            child: PrimaryButton(
              text: 'Cadastrar',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.signUp,
                );
              },
            ),
          ),
          const SizedBox(height: 106.0),
        ],
      ),
    );
  }
}
