import 'package:meu_financeiro/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';

import '../../../common/constants/app_colors.dart';
import '../../../common/constants/app_text_styles.dart';

class GreetingsWidget extends StatefulWidget {
  const GreetingsWidget({
    Key? key,
  }) : super(key: key);

  @override
  _GreetingsWidgetState createState() => _GreetingsWidgetState();
}

class _GreetingsWidgetState extends State<GreetingsWidget> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final authService = FirebaseAuthService();
    final result = await authService.getCurrentUserName();
    setState(() {
      userName = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    double textScaleFactor =
        MediaQuery.of(context).size.width < 360 ? 0.7 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TENHA UM BOM DIA,',
          textScaleFactor: textScaleFactor,
          style: AppTextStyles.smallText.apply(color: AppColors.white),
        ),
        Text(
          userName ?? '',
          textScaleFactor: textScaleFactor,
          style: AppTextStyles.mediumText20.apply(color: AppColors.white),
        ),
      ],
    );
  }
}
