import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  int rating = 0;
  TextEditingController comment = TextEditingController();

  _onCalificate(int calification) {
    rating = calification;
  }

  _submit() async {
    Rating rating = Rating(
        comentario: comment.text.isEmpty ? "<no comment>" : comment.text,
        huecaid: widget.hueca.id,
        stars: this.rating,
        userid: 1);
    showDialog(
        context: context,
        child: Center(
          child: CircularProgressIndicator(),
        ));
    final res = await RaatingService.post(rating);
    if (res != null) {
      widget.hueca.stars += this.rating;
      widget.hueca.ratings += 1;
      Navigator.pop(context);
      Navigator.pop(context);
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
            RatingStar(
              onCalificate: _onCalificate,
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
        ),
      ),
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
  RatingStar({Key key, this.onCalificate}) : super(key: key);

  final Function(int) onCalificate;

  @override
  _RatingStarState createState() => _RatingStarState();
}

class _RatingStarState extends State<RatingStar> {
  List<Color> _stars = [
    AppTheme.pallete.shade200,
    AppTheme.pallete.shade200,
    AppTheme.pallete.shade200,
    AppTheme.pallete.shade200,
    AppTheme.pallete.shade200
  ];

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
        this.widget.onCalificate(index + 1);
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
