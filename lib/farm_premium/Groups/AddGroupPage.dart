import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddGroupPage extends StatefulWidget {
  @override
  State<AddGroupPage> createState() {
    return _AddGroupPage();
  }
}

class _AddGroupPage extends State<AddGroupPage> {
  var _formKey = GlobalKey<FormState>();
  var _name = "";
  var _comment = "";
  String? _selectedContactId;
  String? _selectedContactName;

  var contacts = [];
  bool _loading = false;
  bool _loadingContacts = false;

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Group / Herd")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    artyTechTextInput("Name", (value) {
                      _name = value;
                    }),

                    artyTechTextInput("Comment (optional)", (value) {
                      _comment = value;
                    }),

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
                        : artyTechButtonOvalFilled("Save Group", () {
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
      "create_group",
      {
        "farm_id": farm_id,
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
        print("Error: create_group");
      },
    );
  }
}
