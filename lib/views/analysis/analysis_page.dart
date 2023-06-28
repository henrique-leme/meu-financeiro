// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meu_financeiro/common/widgets/custm_sendfile_button.dart';
import 'package:meu_financeiro/models/analysis_model.dart';
import 'package:meu_financeiro/controllers/purchase_analysis_controller.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

import '../../common/constants/app_colors.dart';
import '../../common/utils/sizes.dart';
import '../../common/utils/money_mask.dart';
import '../../common/widgets/app_header.dart';
import '../../common/widgets/custom_snackbar.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/primary_button.dart';
import '../../controllers/home_controller.dart';
import '../../locator.dart';

class AnalysisPage extends StatefulWidget {
  final AnalysisModel? analysis;
  const AnalysisPage({
    Key? key,
    this.analysis,
  }) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage>
    with SingleTickerProviderStateMixin, CustomSnackBar {
  final _formKey = GlobalKey<FormState>();
  final purchaseAnalisysController = locator.get<PurchaseAnalysisController>();

  bool value = false;
  String? _selectedFileName;
  String? _selectedOfxPath;

  final _descriptionController = TextEditingController();
  final _ofxController = TextEditingController();
  final _dateController = TextEditingController();
  final _amountController = MoneyMaskedText(
    prefix: '\$',
  );

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.analysis?.description ?? '';
    _ofxController.text = widget.analysis?.path ?? '';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _ofxController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _showAnalysisDialog(
      BuildContext context, String valorCompra, int? parcelasCompra) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Análise'),
          content: Text(
              'Com base no saldo atual, você podera fazer a compra no valor de $valorCompra, parcelando em $parcelasCompra vezes'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Voltar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppHeader(
            title: 'Análise de Compra',
            onPressed: () {
              locator.get<HomeController>().pageController.jumpToPage(0);
            },
          ),
          Positioned(
            top: 164.h,
            left: 28.w,
            right: 28.w,
            bottom: 16.h,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 16.0),
                      CustomTextFormField(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        labelText: "Valor da Compra",
                        hintText: "Digite um valor",
                      ),
                      CustomTextFormField(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        controller: _descriptionController,
                        labelText: 'Descrição',
                        hintText: 'Adicione uma descrição',
                        validator: (value) {
                          if (_descriptionController.text.isEmpty) {
                            return 'This field cannot be empty.';
                          }
                          return null;
                        },
                      ),
                      CustomSelectFileField(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        controller: _ofxController,
                        readOnly: true,
                        labelText: "Selecione seu Extrato",
                        hintText: "Selecione um arquivo OFX",
                        onTap: () async {
                          String? ofxPath = await pickOFXFile();
                          _selectedOfxPath = ofxPath;
                          if (ofxPath != null) {
                            _selectedFileName =
                                path.basenameWithoutExtension('$ofxPath.ofx');
                            _ofxController.text = _selectedFileName!;
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: PrimaryButton(
                          text: 'Analisar Compra',
                          onPressed: () async {
                            final newValue = double.parse(_amountController.text
                                .replaceAll('\$', '')
                                .replaceAll('.', '')
                                .replaceAll(',', '.'));
                            if (_formKey.currentState!.validate()) {
                              int? parcelasCompra =
                                  await purchaseAnalisysController
                                      .lerArquivoOFX(
                                          _selectedOfxPath, newValue);
                              String valorCompra = _amountController.text;
                              _showAnalysisDialog(
                                  context, valorCompra, parcelasCompra);
                            } else {
                              log('invalid');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
