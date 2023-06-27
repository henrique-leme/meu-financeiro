import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meu_financeiro/common/constants/app_colors.dart';
import 'package:meu_financeiro/common/constants/app_text_styles.dart';

class CustomSelectFileField extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final String? hintText;
  final String? labelText;
  final TextCapitalization? textCapitalization;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final bool? obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final String? helperText;
  final GestureTapCallback? onTap;
  final bool readOnly;

  const CustomSelectFileField({
    Key? key,
    this.padding,
    this.hintText,
    this.labelText,
    this.textCapitalization,
    this.controller,
    this.keyboardType,
    this.maxLength,
    this.textInputAction,
    this.suffixIcon,
    this.obscureText,
    this.inputFormatters,
    this.validator,
    this.helperText,
    this.onTap,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<CustomSelectFileField> createState() => _CustomSelectFileFieldState();
}

Future<String?> pickOFXFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    PlatformFile file = result.files.first;
    String path = file.path!;
    return path;
  }

  return null;
}

class _CustomSelectFileFieldState extends State<CustomSelectFileField> {
  final defaultBorder = const OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.primaryGreen,
    ),
  );

  String? _helperText;

  @override
  void initState() {
    super.initState();
    _helperText = widget.helperText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 12.0,
          ),
      child: TextFormField(
        readOnly: widget.readOnly,
        onTap: widget.onTap ?? () => pickOFXFile(),
        onChanged: (value) {
          if (value.length == 1) {
            setState(() {
              _helperText = null;
            });
          } else if (value.isEmpty) {
            setState(() {
              _helperText = widget.helperText;
            });
          }
        },
        validator: widget.validator,
        style: AppTextStyles.inputText.copyWith(color: AppColors.primaryGreen),
        inputFormatters: widget.inputFormatters,
        obscureText: widget.obscureText ?? false,
        textInputAction: widget.textInputAction,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        decoration: InputDecoration(
          errorMaxLines: 3,
          helperText: _helperText,
          helperMaxLines: 3,
          suffixIcon: widget.suffixIcon,
          hintText: widget.hintText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: widget.labelText?.toUpperCase(),
          border: defaultBorder,
          focusedBorder: defaultBorder,
          enabledBorder: defaultBorder,
        ),
      ),
    );
  }
}
