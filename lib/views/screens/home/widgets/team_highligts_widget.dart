import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/key_shared.dart';
import 'package:enterprise/components/helpers/shared_prefs.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/poviders/all_leave_provider/all_leave_provider.dart';
import 'package:enterprise/components/poviders/all_leave_provider/team_highligts_provider.dart';
import 'package:enterprise/components/poviders/leave_provider/leave_teamhighlights_provider/leave_teamhigh_provider.dart';
import 'package:enterprise/components/poviders/notifition_provider/notifition_provider.dart';
import 'package:enterprise/components/router/router.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../components/constants/strings.dart';

class TeamHighlightsWidget extends ConsumerStatefulWidget {
  const TeamHighlightsWidget({super.key});

  @override
  ConsumerState createState() => _ComingEventsWidgetState();
}

class _ComingEventsWidgetState extends ConsumerState<TeamHighlightsWidget> {
  bool isLoading = false;
  SharedPrefs sharedPrefs = SharedPrefs();

  Future fetchAllleave() async {
    DateTime now = DateTime.now();
    String formattedNow = DateFormat('yyyy-MM-dd').format(now);
    setState(() {
      isLoading = true;
    });
    EnterpriseAPIService()
        .callAllLeave(
          startdate: formattedNow,
          enddate: formattedNow,
        )
        .then((value) {
          ref
              .watch(stateTeamHighligtsProvider)
              .setteamHighligtsLeaveModel(value: value);
        })
        .catchError((onError) {})
        .whenComplete(() => setState(() {
              isLoading = false;
            }));
  }

  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  Widget _buildAvatar(String? profileUrl, double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).canvasColor,
      child: CircleAvatar(
        radius: radius - 0.5,
        backgroundImage:
            _isValidImageUrl(profileUrl) ? NetworkImage(profileUrl!) : null,
        child: !_isValidImageUrl(profileUrl)
            ? Icon(
                Icons.person,
                size: radius * 1.2,
                color: Colors.grey[600],
              )
            : null,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchAllleave();
  }

  @override
  Widget build(BuildContext context) {
    final nallleaveProvider = ref.watch(stateTeamHighligtsProvider);
    final nallleavedata =
        nallleaveProvider.getTeamHighligtsModelLeaveModel?.data ?? [];
    return Container(
      width: double.infinity,
      height: SizeConfig.heightMultiplier * 19,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).cardColor,
            blurRadius: 1.0,
            spreadRadius: 1.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: const BoxDecoration(
                    color: kYellowFirstColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          nallleavedata.length.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 3),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.widthMultiplier * 4),
                Expanded(
                  child: Text(
                    Strings.txtPeoplefrom.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: SizeConfig.textMultiplier * 1.9),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Color(0xFFF3F3F3),
              thickness: 1.0,
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0;
                                i <
                                    (nallleavedata.length > 3
                                        ? 3
                                        : nallleavedata.length);
                                i++)
                              Align(
                                widthFactor: 0.6,
                                child: _buildAvatar(
                                  nallleavedata[i].profile?.toString(),
                                  SizeConfig.heightMultiplier * 2.5,
                                ),
                              ),
                            if (nallleavedata.length > 3)
                              Align(
                                widthFactor: 0.6,
                                child: CircleAvatar(
                                    radius: SizeConfig.heightMultiplier * 2,
                                    backgroundColor: kYellowColor,
                                    child: Text(
                                      '+${(nallleavedata.length - 3).toString()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      1.9,
                                              color: kTextWhiteColor),
                                    )),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      context.push(PageName.onLeaveRoute);
                    },
                    child: Row(
                      children: [
                        Text(
                          Strings.txtSeeAll.tr,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2,
                                  ),
                        ),
                        const Icon(
                          Icons.arrow_right,
                        )
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
