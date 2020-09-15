import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:supportme/auth/session.dart';
import 'package:supportme/models/hueca.dart';
import 'package:supportme/services/hueca_service.dart';
import 'package:supportme/services/location_service.dart';
import 'package:supportme/theme/theme.dart';

import 'Rating.dart';
import 'login.dart';

class MapView extends StatefulWidget {
  final Function(LatLng) onAddHueca;

  MapView({Key key, this.onAddHueca}) : super(key: key);
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = Map<MarkerId, Marker>();
  GlobalKey<ScaffoldState> _scaff = GlobalKey<ScaffoldState>();
  PanelController panelController = PanelController();
  Hueca hueca;
  LatLng _latLng;
  bool init = true;

  @override
  void dispose() {
    hueca = null;
    _controller.future.then((value) => value.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  static final CameraPosition _ec = CameraPosition(
    target: LatLng(-2.19616, -79.88621),
    zoom: 15.5,
  );

  Future<void> _localice() async {
    LatLng latLng = await LocationService.getUserLocation();
    this._showOptions(latLng);
    this._zoomMap(latLng);
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
    init = false;
    _scaff.currentState.hideCurrentSnackBar();
    MarkerId markerId = MarkerId("tmp");
    _latLng = latLng;
    Marker marker = Marker(
        markerId: markerId,
        position: latLng,
        draggable: true,
        onTap: () => _showSnackBar(_latLng),
        onDragEnd: (latLng) {
          _latLng = latLng;
          _scaff.currentState.hideCurrentSnackBar();
          _showSnackBar(latLng);
        });
    setState(() {
      markers[markerId] = marker;
    });
    await Future.delayed(Duration(seconds: 60));
    if (this.mounted)
      setState(() {
        markers.remove(markerId);
        _scaff.currentState.hideCurrentSnackBar();
      });
  }

  _addMarkers(List<Hueca> huecas) async {
    final Uint8List markerIcon =
        await getBytesFromAsset("assets/images/logo.png", 100);
    if (this.mounted) {
      setState(() {
        for (Hueca hueca in huecas) {
          MarkerId markerId = MarkerId("${hueca.id}");
          Marker marker = Marker(
              markerId: markerId,
              onTap: () {
                init = false;
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
  }

  _zoomMap(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 18)));
  }

  _showSnackBar(LatLng latLng) {
    _scaff.currentState.hideCurrentSnackBar();
    _scaff.currentState.showSnackBar(SnackBar(
        content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.add),
            title: Text("Añadir hueca"),
            onTap: () {
              this.widget.onAddHueca(_latLng);
            }),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.zoom_in),
          title: Text("Acercar mapa"),
          onTap: () async {
            await _zoomMap(latLng);
            _scaff.currentState.hideCurrentSnackBar();
          },
        ),
      ],
    )));
  }

  _showOptions(LatLng latLng) {
    _addMarkerTmp(latLng);
    _showSnackBar(latLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaff,
      body: SlidingUpPanel(
        controller: panelController,
        header: GestureDetector(
          onTap: () => panelController.close(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ),
        ),
        backdropEnabled: true,
        minHeight: 0.0,
        onPanelClosed: () => setState(() {}),
        maxHeight: MediaQuery.of(context).size.height * 0.65,
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
            if (this.mounted) {
              _controller.complete(controller);
              _addMarkers(await HuecaService.getHuecas());
            }
          },
        ),
      ),
      floatingActionButton:
          panelController.isAttached && panelController.isPanelClosed || init
              ? FloatingActionButton(
                  child: Icon(
                    Icons.gps_fixed,
                    color: Color(0xFF59A5BD),
                  ),
                  onPressed: _localice,
                )
              : null,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            HeaderPanel(
              url: widget.hueca?.photo ?? "",
              hueca: widget.hueca,
            ),
            BodyPanel(hueca: widget.hueca),
          ],
        ),
      ),
    );
  }
}

class BodyPanel extends StatelessWidget {
  const BodyPanel({
    Key key,
    @required this.hueca,
  }) : super(key: key);

  final Hueca hueca;

  String _getStars() {
    if (hueca?.ratings != null && hueca?.ratings != 0) {
      return (hueca.stars / hueca.ratings).toStringAsFixed(1);
    }
    return "0.0";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5),
              child: buildDirection(),
            ),
            buildRatings(context),
          ],
        )
      ],
    ));
  }

  RichText buildDirection() {
    return RichText(
        text: TextSpan(
            text: 'Dirección: ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            children: [
          TextSpan(
              text: "${hueca?.address ?? ''}",
              style: TextStyle(fontWeight: FontWeight.normal))
        ]));
  }

  Widget buildRatings(BuildContext context) {
    return StatefulBuilder(builder: (context, setStarState) {
      return Tooltip(
        message: "${hueca?.ratings} calificaciones",
        child: GestureDetector(
          onTap: () => _onRatingTap(context, setStarState),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${_getStars()}"),
              Stack(
                children: [
                  Icon(
                    Icons.star,
                    color: Color(0xFFDFFF1A),
                    size: 20,
                  ),
                  Icon(
                    Icons.star_border,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  void _onRatingTap(
      BuildContext context, void Function(void Function()) setStarState) async {
    if (Session.instance.isAuthenticate) {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RatingView(
                hueca: hueca,
              )));
      setStarState(() {});
    } else {
      bool login = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Login()));
      if (login ?? false) {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RatingView(
                  hueca: hueca,
                )));
        setStarState(() {});
      }
    }
  }
}

class HeaderPanel extends StatelessWidget {
  HeaderPanel({Key key, @required this.url, this.hueca}) : super(key: key);

  final String url;
  final Hueca hueca;
  final TextStyle style = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          BackGroundImageNetwork(url: url),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Material(
              color: Color(0x88FFFFFF),
              elevation: 10,
              shadowColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${hueca?.name ?? ''} ",
                      style: style,
                    ),
                    Text(
                      "${hueca?.descrip ?? ''}",
                      style: style,
                    ),
                    Text(
                      "Abierto",
                      style: style,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.55),
                      child: Text(
                        "${hueca?.schedule}",
                        style: style,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BackGroundImageNetwork extends StatelessWidget {
  const BackGroundImageNetwork({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: FadeInImage(
        placeholder: AssetImage("assets/images/bg.jpg"),
        image: NetworkImage(url),
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) =>
            Image(image: AssetImage("assets/images/bg.jpg")),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.22,
      ),
    );
  }
}
