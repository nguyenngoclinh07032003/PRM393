import 'package:flutter_test/flutter_test.dart';
import 'package:appbanhang/main.dart';

void main() {
  testWidgets('App khởi động hiển thị SplashScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const Ecommerce());
    expect(find.text('Shop App'), findsOneWidget);
  });
}
