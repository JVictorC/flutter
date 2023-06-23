import 'package:contatos_vo/src/core/core.dart';
import 'package:contatos_vo/src/presentation/pages/home_page.dart';
import 'package:contatos_vo/src/presentation/viewModels/home_page_view_model/view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export './core/core.dart';
export './presentation/presentation.dart';
export './domain/domain.dart';
export './data/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'Contatos_Vo',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initAllDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => I.get<HomePageCubit>(),
        ),
      ],
      child: const HomePage(),
    ),
  );
}
