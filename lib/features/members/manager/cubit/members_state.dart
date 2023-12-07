part of 'members_cubit.dart';


sealed class MembersState {}

final class MembersInitial extends MembersState {}

final class MembersLoading extends MembersState {}

final class MembersSuccess extends MembersState {
  final List<List<String>> attendence;

  MembersSuccess({required this.attendence});
}

final class MembersFailure extends MembersState {}
