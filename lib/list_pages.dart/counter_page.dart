import 'package:flutter/material.dart';

class ContadorPage extends StatefulWidget {
  const ContadorPage({super.key});

  @override
  State<ContadorPage> createState() => _ContadorPageState();
}

class _ContadorPageState extends State<ContadorPage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Counter: $counter',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),

          Container(height: 20), //Espaçamento vertical(margin)
          Container(
            width: 160,
            height: 70,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 20, 70, 123),
              borderRadius: BorderRadius.circular(1000.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black..withValues(),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),

            child: Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    counter++;
                  });
                },
                child: Text(
                  'Plus',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 50), //Espaçamento vertical(margin)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                width: 50,
                height: 50,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.red,
                ),
              ),
              SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.green,
                ),
                width: 50,
                height: 50,
              ),
              SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.blue,
                ),
                width: 50,
                height: 50,
              ),
            ],
          ),
          //Espaçamento vertical(margin)
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Padding(padding: EdgeInsets.only(bottom: 20)),

              Container(
                width: 50,
                height: 50,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromARGB(255, 251, 255, 0),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
