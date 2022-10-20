import 'business_logic/cubit/characters_cubit.dart';
import 'data/repository/characters_repo.dart';
import 'data/web_services/characters_services.dart';
import 'presentation/screens/characters_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var charactersServices = CharactersServices();
    var charactersRepository = CharactersRepository(charactersServices);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => CharactersCubit(charactersRepository),
        child: const CharactersScreen(),
      ),
    );
  }
}