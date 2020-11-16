# 카드 간편결제 (생체인식) 데모 
![bootpay_bio_400](https://user-images.githubusercontent.com/1625573/98510224-0d6b8d80-22a6-11eb-95c2-9285f3cc4e89.gif)


# 카드 간편결제 (비밀번호) 스크린샷
![payment window_1](https://docs.bootpay.co.kr/assets/online/onestore-145efaf06e9a3b1a93d07bbe174b2394f50373e9334a3205174676a181acf5b0.png)

# bootpay_api

부트페이에서 관리하는 공식 플러터 플러그인입니다. 
기존의 [bootpay_flutter](https://pub.dev/packages/bootpay_flutter) 모듈을 fork 하여 만들었습니다.
부트페이 개발매뉴얼은 [이곳](https://docs.bootpay.co.kr) 을 참조해주세요.

### 지원하는 PG사 
	1. 이니시스
	2. 나이스페이
	3. 다날
	4. KCP
	5. EasyPay (KICC)
	6. TPay (JTNet)
	7. LG U+
	8. 페이레터
	9. 네이버페이
	10. 카카오페이
	11. 페이코
	

## Getting Started
Add the module to your project ``pubspec.yaml``:
```yaml
...
dependencies:
 ...
 bootpay_api: last_version
...
```
And install it using ``flutter packages get`` on your project folder. After that, just import the module and use it:

## Settings

### Android
No configuration required.

### iOS
** {your project root}/ios/Runner/Info.plist **

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    ...

    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLName</key>
            <string>kr.co.bootpaySample</string> // 사용하고자 하시는 앱의 bundle url name
            <key>CFBundleURLSchemes</key>
            <array>
                <string>bootpaySample</string> // 사용하고자 하시는 앱의 bundle url scheme
            </array>
        </dict>
    </array>

    ...
    <key>NSFaceIDUsageDescription</key>
    <string>생체인증 결제 진행시 권한이 필요합니다</string>
</dict>
</plist>
```

Done!

## Getting Started

```dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:bootpay_api/bootpay_api.dart';
import 'package:bootpay_api/model/payload.dart';
import 'package:bootpay_api/model/extra.dart';
import 'package:bootpay_api/model/user.dart';
import 'package:bootpay_api/model/item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Test",
      home: TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  @override
  TestPageState createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
//  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
//    initPlatformState();
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          child:  RaisedButton(
            onPressed: () {
              goBootpayRequest(context);
            },
            child: Text("부트페이 결제요청"),
          ),
        )
    );
  }

  static Future<void> request(BuildContext context, Payload payload,
      {User user,
      List<Item> items,
      Extra extra,
      StringCallback onDone,
      StringCallback onReady,
      StringCallback onCancel,
      StringCallback onError}) async {

    payload.applicationId = Platform.isIOS
        ? payload.iosApplicationId
        : payload.androidApplicationId;

    if (user == null) user = User();
    if (items == null) items = [];
    if (extra == null) extra = Extra();

    Map<String, dynamic> params = {
      "payload": payload.toJson(),
      "user": user.toJson(),
      "items": items.map((v) => v.toJson()).toList(),
      "extra": extra.toJson()
    };


    Map<dynamic, dynamic> result = await _channel.invokeMethod(
      "bootpayRequest",
      params,
    );


    String method = result["method"];
    if (method == null) method = result["action"];

    String message = result["message"];
    if (message == null) message = result["msg"];



    //confirm 생략
    if (method == 'onDone' || method == 'BootpayDone') {
      if (onDone != null) onDone(message);
    } else if (method == 'onReady' || method == 'BootpayReady') {
      if (onReady != null) onReady(message);
    } else if (method == 'onCancel' || method == 'BootpayCancel') {
      if (onCancel != null) onCancel(message);
    } else if (method == 'onError' || method == 'BootpayError') {
      if (onError != null) onError(message);
    } else if (result['receipt_id'] != null && result['receipt_id'].isNotEmpty) {
      if (onDone != null) onDone(jsonEncode(result));
    }
  }
}
```
