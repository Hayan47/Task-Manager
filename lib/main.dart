import 'package:flutter/material.dart';
import 'package:task_manager/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.onGenerateRoute,
      onGenerateInitialRoutes: (String initialRoute) {
        return [
          appRouter.generateInitialRoute(RouteSettings(name: initialRoute))
        ];
      },
    );
  }

  @override
  void dispose() {
    appRouter.dispose();
    super.dispose();
  }
}
