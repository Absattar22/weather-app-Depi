import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_weather/bloc/weather_bloc_bloc.dart';
import 'package:my_weather/data/determine_position.dart';
import 'package:my_weather/firebase_options.dart';
import 'package:my_weather/screens/forgot_password_view.dart';
import 'package:my_weather/screens/home_screen.dart';
import 'package:my_weather/screens/sign_in_view.dart'; // Assuming SignInView is created
import 'package:my_weather/screens/sign_up_view.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBlocBloc(),
      child: MaterialApp(
        routes: {
          HomeScreen.id: (context) => const HomeScreen(),
          SignUpView.id: (context) => const SignUpView(),
          ForgotPassword.id: (context) => const ForgotPassword(),
          SignInView.id: (context) => const SignInView(),
        },
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: FirebaseAuth.instance.authStateChanges().first,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData) {
              return FutureBuilder(
                future: determinePosition(),
                builder: (context, positionSnap) {
                  if (positionSnap.hasData) {
                    return BlocProvider<WeatherBlocBloc>(
                      create: (context) => WeatherBlocBloc()
                        ..add(FetchWeather(positionSnap.data as Position)),
                      child: const HomeScreen(),
                    );
                  } else {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              );
            } else {
              // User is not signed in, show SignIn screen
              return const SignInView();
            }
          },
        ),
      ),
    );
  }
}
