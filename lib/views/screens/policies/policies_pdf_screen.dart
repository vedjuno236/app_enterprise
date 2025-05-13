import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/poviders/policy_provider/policy_provider.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../components/constants/colors.dart';
import '../../../components/constants/image_path.dart';
import '../../../components/constants/strings.dart';
import '../../../components/services/api_service/enterprise_service.dart';
import '../../../components/styles/size_config.dart';

class PoliciesPdfScreen extends ConsumerStatefulWidget {
  final int? typeID;
  final String? typeName;

  const PoliciesPdfScreen(
      {super.key, required this.typeID, required this.typeName});

  @override
  ConsumerState<PoliciesPdfScreen> createState() => _PoliciesPdfScreenState();
}

class _PoliciesPdfScreenState extends ConsumerState<PoliciesPdfScreen> {
  Future fetchPolicy({required int typeID}) async {
    EnterpriseAPIService().callDetailsPolicy(typeID: typeID).then((value) {
      ref.read(statePolicyProvider).setPolicyModels(value: value);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPolicy(typeID: widget.typeID!);
  }

  @override
  Widget build(BuildContext context) {
    final policyProvider = ref.watch(statePolicyProvider);
    return Scaffold(
      appBar: AppBar(
        // iconTheme: const IconThemeData(color: kBack),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: Text(
          Strings.txtPolicy.tr,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
        ).animate().scaleXY(
            begin: 0,
            end: 1,
            delay: 500.ms,
            duration: 500.ms,
            curve: Curves.easeInOutCubic),
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      // appBar: AppBar(
      //   iconTheme: const IconThemeData(color: kBack),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //         colors: kYellowGradientAppbarColors,
      //       ),
      //     ),
      //   ),
      //   // systemOverlayStyle: SystemUiOverlayStyle.dark,
      //   title: Text(
      //     "${widget.typeName} ${Strings.txtPolicy.tr} ".toLowerCase(),
      //     style: Theme.of(context).textTheme.titleLarge!.copyWith(
      //           fontSize: SizeConfig.textMultiplier * 2,
      //         ),
      //   ),
      //   actions: [
      //     GestureDetector(
      //       onTap: () {},
      //       child: Padding(
      //         padding: const EdgeInsets.only(right: 20),
      //         child: Stack(
      //           clipBehavior: Clip.none,
      //           children: [
      //             Container(
      //               padding: const EdgeInsets.all(10),
      //               decoration: const BoxDecoration(
      //                 color: kTextBack,
      //                 shape: BoxShape.circle,
      //               ),
      //               child: Image.asset(ImagePath.iconComment),
      //             ),
      //             Positioned(
      //               right: 0,
      //               top: -4,
      //               child: Container(
      //                 padding: const EdgeInsets.all(4),
      //                 decoration: const BoxDecoration(
      //                   color: kRedColor,
      //                   shape: BoxShape.circle,
      //                 ),
      //                 child: const Text(
      //                   '',
      //                   style: TextStyle(
      //                     color: kYellowFirstColor,
      //                     fontSize: 12,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: policyProvider.getPolicyModel == null
          ? const Center(
              child: CupertinoActivityIndicator(
                radius: 25,
              ),
            )
          : policyProvider.getPolicyModel!.data!.isEmpty
              ? Center(child: Image.asset(ImagePath.imgIconCreateAcc))
              : ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: policyProvider.getPolicyModel!.data!.length,
                  itemBuilder: (context, index) {
                    final policy = policyProvider.getPolicyModel!.data![index];

                    return Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: policy.policyFile!,
                          fit: BoxFit.cover,
                        )
                      ],
                    );
                  },
                ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensures proper alignment
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                // Centers the content
                children: [
                  Image.asset(
                    ImagePath.iconLike,
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(height: 5), // Space between icon and label
                  Text('Like'), // Add label text
                ],
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ImagePath.iconComment,
                  width: 20,
                  height: 20,
                ),
                SizedBox(height: 5),
                Text('Comment'), // Add label text
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagePath.iconDownload,
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(height: 5),
                  const Text('Download'), // Add label text
                ],
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
