import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supportme/models/hueca.dart';

import 'Rating.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = Map<MarkerId, Marker>();
  GlobalKey<ScaffoldState> _scaff = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _controller.future.then((value) => value.dispose());
    super.dispose();
  }

  static final CameraPosition _ec = CameraPosition(
    target: LatLng(-2.19616, -79.88621),
    zoom: 15.5,
  );

  Future<void> _localice() async {
    final GoogleMapController controller = await _controller.future;

    //controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  _addMarkerTmp(LatLng latLng) async {
    MarkerId markerId = MarkerId("tmp");
    Marker marker = Marker(markerId: markerId, position: latLng);
    setState(() {
      markers[markerId] = marker;
    });
    await Future.delayed(Duration(milliseconds: 4000));
    setState(() {
      markers.remove(markerId);
    });
  }

  _addMarkers(List<Hueca> huecas) async {
    final Uint8List markerIcon =
        await getBytesFromAsset("assets/images/logo.png", 100);
    for (Hueca hueca in huecas) {
      MarkerId markerId = MarkerId("${hueca.id}");
      Marker marker = Marker(
          markerId: markerId,
          onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RatingView(
                          huecaid: hueca.id,
                        )))
              },
          position: LatLng(hueca.lat, hueca.lng),
          icon: BitmapDescriptor.fromBytes(markerIcon));
      markers[markerId] = marker;
    }
  }

  _zoomMap(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 18)));
  }

  _showOptions(LatLng latLng) {
    _addMarkerTmp(latLng);
    _scaff.currentState.showSnackBar(SnackBar(
        content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.add),
          title: Text("Añadir hueca"),
        ),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.zoom_in),
          title: Text("Acercar mapa"),
          onTap: () => _zoomMap(latLng),
        )
      ],
    )));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaff,
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _ec,
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomGesturesEnabled: true,
        onLongPress: _showOptions,
        markers: markers.values.toSet(),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.gps_fixed,
          color: Color(0xFF59A5BD),
        ),
        onPressed: _localice,
      ),
    );
  }
}
