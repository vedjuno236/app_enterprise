enum ApiPath {
  login,
  usersInfos,
  newsType,
  newsAll,
  news,
  newsPagination,
  createNews,
  policy,
  policyType,
  location,
  attendance,
  leaveType,
  createLeave,
  analyticAttendance,
  attendanceMonth,
  menu,
  department,
  allLeaveHistory,
  notification,
  updateleavenoti,
  notificationUser,
  updateProfile,
}

class APIPathHelper {
  static String getValue(ApiPath path) {
    switch (path) {
      case ApiPath.login:
        return "/api/sign-in";
      case ApiPath.usersInfos:
        return "/api/auth/get-infos";
      case ApiPath.newsType:
        return "/api/get-all-news-type";
      case ApiPath.newsAll:
        return "/api/get-all-news";
      case ApiPath.news:
        return "/api/filter-news-by-new-type";
      case ApiPath.createNews:
        return "/api/create-news";
      case ApiPath.newsPagination:
        return "/api/get-news-pagination";
      case ApiPath.policyType:
        return "/api/get-all-type-policy";
      case ApiPath.policy:
        return "/api/filter-by-type-policy";
      case ApiPath.location:
        return "/api/get-lat-long";
      case ApiPath.attendance:
        return "/api/create-attendance";
      case ApiPath.leaveType:
        return "/api/get-by-user-type-leave";
      case ApiPath.createLeave:
        return "/api/create-leave";
      case ApiPath.allLeaveHistory:
        return "/api/get-leave-for-one-user";
      case ApiPath.notification:
        return "/api/auth/get-leave-for-approved";
      case ApiPath.notificationUser:
        return "/api/get-leave-response-status";
      case ApiPath.updateleavenoti:
        return "/api/auth/update-leave";
      case ApiPath.analyticAttendance:
        return "/api/overview-attendance-month";
      case ApiPath.attendanceMonth:
        return "/api/filter-by-month-attendance";
      case ApiPath.menu:
        return "/api/menu-client-get";
      case ApiPath.department:
        return "/api/get-department";
      case ApiPath.updateProfile:
        return "/web/update-profile";
      default:
        return "";
    }
  }
}
