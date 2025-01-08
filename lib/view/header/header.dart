import 'package:airlora_app/view/header/notification/notification.dart';
import 'package:flutter/material.dart';
import 'switch_button/switch.dart';
import 'username/username.dart';

class Header extends StatefulWidget {
  const Header({super.key});
  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        const Username(),

        Row(
          children: [

            const Notifications(),

            SizedBox(width: MediaQuery.of(context).size.width * 0.05),

            const SwitchButton(),
          ],
        )
      ],
    );
  }
}
