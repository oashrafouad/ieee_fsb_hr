import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gsheets/gsheets.dart';
import 'package:ieee_fsb_hr/core/spreadsheet_service.dart';

part 'members_state.dart';

class MembersCubit extends Cubit<MembersState> {
  MembersCubit() : super(MembersInitial());

  static MembersCubit get(context) => BlocProvider.of(context);

  getMembers(Worksheet w) async {
    emit(MembersLoading());
    try {
      final attendence = await SpreadSheetService.getAttendence(w);
      emit(MembersSuccess(attendence: attendence));
    } catch (e) {
      emit(MembersFailure());
    }
  }
}
