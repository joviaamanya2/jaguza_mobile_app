import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditGroupPage extends StatefulWidget {
  final dynamic group;
  const EditGroupPage({required this.group});

  @override
  State<EditGroupPage> createState() {
    return _EditGroupPage();
  }
}

class _EditGroupPage extends State<EditGroupPage> {
  var _formKey = GlobalKey<FormState>();
  late var _name;
  late var _comment;
  String? _selectedContactId;
  String? _selectedContactName;

  var contacts = [];
  bool _loading = false;
  bool _loadingContacts = false;

  @override
  void initState() {
    super.initState();
    _name = widget.group["name"] ?? "";
    _comment = widget.group["comment"] ?? "";

    var contact = widget.group["contact"];
    if (contact != null) {
      _selectedContactId = contact["id"].toString();
      _selectedContactName =
          "${contact["first_name"] ?? ""} ${contact["last_name"] ?? ""}".trim();
    }

    getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Group / Herd")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    artyTechTextInput(
                      "Name",
                      (value) {
                        _name = value;
                      },
                      currentValue: _name,
                    ),

                    artyTechTextInput(
                      "Comment (optional)",
                      (value) {
                        _comment = value;
                      },
                      currentValue: _comment,
                    ),

                    _loadingContacts
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: CircularProgressIndicator(),
                          )
                        : artyTechDropDown(
                            "Responsible Person",
                            _selectedContactName ?? "",
                            contacts
                                .map((c) =>
                                    "${c["first_name"]} ${c["last_name"]}")
                                .toList(),
                            (name) {
                              setState(() {
                                _selectedContactName = name;
                                var contact = contacts.firstWhere(
                                  (c) =>
                                      "${c["first_name"]} ${c["last_name"]}" ==
                                      name,
                                  orElse: () => null,
                                );
                                _selectedContactId =
                                    contact != null ? contact["id"].toString() : null;
                              });
                            },
                          ),

                    _loading
                        ? const Center(child: CircularProgressIndicator())
                        : artyTechButtonOvalFilled("Save Changes", () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                              action();
                            }
                          }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getContacts() async {
    var prefs = await SharedPreferences.getInstance();
    var farm_id = prefs.getInt("farm_id");

    requestAPI(
      "get_contacts",
      {"farm_id": farm_id},
      (progress) {
        setState(() {
          _loadingContacts = progress;
        });
      },
      (response) {
        setState(() {
          contacts = response;
        });
      },
      () {
        print("Error: get_contacts");
      },
    );
  }

  Future<void> action() async {
    var prefs = await SharedPreferences.getInstance();
    var farm_id = prefs.getInt("farm_id");

    requestAPI(
      "update_group",
      {
        "farm_id": farm_id,
        "id": widget.group["id"],
        "name": _name,
        "comment": _comment,
        "user_id": _selectedContactId ?? "",
      },
      (progress) {
        setState(() {
          _loading = progress;
        });
      },
      (response) {
        if (response["status_code"] == 200) {
          showSnackBar(context, response["status_message"]);
          Navigator.pop(context, true);
        }
      },
      () {
        print("Error: update_group");
      },
    );
  }
}
