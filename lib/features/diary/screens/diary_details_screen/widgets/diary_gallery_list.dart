import 'package:flutter/material.dart';
import 'package:rumo/features/diary/screens/diary_details_screen/widgets/diary_gallery_item.dart';
// import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';

class DiaryGalleryList extends StatelessWidget {
  const DiaryGalleryList({super.key});

  @override
  Widget build(BuildContext context) {
    // return StaggeredGridView.countBuilder(
    //   crossAxisCount: 3,
    //   mainAxisSpacing: 12,
    //   crossAxisSpacing: 12,
    //   itemCount: 7,
    //   physics: const NeverScrollableScrollPhysics(),
    //   shrinkWrap: true,
    //   itemBuilder: (context, index) {
    //     return DiaryGalleryItem();
    //   },
    //   staggeredTileBuilder: (index) {
    //     if(index != 0 && index % 3 == 0) {
    //       return StaggeredTile.fit(2);
    //     }
    //     return StaggeredTile.fit(1);
    //   },
    // );
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 12,
      runSpacing: 12,
      children: [
        DiaryGalleryItem(),
        DiaryGalleryItem(),
        DiaryGalleryItem(),
        DiaryGalleryItem(),
        DiaryGalleryItem(),
      ],
    );
  }
}
