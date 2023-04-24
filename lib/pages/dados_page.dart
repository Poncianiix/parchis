import 'package:flutter/material.dart';
import 'dart:math';
import 'package:parchis/pages/utils/globals.dart' as globals;

class DadosPage extends StatefulWidget {
  const DadosPage({super.key});

  @override
  State<DadosPage> createState() => _DadosPageState();
}

class _DadosPageState extends State<DadosPage>
    with SingleTickerProviderStateMixin {
  int leftDiceNumber = 1;
  int rightDiceNumber = 1;
  int leftDiceNumber2 = 1;
  int rightDiceNumber2 = 1;
  late AnimationController controller;
  late CurvedAnimation animation;
  bool isButtonPressed = false;
  bool isButtonDisabled = false;
  Color colorDado = const Color.fromRGBO(120, 42, 99, 0.5);
  final String getPreguntas = """
  
  
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
  """;
  @override
  void initState() {
    super.initState();
    animate();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void animate() {
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceOut);
    animation.addListener(() {
      setState(() {});
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          leftDiceNumber = Random().nextInt(6) + 1;
          rightDiceNumber = Random().nextInt(6) + 1;
          leftDiceNumber2 = Random().nextInt(6) + 1;
          rightDiceNumber2 = Random().nextInt(6) + 1;
          //isButtonDisabled = false; // habilitar botón
        });
        controller.reverse();
      } else if (status == AnimationStatus.forward) {
        setState(() {
          isButtonDisabled = true; // deshabilitar botón
        });
      }
    });
  }

  void roll() {
    setState(() {
      isButtonPressed = true;
    });
    controller.forward();
  }

  void cambiar() {
    Navigator.pushNamed(context, 'preguntas');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        //backgroundColor: const Color.fromRGBO(120, 52, 99, 1),
        appBar: AppBar(
          title: const Text(
            'Tira los dados',
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
                Container(
                  color: colorDado,
                  width: size.width - 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (leftDiceNumber == 1 && rightDiceNumber == 1) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("¡Atención!"),
                                    content:
                                        const Text("Por favor tira los dados"),
                                    actions: [
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              globals.dado1 = leftDiceNumber;
                              globals.dado2 = rightDiceNumber;
                              cambiar();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Image(
                              height: 200 - (animation.value) * 200,
                              image: AssetImage(
                                  'assets/images/dice-png-$leftDiceNumber.png'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (leftDiceNumber == 1 && rightDiceNumber == 1) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("¡Atención!"),
                                    content:
                                        const Text("Por favor tira los dados"),
                                    actions: [
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              globals.dado1 = leftDiceNumber;
                              globals.dado2 = rightDiceNumber;
                              cambiar();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Image(
                              height: 200 - (animation.value) * 200,
                              image: AssetImage(
                                  'assets/images/dice-png-$rightDiceNumber.png'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  color: colorDado,
                  width: size.width - 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (leftDiceNumber == 1 && rightDiceNumber == 1) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("¡Atención!"),
                                    content:
                                        const Text("Por favor tira los dados"),
                                    actions: [
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              globals.dado1 = leftDiceNumber2;
                              globals.dado2 = rightDiceNumber2;
                              cambiar();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Image(
                              height: 200 - (animation.value) * 200,
                              image: AssetImage(
                                  'assets/images/dice-png-$leftDiceNumber2.png'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (leftDiceNumber == 1 && rightDiceNumber == 1) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("¡Atención!"),
                                    content:
                                        const Text("Por favor tira los dados"),
                                    actions: [
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              globals.dado1 = leftDiceNumber2;
                              globals.dado2 = rightDiceNumber2;
                              cambiar();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Image(
                              height: 200 - (animation.value) * 200,
                              image: AssetImage(
                                  'assets/images/dice-png-$rightDiceNumber2.png'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 70.0),
                ElevatedButton(
                  onPressed: isButtonDisabled
                      ? null
                      : isButtonPressed
                          ? cambiar
                          : roll,
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
                  child: Text(
                    isButtonPressed ? 'Tirar' : 'Tirar',
                    style: const TextStyle(
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
