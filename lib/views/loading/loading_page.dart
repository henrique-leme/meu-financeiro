import 'package:flutter/material.dart';

import '../../common/constants/app_colors.dart';
import '../../common/constants/app_text_styles.dart';
import '../../common/constants/routes.dart';
import '../../common/utils/sizes.dart';
import '../../common/widgets/custom_circular_progress_indicator.dart';
import '../../locator.dart';
import '../../controllers/loading_controller.dart';
import 'loading_state.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final _loadingController = locator.get<LoadingController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => Sizes.init(context));

    _loadingController.isUserLogged();
    _loadingController.addListener(() {
      if (_loadingController.state is AuthenticatedUser) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.home,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.initial,
        );
      }
    });
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.gradiantGreen,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'meu',
              style: AppTextStyles.bigText50.copyWith(color: AppColors.white),
            ),
            Text(
              'financeiro',
              style: AppTextStyles.bigText50.copyWith(color: AppColors.white),
            ),
            const CustomCircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
