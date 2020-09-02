import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supportme/theme/theme.dart';

class Rating extends StatefulWidget {
  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  _onCalificate(int calification) {
    print(calification);
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
            RatingStar(
              onCalificate: _onCalificate,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextArea(),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
                width: double.infinity,
                height: 40,
                child: RaisedButton(
                  onPressed: () {},
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
  const TextArea({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: AppTheme.pallete.shade200,
      child: TextField(
        maxLines: 5,
        controller: TextEditingController(),
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
