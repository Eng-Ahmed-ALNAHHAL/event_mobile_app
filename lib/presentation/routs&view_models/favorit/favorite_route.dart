import 'package:flutter/material.dart';

import '../../components/constants/stack_background_manager.dart';
class FavoriteRoute extends StatefulWidget {
  const FavoriteRoute({super.key});

  @override
  State<FavoriteRoute> createState() => _FavoriteRouteState();
}

class _FavoriteRouteState extends State<FavoriteRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: stackBackGroundManager(),
    );
  }
  List<Widget> screenWidgets ()=>[];
}
