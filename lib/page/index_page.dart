import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../entity/member_entity.dart';
import '../util/screen_util.dart';


class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index>  with TickerProviderStateMixin {

  final List<MemberEntity> _viewModel = RxList();
  late TabController _tabController;
  // final GetStorage _memberStorage = GetStorage("member_storage");
  // final GetStorage _totalStorage = GetStorage("total_storage");
  // final GetStorage _arrearsStorage = GetStorage("arrears_storage");
  List tabs = ["list", "msg"];
  RxInt currentIndex = 0.obs;
  late Socket? _socket;

  @override
  initState(){
    super.initState();
    serialTest1();
    // serialTest();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener((){
      currentIndex.value = _tabController.index;
    });

    // int? total = _memberStorage.read("total_member");
    // if(total!=null){
    //  for(int i =0;i<total;i++){
    //    MemberEntity entity = MemberEntity(i, _memberStorage.read("$i"));
    // String? totalStr = _totalStorage.read('$i');
    // if(totalStr!=null){
    //   double result = 0;
    //   totalStr.split(',').forEach((element) {
    //     result += double.parse(element);
    //   });
    //   entity.total = result;
    // }
    //
    // String? arrearsStr = _arrearsStorage.read('$i');
    // if(arrearsStr!=null){
    //   double result = 0;
    //   arrearsStr.split(',').forEach((element) {
    //     result += double.parse(element);
    //   });
    //   entity.arrears = result;
    // }
    // _viewModel.add(entity);
    // }
    // }

    // Socket.connect('192.168.3.250', 8899, timeout: const Duration(seconds: 5))
    //     .then((socket) async {
    //   print('socket connect');
    //
    //   _socket = socket;
    //   _socket?.listen(onReceivedMsg,
    //     onError: (e){
    //       print(e);
    //     },
    //     onDone: (){
    //       _socket?.close();
    //     },
    //     cancelOnError: false,
    //   );
    //   socket.write('B@d42301c');
    // }).catchError((error) {
    //   _socket?.close();
    //   print(error);
    // });


  }

  // //接收到socket消息
  // onReceivedMsg(event) async {
  //   print(event);
  // }


  void serialTest1() {
    print('Available ports:');
    var i = 0;
    List<String> list = SerialPort.availablePorts;
    print('PortSize: ${list.length}');
    for (final name in SerialPort.availablePorts) {
      print('${++i}) $name');
      MemberEntity entity = MemberEntity(i,name);
      _viewModel.add(entity);
    }

  }
  @override
  void dispose() {
    _socket?.close();
    if(port!=null) {
      port!.close();
    }
    super.dispose();
  }


  // void serialTest() {
  //   print('Available ports:');
  //   var i = 0;
  //   List<String> list = SerialPort.availablePorts;
  //   print('PortSize: ${list.length}');
  //   for (final name in SerialPort.availablePorts) {
  //     final sp = SerialPort(name);
  //     print('${++i}) $name');
  //     print('\tDescription: ${sp.description}');
  //     print('\tManufacturer: ${sp.manufacturer}');
  //     print('\tSerial Number: ${sp.serialNumber}');
  //     print('\tProduct ID: 0x${sp.productId!.toRadixString(16)}');
  //     print('\tVendor ID: 0x${sp.vendorId!.toRadixString(16)}');
  //     sp.dispose();
  //   }
  // }

  var wait = false;
  SerialPort? port;
  Future<void> serialTest() async {
    String name = '/COM2';

    // port = SerialPort(name);
    // // var config = SerialPortConfig();
    // // config.baudRate = 19200;
    // // port.config= config;
    // if (!port!.openReadWrite()) {
    //   print(SerialPort.lastError);
    //   return;
    // }

    // 05000009B7F0
    // 05008A1B98B2

     port = SerialPort(name);
    port!.openReadWrite();

    port!.config = SerialPortConfig()
      ..baudRate = 9600
      ..bits = 8
      ..stopBits = 1
      ..parity = SerialPortParity.none
      ..setFlowControl(SerialPortFlowControl.none);

    final reader = SerialPortReader(port!);
    reader.stream.listen((data) {
      print('received: $data');
      print('receivedString: ${utf8.decode(data)}'); // 转换为字符串
      String hexString = data.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
      print('receivedHex: ${hexString.toUpperCase()}'); // 转换为16进制
    },onError: (e){

    },onDone: (){

    });



    // 09 00 01 04 00 00 80 14 DD 23

    var bytes = Uint8List.fromList([0x09, 0x00, 0x01, 0x04, 0x00, 0x00,0x80,0x14,0xDD,0x23]);
    print(bytes);
    port!.write(bytes);

    // print(port.read(port.bytesAvailable,timeout: 1000));


    // bytes = Uint8List.fromList([0x05, 0x00, 0x8A, 0x1B, 0x98, 0xB2]);
    // print(bytes);
    // port.write(bytes);

    // port.close();
  }

  _itemWidget(index) {
    var item = _viewModel[index];
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8).r,
      padding: const EdgeInsets.all(16).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Container(
              margin: const EdgeInsets.only(left: 22).r,
              child: InkWell(
                onTap: (){
                  // _add(item.id);
                },
                child: Text(item.name,style: TextStyle(color:Colors.black, fontSize: 30.sp)),

              )
          ),
          // Obx(() =>Text(currentIndex.value==0?item.total.toString():item.arrears.toString(),style: TextStyle(color:Colors.black,fontSize: 26.sp, fontWeight: FontWeight.bold)),),
          // Obx(() => Container(
          //   margin: const EdgeInsets.only(right: 22).r,
          //   alignment: Alignment.centerRight,
          //   child: Text(currentIndex.value==0?(item.total*50).toInt().toString():(item.arrears*50).toInt().toString(),style: TextStyle(color:Colors.red,fontSize: 26.sp, fontWeight: FontWeight.bold)),
          // ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("串口测试"),
        bottom: TabBar(
            indicatorColor: Colors.white,
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList()
        ),
        // actions: [
        //   IconButton(
        //       icon: const Icon(Icons.clean_hands_sharp),
        //       tooltip: 'clear',
        //       onPressed: () {
        //         for (var element in _viewModel) {
        //           element.arrears = 0;
        //         }
        //         _arrearsStorage.erase();
        //       }
        //   ),
        // ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return _itemWidget(index);
        },
        itemCount: _viewModel.length,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // channel.sink.add('[B@d42301c');
          // channel.sink.add('[B@be0c2dd');
          // channel.sink.add('[B@9ca5276');
        },
        child: const Text("ADD"),

      ),

    );
  }

