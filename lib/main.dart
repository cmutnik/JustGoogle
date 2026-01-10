import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

/// Main entry point for the application
Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables from .env file
    await dotenv.load(fileName: '.env');

    // Check if required environment variables are set
    final apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
    final searchEngineId = dotenv.env['GOOGLE_SEARCH_ENGINE_ID'] ?? '';

    if (apiKey.isEmpty || searchEngineId.isEmpty) {
      print(
        '\n⚠️  WARNING: API credentials not configured!\n'
        'Please add your Google API credentials to the .env file:\n'
        '  GOOGLE_API_KEY=your_api_key_here\n'
        '  GOOGLE_SEARCH_ENGINE_ID=your_search_engine_id_here\n\n'
        'To get your credentials:\n'
        '1. Visit https://console.cloud.google.com\n'
        '2. Create a project and enable Custom Search API\n'
        '3. Create credentials (API key)\n'
        '4. Visit https://programmablesearchengine.google.com\n'
        '5. Create a Custom Search Engine and get the ID\n',
      );
    }
  } catch (e) {
    print('Error loading environment variables: $e');
    print('Make sure you have a .env file in the root directory.');
  }

  // Run the app
  runApp(const JustGoogleApp());
}
