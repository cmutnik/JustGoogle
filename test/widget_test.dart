// Basic Flutter widget test for JustGoogle

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:justgoogle/app.dart';
import 'package:justgoogle/core/constants/app_constants.dart';

void main() {
  // Initialize dotenv before running tests
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Load test environment variables
    dotenv.testLoad(fileInput: '''
GOOGLE_API_KEY=test_api_key
GOOGLE_SEARCH_ENGINE_ID=test_search_engine_id
''');
  });

  testWidgets('App loads and displays home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const JustGoogleApp());

    // Verify that the app name is displayed in AppBar
    expect(find.text(AppConstants.appName), findsOneWidget);

    // Verify that the search bar hint is displayed
    expect(find.text(AppConstants.searchHintText), findsOneWidget);

    // Verify that the search icon is displayed
    expect(find.byIcon(Icons.search), findsWidgets);

    // Verify that the initial state message is displayed
    expect(find.text('Search the web'), findsOneWidget);

    // Verify that the tagline is displayed
    expect(find.text(AppConstants.appTagline), findsOneWidget);
  });

  testWidgets('Search bar accepts input', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const JustGoogleApp());
    await tester.pumpAndSettle();

    // Find the text field
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    // Enter text into the search field
    await tester.enterText(textField, 'flutter');
    await tester.pump();

    // Verify the text is in the field
    expect(find.text('flutter'), findsOneWidget);
  });
}
