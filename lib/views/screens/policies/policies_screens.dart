import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/router/router.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/components/utils/dialogs.dart';
import 'package:enterprise/views/widgets/appbar/appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../components/constants/colors.dart';
import '../../../components/constants/image_path.dart';
import '../../../components/constants/strings.dart';
import '../../../components/poviders/policy_provider/policy_provider.dart';
import '../../../components/styles/size_config.dart';

class PoliciesScreens extends ConsumerStatefulWidget {
  const PoliciesScreens({super.key});

  @override
  ConsumerState createState() => _PoliciesScreensState();
}

class _PoliciesScreensState extends ConsumerState<PoliciesScreens> {
  bool isLoading = false;
  Future fetchPolicyTypeApi() async {
    setState(() {
      isLoading = true;
    });
    EnterpriseAPIService().callPolicy().then((value) {
      ref.watch(statePolicyProvider).setPolicyTypeModels(value: value);
    }).catchError((onErrror) {
      errorDialog(onError: onErrror, context: context);
    }).whenComplete(() => setState(() {
          isLoading = false;
        }));
  }

  @override
  void initState() {
    super.initState();
    fetchPolicyTypeApi();
  }

  Widget _buildShimmerItem() {
    return Container(
      decoration: BoxDecoration(
        color: kTextWhiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: kTextWhiteColor,
            offset: Offset(0, 1),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfig.heightMultiplier * 1),
          Shimmer.fromColors(
            baseColor: kGreyColor1,
            highlightColor: kGary,
            child: const CircleAvatar(
              radius: 40,
              backgroundColor: kTextWhiteColor,
            ),
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1),
          Shimmer.fromColors(
            baseColor: kGreyColor1,
            highlightColor: kGary,
            child: Container(
              width: SizeConfig.widthMultiplier * 20,
              height: SizeConfig.heightMultiplier * 1,
              decoration: BoxDecoration(
                color: kTextWhiteColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    final policyProvider = ref.watch(statePolicyProvider);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: policyProvider.getPolicyTypeModel?.data?.length ?? 0,
      itemBuilder: (context, index) => _buildShimmerItem(),
    );
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Builder(
          builder: (context) {
            final policyData = policyProvider.getPolicyTypeModel?.data;

            if (policyData == null) {
              return _buildLoadingGrid();
            }
            if (policyData.isEmpty) {
              return Center(child: Image.asset(ImagePath.imgIconCreateAcc));
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: policyProvider.getPolicyTypeModel!.data!.length,
              itemBuilder: (context, index) {
                final category =
                    policyProvider.getPolicyTypeModel!.data![index];

                return GestureDetector(
                  onTap: () {
                    context.push(
                      PageName.policiesPdfScreenRoute,
                      extra: {
                        'typeId': category.id,
                        'typeName': category.typeName
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).canvasColor,
                          offset: Offset(0, 1),
                          blurRadius: 2.0,
                        ),
                      ],
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: SizeConfig.heightMultiplier * 1),
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: kGary,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: CachedNetworkImage(
                              imageUrl: category.logo!,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CupertinoActivityIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.heightMultiplier * 1),
                        Text(
                          category.typeName!.toLowerCase(),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2,
                                  ),
                        ),
                      ],
                    ),
                  ).animate().scaleXY(
                      begin: 0,
                      end: 1,
                      delay: 800.ms,
                      duration: 800.ms,
                      curve: Curves.easeInOutCubic),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
