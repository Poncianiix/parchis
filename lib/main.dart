import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parchis/pages/dados_page.dart';
import 'package:parchis/pages/fichas_page.dart';
import 'package:parchis/pages/waiting_page.dart';
import 'package:parchis/pages/waiting_turn_page.dart';

import 'pages/questions_page.dart';
import 'pages/select_name.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final HttpLink httpLink = HttpLink(
    'http://localhost:4000',
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      ),
    );

    try {
      return GraphQLProvider(
          client: client,
          child: MaterialApp(
            title: 'Parchis',
            debugShowCheckedModeBanner: false,
            initialRoute: 'seleccionarNombre',
            routes: {
              'seleccionarNombre': (BuildContext context) => const SelectName(),
              'espera': (BuildContext context) => const WaitingPage(),
              'turno': (BuildContext context) => const WaitingTurnPage(),
              'dados': (BuildContext context) => const DadosPage(),
              'preguntas': (BuildContext context) => const QuestionScreen(),
              'fichas': (BuildContext context) => const FichasPage(),
            },
          ));
    } catch (e) {
      //errorInicio(context, e.toString());
      return Container();
    }
  }
}
