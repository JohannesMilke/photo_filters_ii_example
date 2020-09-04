import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:photo_filters_ii_example/widget/filtered_image_list_widget.dart';
import 'package:photo_filters_ii_example/widget/filtered_image_widget.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/filters/preset_filters.dart';

import 'filter_utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Photo Filters II',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: MyHomePage(title: 'Advanced Photo Filters II'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  img.Image image;
  Filter filter = presetFiltersList.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: pickImage,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                filter = presetFiltersList[3];
              });
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          buildImage(),
          const SizedBox(height: 12),
          buildFilters(),
        ],
      ),
    );
  }

  Future pickImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    final imageBytes = File(image.path).readAsBytesSync();

    final newImage = img.decodeImage(imageBytes);
    FilterUtils.clearCache();

    setState(() {
      this.image = newImage;
    });
  }

  Widget buildImage() {
    const double height = 450;
    if (image == null) return Container();

    return FilteredImageWidget(
      filter: filter,
      image: image,
      successBuilder: (imageBytes) =>
          Image.memory(imageBytes, height: height, fit: BoxFit.fitHeight),
      errorBuilder: () => Container(height: height),
      loadingBuilder: () => Container(
        height: height,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget buildFilters() {
    if (image == null) return Container();

    return FilteredImageListWidget(
      filters: presetFiltersList,
      image: image,
      onChangedFilter: (filter) {
        setState(() {
          this.filter = filter;
        });
      },
    );
  }
}
