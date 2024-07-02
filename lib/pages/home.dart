// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/band.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Band> band = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 1),
    Band(id: '3', name: 'Heroes del Silencio', votes: 2),
    Band(id: '4', name: 'Bon Jovi', votes: 5)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: band.length,
        itemBuilder: (context, index) => buildBandTile(band[index]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[100],
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Dismissible buildBandTile(Band band) => Dismissible(
        key: Key(band.id),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction)=>print(direction),
        background: Container(
          padding: const EdgeInsets.only(left: 10),
          color: Colors.red,
          child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Delete Band',
                style: TextStyle(color: Colors.white),
              )),
        ),
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(band.name.substring(0, 2))),
          title: Text(band.name),
          trailing: Text(
            '${band.votes}',
            style: const TextStyle(fontSize: 20),
          ),
          onTap: () {
            print(band.name);
          },
        ),
      );

  addNewBand() {
    final textController = TextEditingController();
    (Platform.isAndroid)
        ? showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('New band name'),
                  content: TextField(
                    controller: textController,
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () => addBandToList(textController.text),
                      elevation: 1,
                      textColor: Colors.blue,
                      child: const Text('Add'),
                    )
                  ],
                ))
        : showCupertinoDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
                  title: const Text('New band name:'),
                  content: TextField(
                    controller: textController,
                  ),
                  actions: [
                    CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () => addBandToList(textController.text),
                        child: const Text('Add')),
                    CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Dismiss'))
                  ],
                ));
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      band.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
