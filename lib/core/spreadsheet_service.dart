import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gsheets/gsheets.dart';

class SpreadSheetService {
  static const _cre = r'''
  {
    "type": "service_account",
    "project_id": "ieee-fsb-hr",
    "private_key_id": "c3570842e64d492f3162434b2337d3052ac3e1ca",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDPBc62axpMW7sz\n/vmWICDK5eEDUmkBeLJHcM5M1uvKlk8nHfgefg6oLeXpc95KeOaTUE4vYInUxpQY\nXbwvKGgW88jPn1dYqPoFNnsNejksqL/xQH3EHO+XsRg+w9OahLES6+MU42Q+vtHx\nw+BhqGqG4uiX+OyeGPjJIRNDfb6lxlAgYPTkHysw90an774juq3I1JqQ6nzrQSWl\n3/j66GRYA0+g6Mfkc7sO7ior7jnIjMo342V95XCny8pK8Z6WMhE7sHX0tsB//1Py\nAW7WTFRGaMDdtJ302gVYVIlyJTBXBWh/LMA+oCWQ9W0WBKHvGU44pWZEKaiOWb1J\nkCSL19TRAgMBAAECggEABhTTF4Zk6DT89lA5T7Yo5ceZSQoyMyIIW/3jKYcEt9eb\ngqLS55O8utGtAnhuDBJUyk4JG0OC46u5AlA6l3NglLqw6EceKei+KMoKv6tv+Nu0\n1mbrwDI4vY7XufxG/9qBrcnHyr91RzyUGT3aSQlz+6YNvsJyskrkgAVci1aAc7PR\nOpk4grI1MBcyY5yqAHXc/7+5GJydFbG5dU5qaGLRZ7tvC61wOLFYLf1RLZOgtBOq\nQag5YCJ66K4ycxbMfcUDpco8MPAsnuyl8gvanDjkuY87YWZZhTO5B5u2SmknT29i\n+4KvgOXtEz+ynFdn2QXJ6M2VoEFd/EdNmTMN+gbIWQKBgQD87HmHFZ0zElBTs+Et\nSsRp1UAGxf61+chLBRwosc7ZGo7LQn6pwUgSpfFpiVgX8AVnjjiW6Z6u3jAcgcPf\nA8K8YmhFMCvjI2nP8t3FFXyW4mK6Lt10Ibx7GdL9N00l5MPpa5Fey2ob17qonKcV\nji/dTNdk3ZtYquzIubN4ZCgGTQKBgQDRimlJg/ImRFJbblfMSwz8y2/Dgi18NuN1\nOuZ4NzTrmKdG2lPhQvFjITmtY9Nf37RxIuvZi9oFhGcGgkq57wHb+leNOqosLkuC\nh7tYXK4xVFaSqp8DlluK0hlO9MXy64aFiiHcgfsRH/Bi6MCcsyOa0X+gN4Fyqg15\nHbRQK2XSlQKBgQDbUzkjchPKmOP9YawvuXlPiTQna4SwSzVsELdVdrM3wvb2vefW\nzxvvx+TrrsUspOAa59Kc02PeoiA4aDLxbnJtKCzhap90LV5xjFrRsAtFUHVqnH8/\nWI34dfFn0Y/d/14ASV5bRKv0DwP3eTjO0WkiT6Ms/ZrbrgT9H0PJb5jhtQKBgQCq\nK1TcHiq+Rwf3NsJYp66Rcgl+5i5YTR8l6kKW6IayulNG6DHso3fzgF0d4g8cMkmR\nA8Iz9y6FAoTEtXVIUMDazBDkIftnS+WIyQAtf377krmH/MaMnEQVlhB1nbVQVVP3\nCTn8oRarTpvjR5B88cJ9jZuvGsSmwVGVxbjUzpmvjQKBgCQcliNa81ovsuUv30Rw\nPvrQ1WS4SIPo+kXMO8Mjl667etetu4Yva8thr2drrIT/NMdapK3B6UCFArN/I7Ks\n+VnCAe8Qv0KhTtXhHQ+bUFYmRQT9g/BygjuwDiZ/phcHOajdPRoKZYXGQ724wlI2\ndBorjbyFnESc8H1y7AaV3l6P\n-----END PRIVATE KEY-----\n",
    "client_email": "ieee-fsb-hr@ieee-fsb-hr.iam.gserviceaccount.com",
    "client_id": "107726277270548697296",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/ieee-fsb-hr%40ieee-fsb-hr.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  }
  ''';
  static final _gsheet = GSheets(_cre);

  static Spreadsheet? _dataSheet;
  static Spreadsheet? _globalSheet;

  static Future<void> init({
    required String dataSheetID,
    required String globalSheetID,
  }) async {
    _dataSheet = await _gsheet.spreadsheet(dataSheetID);
    _globalSheet = await _gsheet.spreadsheet(globalSheetID);
  }

