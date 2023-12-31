import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deneme_takip/core/constants/navigation_constants.dart';

import 'package:flutter_deneme_takip/core/navigation/navigation_route.dart';
import 'package:flutter_deneme_takip/core/navigation/navigation_service.dart';
import 'package:flutter_deneme_takip/core/notifier/provider_list.dart';
import 'package:flutter_deneme_takip/firebase_options.dart';
import 'package:flutter_deneme_takip/services/auth_service.dart';
import 'package:flutter_deneme_takip/view/tabbar_views/bottom_tabbar_view.dart';
import 'package:flutter_deneme_takip/view/deneme_user_login.dart';
import 'package:flutter_deneme_takip/view_model/deneme_login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  await _init();

  runApp(
    MultiProvider(
      providers: [...ApplicationProvider.instance.dependItems],
      child: const MainApp(),
    ),
  );
}

Future<void> _init() async {
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom,
  ]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("mainYY ${AuthService().fAuth.currentUser}");
    final loginProv = Provider.of<DenemeLoginViewModel>(context, listen: false);
  
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme:
                const AppBarTheme(backgroundColor: Colors.transparent)),
        onGenerateRoute: NavigationRoute.instance.generateRoute,
        navigatorKey: NavigationService.instance.navigatorKey,
        home: Scaffold(
          body: Center(
              child: FutureBuilder<bool?>(
                  future: checkIfAnonymous(loginProv),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (AuthService().fAuth.currentUser != null ||
                        snapshot.data! && snapshot.hasData) {
                      return const BottomTabbarView();
                    } else {
                      return const UserLoginView();
                    }
                  })),
        ));
  }

  Future<bool?> checkIfAnonymous(DenemeLoginViewModel loginProv) async {
    bool? isAnonymous = await loginProv.getIsAnonymous ?? false;
    return Future.value(isAnonymous);
  }
}
