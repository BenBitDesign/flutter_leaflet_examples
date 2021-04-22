import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:xml/xml_events.dart';

import '../widgets/drawer.dart';

class PolylinePage extends StatefulWidget {
  static const String route = 'polyline';

  @override
  _PolylinePageState createState() => _PolylinePageState();
}

class _PolylinePageState extends State<PolylinePage> {
  List<LatLng> points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Polylines')),
      drawer: buildDrawer(context, PolylinePage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('Polylines'),
            ),
            Flexible(
              child: points.isEmpty
                  ? Center(child: Text('loading'))
                  : FlutterMap(
                      options: MapOptions(
                        center: points.first,
                        zoom: 12.0,
                      ),
                      layers: [
                        TileLayerOptions(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c']),
                        PolylineLayerOptions(
                          polylines: [
                            Polyline(
                                points: points,
                                strokeWidth: 4.0,
                                color: Colors.purple),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    getCoordsTest();
  }

  void getCoordsTest() async {
    final HttpClient httpClient = HttpClient();
    final url = Uri.parse(
        'https://bitdesign.be/hiking-in-bulgaria-site/public/data/mumdjidam/gps/1.gpx');
    final request = await httpClient.getUrl(url);
    final response = await request.close();
    final stream = response.transform(utf8.decoder);

    await stream
        .toXmlEvents()
        .normalizeEvents()
        .selectSubtreeEvents((event) => event.name == 'trkpt')
        .toXmlNodes()
        .flatten()
        .forEach((element) {
      points.add(LatLng(double.parse(element.getAttribute('lat')),
          double.parse(element.getAttribute('lon'))));
    });
    setState(() {});
  }
}