// _add(id){
//   String count = "";
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('添加记录'),
//         content: TextField(
//           minLines: 1,
//           keyboardType: TextInputType.number,
//           decoration: InputDecoration(
//             isCollapsed: true,
//             border: InputBorder.none,
//             hintText: "输入成绩",
//             hintStyle: TextStyle(color: Colors.grey, fontSize: 26.sp,),
//           ),
//           onChanged: (value){
//             count = value;
//           },
//
//           style:  TextStyle(
//             color: Colors.black,
//             fontSize: 26.sp,
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: (){
//             _addToTotal(count, id);
//             _addToArrears(count, id);
//             Get.back();
//           }, child: const Text("确定"))
//         ],
//       );
//     },
//   );
// }

// _addToTotal(count,id){
//   String? pre = _totalStorage.read('$id');
//   if(pre==null){
//     pre = count;
//   }else{
//     pre = "$pre,$count";
//   }
//   _totalStorage.write('$id', pre);
//   double result = 0;
//   pre?.split(',').forEach((element) {
//     result += double.parse(element);
//   });
//   _viewModel[id].total = result;
// }
//
// _addToArrears(count,id){
//   String? pre = _arrearsStorage.read('$id');
//   if(pre==null){
//     pre = count;
//   }else{
//     pre = "$pre,$count";
//   }
//   _arrearsStorage.write('$id', pre);
//   double result = 0;
//   pre?.split(',').forEach((element) {
//     result += double.parse(element);
//   });
//   _viewModel[id].arrears = result;
// }
//
//
// _addMember(){
//   String addMemberName = "";
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('添加成员'),
//         content: TextField(
//           minLines: 1,
//           decoration: InputDecoration(
//             isCollapsed: true,
//             border: InputBorder.none,
//             hintText: "请输入成员名称",
//             hintStyle: TextStyle(color: Colors.grey, fontSize: 26.sp,),
//           ),
//           onChanged: (value){
//             addMemberName = value;
//           },
//
//           style:  TextStyle(
//             color: Colors.black,
//             fontSize: 26.sp,
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: (){
//             int id = _viewModel.length;
//             MemberEntity entity = MemberEntity(id,addMemberName);
//             _viewModel.add(entity);
//             _memberStorage.write("$id", addMemberName);
//             _memberStorage.write("total_member", _viewModel.length);
//             Get.back();
//           }, child: const Text("确定"))
//         ],
//       );
//     },
//   );
// }

}