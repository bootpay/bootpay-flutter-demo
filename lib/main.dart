import 'package:flutter/material.dart';

import 'package:bootpay_api/bootpay_api.dart';
import 'package:bootpay_api/model/payload.dart';
import 'package:bootpay_api/model/extra.dart';
import 'package:bootpay_api/model/user.dart';
import 'package:bootpay_api/model/item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 100,
                child: RaisedButton(
                  onPressed: () {
                    goBootpayRequest(context, "danal", "",
                        ['card', 'phone', 'vbank', 'bank']);
                  },
                  child: Text("부트페이 통합결제"),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: RaisedButton(
                  onPressed: () {
                    goBootpayRequest(context, "kcp", "npay", []);
                  },
                  child: Text("네이버페이 결제"),
                ),
              ),
            ],
          ),
        ));
  }
}

void goBootpayRequest(BuildContext context, String pg, String method,
    List<String> methods) async {
  Item item1 = Item();
  item1.itemName = "미키 마우스"; // 주문정보에 담길 상품명
  item1.qty = 1; // 해당 상품의 주문 수량
  item1.unique = "ITEM_CODE_MOUSE"; // 해당 상품의 고유 키
  item1.price = 500; // 상품의 가격

  Item item2 = Item();
  item2.itemName = "키보드"; // 주문정보에 담길 상품명
  item2.qty = 1; // 해당 상품의 주문 수량
  item2.unique = "ITEM_CODE_KEYBOARD"; // 해당 상품의 고유 키
  item2.price = 500; // 상품의 가격
  List<Item> itemList = [item1, item2];

  Payload payload = Payload();
  payload.applicationId = '5b8f6a4d396fa665fdc2b5e8';
  payload.androidApplicationId = '5b8f6a4d396fa665fdc2b5e8';
  payload.iosApplicationId = '5b8f6a4d396fa665fdc2b5e9';

  payload.pg = pg;
  payload.method = method;
  payload.methods = methods;
  payload.name = '테스트 상품';
  payload.price = 1000.0; //정기결제시 0 혹은 주석
  payload.orderId = DateTime.now().millisecondsSinceEpoch.toString();
  payload.params = {
    "callbackParam1": "value12",
    "callbackParam2": "value34",
    "callbackParam3": "value56",
    "callbackParam4": "value78",
  };
//    payload.us

  User user = User();
  user.username = "사용자 이름";
  user.email = "user1234@gmail.com";
  user.area = "서울";
  user.phone = "010-4033-4678";
  user.addr = '서울시 동작구 상도로 222';

  Extra extra = Extra();
  extra.appScheme = 'bootpayFlutterSample';
  extra.quotas = [0, 2, 3];

  BootpayApi.request(
    context,
    payload,
    extra: extra,
    user: user,
    items: itemList,
    onDone: (String json) {
      print('--- onDone: $json');
    },
    onCancel: (String json) {
      print('--- onCancel: $json');
    },
    onError: (String json) {
      print(' --- onError: $json');
    },
  );
}
