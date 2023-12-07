part of 'configure_cubit.dart';

sealed class ConfigureState {}

final class ConfigureInitial extends ConfigureState {}

final class ConfigureSuccess extends ConfigureState {
  final List<Worksheet> meetings;
  final String teamName;
  ConfigureSuccess({required this.teamName, required this.meetings});
}

final class ConfigureNotAuthorized extends ConfigureState {}

final class ConfigureLoading extends ConfigureState {}

final class ConfigureFailure extends ConfigureState {
  final String msg;

  ConfigureFailure({required this.msg});
}
