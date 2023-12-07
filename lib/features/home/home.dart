import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ieee_fsb_hr/features/home/manager/cubit/configure_cubit.dart';
import 'package:ieee_fsb_hr/features/meeting_details/meeting_details.dart';

class Home extends StatelessWidget {
  const Home({Key? key, required this.name, required this.userEmail})
      : super(key: key);

  final String name;
  final String userEmail;
  // late final String? team;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfigureCubit()..loadConfig(userEmail),
      child: BlocBuilder<ConfigureCubit, ConfigureState>(
        builder: (context, state) {
          if (state is ConfigureFailure) {
            return Scaffold(body: Center(child: Text(state.msg)));
          } else if (state is ConfigureSuccess) {
            return Scaffold(
              appBar: AppBar(
                title: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Hi, $name\nTeam: ${state.teamName}"),
                ),
                actions: [
                  TextButton(
                      onPressed: () async {
                        await GoogleSignIn().signOut();
                        FirebaseAuth.instance.signOut();
                      },
                      child: const Text("Sign Out"))
                ],
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (int i = 0; i < state.meetings.length; i++)
                        Column(
                          children: [
                            FilledButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MeetingDetatils(
                                        worksheet: state.meetings[i],
                                      ),
                                    ),
                                  );
                                },
                                child: Text(state.meetings[i].title)),
                            const Gap(16),
                          ],
                        ),
                      FilledButton(
                        onPressed: () {
                          final textEditor = TextEditingController();
                          final formKey = GlobalKey<FormState>();
                          showDialog(
                            context: context,
                            builder: (_) => Form(
                              key: formKey,
                              child: AlertDialog(
                                title: const Text("Add New Meeting"),
                                content: TextFormField(
                                  controller: textEditor,
                                  validator: (value) {
                                    for (var i in state.meetings) {
                                      if (i.title == value) {
                                        return "Meeting name must be unique";
                                      }
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Meeting Name",
                                  ),
                                ),
                                actions: [
                                  FilledButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          ConfigureCubit.get(context)
                                              .addMeeting(textEditor.text,
                                                  state.teamName);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text("Add Meeting"))
                                ],
                              ),
                            ),
                          );
                          // ConfigureCubit.get(context).addMeeting("sheet4");
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blueGrey)),
                        child: const Text("Add meeting"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is ConfigureNotAuthorized) {
            return Scaffold(
                appBar: AppBar(actions: [
                  TextButton(
                      onPressed: () async {
                        await GoogleSignIn().signOut();
                        FirebaseAuth.instance.signOut();
                      },
                      child: const Text("Sign Out"))
                ]),
                body: const Center(
                    child: Text("Not Authorized, please sign out")));
          } else {
            return const Loading();
          }
        },
      ),
    );
    // return FutureBuilder(
    //   future: loadConfig(userEmail),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       if (snapshot.data == "Not Garanteed") {
    //         return const Scaffold(
    //             body: Center(child: Text("Not Garanteed Access")));
    //       } else {
    //         team = snapshot.data;
    //         final stream =
    //             FirebaseFirestore.instance.collection(team!).doc("sheets").get();
    //         return Scaffold(
    //           appBar: AppBar(
    //             title: Text("Hi, $name"),
    //             actions: [
    //               TextButton(
    //                 child: const Text("Log Out",
    //                     style: TextStyle(color: Colors.white)),
    //                 onPressed: () async {
    //                   await GoogleSignIn().signOut();
    //                   FirebaseAuth.instance.signOut();
    //                 },
    //               )
    //             ],
    //           ),
    //           body: Center(
    //             child: Column(
    //               children: [
    //                 FutureBuilder(
    //                   future: stream,
    //                   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //                                             if (snapshot.connectionState ==
    //                         ConnectionState.done) {
    //                       print(snapshot.data.data());
    //                       return Container(
    //                         child: const Text(""),
    //                       );
    //                     } else {
    //                       return const CircularProgressIndicator();
    //                     }

    //                   },
    //                 ),
    //               ],
    //             ),
    //           ),
    //         );
    //       }
    //     }
    //     return const Scaffold(body: Center(child: CircularProgressIndicator()));
    //   },
    // );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class Meetings extends StatelessWidget {
  const Meetings({Key? key, required this.dataSheet, required this.globalSheet})
      : super(key: key);
  final String dataSheet;
  final String globalSheet;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
// Future<String> loadConfig(userEmail) async {
//   final response = await SpreadSheetService.accessInit(userEmail);
//   if (response == null) {
//     return "Not Garanteed";
//   } else {
//     return response;
//   }
// }
