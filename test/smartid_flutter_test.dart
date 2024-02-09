import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartid_flutter/smartid_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('smartid_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SmartIdFlutter.platformVersion, '42');
  });
}
