import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdapter{

  static init(context){
    ScreenUtil.init(context, designSize: const Size(750, 1334));
  }
}