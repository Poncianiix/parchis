import 'package:flutter/material.dart';
import 'package:parchis/pages/utils/globals.dart' as globals;
import 'package:graphql_flutter/graphql_flutter.dart';

class FichasPage extends StatefulWidget {
  const FichasPage({super.key});

  @override
  State<FichasPage> createState() => _FichasPageState();
}

class _FichasPageState extends State<FichasPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  final String updatePositionMutation = """
  mutation UpdateMyPosition(\$input: UpdatepositionInput) {
  updateMyPosition(input: \$input)
  }
  """;
  final String updateNextGamer = """
   mutation Mutation {
  updateNextGamer
}
  """;

  int dado1 = globals.dado1;
  int dado2 = globals.dado2;
  int chosenNumber = 0;
  int tiros = 2;

  void actualizarPosicion(numero, ficha) async {
    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink('http://localhost:4000',
          defaultHeaders: {'Authorization': 'Bearer ${globals.token}'}),
    );

    final MutationOptions options = MutationOptions(
      document: gql(updatePositionMutation),
      variables: {
        "input": {"position": numero, "number": ficha}
      },
    );
    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      final textError =
          result.exception!.graphqlErrors[0].message.replaceAll("Error: ", "");
      error(textError);
    } else {
      //print(result.data);
    }
  }

  void pasarTurno() async {
    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(
        'http://localhost:4000',
      ),
    );

    final MutationOptions options = MutationOptions(
      document: gql(updateNextGamer),
    );
    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      //print(result.exception);
      error(result.exception.toString());
    } else {
      //print(result.data);
    }
  }

  void error(errorText) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color.fromRGBO(120, 52, 99, 1),
        title: const Text(
          "Error",
          style: TextStyle(
            color: Colors.red,
            fontSize: 25,
          ),
        ),
        content: Text(
          errorText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Aceptar"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void cambiar() {
    pasarTurno();
    Navigator.pushNamed(context, 'espera');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        //backgroundColor: const Color.fromRGBO(120, 52, 99, 1),
        appBar: AppBar(
          title: const Text(
            'Selecciona la ficha que quieres mover',
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(247, 170, 36, 0.7),
        ),
        body: Container(
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            barrierDismissible:
                                true, // Evita cerrar el diálogo al presionar fuera de él
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                backgroundColor:
                                    const Color.fromRGBO(120, 52, 99, 1),
                                title: const Text(
                                  "¿Cuánto quieres que avance la ficha?",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                                children: [
                                  SimpleDialogOption(
                                    onPressed: () {
                                      chosenNumber = dado1;
                                      dado1 = 0;
                                      actualizarPosicion(chosenNumber, 1);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "$dado1",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      chosenNumber = dado2;
                                      dado2 = 0;
                                      actualizarPosicion(chosenNumber, 1);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "$dado2",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ).then((value) {
                            // Este código se ejecuta al presionar el botón "Aceptar"

                            if (chosenNumber == 0) {
                            } else {
                              tiros -= 1;
                              if (tiros == 0) {
                                cambiar();
                              }
                              //print("Número elegido: $chosenNumber");
                              chosenNumber = 0;
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Image(
                            height: size.height / 2,
                            image: AssetImage(
                                'assets/fichas/${globals.color}1.png'),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            barrierDismissible:
                                true, // Evita cerrar el diálogo al presionar fuera de él
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                backgroundColor:
                                    const Color.fromRGBO(120, 52, 99, 1),
                                title: const Text(
                                  "¿Cuánto quieres que avance la ficha?",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                                children: [
                                  SimpleDialogOption(
                                    onPressed: () {
                                      chosenNumber = dado1;
                                      dado1 = 0;
                                      actualizarPosicion(chosenNumber, 2);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "$dado1",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      chosenNumber = dado2;
                                      dado2 = 0;
                                      actualizarPosicion(chosenNumber, 2);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "$dado2",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ).then((value) {
                            // Este código se ejecuta al presionar el botón "Aceptar"

                            if (chosenNumber == 0) {
                            } else {
                              tiros -= 1;
                              if (tiros == 0) {
                                cambiar();
                              }
                              //print("Número elegido: $chosenNumber");
                              chosenNumber = 0;
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Image(
                            height: size.height / 2,
                            image: AssetImage(
                                'assets/fichas/${globals.color}2.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'espera');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(29, 223, 9, 0.7),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Pasar turno',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
