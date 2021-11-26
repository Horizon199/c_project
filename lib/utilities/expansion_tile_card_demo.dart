// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

class ExpansionTileCardDemo extends StatefulWidget {
  final String title;
  final String desc;
  final String imageUrl;

  const ExpansionTileCardDemo(
      {Key? key,
      required this.title,
      required this.desc,
      required this.imageUrl})
      : super(key: key);

  @override
  _ExpansionTileCardDemoState createState() => _ExpansionTileCardDemoState();
}

class _ExpansionTileCardDemoState extends State<ExpansionTileCardDemo> {
  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: <Widget>[
        ExpansionTileCard(
          baseColor: Colors.blue,
          expandedColor: Colors.white,
          key: cardA,
          leading: Image.network(widget.imageUrl, fit: BoxFit.cover),
          title: Text(widget.title),
          children: <Widget>[
            const Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(widget.desc,
                    style: Theme.of(context).textTheme.bodyText2),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Image(
                    image: NetworkImage(widget.imageUrl),
                  )),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              buttonHeight: 52.0,
              buttonMinWidth: 90.0,
              children: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  onPressed: () {
                    // do checkin
                    cardA.currentState?.expand();
                  },
                  child: Column(
                    children: const <Widget>[
                      Icon(Icons.arrow_downward),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Text('Checkin'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const Divider(
          thickness: 1.0,
          height: 1.0,
          color: Colors.white,
        ),
      ],
    );
  }
}
