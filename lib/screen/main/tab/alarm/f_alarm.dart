import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:fast_app_base/screen/main/tab/alarm/ring.dart';
import 'package:fast_app_base/screen/main/tab/alarm/tile.dart';
import 'package:flutter/material.dart';

import 'edit_alarm.dart';

class AlarmFragment extends StatefulWidget {
  const AlarmFragment({super.key});

  @override
  State<AlarmFragment> createState() => _AlarmFragmentState();
}

class _AlarmFragmentState extends State<AlarmFragment> {
  late List<AlarmSettings> alarms;

  static StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
          (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ExampleAlarmRingScreen(alarmSettings: alarmSettings),
        ));
    loadAlarms();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    final res = await showModalBottomSheet<bool?>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.75,
            child: ExampleAlarmEditScreen(alarmSettings: settings),
          );
        });

    if (res != null && res == true) loadAlarms();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "알람",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: alarms.isNotEmpty
            ? ListView.separated(
          itemCount: alarms.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            return ExampleAlarmTile(
              key: Key(alarms[index].id.toString()),
              title: TimeOfDay(
                hour: alarms[index].dateTime.hour,
                minute: alarms[index].dateTime.minute,
              ).format(context),
              onPressed: () => navigateToAlarmScreen(alarms[index]),
              onDismissed: () {
                Alarm.stop(alarms[index].id).then((_) => loadAlarms());
              },
            );
          },
        )
            : Center(
          child: Text(
            "알람이 없습니다.",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () => navigateToAlarmScreen(null),
          child: const Icon(Icons.alarm_add_rounded, size: 33),
        ),
      ),
      //floatingActionButton location up


      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }
}
