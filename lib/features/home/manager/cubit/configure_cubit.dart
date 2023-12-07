import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gsheets/gsheets.dart';

import '../../../../core/spreadsheet_service.dart';

part 'configure_state.dart';

class ConfigureCubit extends Cubit<ConfigureState> {
  ConfigureCubit() : super(ConfigureInitial());

  static ConfigureCubit get(context) => BlocProvider.of(context);
  loadConfig(userEmail) async {
    emit(ConfigureLoading());
    try {
      final teamName = await SpreadSheetService.accessInit(userEmail);
      if (teamName == null) {
        emit(ConfigureNotAuthorized());
      } else {
        final doc = await FirebaseFirestore.instance
            .collection(teamName)
            .doc("sheets")
            .get();
        final data = doc.data();
        if (data == null) {
          throw ("data from firebase is null");
        }
        await SpreadSheetService.init(
            dataSheetID: data["dataSheet"], globalSheetID: data["globalSheet"]);
        getMeetings(teamName);
      }
    } catch (e) {
      emit(ConfigureFailure(msg: e.toString()));
    }
  }
  

  getMeetings(String teamName) {
    final meetings = SpreadSheetService.displayMeetings();
    emit(ConfigureSuccess(meetings: meetings,teamName: teamName));
  }

  addMeeting(String meetingName, String teamName) async {
    emit(ConfigureLoading());
    await SpreadSheetService.addMeeting(meetingName);
    getMeetings(teamName);
  }
}
