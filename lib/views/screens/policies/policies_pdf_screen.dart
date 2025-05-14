import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/poviders/policy_provider/policy_provider.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

import '../../../components/constants/image_path.dart';
import '../../../components/constants/strings.dart';
import '../../../components/services/api_service/enterprise_service.dart';
import 'package:flutter/services.dart' show NetworkAssetBundle, Uint8List;

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
          style: Theme.of(context).textTheme.titleLarge!.copyWith(),
        ).animate().scaleXY(
            begin: 0,
            end: 1,
            delay: 500.ms,
            duration: 500.ms,
            curve: Curves.easeInOutCubic),
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
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
                    final fileUrl = policy.policyFile!;
                    final fileExtension = fileUrl.split('.').last.toLowerCase();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (fileExtension == 'pdf') ...[
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 100,
                            child: FutureBuilder<Uint8List>(
                              future: NetworkAssetBundle(Uri.parse(fileUrl))
                                  .load(fileUrl)
                                  .then((byteData) =>
                                      byteData.buffer.asUint8List()),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: LoadingPlatformV2(
                                    size: 100,
                                  ));
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text(
                                    'ບໍ່ມີຂໍ້ມູນ',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ));
                                } else {
                                  final bytes = snapshot.data!;
                                  final document = PdfDocument.openData(bytes);
                                  final controller =
                                      PdfControllerPinch(document: document);

                                  return PdfViewPinch(controller: controller);
                                }
                              },
                            ),
                          ),
                        ] else if (['jpg', 'jpeg', 'png', 'webp']
                            .contains(fileExtension)) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: fileUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ] else ...[
                          Center(
                              child: Text(
                            'ບໍ່ມີຂໍ້ມູນ',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ))
                        ],
                      ],
                    );
                  }),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: const Color(0xFFF1F1F1),
        backgroundColor: Theme.of(context).cardColor,

        type: BottomNavigationBarType.fixed,

        unselectedLabelStyle: TextStyle(
          fontSize: SizeConfig.textMultiplier * 1.8,
        ),
        selectedLabelStyle: TextStyle(
          fontSize: SizeConfig.textMultiplier * 1,
          fontWeight: FontWeight.bold,
        ),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ImagePath.iconLike,
                  color: Theme.of(context).iconTheme.color,
                  height: SizeConfig.imageSizeMultiplier * 6,
                  width: SizeConfig.imageSizeMultiplier * 6,
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ImagePath.iconComment,
                  color: Theme.of(context).iconTheme.color,
                  height: SizeConfig.imageSizeMultiplier * 6,
                  width: SizeConfig.imageSizeMultiplier * 6,
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ImagePath.iconDownload,
                  color: Theme.of(context).iconTheme.color,
                  height: SizeConfig.imageSizeMultiplier * 6,
                  width: SizeConfig.imageSizeMultiplier * 6,
                ),
              ],
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
