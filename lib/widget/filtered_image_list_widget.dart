import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:photo_filters_ii_example/widget/filtered_image_widget.dart';
import 'package:photofilters/filters/filters.dart';

class FilteredImageListWidget extends StatelessWidget {
  final List<Filter> filters;
  final img.Image image;
  final ValueChanged<Filter> onChangedFilter;

  const FilteredImageListWidget({
    Key key,
    @required this.filters,
    @required this.image,
    @required this.onChangedFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double height = 150;

    return Container(
      height: height,
      color: Colors.black.withOpacity(0.2),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];

          return InkWell(
            onTap: () => onChangedFilter(filter),
            child: Container(
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilteredImageWidget(
                    filter: filter,
                    image: image,
                    successBuilder: (imageBytes) => CircleAvatar(
                      radius: 50,
                      backgroundImage: MemoryImage(imageBytes),
                      backgroundColor: Colors.white,
                    ),
                    errorBuilder: () => CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.report, size: 32),
                      backgroundColor: Colors.white,
                    ),
                    loadingBuilder: () => CircleAvatar(
                      radius: 50,
                      child: Center(child: CircularProgressIndicator()),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    filter.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
