import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parchis/pages/utils/globals.dart' as globals;

class SelectName extends StatefulWidget {
  const SelectName({super.key});

  @override
  State<SelectName> createState() => _SelectNameState();
}

const String gamer = """
    mutation NewGamer(\$input: GamerInput) {
  newGamer(input: \$input) {
    token
    id
  }
}
  """;

final ThemeData miTema = ThemeData(
  //primarySwatch: Color.fromARGB(255, 182, 169, 168),
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.white,
  colorScheme: const ColorScheme.light(primary: Colors.white),
  hintColor: Colors.white54,

  shadowColor: Colors.white,
  cardColor: Colors.white,
  canvasColor: Colors.white,
  hoverColor: Colors.white,
);

class _SelectNameState extends State<SelectName> {
  String name = '';

  @override
  Widget build(BuildContext context) {
    globals.dado1 = 0;
    globals.dado2 = 0;
    globals.token = '';
    globals.id = '';
    return Scaffold(
        backgroundColor: const Color.fromRGBO(120, 52, 99, 1),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ingresa tu Nombre',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(40),
                child: Theme(
                  data: miTema,
                  child: TextField(
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      decorationColor: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Ingresa un Nombre',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Mutation(
                  options: MutationOptions(
                    document: gql(gamer),
                    onCompleted: (data) {
                      String token = data?['newGamer']['token'];
                      String id = data?['newGamer']['id'];
                      globals.token = token;
                      globals.id = id;
                    },
                  ),
                  builder: (RunMutation newGamer, QueryResult? result) {
                    return ElevatedButton(
                      onPressed: () async {
                        try {
                          newGamer({
                            "input": {"name": name}
                          });
                          Navigator.pushNamed(context, 'turno',
                              arguments: name);
                        } catch (e) {
                          //print(e);
                        }
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
                        'Continuar',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ));
  }
}
