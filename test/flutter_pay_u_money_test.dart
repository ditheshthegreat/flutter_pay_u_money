import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pay_u_money/flutter_pay_u_money.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_pay_u_money');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  /*test('getPlatformVersion', () async {
    expect(await FlutterPayUMoney.platformVersion, '42');
  });*/
}
