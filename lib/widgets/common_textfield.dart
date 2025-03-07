import 'package:flutter/material.dart';

import '../../styles/colors.dart';

class CommonTextField extends StatefulWidget {
  final String ? hintText;
  final String ? appmode;
  final String ? pageMode;
  final FormFieldValidator ? validate;
  final IconData ? prefixIcon;
  final double ? prefixIconSize;
  final IconData ? suffixIcon;
  final VoidCallback ? suffixIconOnclick;
  final Color ? prefixIconColor;
  final Color ? sufixIconColor;
  final TextEditingController ? txtController;
  final double ? txtSize;
  final int ? maxline;
  final bool? obscureY;
  final TextStyle ? textStyle;
  final TextAlign ? textAlignment;
  final bool ? enableY;
  final bool? lookupY;
  final bool? emptySts;
  final TextInputType? keybordType;
  final dynamic inputformate;
  final ValueChanged<String> ? onChanged;
  final ValueChanged<String> ? onSubmit;
  final Function? fnClear;
  const CommonTextField({super.key, this.hintText, this.prefixIcon, this.prefixIconColor,this.prefixIconSize, this.txtController, this.txtSize, this.onChanged, this.onSubmit,  this.obscureY, this.suffixIcon, this.suffixIconOnclick, this.maxline,  this.lookupY, this.pageMode,  this.enableY, this.textStyle, this.keybordType, this.textAlignment, this.inputformate, this.validate, this.sufixIconColor,  this.fnClear, this.emptySts, this.appmode="cyl"});

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
        textAlign: TextAlign.start,
        enabled: widget.enableY,
        keyboardType:widget.keybordType ,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500,),

          border: OutlineInputBorder(
            borderSide:  BorderSide(width: 1, color: primaryColor),
            borderRadius: BorderRadius.circular(10),

          ),
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(width: 1, color:primaryColor),
            borderRadius: BorderRadius.circular(10),),
          // prefixIcon: Icon(widget.prefixIcon,color: widget.prefixIconColor,size: widget.prefixIconSize),
          suffixIcon:widget.suffixIcon!=null? GestureDetector(
              onTap: widget.suffixIconOnclick,
              child: Icon(widget.lookupY==true?Icons.search:widget.suffixIcon,color: widget.sufixIconColor,)):
          GestureDetector(
            onTap: widget.fnClear??fn(),
            child:  (widget.emptySts??true)?  Icon(Icons.cancel_outlined,size: 15,color: Colors.grey.withOpacity(0.9)): const Icon(Icons.cancel_outlined,size: 15,color: black,),
          ),

        ),
        controller: widget.txtController,
        inputFormatters: widget.inputformate,
        obscureText:widget.obscureY??false,
        maxLines: widget.maxline,
        validator:widget.validate,
        style:widget.textStyle,
        onChanged: widget.onChanged

    );
  }

  fn(){

  }
}
