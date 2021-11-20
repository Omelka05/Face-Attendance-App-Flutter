import '../../../constants/app_sizes.dart';
import '../../../controllers/map/map_controller.dart';
import '../../widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SpaceRangeScreen extends StatelessWidget {
  const SpaceRangeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Range'),
      ),
      // extendBodyBehindAppBar: true,
      body: GetBuilder<AppMapController>(
        init: AppMapController(),
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: controller.initialCameraPostion,
                      onMapCreated: (c) {
                        controller.onMapCreated(c, context);
                      },
                      onCameraMove: controller.onCameraMove,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: controller.mapType,
                      mapToolbarEnabled: true,
                      cameraTargetBounds: controller.hkgBounds,
                      markers: controller.allMarker,
                      circles: controller.allCircles,
                      onTap: controller.onTap,
                    ),
                    Positioned(
                      top: 10,
                      right: 5,
                      child: Column(
                        children: [
                          CircleIconButton(
                            icon: const Icon(
                              Icons.satellite_rounded,
                              color: Colors.white,
                            ),
                            onTap: () {
                              controller.changeMapType(MapType.hybrid);
                            },
                          ),
                          AppSizes.hGap10,
                          CircleIconButton(
                            icon: const Icon(
                              Icons.map,
                              color: Colors.white,
                            ),
                            onTap: () {
                              controller.changeMapType(MapType.terrain);
                            },
                          ),
                          AppSizes.hGap10,
                          CircleIconButton(
                            icon: const Icon(
                              Icons.maps_home_work_rounded,
                              color: Colors.white,
                            ),
                            onTap: () {
                              controller.changeMapType(MapType.normal);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: Get.width,
                color: context.theme.scaffoldBackgroundColor,
                child: Slider(
                  onChanged: controller.updateCircleRadius,
                  value: controller.sliderValue,
                  min: 0.05,
                  max: 1.5,
                ),
              ),
              Text('${controller.defaultRadius.toInt()} Squre Meter'),
              // Current Lat ln
              _BottomLatLn(
                currentLat: controller.currentLat,
                currentLon: controller.currentLon,
                onForwardButton: () {},
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BottomLatLn extends StatelessWidget {
  const _BottomLatLn({
    Key? key,
    required this.currentLat,
    required this.currentLon,
    required this.onForwardButton,
  }) : super(key: key);

  final double currentLat;
  final double currentLon;
  final void Function() onForwardButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Latitude: $currentLat'),
              Text('Longitude: $currentLon'),
            ],
          ),
          CircleIconButton(
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
            onTap: onForwardButton,
          )
        ],
      ),
    );
  }
}
