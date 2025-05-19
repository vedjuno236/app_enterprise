import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/poviders/policy_provider/policy_provider.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class PoliciesPdfScreen extends ConsumerStatefulWidget {
  final int? typeID;
  final String? typeName;

  const PoliciesPdfScreen(
      {super.key, required this.typeID, required this.typeName});

  @override
  ConsumerState<PoliciesPdfScreen> createState() => _PoliciesPdfScreenState();
}

class _PoliciesPdfScreenState extends ConsumerState<PoliciesPdfScreen> {
  bool _isLoading = false;
  Map<String, String> _localFilePaths = {};

  Future fetchPolicy({required int typeID}) async {
    EnterpriseAPIService().callDetailsPolicy(typeID: typeID).then((value) {
      ref.read(statePolicyProvider).setPolicyModels(value: value);
      _downloadFiles();
    });
  }

  Future<void> _downloadFiles() async {
    final policyProvider = ref.read(statePolicyProvider);
    if (policyProvider.getPolicyModel == null ||
        policyProvider.getPolicyModel!.data == null ||
        policyProvider.getPolicyModel!.data!.isEmpty) {
      return;
    }

    setState(() => _isLoading = true);

    for (var policy in policyProvider.getPolicyModel!.data!) {
      if (policy.policyFile != null && policy.policyFile!.isNotEmpty) {
        final fileUrl = policy.policyFile!;
        final fileExtension = path.extension(fileUrl).toLowerCase();

        if (fileExtension == '.pdf') {
          try {
            final response = await http.get(Uri.parse(fileUrl));
            final directory = await getApplicationDocumentsDirectory();
            final fileName =
                '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
            final filePath = path.join(directory.path, fileName);
            final file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);
            _localFilePaths[fileUrl] = filePath;
          } catch (e) {
            print("Error downloading file: $e");
          }
        }
      }
    }

    setState(() => _isLoading = false);
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: Text(
          Strings.txtPolicy.tr,
          style: Theme.of(context).textTheme.titleLarge,
        ).animate().scaleXY(
            begin: 0,
            end: 1,
            delay: 500.ms,
            duration: 500.ms,
            curve: Curves.easeInOutCubic),
      ),
      body: policyProvider.getPolicyModel == null || _isLoading
          ? const Center(child: LoadingPlatformV2(size: 60))
          : policyProvider.getPolicyModel!.data!.isEmpty
              ? Center(child: Image.asset(ImagePath.imgIconCreateAcc))
              : PageView.builder(
                  itemCount: policyProvider.getPolicyModel!.data!.length,
                  itemBuilder: (context, index) {
                    final policy = policyProvider.getPolicyModel!.data![index];
                    final fileUrl = policy.policyFile ?? '';
                    final fileExtension = path.extension(fileUrl).toLowerCase();

                    if (fileExtension == '.pdf') {
                      if (!_localFilePaths.containsKey(fileUrl)) {
                        return Center(
                          child: Text(
                            'ກໍາລັງໂຫລດ PDF...',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PDFView(
                          filePath: _localFilePaths[fileUrl],
                          enableSwipe: true,
                          swipeHorizontal: false,
                          autoSpacing: true,
                          pageFling: true,
                          onError: (error) => print("PDF Error: $error"),
                          onPageError: (page, error) =>
                              print("PDF Page Error: $page, $error"),
                        ),
                      );
                    } else if (['.jpg', '.jpeg', '.png', '.webp']
                        .contains(fileExtension)) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: fileUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) =>
                                LoadingPlatformV2(size: 60),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          'ບໍ່ຮອງຮັບບຮູບແບບ',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }
                  },
                ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).cardColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              ImagePath.iconLike,
              color: Theme.of(context).iconTheme.color,
              height: SizeConfig.imageSizeMultiplier * 6,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              ImagePath.iconComment,
              color: Theme.of(context).iconTheme.color,
              height: SizeConfig.imageSizeMultiplier * 6,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              ImagePath.iconDownload,
              color: Theme.of(context).iconTheme.color,
              height: SizeConfig.imageSizeMultiplier * 6,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
