class User {
  String id;
  String name;
  String profilePictureUrl;
  String grade;
  int attendanceCount;

  User({required this.id, required this.name, required this.profilePictureUrl, required this.grade, required this.attendanceCount});
}

class Attendance {
  String userId;
  DateTime date;
  bool isPresent;

  Attendance({required this.userId, required this.date, required this.isPresent});
}

class LeaveRequest {
  String userId;
  DateTime fromDate;
  DateTime toDate;
  String reason;
  String status;

  LeaveRequest({required this.userId, required this.fromDate, required this.toDate, required this.reason, required this.status});
}
