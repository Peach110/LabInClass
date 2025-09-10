import 'package:flutter/material.dart';

class TripPage extends StatefulWidget {
  final int idx;

  const TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trip Page ${widget.idx}")),
      body: Center(
        child: Text(
          "Index: ${widget.idx.toString()}",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

void goToTrip(BuildContext context, int idx) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TripPage(idx: idx),
    ),
  );
}

