import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rfid/page/index_page.dart';


void main() async {
  // await ScreenUtil.ensureScreenSize();
  // await GetStorage.init('member_storage');
  // await GetStorage.init('total_storage');
  // await GetStorage.init('arrears_storage');
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   //设置状态栏颜色
  //   statusBarColor: Colors.red,
  // ));

  runApp(const MyApp());

}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Index()
    );
  }


}
