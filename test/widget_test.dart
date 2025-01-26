import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/main.dart'; // Ez hozza be a WeatherApp osztályt

void main() {
  testWidgets('Weather App smoke test', (WidgetTester tester) async {
    // Építse meg az appot és indítsa el.
    await tester.pumpWidget(const WeatherApp());

    // Ellenőrizze, hogy az üdvözlő szöveg megjelenik.
    expect(find.text('Welcome to the Weather App!'), findsOneWidget);
    expect(find.text('Add meg a várost!'), findsNothing);
  });
}