  static Future<String?> accessInit(String email) async {
    await dotenv.load(fileName: ".env");
    final accessDS =
        await _gsheet.spreadsheet(dotenv.env["ACCESS_SPREADSHEET"].toString());
    final sh = accessDS.worksheetByTitle("Sheet1");
    final val = await sh!.values.allColumns(fromRow: 2);
    final index = val[1].indexOf(email);
    if (index == -1) {
      return null;
    } else {
      return val[2][index];
    }
  }

  static List<Worksheet> displayMeetings() {
    return _dataSheet!.sheets.sublist(1);
  }

  static Future<void> addMeeting(String meetingTitle) async {
    final newMeeing = await _dataSheet!.addWorksheet(meetingTitle);
    final tempSheet = _dataSheet!.worksheetByTitle("Data");
    final allColumns = await tempSheet!.values.allColumns();

    await newMeeing.values.appendColumns(allColumns);
  }

  static addGuestByEmail(String email, Worksheet w) async {
    final globalSheet = _globalSheet!.worksheetByTitle("Data");
    final mails = await globalSheet!.values.column(2, fromRow: 2);
    final index = mails.indexOf(email);
    if (index == -1) {
      throw ("Not found");
    }
    final row = await globalSheet.values.row(index + 2);
    final l = await w.values.column(2, fromRow: 2);
    if (l.contains(email)) {
      throw ("Already Added");
    }
    row.add(
        "${DateTime.now().hour > 12 ? DateTime.now().hour - 12 : DateTime.now().hour}:${DateTime.now().minute}");
    row.add(
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
    row.add("1");
    await w.values.appendRow(row);
  }

  static addApology(String email, Worksheet w) async {
    final list = await w.values.column(2, fromRow: 2);
    final index = list.indexOf(email);
    if (index == -1) {
      throw "Not Found";
    }
    final val = await w.values.value(column: 6, row: index + 2);
    if (val == "1") {
      throw "already attended";
    }
    if (val == "2") {
      throw "already apologied";
    }
    final row = await w.values.row(index + 2);
    row.add(
        "${DateTime.now().hour > 12 ? DateTime.now().hour - 12 : DateTime.now().hour}:${DateTime.now().minute}");
    row.add(
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
    row.add("2");
    await w.values.insertRow(index + 2, row);
  }

  static searchMember(String email, Worksheet w) async {
    final emailList = await w.values.column(2, fromRow: 2);
    final index = emailList.indexOf(email);
    if (index == -1) {
      throw ("Not Found");
    }
    final s = await w.values.value(column: 6, row: index + 2);
    if (s == "1") {
      throw ("Already Added");
    }
    if (s == "2") {
      throw ("Already Apologied");
    }
    final row = await w.values.row(index + 2);
    row.add(
        "${DateTime.now().hour > 12 ? DateTime.now().hour - 12 : DateTime.now().hour}:${DateTime.now().minute}");
    row.add(
        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
    row.add("1");
    await w.values.insertRow(index + 2, row);
  }

  static Future<List<List<String>>> getAttendence(Worksheet w) async {
    final listOfAttendence = w.values.allRows(fromRow: 2);
    return listOfAttendence;
  }
//   static Future<List<String>> searchForEmail(String key, int mood) async {
//     List<String> list = await _worksheetresponses!.values.column(5, fromRow: 2);
//     int index = list.indexOf(key);
//     if (index == -1) {
//       return [];
//     } else {
//       List<String> row = await _worksheetresponses!.values.row(index + 2);
//       try {
//         row[10 + mood];
//       } catch (e) {
//         await _worksheetresponses!.values
//             .insertValue("1", column: 11 + mood, row: index + 2);
//         return [row[0], row[1], row[2], row[5], row[9], list.length.toString()];
//       }
//       if (row[10 + mood] == "") {
//         await _worksheetresponses!.values
//             .insertValue("1", column: 11 + mood, row: index + 2);
//         return [row[0], row[1], row[2], row[5], row[9], list.length.toString()];
//       } else {
//         return [];
//       }
//     }
//   }

//   static Future<List<String>> searchForPhone(String key, int mood) async {
//     List<String> list = await _worksheetresponses!.values.column(7, fromRow: 2);
//     int index = list.indexOf(key);
//     if (index == -1) {
//       return [];
//     } else {
//       List<String> row = await _worksheetresponses!.values.row(index + 2);
//       try {
//         row[10 + mood];
//       } catch (e) {
//         await _worksheetresponses!.values
//             .insertValue("1", column: 11 + mood, row: index + 2);
//         return [row[0], row[1], row[2], row[5], row[9], list.length.toString()];
//       }
//       if (row[10 + mood] == "") {
//         await _worksheetresponses!.values
//             .insertValue("1", column: 11 + mood, row: index + 2);
//         return [row[0], row[1], row[2], row[5], row[9], list.length.toString()];
//       } else {
//         return [];
//       }
//     }
//   }

//   static Future<String> getCount(int count) async {
//     String i =
//         await _worksheetresponses!.values.value(column: 14 + count, row: 3);
//     return i;
//   }
// }
}
