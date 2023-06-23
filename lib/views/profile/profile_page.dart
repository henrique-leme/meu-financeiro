import 'package:flutter/material.dart';
import 'package:meu_financeiro/common/constants/app_colors.dart';
import 'package:meu_financeiro/common/constants/app_text_styles.dart';
import 'package:meu_financeiro/common/widgets/app_header.dart';
import 'package:meu_financeiro/controllers/home_controller.dart';
import 'package:meu_financeiro/services/firebase_auth_service.dart';

import '../../locator.dart';
import '../../services/auth_service.dart';
import '../../services/secure_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  String? userName;
  String? userEmail;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadUserEmail();
  }

  Future<void> _loadUserName() async {
    final authService = FirebaseAuthService();
    final resultName = await authService.getCurrentUserName();
    setState(() {
      userName = resultName;
    });
  }

  Future<void> _loadUserEmail() async {
    final authService = FirebaseAuthService();
    final resultEmail = await authService.getCurrrentUserEmail();
    setState(() {
      userEmail = resultEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          AppHeader(
            title: 'Perfil',
            onPressed: () {
              locator.get<HomeController>().pageController.jumpToPage(0);
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 120,
                  height: 120,
                  child: CircleAvatar(
                    backgroundColor: AppColors.green,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                  child:
                      Text(userName ?? '', style: AppTextStyles.mediumText30),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child:
                      Text(userEmail ?? '', style: AppTextStyles.mediumText20),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.primaryGreen),
                        elevation: MaterialStateProperty.all(0),
                        overlayColor:
                            MaterialStateProperty.all(AppColors.primaryGreen),
                      ),
                      onPressed: () async {
                        await locator.get<AuthService>().signOut();
                        await const SecureStorageService().deleteAll();
                        if (mounted) {
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        }
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Login",
                            fontSize: 20,
                            color: Colors.white),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
