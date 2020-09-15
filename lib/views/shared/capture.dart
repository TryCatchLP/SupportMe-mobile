import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ActionCapture extends StatelessWidget {
  final Function(File result) onCapture;

  final ImagePicker _picker = ImagePicker();
  final double width;

  ActionCapture({Key key, this.onCapture, this.width}) : super(key: key);

  _onCapture(ImageSource source) async {
    final image = await _picker.getImage(source: source, maxWidth: width);
    if (image != null) {
      File file = File(image.path);
      onCapture(file);
    } else
      onCapture(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ActionItem(
          icon: Icons.camera_alt,
          title: "Cámara",
          onTap: () => _onCapture(ImageSource.camera),
        ),
        ActionItem(
          icon: Icons.photo,
          title: "Fotos",
          onTap: () => _onCapture(ImageSource.gallery),
        )
      ],
    );
  }
}

class ActionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onTap;
  const ActionItem({Key key, this.icon, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: Icon(icon),
        title: Text(title),
        onTap: onTap);
  }
}