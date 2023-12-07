import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gsheets/gsheets.dart';
import 'package:ieee_fsb_hr/features/members/manager/cubit/members_cubit.dart';

class MembersDetails extends StatelessWidget {
  const MembersDetails({Key? key, required this.w}) : super(key: key);
  final Worksheet w;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${w.title} attendence")),
      body: BlocProvider(
        create: (context) => MembersCubit()..getMembers(w),
        child: BlocBuilder<MembersCubit, MembersState>(
          builder: (context, state) {
            if (state is MembersSuccess) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: RefreshIndicator(
                  onRefresh: () async{
                    await MembersCubit.get(context).getMembers(w);
                  },
                  child: SingleChildScrollView(
                    child: Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.top,
                      border: TableBorder.all(width: 2),
                      children: [
                        const TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Name"),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Team"),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Status"),
                              ),
                            ),
                          ],
                        ),
                        for (var i in state.attendence)
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(i[0]),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(i[2]),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.fill,
                                child: i.length < 4
                                    ? Container(color: Colors.red)
                                    : i[5] == "1"
                                        ? Container(color: Colors.green)
                                        : Container(color: Colors.orange),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is MembersFailure) {
              return const Center(child: Text("Error"));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
