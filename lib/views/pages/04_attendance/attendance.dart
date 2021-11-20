import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../controllers/spaces/space_controller.dart';
import '../08_spaces/space_add.dart';
import '../../widgets/app_button.dart';
import 'user_list.dart';
import '../07_settings/settings.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../themes/text.dart';
import 'drop_down_row.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      color: context.theme.canvasColor,
      child: SafeArea(
        child: Column(
          children: [
            /* <---- Header ----> */
            const _HeaderMainPage(),
            /* <---- Attendance List -----> */
            GetBuilder<SpaceController>(
              builder: (controller) {
                if (controller.isFetchingSpaces) {
                  return const LoadingMembers();
                } else if (controller.allSpaces.isEmpty) {
                  return const _NoSpaceFound();
                } else {
                  return Expanded(
                    child: Column(
                      children: const [
                        /* <---- DropDown and Date----> */
                        DropDownRow(),

                        /* <---- User List ----> */
                        AttendedUserList()
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderMainPage extends StatelessWidget {
  const _HeaderMainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: Get.height * 0.1,
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        boxShadow: AppDefaults.defaultBoxShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /* <---- Left Side ----> */
          Row(
            children: [
              Hero(
                tag: AppImages.mainLogo,
                child: Image.asset(
                  AppImages.mainLogo2,
                  width: Get.width * 0.13,
                ),
              ),
              AppSizes.wGap5,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Turing Tech',
                    style: AppText.b2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Face Attendance App',
                    style: AppText.caption,
                  )
                ],
              ),
            ],
          ),
          /* <---- Right Side ----> */
          // ADMIN PROFILE PICTURE
          const _UserProfilePicture(),
        ],
      ),
    );
  }
}

class _UserProfilePicture extends StatelessWidget {
  const _UserProfilePicture({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppUserController>(
      builder: (controller) {
        if (controller.isUserInitialized == false) {
          return Shimmer.fromColors(
            baseColor: AppColors.shimmerBaseColor,
            highlightColor: AppColors.shimmerHighlightColor,
            child: CircleAvatar(
                backgroundImage: const AssetImage(
                  AppImages.deafaultUser,
                ),
                radius: Get.width * 0.07),
          );
        } else if (controller.isUserInitialized == true) {
          return InkWell(
            onTap: () {
              Get.to(() => const AdminSettingScreen());
            },
            child: Hero(
              tag: controller.currentUser.userID!,
              child: controller.currentUser.userProfilePicture != null
                  ? CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        controller.currentUser.userProfilePicture!,
                      ),
                      radius: Get.width * 0.07,
                    )
                  : CircleAvatar(
                      backgroundImage: const AssetImage(AppImages.deafaultUser),
                      radius: Get.width * 0.07),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _NoSpaceFound extends StatelessWidget {
  const _NoSpaceFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: Get.width * 0.5,
              child: Image.asset(AppImages.illustrationSpaceEmpty),
            ),
            AppSizes.hGap20,
            const Text('No space found..'),
            AppButton(
              width: Get.width * 0.5,
              prefixIcon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: 'Create Space',
              onTap: () {
                Get.to(() => const SpaceCreateScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
