import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gsheets/gsheets.dart';
import 'package:ieee_fsb_hr/core/spreadsheet_service.dart';
import 'package:ieee_fsb_hr/features/members/members_details.dart';

class MeetingDetatils extends StatefulWidget {
  const MeetingDetatils({Key? key, required this.worksheet}) : super(key: key);
  final Worksheet worksheet;

  @override
  State<MeetingDetatils> createState() => _MeetingDetatilsState();
}

class _MeetingDetatilsState extends State<MeetingDetatils> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.worksheet.title)),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton(
                      onPressed: () async {
                        try {
                          ScanResult keyWord = await BarcodeScanner.scan();
                          setState(() => isLoading = true);
                          await SpreadSheetService.searchMember(
                              keyWord.rawContent, widget.worksheet);
                          setState(() => isLoading = false);
                        } catch (e) {
                          setState(() => isLoading = false);
                          errorMsg(context, e.toString());
                        }
                      },
                      child: const Text("Search a member")),
                  const Gap(16),
                  FilledButton(
                    onPressed: () async {
                      try {
                        ScanResult keyWord = await BarcodeScanner.scan();
                        setState(() => isLoading = true);
                        await SpreadSheetService.addGuestByEmail(
                            keyWord.rawContent, widget.worksheet);
                        setState(() => isLoading = false);
                      } catch (e) {
                        setState(() => isLoading = false);
                        errorMsg(context, e.toString());
                      }
                    },
                    child: const Text("Search a guest"),
                  ),
                  const Gap(16),
                  FilledButton(
                    onPressed: () {
                      final apologyControl = TextEditingController();
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: const Text("Add appology"),
                                content: TextFormField(
                                  controller: apologyControl,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Member Email"),
                                ),
                                actions: [
                                  FilledButton(
                                      onPressed: () async {
                                        Navigator.of(_).pop();
                                        try {
                                          setState(() => isLoading = true);

                                          await SpreadSheetService.addApology(
                                              apologyControl.text,
                                              widget.worksheet);
                                          setState(() => isLoading = false);
                                        } catch (e) {
                                          setState(() => isLoading = false);

                                          errorMsg(context, e.toString());
                                        }
                                      },
                                      child: const Text("Add"))
                                ],
                              ));
                    },
                    child: const Text("Make an appology"),
                  ),
                  const Gap(16),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MembersDetails(
                            w: widget.worksheet,
                          ),
                        ),
                      );
                    },
                    child: const Text("Show Attendees"),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.black.withOpacity(.5)),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  errorMsg(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(msg),
        actions: [
          FilledButton(
              onPressed: () {
                Navigator.of(_).pop();
              },
              child: const Text("OK"))
        ],
      ),
    );
  }
}
