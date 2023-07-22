import 'package:Calculator/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:math_expressions/math_expressions.dart';


class calculator extends StatefulWidget {
  const calculator({super.key});

  @override
  State<calculator> createState() => _calculatorState();
}

class _calculatorState extends State<calculator> {
  double fristnum = 0.0;
  double secondnum = 0.0;
  var input = '';
  var output = '';
  var operation = '';
  var hideinput = false;
  var outputsize = 34.0;

  final flutter = FlutterTts();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> speak(String content) async {
    content = content.replaceAll('-', 'minus');
    content = content.replaceAll('*', 'multiply by');
    content = content.replaceAll('^', 'ki power');
    content = content.replaceAll('/', 'divide by');
    content = content.replaceAll('.', 'point');
    if (content == 'AC') {
      flutter.stop();
    } else {
      await flutter.speak(content);
    }
  }

  @override
  onbuttonclick(value) {
    if (value == 'AC') {
      speak('AC');
      input = '';
      output = '';
    } else if (value == '<-') {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    } else if (value == '=') {
      try {
        if (input.isNotEmpty) {
          var userinput = input;
          Parser p = Parser();
          Expression expression = p.parse(userinput);
          ContextModel cm = ContextModel();
          var finalvalue = expression.evaluate(EvaluationType.REAL, cm);
          output = finalvalue.toString();
          if (output.contains('.0')) {
            output = output.substring(0, output.length - 2);
          }
          speak('equals to $output');
          input = output;
          //   input = '';
          hideinput = true;
          outputsize = 52;
        }
      } catch (e) {
        speak('Invalid Value');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid Value')),
        );
      }
    } else {
      if (output.isNotEmpty) {
        output = '';
      }
      input = input + value;

      speak(value);

      hideinput = false;
      outputsize = 34;
      setState(() {});
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Calculator',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    hideinput ? '' : input,
                    style: TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    output,
                    style: TextStyle(
                      fontSize: outputsize,
                      color: Colors.white.withOpacity(0.7),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),

          //button area
          Row(
            children: [
              Button(
                text: 'AC',
                buttonbgcolor: operatorcolor,
                tcolor: orangecolor,
              ),
              Button(
                text: '<-',
                buttonbgcolor: operatorcolor,
                tcolor: orangecolor,
              ),
              Button(
                text: '^',
                buttonbgcolor: operatorcolor,
                tcolor: orangecolor,
              ),
              Button(
                text: '/',
                buttonbgcolor: operatorcolor,
                tcolor: orangecolor,
              ),
            ],
          ),
          Row(
            children: [
              Button(
                text: '7',
              ),
              Button(
                text: '8',
              ),
              Button(
                text: '9',
              ),
              Button(
                text: '*',
                buttonbgcolor: operatorcolor,
                tcolor: orangecolor,
              ),
            ],
          ),
          Row(
            children: [
              Button(
                text: '4',
              ),
              Button(
                text: '5',
              ),
              Button(
                text: '6',
              ),
              Button(
                text: '-',
                buttonbgcolor: operatorcolor,
                tcolor: orangecolor,
              ),
            ],
          ),
          Row(
            children: [
              Button(
                text: '1',
              ),
              Button(
                text: '2',
              ),
              Button(
                text: '3',
              ),
              Button(
                text: '+',
                buttonbgcolor: operatorcolor,
                tcolor: orangecolor,
              ),
            ],
          ),
          Row(
            children: [
              Button(
                text: '%',
                buttonbgcolor: operatorcolor,
                tcolor: orangecolor,
              ),
              Button(
                text: '0',
              ),
              Button(
                text: '.',
              ),
              Button(
                text: '=',
                buttonbgcolor: orangecolor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget Button({
    text,
    tcolor = Colors.white,
    buttonbgcolor = buttoncolor,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: buttonbgcolor,
            padding: EdgeInsets.all(22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            onbuttonclick(text);
          },
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: tcolor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
