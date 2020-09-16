import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supportme/models/hueca.dart';
import 'package:supportme/models/rating.dart';
import 'package:supportme/services/rating_service.dart';
import 'package:supportme/theme/theme.dart';
import 'package:supportme/views/Rating.dart';

class UserRatingsView extends StatefulWidget {
  @override
  _UserRatingsViewState createState() => _UserRatingsViewState();
}

class _UserRatingsViewState extends State<UserRatingsView> {
  Widget _itemBuilder(Rating rating) {
    return RatingItem(
      rating: rating,
      onChange: () => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calificaciones"),
          automaticallyImplyLeading: true,
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder(
            future: RatingService.getUserRatings(),
            builder: (context, AsyncSnapshot<List<Rating>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.separated(
                    padding: EdgeInsets.all(25.0),
                    itemBuilder: (c, i) => _itemBuilder(snapshot.data[i]),
                    separatorBuilder: (c, i) => SizedBox(
                          height: 15.0,
                        ),
                    itemCount: snapshot.data.length);
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}

class RatingItem extends StatelessWidget {
  final Rating rating;
  final Function onChange;

  const RatingItem({Key key, this.rating, this.onChange}) : super(key: key);

  void _onEditRating(BuildContext context, Rating rating) async {
    bool res = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RatingView(
                  hueca: Hueca(
                      id: rating.huecaid,
                      name: rating.huecaname,
                      stars: 0,
                      ratings: 0),
                  rating: rating,
                )));
    if (res != null) {
      this.onChange();
    }
  }

  _onDelete(BuildContext context, Rating rating) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("¿Está seguro que desea eliminar esta calificación?"),
        content: Text("Hueca: ${rating.huecaname}\nEstrellas: ${rating.stars}"),
        actions: [
          FlatButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
          FlatButton(
              onPressed: () async {
                bool res = await RatingService.delete(rating);
                if (res) {
                  Navigator.pop(context);
                  this.onChange();
                  Fluttertoast.showToast(
                      msg: "Eliminado con éxito",
                      toastLength: Toast.LENGTH_LONG);
                }
              },
              child: Text("Eliminar")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.card,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), side: BorderSide()),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.2),
                      child: Text(
                        rating.huecaname,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )]..addAll(List.generate(
                          5,
                          _buildStars,
                      ))
                ),
                Row(
                  children: [
                    IconButton(
                        padding: EdgeInsets.zero,
                        tooltip: "Eliminar",
                        icon: Icon(Icons.delete_outline),
                        onPressed: () => _onDelete(context, rating)),
                    IconButton(
                        padding: EdgeInsets.zero,
                        tooltip: "Editar",
                        icon: Icon(Icons.edit),
                        onPressed: () => _onEditRating(context, rating))
                  ],
                )
              ],
            ),
            Text("Comentario: ${rating.comentario}")
          ],
        ),
      ),
    );
  }

  Widget _buildStars(index) {
    if (index < rating.stars) {
      return Icon(
        Icons.star,
        color: Colors.yellow,
      );
    }
    return Icon(
      Icons.star,
      color: AppTheme.pallete.shade200,
    );
  }
}
