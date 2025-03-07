import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:taskmanager/widgets/common.dart';


class CommonButton extends StatelessWidget {
  final String ? btnName;
  final VoidCallback onTap;
  final bool ? iconYN;
  final IconData ? icon;
  final Color ? btnColor;
  final Color ? txtColor;
  final double ? iconSize;

  const CommonButton({super.key, required this.btnName,required this.onTap, this.iconYN, this.icon, this.btnColor, this.txtColor, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onPressed: onTap,
      duration: const Duration(milliseconds: 110),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(40)
        ),
        child: Center(child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tcBody(btnName, txtColor,0.0),
            iconYN==true? Icon(icon,color: txtColor,size: iconSize,) :const SizedBox()
          ],
        )),
      ),
    );
  }
}
