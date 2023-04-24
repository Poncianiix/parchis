import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class QueryPage extends StatefulWidget {
  const QueryPage({Key? key}) : super(key: key);

  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Query(
              options: QueryOptions(
                document: gql('''
                  query GetQuestions {
                    getQuestions {
                      question
                      id
                      correctAnswer
                      answers {
                        text
                        number
                      }
                    }
                  }
                '''),
              ),
              builder: (QueryResult result,
                  {VoidCallback? refetch, FetchMore? fetchMore}) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.isLoading) {
                  return const Text('Loading');
                }

                final questions = result.data!['getQuestions'] as List<dynamic>;

                return ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (BuildContext context, int index) {
                    final question = questions[index];

                    return ListTile(
                      title: Text(question['question']),
                      subtitle: Text(question['correctAnswer']),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            child: const Text('Refetch'),
            onPressed: () {
              final query = gql('''
                query GetQuestions {
                  getQuestions {
                    question
                    id
                    correctAnswer
                    answers {
                      text
                      number
                    }
                  }
                }
              ''');
            },
          ),
        ],
      ),
    );
  }
}
