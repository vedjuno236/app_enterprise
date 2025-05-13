import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/poviders/home_provider/home_provider.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../components/constants/colors.dart';
import '../../../../components/router/router.dart';
import '../../../../components/services/api_service/enterprise_service.dart';
import '../../../../components/styles/size_config.dart';

class FunctionWidget extends ConsumerStatefulWidget {
  const FunctionWidget({super.key});

  @override
  ConsumerState<FunctionWidget> createState() => _FunctionWidgetState();
}

class _FunctionWidgetState extends ConsumerState<FunctionWidget> {
  final PageController _pageController = PageController();

  bool isloading = false;

  Future fetchMenuApi() async {
    setState(() {
      isloading = true;
    });
    EnterpriseAPIService().getMenu().then((value) {
      ref.watch(stateHomeProvider).setMenuModel(value: value);
    }).catchError((onError) {
      // errorDialog(onError: onError, context: context);
    }).whenComplete(() {
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMenuApi();
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = ref.watch(stateHomeProvider);
    const int itemsPerPage = 6;
    const int crossAxisCount = 3;
    final filterMenuList = menuProvider.getMenuModel?.data ?? [];
    final int totalPages = (filterMenuList.length / itemsPerPage).ceil();
    final currentPage = ref.watch(stateHomeProvider).pageIndex;
    final startIndex = currentPage * itemsPerPage;
    final endIndex = (currentPage + 1) * itemsPerPage;
    final itemsInCurrentPage = filterMenuList.sublist(
      startIndex,
      endIndex > filterMenuList.length ? filterMenuList.length : endIndex,
    );
    final int rows = (itemsInCurrentPage.length / crossAxisCount).ceil();

    final double containerHeight = (SizeConfig.heightMultiplier * rows * 10) +
        (SizeConfig.heightMultiplier * 11);
    // ref.listen(stateHomeProvider, (_, __) {
    //   _pageController.animateToPage(
    //     menuProvider.pageIndex,
    //     duration: const Duration(milliseconds: 300),
    //     curve: Curves.easeInOut,
    //   );
    // });
    return Container(
      height: containerHeight,
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).canvasColor,
            blurRadius: 1.0,
            spreadRadius: 1.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        // child: menuProvider.getMenuModel == null
        //     ? Shimmer.fromColors(
        //         baseColor: kGreyColor1,
        //         highlightColor: kGary,
        //         child: Container(
        //           height: containerHeight,
        //           width: double.infinity,
        //           padding: const EdgeInsets.only(bottom: 2),
        //           decoration: const BoxDecoration(
        //             color: kTextWhiteColor,
        //             boxShadow: [
        //               BoxShadow(
        //                 color: kTextWhiteColor,
        //                 blurRadius: 1.0,
        //                 spreadRadius: 1.0,
        //               ),
        //             ],
        //             borderRadius: BorderRadius.all(Radius.circular(20)),
        //           ),
        //         ),
        //       )
        //     : Column(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  ref.read(stateHomeProvider).pageIndex = index;
                  debugPrint("==> $index");
                },
                itemCount: totalPages,
                itemBuilder: (context, pageIndex) {
                  final startIndex = pageIndex * itemsPerPage;
                  final endIndex = (pageIndex + 1) * itemsPerPage;

                  final items = filterMenuList.sublist(
                    startIndex,
                    endIndex > filterMenuList.length
                        ? filterMenuList.length
                        : endIndex,
                  );

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 8.5,
                      childAspectRatio: 1,
                      crossAxisSpacing: 25,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];

                      var datatxt =
                          getItemColor(items[index].keyWord.toString());
                      String txt = datatxt['txt'];

                      return GestureDetector(
                        onTap: () {
                          onTapPage(context, item.keyWord!);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (menuProvider.getMenuModel == null ||
                                menuProvider.getMenuModel!.data == null)
                              Shimmer.fromColors(
                                baseColor: kGreyColor1,
                                highlightColor: kGary,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      radius: SizeConfig.heightMultiplier * 4,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          height:
                                              SizeConfig.heightMultiplier * 1,
                                          width:
                                              SizeConfig.widthMultiplier * 10,
                                          margin: const EdgeInsets.only(
                                            top: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: kTextWhiteColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            else
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      CircleAvatar(
                                        radius:
                                            SizeConfig.imageSizeMultiplier * 8,
                                        backgroundColor:
                                            Theme.of(context).cardColor,
                                        child: SizedBox(
                                          width: SizeConfig.widthMultiplier * 7,
                                          child: CachedNetworkImage(
                                            imageUrl: item.icon!,
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) =>
                                                const LoadingPlatformV1(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: SizeConfig.heightMultiplier * 1),
                                  Text(
                                    // item.menuName!,
                                    txt,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                totalPages,
                (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    margin: const EdgeInsets.symmetric(horizontal: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: currentPage == index
                          ? kYellowFirstColor
                          : const Color(0xFFEDEFF7),
                    ),
                    height: 8,
                    width: currentPage == index ? 20 : 7,
                    duration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> getItemColor(String keywrd) {
    switch (keywrd) {
      case "APPLYLEAVE":
        return {
          'color': const Color(0xFF3085FE),
          'txt': Strings.txtApplyeave.tr
        };
      case "POLICY":
        return {'color': const Color(0xFFF45B69), 'txt': Strings.txtPolicy.tr};
      case "PAYSLIPS":
        return {
          'color': const Color(0xFFF59E0B),
          'txt': Strings.txtPayslips.tr
        };
      case "CALENDAR":
        return {
          'color': const Color(0xFF23A26D),
          'txt': Strings.txtCalendar.tr
        };
      case "REQUEST OT":
        return {
          'color': const Color(0xFF23A26D),
          'txt': Strings.txtRequestOt.tr
        };
      case "EVENT":
        return {'color': const Color(0xFF23A26D), 'txt': Strings.txtEvent.tr};
      default:
        return {
          'color': Colors.blueAccent,
        };
    }
  }

  void onTapPage(BuildContext context, String keyword) {
    switch (keyword) {
      case 'APPLYLEAVE':
        // AnalyticsEventService().logAnalyticsEvent(
        //   eventName: Strings.txtLeave,
        //   eventParameter: Strings.txtLeave,
        // );
        GoRouter.of(context).push(PageName.applyLeavesScreenRoute);
        break;
      case 'POLICY':
        GoRouter.of(context).push(PageName.policiesScreensRoute);
        break;
      case 'INFORMATION':
        GoRouter.of(context).push(PageName.informationScreenRoute);
        break;
      case 'PAYSLIPS':
        GoRouter.of(context).push(PageName.paySlips);
        break;
      case 'REQUEST OT':
        GoRouter.of(context).push(PageName.requestOtScreen);
        break;
      case 'CALENDAR':
        GoRouter.of(context).push(PageName.calendarScreenRoute);
        break;
      case 'REQUEST':
        GoRouter.of(context).push(PageName.requestScreen);
        break;
      case 'REPORT':
        GoRouter.of(context).push(PageName.reportScreen);
        break;

      case 'MARKETPLACE':
        GoRouter.of(context).push(PageName.marketPlace);
        break;

      case 'EVENT':
        GoRouter.of(context).push(PageName.eventsScreens);
        break;
      default:
        debugPrint('Unknown keyword: $keyword');
        break;
    }
  }
}
