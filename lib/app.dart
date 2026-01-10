import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/remote/search_api_client.dart';
import 'data/repositories/search_repository_impl.dart';
import 'domain/usecases/search_web.dart';
import 'presentation/providers/search_provider.dart';
import 'presentation/screens/home/home_screen.dart';

/// Root application widget
class JustGoogleApp extends StatelessWidget {
  const JustGoogleApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set up dependency injection
    final apiClient = SearchApiClient();
    final repository = SearchRepositoryImpl(apiClient);
    final searchWeb = SearchWeb(repository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SearchProvider(searchWeb),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,

        // Theme configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        // Home page
        home: const HomeScreen(),
      ),
    );
  }
}
