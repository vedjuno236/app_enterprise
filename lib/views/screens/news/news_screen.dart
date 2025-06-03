import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/key_shared.dart';
import 'package:enterprise/components/poviders/dark_mode_provider/dark_mode_provider.dart';
import 'package:enterprise/components/poviders/news_provider/news_provider.dart';
import 'package:enterprise/components/poviders/users_provider/users_provider.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/components/utils/dialogs.dart';
import 'package:enterprise/views/screens/news/news_details_Screen.dart';
import 'package:enterprise/views/widgets/animation/animation_text_appBar.dart';
import 'package:enterprise/views/widgets/bottom_sheet_push/bottom_sheet_push.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_platform.dart';
import 'package:enterprise/views/widgets/shimmer/app_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../../../components/constants/colors.dart';
import '../../../components/constants/image_path.dart';
import '../../../components/constants/strings.dart';
import '../../../components/logger/logger.dart';
import '../../../components/utils/date_format_utils.dart';
import '../../widgets/appbar/appbar_widget.dart';
import '../../widgets/text_input/custom_text_filed.dart';

final isLoadingCProvider = StateProvider<bool>((ref) => false);

enum AppState {
  free,
  picked,
  cropped,
}

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  ScrollController? _scrollController;
  int limit = 50;
  int page = 1;
  bool isLoading = false;
  bool cancelled = false;

  AppState state = AppState.free;

  Future fetchNewsTypeApi() async {
    EnterpriseAPIService().callNewsType().then((value) {
      ref.watch(stateNewsProvider).setNewsTypeModels(value: value);
    });
  }

  Future fetchNew({typeID}) async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    EnterpriseAPIService()
        .callPaginationNews(
      typeID: typeID ?? 0,
      perPage: limit,
      currentPage: page,
      sorting: "date_desc",
    )
        .then((value) {
      if (!cancelled) {
        ref.watch(stateNewsProvider).setNewsPaginationModel(value: value);
      }
    }).catchError((onError) {
      debugPrint("onError fetchNews $onError");
      if (onError.runtimeType.toString() == 'DioError') {
        // errorDialogMsg(context: context, onError: onError);
      }
    }).whenComplete(() {
      if (mounted) {
        setState(() => isLoading = false);
      }
    });
  }

  @override
  void initState() {
    fetchNewsTypeApi();
    fetchNew();
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.position.atEdge) {
        if (_scrollController!.position.pixels == 0) {
          if (mounted) {
            setState(() {
              page--;
              fetchNew();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              page++;
              fetchNew();
            });
          }
        }
      }
    });

    super.initState();
  }

  void cancel() {
    cancelled = true;
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    if (int.parse(ref
            .watch(stateNewsProvider)
            .getNewsPaginationModel!
            .data!
            .currentPage
            .toString()) >
        1) {
      if (mounted) {
        setState(() {
          page--;
          fetchNew();
        });
      }
    }

    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (int.parse(ref
            .watch(stateNewsProvider)
            .getNewsPaginationModel!
            .data!
            .currentPage
            .toString()) <
        int.parse(ref
            .watch(stateNewsProvider)
            .getNewsPaginationModel!
            .data!
            .totalPages
            .toString())) {
      if (mounted) {
        setState(() {
          page++;
          fetchNew();
        });
      }
    }
    // print("_onLoading");
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 3,
      itemBuilder: (context, index) => _buildShimmerItem(),
    );
  }

  Widget _buildLoadingNull() {
    return SizedBox(
      height: SizeConfig.heightMultiplier * 7,
      child: AppShimmer(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          // Placeholder count
          itemBuilder: (context, index) {
            return Container(
              width: SizeConfig.widthMultiplier * 30,
              margin: const EdgeInsets.only(top: 10, right: 15),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: kTextWhiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      decoration: BoxDecoration(
        color: kTextWhiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppShimmer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 30,
                  color: kGary,
                ),
              ),
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 1),
            AppShimmer(
              child: Column(
                children: [
                  Container(
                    height: 12,
                    width: 100,
                    color: kGary,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 150,
                    color: kGary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();

  Future<void> createNew() async {
    final newProvider = ref.watch(stateNewsProvider);

    final String imagePath = newProvider.selectedBackgroundImage != null
        ? newProvider.selectedBackgroundImage!.path
        : "";

    final userProvider = ref.watch(stateUserProvider);

    final response = await EnterpriseAPIService().createNews(
        userID: userProvider.getUserModel!.data!.id ?? 0,
        title: titleController.text,
        description: descriptionController.text,
        link: linkController.text,
        image: imagePath,
        newTypeId: newProvider.dropdown);
    logger.d(response);

    await fetchNew();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = ref.watch(stateNewsProvider);
    final darkTheme = ref.watch(darkThemeProviderProvider);

    darkTheme.darkTheme
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light)
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    String? role = sharedPrefs.getStringNow(KeyShared.keyRole);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: const AppbarWidget(),
        title: AnimatedTextAppBarWidget(
          text: Strings.txtNews.tr,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(),
        ),
        actions: [
          if (role == "HR") ...[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Minimize Column height
                children: [
                  GestureDetector(
                    onTap: () {
                      widgetBottomSheetFormNews(context);
                    },
                    child: const CircleAvatar(
                      backgroundColor: kBack87,
                      radius: 16,
                      child: Icon(
                        Bootstrap.plus,
                        color: kTextWhiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              Builder(
                builder: (context) {
                  final newsTypeModel = newsProvider.getNewsTypeModel;

                  if (newsTypeModel == null) {
                    return Center(
                      child: _buildLoadingNull(),
                    );
                  }

                  if (newsTypeModel.data!.isEmpty) {
                    return const SizedBox();
                  }
                  final screenHeight = MediaQuery.of(context).size.height;
                  final responsiveHeight = screenHeight * 0.07;

                  return SizedBox(
                    height: responsiveHeight,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: newsTypeModel.data!.length,
                      itemBuilder: (context, index) {
                        final item = newsTypeModel.data![index];
                        final isSelected =
                            newsProvider.selectedIndex == item.id;

                        return GestureDetector(
                                onTap: () {
                                  newsProvider.selectedIndex = item.id ?? 0;
                                  setState(() {
                                    page = 1;
                                    fetchNew(typeID: item.id ?? 0);
                                  });
                                  logger.d(item.id);
                                },
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, right: 15),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: isSelected
                                            ? kYellowFirstColor
                                            : const Color(0xFFDADADA),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.network(
                                          item.image!,
                                          width:
                                              SizeConfig.imageSizeMultiplier *
                                                  7,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          item.nameType!.toLowerCase(),
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(),
                                        ),
                                      ],
                                    )))
                            .animate()
                            .fadeIn(duration: 900.ms, delay: 300.ms)
                            .shimmer(blendMode: BlendMode.srcOver, color: kGary)
                            .move(
                                begin: const Offset(-16, 0),
                                curve: Curves.easeOutQuad);
                      },
                    ),
                  )
                      .animate()
                      .scale(duration: 600.ms, alignment: Alignment.centerLeft);
                },
              ),
              const SizedBox(height: 10),
              newsProvider.getNewsPaginationModel == null
                  ? Expanded(child: Center(child: _buildLoadingGrid()))
                  : newsProvider.getNewsPaginationModel!.data!.items!.isEmpty
                      ? Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 100),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/no_noti.svg',
                                    width: 150,
                                    height: 150,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    ' ຍັງບໍ່ມີຂໍ້ມູນ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    2.2),
                                  )
                                ],
                              ),
                            ),
                          )
                      : Expanded(
                          child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            onLoading: _onLoading,
                            header: const WaterDropMaterialHeader(
                              backgroundColor: kYellowFirstColor,
                              color: kTextWhiteColor,
                            ),
                            footer: CustomFooter(
                              builder:
                                  (BuildContext context, LoadStatus? mode) {
                                Widget body;
                                if (mode == LoadStatus.idle) {
                                  body = const Text(Strings.txtPull);
                                } else if (mode == LoadStatus.loading) {
                                  body = const LoadingPlatformV1(
                                    color: kYellowColor,
                                  );
                                } else if (mode == LoadStatus.failed) {
                                  body = const Text(Strings.txtLoadFailed);
                                } else if (mode == LoadStatus.canLoading) {
                                  body = const Text(Strings.txtLoadMore);
                                } else {
                                  body = const Text(Strings.txtMore);
                                }
                                return SizedBox(
                                  height: 55.0,
                                  child: Center(child: body),
                                );
                              },
                            ),
                            child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: newsProvider
                                  .getNewsPaginationModel!.data!.items!.length,
                              itemBuilder: (context, index) {
                                final newsData = newsProvider
                                    .getNewsPaginationModel!
                                    .data!
                                    .items![index];

                                return Builder(builder: (context) {
                                  if (newsProvider
                                          .getNewsPaginationModel!.data ==
                                      null) {
                                    return const Text('ບໍ່ມີປະເພດຂ່າວສານ');
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NewsDetailsScreen(
                                                        news: newsData)));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Theme.of(context).canvasColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Theme.of(context).cardColor,
                                              blurRadius: 1.0,
                                              spreadRadius: 1.0,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Hero(
                                                tag: newsData.image!,
                                                child: CachedNetworkImage(
                                                  imageUrl: newsData.image!
                                                      .toString(),
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child: LoadingPlatformV1(),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                  width: double.infinity,
                                                ),
                                              ),
                                            ).animate().scaleXY(
                                                begin: 0,
                                                end: 1,
                                                delay: 400.ms,
                                                duration: 400.ms,
                                                curve: Curves.easeInOutCubic),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              newsData.title!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              newsData.description!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                            Divider(
                                              color: Colors.grey[300],
                                              thickness: 1,
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const CircleAvatar(
                                                  radius: 25,
                                                  backgroundImage: NetworkImage(
                                                      'https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg'),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'KingKunyar',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    Text(DateFormatUtil.formatA(
                                                        DateTime.parse(newsData
                                                            .createdAt!))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ).animate().scale(
                                          duration: 300.ms,
                                          alignment: Alignment.centerLeft),
                                    ),
                                  );
                                });
                              },
                            ),
                          ),
                        )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 500.ms)
                          .move(
                              begin: Offset(-16, 0), curve: Curves.easeOutQuad)
            ])),
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

      default:
        return {
          'color': Colors.blueAccent,
        };
    }
  }

  void widgetBottomSheetFormNews(BuildContext context) {
    final newsProvider = ref.watch(stateNewsProvider);
    return bottomSheetPushContainerForme(
      context: context,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'ສ້າງຂ່າວສານ',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: SizeConfig.textMultiplier * 2),
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close))
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'ຫົວຂໍ້ຂອງຂ່າວ',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: SizeConfig.textMultiplier * 1.9),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              controller: titleController,
              hintText: 'ຫົວຂໍ້'.tr,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'ລາຍລະອຽດ',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: SizeConfig.textMultiplier * 1.9),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              controller: descriptionController,
              maxLines: 3,
              hintText: Strings.txtDescription.tr,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'ລີ້ງຂ່າວ'.tr,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: SizeConfig.textMultiplier * 1.9),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              controller: linkController,
              hintText: 'ລີ້ງຂ່າວ'.tr,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'ເລືອກປະເພດຂ່າວ'.tr,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: SizeConfig.textMultiplier * 1.9),
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<int>(
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: kGary,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: kGary,
                    width: 1,
                  ),
                ),
              ),
              hint: Text(
                'ເລືອກປະເພດຂ່າວສານ',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: SizeConfig.textMultiplier * 1.9),
              ),
              dropdownColor: Theme.of(context).canvasColor,
              value: ref.watch(stateNewsProvider).dropdown,
              onChanged: (int? newValue) {
                ref.read(stateNewsProvider).dropdown = newValue;
              },
              items: newsProvider.getNewsTypeModel!.data!
                  .map<DropdownMenuItem<int>>((item) {
                return DropdownMenuItem<int>(
                  value: item.id,
                  child: Row(
                    children: [
                      Image.network(
                        item.image!,
                        width: SizeConfig.imageSizeMultiplier * 7,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        item.nameType.toString().toLowerCase(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 15,
            ),
            Text('ເລືອກຮູບພາບ'.tr,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 15)),
            const SizedBox(
              height: 15,
            ),
            Consumer(builder: (context, ref, child) {
              final newsProvider = ref.watch(stateNewsProvider);
              return InkWell(
                onTap: () {
                  ref.read(stateNewsProvider).pickBackgroundImageFromGallery();
                },
                child: IntrinsicHeight(
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: DashedBorder(
                        color: kGreyColor2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    width: SizeConfig.widthMultiplier * 100,
                    child: newsProvider.selectedBackgroundImage != null
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                File(
                                    newsProvider.selectedBackgroundImage!.path),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Strings.txtUploadImage.tr,
                                  style: GoogleFonts.notoSansLao(
                                    textStyle:
                                        Theme.of(context).textTheme.titleLarge,
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                  ),
                                ),
                                SizedBox(
                                    height: SizeConfig.heightMultiplier * 1),
                                Image.asset(
                                  ImagePath.iconIconImage,
                                  width: SizeConfig.widthMultiplier * 6,
                                  height: SizeConfig.heightMultiplier * 6,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              );
            }),
            const SizedBox(
              height: 20,
            ),
            Consumer(
              builder: (context, ref, child) {
                final isLoadingC = ref.watch(isLoadingCProvider);

                return SizedBox(
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 5,
                  child: ElevatedButton(
                    onPressed: () async {
                      ref.read(isLoadingCProvider.notifier).state = true;
                      await createNew().whenComplete(() {
                        ref.read(isLoadingCProvider.notifier).state = false;
                        context.pop();
                      });
                      newsProvider.clearForm();
                      titleController.clear();
                      descriptionController.clear();
                      linkController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: isLoadingC
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Strings.txtLoading.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontSize: SizeConfig.textMultiplier * 2,
                                      color: kBack,
                                    ),
                              ),
                            ],
                          )
                        : Center(
                            child: Text(
                              Strings.txtSubmitForm.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2.5,
                                  ),
                            ),
                          ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
