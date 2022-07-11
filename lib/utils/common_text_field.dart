import 'package:flutter/material.dart';
import 'package:realtime_database_app/utils/app_config.dart';

import '../constants/app_constants.dart';

class CommonTextFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final bool? obscureText;
  final VoidCallback? onTap;
  final int? errorMaxLines;
  final bool? autoFocus;
  final bool? enableSuffixIconVisibility;
  const CommonTextFieldWidget({Key? key, this.controller,this.hintText,this.validator,this.keyboardType,this.readOnly,this.onTap,this.obscureText,this.errorMaxLines,this.autoFocus, this.enableSuffixIconVisibility}) : super(key: key);
  @override
  _CommonTextFieldWidgetState createState() => _CommonTextFieldWidgetState();
}

class _CommonTextFieldWidgetState extends State<CommonTextFieldWidget> {

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      cursorColor: Colors.black,
      readOnly: widget.readOnly!,
       keyboardType: widget.keyboardType,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppConfig(context).rWP(1.89), vertical: AppConfig(context).rHP(1.89)),
        prefixIcon: const Icon(
          Icons.task,
          color: Colors.grey,
        ),
        labelText: AppConstants.whatNeedsToDoneString,
        labelStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.grey.withOpacity(0.3),
       border: const OutlineInputBorder(borderSide: BorderSide.none),
      ),
        validator: widget.validator
    );
    
    
    
    
    
    
    
    
    // TextFormField(
    //   autovalidateMode: AutovalidateMode.onUserInteraction,
    //   controller: widget.controller,
    //   readOnly: widget.readOnly!,
    //   autofocus: widget.autoFocus!,
    //   obscureText: widget.obscureText!,
    //   onTap: widget.onTap,
    //   cursorColor: Colors.white,
    //     keyboardType: widget.keyboardType,
    //   decoration: InputDecoration(
    //     errorMaxLines: widget.errorMaxLines,
    //     contentPadding: EdgeInsets.symmetric(
    //         horizontal: AppConfig(context).rWP(1.89), vertical: AppConfig(context).rHP(1.89)),
    //     hintText: widget.hintText,
    //     hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
    //       fontSize: 14,
    //       fontWeight: FontWeight.w400,
    //     ),
    //     filled: true,
    //     fillColor: Colors.grey.withOpacity(0.3),
    //     border: const OutlineInputBorder(borderSide: BorderSide.none),
    //   ),
    //     validator: widget.validator
    // );
  }
}
