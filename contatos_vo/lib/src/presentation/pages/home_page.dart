import 'package:contatos_vo/src/main.dart';
import 'package:contatos_vo/src/presentation/viewModels/home_page_view_model/states.dart';
import 'package:contatos_vo/src/presentation/viewModels/home_page_view_model/view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final HomePageCubit _cubit;

  @override
  void dispose() {
    _cubit.close();

    super.dispose();
  }

  @override
  void initState() {
    _cubit = I.get<HomePageCubit>();

    startPage();

    super.initState();
  }

  Future<void> startPage() async {
    await _cubit.getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        top: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              Text(
                "Todos os Contatos",
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Divider(thickness: 1),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      // BlocBuilder<HomePageCubit, HomePageState>(
                      //   builder: (context, state) {
                      //     if (state is LoadingState) {
                      //       return const Center(
                      //         child: CircularProgressIndicator(),
                      //       );
                      //     }

                      //     return Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           "Ultimo Contato",
                      //           style: GoogleFonts.roboto(
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.w400,
                      //           ),
                      //         ),
                      //         const ContactWidget(
                      //           contact: ContactModel(
                      //             apelido: "",
                      //             endereco: "",
                      //             imagem:
                      //                 "https://firebasestorage.googleapis.com/v0/b/contatos-vo.appspot.com/o/Fotos%20Parentes%2FFoto%20Joao%20Victor%20Cordeiro.jpg?alt=media&token=06520dee-09ff-415b-9f79-5cb04e939832",
                      //             nome: "",
                      //             telefone: "",
                      //             whatsapp: "",
                      //             parentesco: Parentesco.Filho,
                      //           ),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // ),

                      Expanded(
                        child: BlocBuilder<HomePageCubit, HomePageState>(
                          builder: (context, state) {
                            if (state is LoadingState) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (state is LoadedState) {
                              return ListView.builder(
                                itemCount: state.contacts.length,
                                itemBuilder: (context, index) {
                                  final c = state.contacts[index];

                                  return Column(
                                    children: [
                                      ContactWidget(
                                        axis: Axis.vertical,
                                        contact: ContactModel.fromEntity(c),
                                      ),
                                      const Divider(thickness: 1),
                                    ],
                                  );
                                },
                              );
                            }

                            return SizedBox();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
