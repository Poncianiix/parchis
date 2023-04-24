import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parchis/pages/utils/globals.dart' as globals;

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

const String getQuestion = """
    
query GetRandomQuestion {
  getRandomQuestion {
    question
    id
    answers {
      text
      number
    }
  }
}
""";

const String verificar = """
    
query Query(\$input: ReturnAnswerInput) {
  verifyQuestion(input: \$input)
}
""";

const String updatePositionMutation = """
  mutation UpdateMyPosition(\$input: UpdatepositionInput) {
  updateMyPosition(input: \$input)
  }
  """;

const String updateNextGamer = """
   mutation Mutation {
  updateNextGamer
}
  """;
String id = "";
String respuesta = "";

class _QuestionScreenState extends State<QuestionScreen> {
  void actualizarPosicion() async {
    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink('https://gameback.onrender.com',
          defaultHeaders: {'Authorization': 'Bearer ${globals.token}'}),
    );

    final MutationOptions options = MutationOptions(
      document: gql(updatePositionMutation),
      variables: {
        "input": {
          "position": Random().nextInt(3) + 1,
          "number": Random().nextInt(2) + 1
        }
      },
    );
    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      //print(result.exception);
      //error(result.exception.toString());
    } else {
      //print(result.data);
    }
  }

  void pasarTurno() async {
    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(
        'https://gameback.onrender.com',
      ),
    );

    final MutationOptions options = MutationOptions(
      document: gql(updateNextGamer),
    );
    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      //print(result.exception);
      //error(result.exception.toString());
    } else {
      //print(result.data);
    }
  }

  void comprobar() async {
    final input = {
      "input": {"question": id, "answer": respuesta}
    };
    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink('http://localhost:4000',
          defaultHeaders: {'Authorization': 'Bearer ${globals.token}'}),
    );

    final QueryResult result = await client.query(QueryOptions(
        document: gql(
          verificar,
        ),
        variables: input));

    if (result.hasException) {
      //print(result.exception);
    } else {
      if (result.data?['verifyQuestion'] == true) {
        correcto();
      } else {
        incorrecto();
      }
    }
  }

  void correcto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(120, 52, 99, 1),
          title: const Text(
            'Correcto',
            style: TextStyle(
              color: Colors.green,
              fontSize: 30,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Has acertado la respuesta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, 'fichas');
              },
            ),
          ],
        );
      },
    );
  }

  void incorrecto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(120, 52, 99, 1),
          title: const Text(
            'Incorrecto',
            style: TextStyle(
              color: Colors.red,
              fontSize: 30,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Has fallado la respuesta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              onPressed: () {
                actualizarPosicion();
                pasarTurno();
                Navigator.pushNamed(context, 'espera');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(120, 52, 99, 1),
      body: Query(
        options: QueryOptions(
          document: gql(
            getQuestion,
          ),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Text('Loading');
          }

          String pregunta = result.data!['getRandomQuestion']['question'];
          List<dynamic> respuestas =
              result.data!['getRandomQuestion']['answers'];
          id = result.data!['getRandomQuestion']['id'];

          return Stack(
            children: [
              Container(
                height: size.height,
                width: size.width,
                padding: const EdgeInsets.only(top: 200),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(120, 52, 99, 1),
                      Color.fromRGBO(120, 40, 60, 1),
                    ],
                  ),
                ),
                child: Text(
                  pregunta,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: size.height / 2,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(120, 52, 99, 1),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          _KahootButton(
                            color: Colors.yellow,
                            text: respuestas[0]['text'],
                            onPressed: () {
                              respuesta = respuestas[0]['number'];
                              comprobar();
                              //Navigator.pushNamed(context, 'fichas');
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _KahootButton(
                            color: Colors.green,
                            text: respuestas[1]['text'],
                            onPressed: () {
                              respuesta = respuestas[1]['number'];
                              comprobar();
                              //Navigator.pushNamed(context, 'fichas');
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          _KahootButton(
                            color: Colors.blue,
                            text: respuestas[2]['text'],
                            onPressed: () {
                              respuesta = respuestas[2]['number'];
                              comprobar();
                              //Navigator.pushNamed(context, 'fichas');
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _KahootButton(
                            color: Colors.red,
                            text: respuestas[3]['text'],
                            onPressed: () {
                              respuesta = respuestas[3]['number'];
                              comprobar();
                              //Navigator.pushNamed(context, 'fichas');
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _KahootButton extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback onPressed;

  const _KahootButton({
    required this.color,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: (size.height / 4) - 30,
      width: (size.width / 2) - 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
