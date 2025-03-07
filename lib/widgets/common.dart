import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/colors.dart';

//===============================================TEXT
Text tcnBody(text,color) => Text(text,style: GoogleFonts.poppins(fontSize: 12,color: color));
Text tcBody(text,color,[height]) => Text(text,style: GoogleFonts.beVietnamPro(fontSize: 14,color: color,height: height,));

//=============================================GAP
SizedBox gapH() => const SizedBox(height: 20,);
SizedBox gapHC(double h) => SizedBox(height: h,);
SizedBox gapWC(double h) => SizedBox(width: h,);



dprint(msg){
  if (kDebugMode) {
    print(msg);
  }
}
