// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:websocket/services/socket_service.dart';
import '../models/band.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Band> band = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    band = (payload as List).map((b) => Band.fromMap(b)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    setState(() {});
    super.dispose();
  }

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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: context
                .watch<SocketService>()
                .serverStatus ==
                ServerStatus.online
                ? Icon(
              Icons.check_circle,
              color: Colors.blue[100],
            )
                : const Icon(
              Icons.offline_bolt,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Column(children: [
        _showGraft(),
        Expanded(
          child: ListView.builder(
            itemCount: band.length,
            itemBuilder: (context, index) => buildBandTile(band[index]),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[100],
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Dismissible buildBandTile(Band band) =>
      Dismissible(
        key: Key(band.id),
        direction: DismissDirection.startToEnd,
        onDismissed: (_) =>
            context.read<SocketService>().emit('delete-band', {'id': band.id}),
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
            context.read<SocketService>().emit('vote-band', {'id': band.id});
          },
        ),
      );

  addNewBand() {
    final textController = TextEditingController();
    (Platform.isAndroid)
        ? showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
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
        builder: (_) =>
            CupertinoAlertDialog(
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

  Widget _showGraft() {
    Map<String, double> dataMap = {};
    if (band.isNotEmpty) {
      for (var b in band) {
        dataMap.putIfAbsent(b.name, () => b.votes.toDouble());
      }
    } else {
      dataMap = {'': 1};
    }

    final List<Color> colorList = [
      Colors.blue[50]!,
      Colors.blue[200]!,
      Colors.pink[50]!,
      Colors.pink[200]!,
      Colors.yellow[50]!,
      Colors.yellow[200]!
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        colorList: colorList,
        chartType: ChartType.ring,
        ringStrokeWidth: 15,
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: false,
          showChartValues: true,
          showChartValuesOutside: false,
          showChartValuesInPercentage: true,
          decimalPlaces: 0,
        ),
      ),
    );
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      context.read<SocketService>().emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }
}
