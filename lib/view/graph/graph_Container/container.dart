import 'package:flutter/material.dart';
import '../../homepage.dart';
import 'graph.dart';

class ContainerScreen extends StatefulWidget {
  const ContainerScreen({
    super.key,
  });

  @override
  State<ContainerScreen> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.46,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFD8D8D8),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFA0A0A0), // Dark shadow color
              offset: Offset(0, 10),    // Shadow offset
              blurRadius: 20,           // Large blur for soft shadow
              spreadRadius: 1,          // Slight spread for larger shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monitoring',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              //call widget from GraphScreen
              const Expanded(
                  child: Graph()),

            ],
          ),
        )
    );
  }
}