import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/core/helpers/app_environment.dart';
import 'package:rumo/features/diary/controllers/diary_details_controller.dart';
import 'package:rumo/features/diary/screens/diary_details_screen/widgets/diary_comments_bottom_sheet.dart';
import 'package:rumo/features/diary/screens/diary_details_screen/widgets/diary_gallery_list.dart';
import 'package:rumo/widgets/go_back_button.dart';

class DiaryDetailsScreen extends ConsumerWidget {
  const DiaryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) {
            final diaryAsync = ref.watch(diaryDetailsControllerProvider);
            if (diaryAsync.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // if ((diaryAsync.hasError || diaryAsync.valueOrNull == null)) {
            //   return Center(
            //     child: Text('Error loading diary details'),
            //   );
            // }
            return Stack(
              children: [
                Image.network(
                  'https://i.pinimg.com/736x/20/2c/93/202c93cc9d7f26578c00f3b350dec976.jpg',
                  width: double.maxFinite,
                  height: 115,
                  fit: BoxFit.cover,
                ),
                ListView(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                        ),
                        child: const GoBackButton(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    BottomSheet(
                      onClosing: () {},
                      showDragHandle: false,
                      enableDrag: false,
                      builder: (context) {
                        return SizedBox(
                          width: double.maxFinite,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        spacing: 16,
                                        children: [
                                          Chip(
                                            color: WidgetStatePropertyAll(Color(0xFFF5F5F5)),
                                            avatar: ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              clipBehavior: Clip.antiAlias,
                                              child: Image.asset(
                                                AssetImages.onboardingCharacter,
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            label: Text('Guilherme Souza'),
                                          ),
                                          Chip(
                                            color: WidgetStatePropertyAll(Color(0xFFF5F5F5)),
                                            avatar: SvgPicture.asset(
                                              AssetImages.iconCalendar,
                                              width: 20,
                                              height: 20,
                                              fit: BoxFit.cover,
                                            ),
                                            labelPadding: EdgeInsets.only(
                                              left: 4,
                                              right: 16,
                                            ),
                                            label: Text(
                                              '16/06/2025',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                                color: Color(0xFF757575),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // MenuAnchor(
                                    //   alignmentOffset: Offset(-60, 0),
                                    //   menuChildren: [],
                                    //   builder: (context, controller, _) {
                                    //     return GestureDetector(
                                    //       onTap: () {},
                                    //       child: Padding(
                                    //         padding: const EdgeInsets.only(
                                    //           top: 6,
                                    //           bottom: 6,
                                    //           left: 6,
                                    //         ),
                                    //         child: SvgPicture.asset(
                                    //           AssetImages.iconDotsMenu,
                                    //           width: 20,
                                    //           height: 20,
                                    //         ),
                                    //       ),
                                    //     );
                                    //   },
                                    // ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Conhecendo Brasília',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Color(0xFF131927),
                                  ),
                                ),
                                const Text(
                                  'Brasília, Brasil',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    color: Color(0xFF757575),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 16,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: 4,
                                      children: [
                                        SvgPicture.asset(
                                          AssetImages.iconStar,
                                          colorFilter: ColorFilter.mode(Color(0xFFDFB300), BlendMode.srcIn),
                                          width: 14,
                                          height: 14,
                                        ),
                                        Text(
                                          '4.5',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Color(0xFF303030),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: 4,
                                      children: [
                                        SvgPicture.asset(
                                          AssetImages.iconHeart,
                                          width: 14,
                                          height: 14,
                                        ),
                                        Text(
                                          '100',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Color(0xFF303030),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'SOBRE A VIAGEM',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF757575),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In laoreet, purus non dictum ornare, nisl justo consectetur dolor, et congue ante lectus a eros. Donec ac sodales massa. Proin et magna tempor, porttitor mi at, auctor dolor. Maecenas semper facilisis convallis. In ut purus porta, finibus dui in, fringilla lacus. Suspendisse consequat quam arcu, nec dictum est imperdiet vitae. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer a porta nibh.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF757575),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.maxFinite,
                                  constraints: BoxConstraints(
                                    maxHeight: 133,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Color(0xFFD9D9D9),
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    clipBehavior: Clip.antiAlias,
                                    child: FlutterMap(
                                      options: MapOptions(
                                        initialCenter: LatLng(-27.8167, -50.3264),
                                        initialZoom: 12,
                                        interactionOptions: InteractionOptions(
                                          flags: InteractiveFlag.none,
                                        ),
                                      ),
                                      children: [
                                        TileLayer(
                                          urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=${AppEnvironment.mapTileKey}',
                                          userAgentPackageName: 'br.com.othavioh.rumo',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'GALERIA',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Color(0xFF757575),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                DiaryGalleryList(),
                                const SizedBox(height: 24),
                                Container(
                                  decoration: BoxDecoration(color: Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(16)),
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    spacing: 16,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        spacing: 4,
                                        children: [
                                          SvgPicture.asset(
                                            AssetImages.iconEmptyHeart,
                                            width: 20,
                                            height: 20,
                                          ),
                                          Text(
                                            '100',
                                            style: TextStyle(
                                              color: Color(0xFF6D717F),
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return DiaryCommentsBottomSheet();
                                            },
                                            isScrollControlled: true,
                                          );
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 4,
                                          children: [
                                            SvgPicture.asset(
                                              AssetImages.iconChat,
                                              width: 20,
                                              height: 20,
                                            ),
                                            Text(
                                              '20',
                                              style: TextStyle(
                                                color: Color(0xFF6D717F),
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
