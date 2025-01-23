import 'package:flutter/material.dart';
import 'category_Card/card.dart';
import 'graph_Container/container.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          const ContainerScreen(),

          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03, top: MediaQuery.of(context).size.height * 0.05, right: MediaQuery.of(context).size.width * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Categories' , style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05),),

                const Text('View all', style: TextStyle(color: Colors.white),)
              ],
            ),
          ),

          const Expanded(
              child: CategoryCard())
        ],
      ),
    );
  }
}


