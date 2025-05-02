import 'package:enterprise/components/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/styles/size_config.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  final Function onCameraTap;
  final Function onGalleryTap;

  const ImagePickerBottomSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.heightMultiplier * 12,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'ກະລຸນາເລືອກຮຸບພາບຂອງທ່ານ',
                    style: GoogleFonts.notoSansLao(
                      textStyle:
                          Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontSize: SizeConfig.textMultiplier * 2,
                              ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => onCameraTap(),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          color: kYellowFirstColor,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'ກ້ງຖ່າຍຮູບ',
                          style: GoogleFonts.notoSansLao(
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 2,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => onGalleryTap(),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.image_outlined,
                          color: kYellowFirstColor,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'ຄັງຮູບ',
                          style: GoogleFonts.notoSansLao(
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 2,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
//

// Future<void> bottomSheetPushContainer({
//   BuildContext? context,
//   Widget? child,
//   double? constantsSize,
//   double? height,
//   bool? isScrollControlled = false,
// }) {
//   return showModalBottomSheet(
//     isScrollControlled: isScrollControlled!,
//     backgroundColor: Colors.transparent,
//     context: context!,
//     builder: (context) => Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: const [BoxShadow(color: kYellowFirstColor, blurRadius: 10)],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: child,
//     ),
//   );
// }


Future<void> bottomSheetPushContainer({
  BuildContext? context,
  Widget? child,
  double? constantsSize,
  double? height,
  bool? isScrollControlled = false,
}) {
  return showModalBottomSheet(
    isScrollControlled: isScrollControlled!,
    backgroundColor: Colors.transparent,
    context: context!,
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: kPrimaryColor.shade50, blurRadius: 10)],
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    ),
  );
}

void bottomSheetPushContainerForme({
  required BuildContext context,
  required Widget child,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: child,
          );
        },
      );
    },
  );
}

void bottomSheetPushContainerFormeOT({
  required BuildContext context,
  required Widget child,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: child,
          );
        },
      );
    },
  );
}
