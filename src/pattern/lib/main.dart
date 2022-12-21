import 'app/routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => SharedPreferences.getInstance());
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      position: ToastPosition.center,
      child: GetMaterialApp(
        initialRoute: Routes.HOME,
        getPages: AppPages.routes,
        theme: AppTheme.lightTheme,
        defaultTransition: Transition.noTransition,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}
