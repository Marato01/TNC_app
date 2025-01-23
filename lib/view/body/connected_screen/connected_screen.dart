import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import '../../graph/graph_screen.dart';
import '../../configuration/config_screen/config_screen.dart';

class ConnectedScreen extends StatefulWidget {
  const ConnectedScreen({super.key});

  @override
  State<ConnectedScreen> createState() => _ConnectedScreenState();
}

class _ConnectedScreenState extends State<ConnectedScreen> {

  // List of titles and icons
  final List<Map<String, dynamic>> gridItems = [
    {'title': 'Configuration', 'icon': Icons.settings},
    {'title': 'Graph', 'icon': Icons.stacked_line_chart_outlined},
    {'title': 'debugging', 'icon': Icons.code_outlined},
    {'title': 'Notifications', 'icon': Icons.notifications},
    {'title': 'Profile', 'icon': Icons.person},
    {'title': 'Help', 'icon': Icons.help},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 50, // Spacing between columns
          mainAxisSpacing: 20, // Spacing between rows
        ),
        itemCount: gridItems.length, // Length of the list,
        itemBuilder: (context, index){
          final item = gridItems[index]; // Access each item
          return GestureDetector(
            onTap: (){
              if(index == 0){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfigScreen()));
              } else if(index ==1){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const GraphScreen()));
              }
              else {
                CherryToast.info(
                  toastDuration: const Duration(milliseconds: 1),
                  disableToastAnimation: true,
                  title: const Text(
                    'This feature not available',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  inheritThemeColors: true,
                  actionHandler: () {},
                  onToastClosed: () {},
                ).show(context);
              }
            },
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration: BoxDecoration(
                    color: const Color(0xFF454545),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color
                        blurRadius: 10, // Softness of shadow
                        spreadRadius: 5, // Spread of shadow
                        offset: const Offset(5, 5), // Position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                    child: Center(child: Icon( item['icon'], // Access icon from the list
                      size: 50,
                      color: const Color(0xFF8D8D8D),)),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA9A9A9),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color
                        blurRadius: 10, // Softness of shadow
                        spreadRadius: 5, // Spread of shadow
                        offset: const Offset(5, 5), // Position of shadow
                      ),
                    ],
                  ),
                  child:  Center(child: Text( item['title'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),),
                ),
              ],
            ),
          );
        }
    );
  }
}
