import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parchis/pages/utils/globals.dart' as globals;

class WaitingTurnPage extends StatefulWidget {
  const WaitingTurnPage({super.key});

  @override
  State<WaitingTurnPage> createState() => _WaitingTurnPageState();
}

const String getActiveGeneral = """
    
query GetActiveGeneral {
  getActiveGeneral {
    gamers {
      name
      id
    }
  }
}
""";

class _WaitingTurnPageState extends State<WaitingTurnPage> {
  Timer? _timer;
  List<String> gamerIds = [];
  List<String> gamerNames = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      consultarJugadores();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void consultarJugadores() async {
    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(
        'https://gameback.onrender.com',
      ),
    );

    final QueryResult result = await client.query(QueryOptions(
      document: gql(
        getActiveGeneral,
      ),
    ));

    if (result.hasException) {
      //print(result.exception);
    } else {
      if (result.data?['getActiveGeneral']['gamers'] == null) {
      } else {
        //print(result.data?['getActiveGeneral']['gamers']);

        final List gamers = result.data?['getActiveGeneral']['gamers'];
        List<String> ids = [];
        List<String> names = [];
        for (var gamer in gamers) {
          ids.add(gamer['id']);
          names.add(gamer['name']);
        }
        //print(ids);
        if (globals.id == ids[0]) {
          globals.color = "r";
        } else if (globals.id == ids[1]) {
          globals.color = "v";
        } else if (globals.id == ids[2]) {
          globals.color = "a";
        } else if (globals.id == ids[3]) {
          globals.color = "az";
        }

        //print(names);
        //print(globals.color);

        // Aquí puedes hacer algo con los datos obtenidos, por ejemplo, actualizar el estado de la página
        setState(() {
          gamerIds = ids;
          gamerNames = names;

          // Buscar similitudes en la lista de IDs
          if (gamerIds.contains(globals.id)) {
            Navigator.pushReplacementNamed(context, 'espera');

            //print('El ID del jugador está en la lista');
          } else {
            //print("El ID del jugador no está en la lista");
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: const Color.fromRGBO(120, 52, 99, 1),
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
          children: const [
            SizedBox(height: 30.0),
            Text(
              'Partida en progreso...',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 50.0),
            CircularProgressIndicator(
              color: Colors.white54,
            ),
          ],
        ),
      ),
    ));
  }
}
