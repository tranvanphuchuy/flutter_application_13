import 'button.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userQuestion = '';
  var userAnswer = '';
  List<String> inputHistory = [];  // Track the history of inputs

  final myTextStyle = TextStyle(fontSize: 30, color: Colors.deepPurple[900]);

  final List<String> buttons = [
    'C', 'DEL', '%', '/', '9', '8', '7', 'x',
    '6', '5', '4', '-', '3', '2', '1', '+',
    '0', '.', 'ANS', '='
  ];

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsive layout
    final size = MediaQuery.of(context).size;
    final buttonSize = size.width / 4;  // Divide the width by the number of columns

    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child: Text(userQuestion, style: const TextStyle(fontSize: 20)),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerRight,
                  child: Text(userAnswer, style: const TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,  // Adjust flex to scale with the size of the screen
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: buttonSize / (buttonSize * 0.25),  // Adjust the button aspect ratio
              ),
              itemBuilder: (BuildContext context, int index) {
                return MyButton(
                  buttonTapped: () {
                    setState(() {
                      handleButtonPress(buttons[index]);
                    });
                  },
                  buttonText: buttons[index],
                  color: isOperator(buttons[index]) ? Colors.deepPurple : Colors.white,
                  textColor: isOperator(buttons[index]) ? Colors.white : Colors.deepPurple,
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  bool isOperator(String x) {
    return ['%', '/', 'x', '-', '+', '='].contains(x);
  }

  void handleButtonPress(String label) {
    if (label == 'C') {
      userQuestion = '';
      inputHistory.clear();
    } else if (label == 'DEL') {
      userQuestion = userQuestion.isNotEmpty ? userQuestion.substring(0, userQuestion.length - 1) : '';
      inputHistory.add(label);
    } else if (label == '=') {
      equalPressed();
      // Check if the last three inputs were DEL, 0, 9
      if (inputHistory.length >= 3 &&
          inputHistory[inputHistory.length - 3] == 'DEL' &&
          inputHistory[inputHistory.length - 2] == '0' &&
          inputHistory[inputHistory.length - 1] == '9') {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Congratulations! You found a hidden DOG'),
            content: Image.asset('images/dog.png'), 
          ),
        );
      }
      
      inputHistory.clear();
    } else {
      userQuestion += label;
      inputHistory.add(label);
    }
  }

  void equalPressed() {
    String finalQuestion = userQuestion.replaceAll('x', '*');
    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    userAnswer = eval.toString();
  }
}
