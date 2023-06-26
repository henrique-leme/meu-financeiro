import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:meu_financeiro/common/widgets/custm_sendfile_button.dart';
import 'package:path/path.dart' as path;

import '../../common/constants/app_colors.dart';
import '../../common/utils/date_formatter.dart';
import '../../common/utils/sizes.dart';
import '../../models/transaction_model.dart';
import '../../common/utils/money_mask.dart';
import '../../common/widgets/app_header.dart';
import '../../common/widgets/custom_circular_progress_indicator.dart';
import '../../common/widgets/custom_snackbar.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/primary_button.dart';
import '../../locator.dart';
import '../../controllers/transaction_controller.dart';
import 'analysis_state.dart';

class AnalysisPage extends StatefulWidget {
  final TransactionModel? transaction;
  const AnalysisPage({
    super.key,
    this.transaction,
  });

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage>
    with SingleTickerProviderStateMixin, CustomSnackBar {
  final _transactionController = locator.get<TransactionController>();

  final _formKey = GlobalKey<FormState>();

  DateTime? _newDate;
  bool value = false;
  String? _selectedFileName;

  final _descriptionController = TextEditingController();
  final _pdfController = TextEditingController();
  final _dateController = TextEditingController();
  final _amountController = MoneyMaskedText(
    prefix: '\$',
  );

  late final TabController _tabController;

  int get _initialIndex {
    if (widget.transaction != null && widget.transaction!.value.isNegative) {
      return 1;
    }

    return 0;
  }

  @override
  void initState() {
    super.initState();
    _amountController.updateValue(widget.transaction?.value ?? 0);
    value = widget.transaction?.status ?? false;
    _descriptionController.text = widget.transaction?.description ?? '';
    _pdfController.text = widget.transaction?.category ?? '';
    _newDate =
        DateTime.fromMillisecondsSinceEpoch(widget.transaction?.date ?? 0);
    _dateController.text = widget.transaction?.date != null
        ? DateTime.fromMillisecondsSinceEpoch(widget.transaction!.date).toText
        : '';
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _initialIndex,
    );

    _transactionController.addListener(() {
      if (_transactionController.state is AnalysisStateLoading) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const CustomCircularProgressIndicator(),
        );
      }
      if (_transactionController.state is AnalysisStateSuccess) {
        Navigator.of(context).pop();
      }
      if (_transactionController.state is AnalysisStateError) {
        final error = _transactionController.state as AnalysisStateError;
        showCustomSnackBar(
          context: context,
          text: error.message,
          type: SnackBarType.error,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _pdfController.dispose();
    _dateController.dispose();
    _transactionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppHeader(title: 'Análise de Compra'),
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
                        controller: _pdfController,
                        readOnly: true,
                        labelText: "Selecione seu Extrato",
                        hintText: "Selecione um arquivo PDF",
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'This field cannot be empty.';
                          }
                          return null;
                        },
                        onTap: () async {
                          String? pdfPath = await pickPDFFile();
                          if (pdfPath != null) {
                            _selectedFileName =
                                path.basenameWithoutExtension(pdfPath + '.pdf');
                            _pdfController.text = _selectedFileName!;
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: PrimaryButton(
                          text: 'Analisar Compra',
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              final newValue = double.parse(_amountController
                                  .text
                                  .replaceAll('\$', '')
                                  .replaceAll('.', '')
                                  .replaceAll(',', '.'));

                              final now = DateTime.now().millisecondsSinceEpoch;

                              final newTransaction = TransactionModel(
                                category: _pdfController.text,
                                description: _descriptionController.text,
                                value: _tabController.index == 1
                                    ? newValue * -1
                                    : newValue,
                                date: _newDate != null
                                    ? _newDate!.millisecondsSinceEpoch
                                    : now,
                                createdAt: widget.transaction?.createdAt ?? now,
                                status: value,
                                id: widget.transaction?.id,
                              );
                              if (widget.transaction == newTransaction) {
                                Navigator.pop(context);
                                return;
                              }
                              if (widget.transaction != null) {
                                await _transactionController
                                    .updateTransaction(newTransaction);
                                if (mounted) {
                                  Navigator.of(context).pop(true);
                                }
                              } else {
                                await _transactionController.addTransaction(
                                  newTransaction,
                                );
                                if (mounted) {
                                  Navigator.of(context).pop(true);
                                }
                              }
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
