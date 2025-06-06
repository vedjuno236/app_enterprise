import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enterprise/components/utils/api_path.dart';

import '../../logger/logger.dart';
import '../../utils/api_base.dart';

class EnterpriseAPIService {
  late Response response;
  late Dio? _dio;

  EnterpriseAPIService() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiBase.baseURL,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
    );
    _dio = Dio(options);
  }

  ///Login API
  Future loginAPI({phone, password, deviceToken}) async {
    String url = APIPathHelper.getValue(ApiPath.login);

    Map body = {
      'phone': phone,
      'password': password,
      'device_token': deviceToken,
    };

    response = await _dio!.post(url,
        data: body,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));
    return response.data;
  }

  /// call location API
  Future callLocationAPI() async {
    String url = APIPathHelper.getValue(ApiPath.location);

    response = await _dio!.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));

    return response.data;
  }

  ///Call UserInfos API
  Future callUserInfos({required token}) async {
    String url = APIPathHelper.getValue(ApiPath.usersInfos);

    response = await _dio!.post(
      url,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    return response.data;
  }

  // edit
  Future profileUpdate(
    File file, {
    required userId,
  }) async {
    if (!file.existsSync()) {
      throw Exception('File does not exist at ${file.path}');
    }

    final uri = APIPathHelper.getValue(ApiPath.updateProfile);

    final fileName = file.path.split('/').last;

    final formData = FormData.fromMap({
      "Profile": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "UserID": userId,
    });
    try {
      final response = await _dio!.post(
        uri,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      logger.d(response);
      return response.data;
    } catch (e) {
      logger.e(e);

      rethrow;
    }
  }

  /// Clock in Out API

  Future saveAttendanceData({
    required String type,
    required int userID,
    required double latitude,
    required double longitude,
    required String createdAt,
    String? imagePath,
    required String title,
  }) async {
    String url = APIPathHelper.getValue(ApiPath.attendance);

    if (_dio == null) {
      throw Exception("Dio instance is not initialized");
    }

    FormData formData = FormData.fromMap({
      'UserID': userID,
      'Type': type,
      'Latitude': latitude,
      'Longitude': longitude,
      'Title': title,
      'CreatedAt': createdAt
    });

    if (imagePath != null && imagePath.isNotEmpty) {
      MultipartFile imageFile =
          await MultipartFile.fromFile(imagePath, filename: "image.jpg");
      formData.files.add(MapEntry('Image', imageFile));
    }
    Response response = await _dio!.post(
      url,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  /// call analytic_attendance

  Future callAnalyticAttendance({userID, month, perPage, currentPage}) async {
    String url = APIPathHelper.getValue(ApiPath.analyticAttendance);

    Map body = {
      'user_id': userID,
      'month': month,
      'per_page': perPage,
      'current_page': currentPage,
    };
    response = await _dio!.post(
      url,
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  Future callAnalyticAttendanceMonth(
      {userID, month, perPage, currentPage}) async {
    String url = APIPathHelper.getValue(ApiPath.attendanceMonth);

    Map body = {
      'user_id': userID,
      'month': month,
      'per_page': perPage,
      'current_page': currentPage,
    };
    response = await _dio!.post(
      url,
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  /// getFunctionMenu

  Future getMenu() async {
    String url = APIPathHelper.getValue(ApiPath.menu);

    response = await _dio!.post(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return response.data;
  }

  ///Edit profile API

  /// Call News  API

  Future callNewsType() async {
    String url = APIPathHelper.getValue(ApiPath.newsType);

    response = await _dio!.post(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  /// Call News  Details API

  Future callDetailsNews({typeID}) async {
    String url = APIPathHelper.getValue(ApiPath.news);

    Map body = {'new_type_id': typeID};
    response = await _dio!.post(
      url,
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  ///

  Future callPaginationNews(
      {required typeID,
      required perPage,
      required currentPage,
      required,
      required sorting}) async {
    String url = APIPathHelper.getValue(ApiPath.newsPagination);

    Map body = {
      'news_type_id': typeID,
      'per_page': perPage,
      'current_page': currentPage,
      'sorting': sorting,
    };
    response = await _dio!.post(
      url,
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  Future callAllNews() async {
    String url = APIPathHelper.getValue(ApiPath.newsAll);

    response = await _dio!.post(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  Future createNews({
    userID,
    newTypeId,
    title,
    description,
    link,
    image,
  }) async {
    String url = APIPathHelper.getValue(ApiPath.createNews);

    if (_dio == null) {
      throw Exception("Dio instance is not initialized");
    }

    try {
      Map<String, dynamic> formDataMap = {
        "UserID": userID,
        "NewsTypeID": newTypeId,
        "Title": title,
        "Description": description,
        "Link": link,
      };

      if (image != null && image.isNotEmpty) {
        formDataMap['Image'] =
            await MultipartFile.fromFile(image, filename: "image.jpg");
      }

      FormData formData = FormData.fromMap(formDataMap);

      Response response = await _dio!.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      logger.d(response.data);
      return response.data;
    } catch (e) {
      logger.e('Error createNew: $e');
      throw Exception('Failed to createNew');
    }
  }

  /// Call Policy API
  Future callPolicy() async {
    String url = APIPathHelper.getValue(ApiPath.policyType);

    response = await _dio!.post(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  /// Call Policy Details API
  Future callDetailsPolicy({typeID}) async {
    String url = APIPathHelper.getValue(ApiPath.policy);
    Map body = {'policy_type_id': typeID};
    response = await _dio!.post(
      url,
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    // logger.d(response.data);
    return response.data;
  }

  ///call LeaveType
  Future callLeaveType({userID}) async {
    String url = APIPathHelper.getValue(ApiPath.leaveType);

    Map body = {'user_id': userID};

    response = await _dio!.post(
      url,
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  /// createLeave
  Future createLeave({
    userID,
    leaveTypeId,
    startDate,
    endDate,
    note,
    document,
  }) async {
    String url = APIPathHelper.getValue(ApiPath.createLeave);

    if (_dio == null) {
      throw Exception("Dio instance is not initialized");
    }

    try {
      Map<String, dynamic> formDataMap = {
        "UserID": userID,
        "LeaveTypeID": leaveTypeId,
        "StartDate": startDate,
        "EndDate": endDate,
        "Reason": note,
      };

      if (document != null && document.isNotEmpty) {
        formDataMap['Document'] =
            await MultipartFile.fromFile(document, filename: "image.jpg");
      }

      FormData formData = FormData.fromMap(formDataMap);

      Response response = await _dio!.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      logger.d(response.data);
      return response.data;
    } catch (e) {
      logger.e('Error createLeave: $e');
      throw Exception('Failed to createLeave');
    }
  }

  Future callAllLeaveHistory({
    required UserId,
    required LeaveTypeID,
    required Status,
    required start_date,
    required end_date,
  }) async {
    String url = APIPathHelper.getValue(ApiPath.allLeaveHistory);

    Map body = {
      'user_id': UserId,
      'leave_type_id': LeaveTypeID,
      'status': Status,
      "start_date": start_date,
      "end_date": end_date,
    };
    response = await _dio!.post(
      url,
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  Future callAllLeave({
    required startdate,
    required enddate,
  }) async {
    String url = APIPathHelper.getValue(ApiPath.allLeave);

    Map body = {
      'start_date': startdate,
      "end_date": enddate,
    };
    response = await _dio!.post(
      url,
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  ///call LeaveType
  Future callDepartment() async {
    String url = APIPathHelper.getValue(ApiPath.department);

    response = await _dio!.post(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  Future callNotification({
    required token,
    required start_date,
    required end_date,
  }) async {
    String url = APIPathHelper.getValue(ApiPath.notification);
    Map body = {
      'start_date': start_date,
      'end_date': end_date,
    };
    response = await _dio!.post(
      url,
      data: body,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    return response.data;
  }

  Future callNotificationUser({
    required userid,
  }) async {
    String url = APIPathHelper.getValue(ApiPath.notificationUser);
    Map body = {
      'user_id': userid,
    };
    response = await _dio!.post(
      url,
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return response.data;
  }

  Future updateLeaveNoti(
      {required int id,
      required String status,
      required String comment,
      required token}) async {
    String url = APIPathHelper.getValue(ApiPath.updateleavenoti);

    if (_dio == null) {
      throw Exception("Dio instance is not initialized");
    }

    try {
      Map<String, dynamic> data = {
        "id": id,
        "status": status,
        "comment": comment,
      };

      Response response = await _dio!.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data;
    } catch (e) {
      logger.e('Error updateLeaveNoti: $e');
      throw Exception('Failed to updateLeaveNoti');
    }
  }

    Future cllbooleancheckInOut({
    required userid,
  }) async {
    String url = APIPathHelper.getValue(ApiPath.checkbooleaninout);
    Map body = {
      'user_id': userid,
    };
    response = await _dio!.post(
      url,
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return response.data;
  }

}
