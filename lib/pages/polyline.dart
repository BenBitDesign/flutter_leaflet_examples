import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:xml/xml_events.dart';

import '../widgets/drawer.dart';

class PolylinePage extends StatelessWidget {
  static const String route = 'polyline';

  void getCoordsTest() async {
    final HttpClient httpClient = HttpClient();
    final url = Uri.parse(
        'https://bitdesign.be/hiking-in-bulgaria-site/public/gps/mumdjidam/1.gpx');
    final request = await httpClient.getUrl(url);
    final response = await request.close();
    final stream = response.transform(utf8.decoder);

    stream
        .toXmlEvents()
        .normalizeEvents()
        .selectSubtreeEvents((event) => event.name == 'trkpt')
        .toXmlNodes()
        .flatten()
        .forEach((element) {
      print(element.getAttribute('lat'));
      print(element.getAttribute('lon'));
    });

    /*.where((node) => node.nodeType == XmlNodeType.ELEMENT)
        .cast<XmlElement>()
        .map((element) => element.name == 'book');

        .toXmlNodes()
        .flatten()
        .forEach((node) {
      print(node.toString());
    });
        */
  }

  @override
  Widget build(BuildContext context) {
    getCoordsTest();

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
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(41.8428863491863, 25.033135442063212),
                  zoom: 12.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  PolylineLayerOptions(
                    polylines: [
                      Polyline(points: [
                        LatLng(41.7988785076886,
                            25.081609161570668), // TODO:remove hardcoded
                        LatLng(41.862776605412364, 25.06568287499249)
                      ], strokeWidth: 4.0, color: Colors.purple),
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
}
