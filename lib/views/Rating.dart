import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supportme/models/hueca.dart';
import 'package:supportme/models/rating.dart';
import 'package:supportme/services/rating_service.dart';
import 'package:supportme/theme/theme.dart';

class RatingView extends StatefulWidget {
  final Hueca hueca;

  const RatingView({Key key, this.hueca}) : super(key: key);

  @override
  _RatingViewState createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  TextEditingController comment = TextEditingController();
  Rating rating;
  final _ratingState = GlobalKey<_RatingStarState>();
  int oldStars;

  @override
  void initState() {
    rating = Rating.zero()..huecaid = widget.hueca.id;
    oldStars = 0;
    super.initState();
  }

  _onCalificate(int calification) {
    rating.stars = calification;
  }

  _submit() async {
    rating.comentario = comment.text.isEmpty ? "<no comment>" : comment.text;
    showDialog(
        context: context,
        barrierDismissible: false,
        child: Center(
          child: CircularProgressIndicator(),
        ));
    final res = rating.id == null
        ? await RatingService.post(rating)
        : await RatingService.update(rating);
    if (res != null) {
      if (rating.id != null) {
        widget.hueca.stars -= oldStars;
        widget.hueca.stars += this.rating.stars;
      } else {
        widget.hueca.stars += this.rating.stars;
        widget.hueca.ratings += 1;
      }
      Navigator.pop(context);
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Calificado con éxito", toastLength: Toast.LENGTH_LONG);
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Error al enviar calificación", toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calificar Hueca"),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
                child: Text(
              "${widget.hueca.name}",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 15,
            ),
            FutureBuilder(
                future: RatingService.getUserRatingHueca(widget.hueca),
                builder: (context, AsyncSnapshot<Rating> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Rating value = snapshot.data;
                    comment.text = value.comentario != "<no comment>"
                        ? value.comentario
                        : "";
                    rating = value..huecaid = widget.hueca.id;
                    oldStars = rating.stars;
                    _ratingState.currentState.update(rating.stars);
                    Navigator.pop(context);
                    return buildColumn(rating);
                  } else {
                    Future.delayed(
                        Duration.zero,
                        () => showDialog(
                            barrierDismissible: false,
                            context: context,
                            child: Center(child: CircularProgressIndicator())));
                    return buildColumn(rating);
                  }
                })
          ],
        ),
      ),
    );
  }

  Column buildColumn(Rating rating) {
    return Column(
      children: [
        RatingStar(
          key: _ratingState,
          onCalificate: _onCalificate,
          initStars: rating.stars,
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: TextArea(
            controller: comment,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            width: double.infinity,
            height: 40,
            child: RaisedButton(
              onPressed: _submit,
              child: Text("ENVIAR"),
              color: AppTheme.pallete.shade600,
            ),
          ),
        )
      ],
    );
  }
}

class TextArea extends StatelessWidget {
  const TextArea({Key key, this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: AppTheme.pallete.shade200,
      child: TextField(
        maxLines: 5,
        controller: controller,
        decoration: InputDecoration(
            hintText: "Deja tu comentario",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 0.0))),
      ),
    );
  }
}

class RatingStar extends StatefulWidget {
  final initStars;
  RatingStar({Key key, this.onCalificate, this.initStars = 0})
      : super(key: key);

  final Function(int) onCalificate;

  @override
  _RatingStarState createState() => _RatingStarState();
}

class _RatingStarState extends State<RatingStar> {
  int rating = 0;
  List<Color> _stars = [
    AppTheme.pallete.shade200,
    AppTheme.pallete.shade200,
    AppTheme.pallete.shade200,
    AppTheme.pallete.shade200,
    AppTheme.pallete.shade200
  ];

  @override
  void initState() {
    rating = widget.initStars;
    update(widget.initStars);
    super.initState();
  }

  update(int stars) {
    for (int i = 0; i < stars; i++) {
      _stars[i] = Colors.yellow;
    }
    setState(() {});
  }

  _initStars() {
    for (int i = 0; i < _stars.length; i++) {
      _stars[i] = AppTheme.pallete.shade200;
    }
  }

  Widget _starBuilder(int index) {
    return GestureDetector(
      child: Icon(
        Icons.star,
        size: 48,
        color: _stars[index],
      ),
      onTap: () {
        rating = index + 1;
        this.widget.onCalificate(rating);
        setState(() {
          _initStars();
          for (int i = 0; i <= index; i++) {
            _stars[i] = Colors.yellow;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_stars.length, _starBuilder),
    );
  }
}
