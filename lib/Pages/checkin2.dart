// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:c_project/utilities/expansion_tile_card_demo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<EventList> buildEventList(Function getPosition) async {
  Position currentPosition = await getPosition();
  EventList events =
      await getLocalEvents(currentPosition.latitude, currentPosition.longitude);
  print(events);
  return events;
}

Future<EventList> getLocalEvents(lat, long) async {
  final response =
      await http.post(Uri.parse("http://10.0.2.2:8080/nearest-events"),
          headers: <String, String>{"Content-Type": "application/json"},
          body: jsonEncode(<String, String>{
            "lat": lat.toString(),
            "long": long.toString(),
          }));
  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return EventList.fromJson(jsonDecode(response.body));
  } else {
    return EventList(events: [
      Event(
          id: "id",
          title: "unable to fetch events",
          image: "null",
          desc: "null")
    ]);
  }
}

class EventList {
  List<Event> events;
  EventList({
    required this.events,
  });

  factory EventList.fromJson(List<dynamic> parsedJson) {
    List<Event> events = parsedJson.map((i) => Event.fromJson(i)).toList();
    return EventList(events: events);
  }
}

class Event {
  final String id;
  final String title;
  final String desc;
  final String image;

  Event(
      {required this.id,
      required this.title,
      required this.image,
      required this.desc});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'] ?? "missing",
        title: json["name"] ?? "missing",
        desc: json["shortDesc"] ?? "missing",
        image: json["image"] ?? "missing");
  }
}

class Checking extends StatefulWidget {
  @override
  _CheckingState createState() => _CheckingState();
}

class _CheckingState extends State<Checking> {
  bool eventsInitialized = false;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Events"),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF8E24AA),
                      Color(0xFF7B1FA2),
                      Color(0xFF6A1B9A),
                      Color(0xFF4A148C),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              FutureBuilder(
                future: buildEventList(_determinePosition),
                builder:
                    (BuildContext context, AsyncSnapshot<EventList> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      for (int i = 0; i < snapshot.data!.events.length; i++)
                        ExpansionTileCardDemo(
                            title: snapshot.data!.events[i].title,
                            desc: snapshot.data!.events[i].desc,
                            imageUrl: snapshot.data!.events[i].image)
                    ];
                  } else if (snapshot.hasError) {
                    return Text("Unable to fetch events!");
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      )
                    ];
                  }
                  return ListView(children: children);
                },
              )
            ]),
          ),
        ));
  }
}
