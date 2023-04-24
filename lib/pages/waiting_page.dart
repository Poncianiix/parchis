import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parchis/pages/utils/globals.dart' as globals;

class WaitingPage extends StatefulWidget {
  const WaitingPage({super.key});

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

const String getActiveGeneral = """
    
query GetActiveGeneral {
  getActiveGeneral {
    activeGamer {
      name
      id
    }
  }
}
""";

class _WaitingPageState extends State<WaitingPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _performGraphQLQuery();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _performGraphQLQuery() async {
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
      String id = result.data!['getActiveGeneral']['activeGamer']['id'];
      //print(id);
      //print(name);

      // Aquí puedes hacer algo con los datos obtenidos, por ejemplo, actualizar el estado de la página
      setState(() {
        if (id == globals.id) {
          Navigator.pushReplacementNamed(context, 'dados');
        }
      });
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
              'Espera tu turno...',
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
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
