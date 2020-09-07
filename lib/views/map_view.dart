import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:supportme/models/hueca.dart';
import 'package:supportme/services/hueca_service.dart';
import 'package:supportme/services/rating_service.dart';
import 'package:supportme/theme/theme.dart';

import 'Rating.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = Map<MarkerId, Marker>();
  GlobalKey<ScaffoldState> _scaff = GlobalKey<ScaffoldState>();
  PanelController panelController = PanelController();
  Hueca hueca;

  @override
  void dispose() {
    hueca = null;
    _controller.future.then((value) => value.dispose());
    super.dispose();
  }

  static final CameraPosition _ec = CameraPosition(
    target: LatLng(-2.19616, -79.88621),
    zoom: 15.5,
  );

  Future<void> _localice() async {
    //final GoogleMapController controller = await _controller.future;

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
    setState(() {
      for (Hueca hueca in huecas) {
        MarkerId markerId = MarkerId("${hueca.id}");
        Marker marker = Marker(
            markerId: markerId,
            onTap: () {
              setState(() {
                this.hueca = hueca;
              });
              panelController.open();
            },
            position: LatLng(hueca.lat, hueca.lng),
            icon: BitmapDescriptor.fromBytes(markerIcon));
        markers[markerId] = marker;
      }
    });
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
    return Scaffold(
      key: _scaff,
      body: SlidingUpPanel(
        controller: panelController,
        collapsed: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
        backdropEnabled: true,
        minHeight: 0.0,
        color: AppTheme.primary,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        panel: Panel(
          hueca: hueca,
        ),
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _ec,
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomGesturesEnabled: true,
          onLongPress: _showOptions,
          markers: markers.values.toSet(),
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            _addMarkers(await HuecaService.getHuecas());
          },
        ),
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

class Panel extends StatefulWidget {
  final Hueca hueca;
  const Panel({Key key, this.hueca}) : super(key: key);

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  String _getStars() {
    if (widget.hueca.ratings != 0) {
      return (widget.hueca.stars / widget.hueca.ratings).toStringAsFixed(1);
    }
    return "0.0";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nombre: ${widget.hueca?.name ?? ''} "),
                Text("Descripción: ${widget.hueca?.descrip ?? ''}"),
                Text("Dirección: ${widget.hueca?.address ?? ''}"),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${_getStars()}"),
                Icon(Icons.star, size: 16,),
                Text("(${widget.hueca.ratings})")
              ],
            ),
            RaisedButton(
                child: Text("Calificar"),
                onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RatingView(
                                hueca: widget.hueca,
                              )))
                    })
          ],
        ),
      ),
    );
  }
}
