import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/Animals/AnimalsListPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Helper.dart';
import 'AddGroupPage.dart';
import 'EditGroupPage.dart';

class GroupsListPage extends StatefulWidget {
  @override
  State<GroupsListPage> createState() {
    return _GroupsListPage();
  }
}

class _GroupsListPage extends State<GroupsListPage> {
  var groups = [];
  var filteredGroups = [];

  var _formKey = GlobalKey<FormState>();
  String? searchText = "";
  bool showProgress = false;

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Groups / Herds")),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: jaguzaTextField("Search by name", (value) {
                      searchText = value;
                    }),
                  ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        searchAction();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
          ),
          showProgress ? const LinearProgressIndicator() : const SizedBox.shrink(),
          Expanded(
            child: filteredGroups.isEmpty && !showProgress
                ? const Center(child: Text("No groups found"))
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: filteredGroups.length,
                    itemBuilder: (context, index) {
                      var group = filteredGroups[index];
                      return _buildGroupCard(group);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addGroup,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGroupCard(dynamic group) {
    var contact = group["contact"];
    var contactName = contact != null
        ? "${contact["first_name"] ?? ""} ${contact["last_name"] ?? ""}".trim()
        : "";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimalsListPage(group: group),
          ),
        );
      },
      child: Card(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.group_work, color: primaryColor, size: 22),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          group["name"] ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${group["number_of_animals"] ?? 0} animals",
                    style: TextStyle(color: primaryColor, fontSize: 13),
                  ),
                  if (contactName.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      contactName,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: PopupMenuButton<String>(
                iconSize: 18,
                onSelected: (value) {
                  if (value == "edit") {
                    editGroup(group);
                  } else if (value == "delete") {
                    confirmDelete(group);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: "edit", child: Text("Edit")),
                  const PopupMenuItem(value: "delete", child: Text("Delete")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getGroups() async {
    var prefs = await SharedPreferences.getInstance();
    var farm_id = prefs.getInt("farm_id");

    requestAPI(
      "get_group",
      {"farm_id": farm_id},
      (progress) {
        setState(() {
          showProgress = progress;
        });
      },
      (response) {
        setState(() {
          groups = response;
          filteredGroups = groups;
        });
      },
      () {
        print("Error: get_group");
      },
    );
  }

  void searchAction() {
    setState(() {
      if (searchText == "") {
        filteredGroups = groups;
        return;
      }
      filteredGroups = groups
          .where((e) =>
              e["name"].toString().toLowerCase().contains(searchText!.toLowerCase()))
          .toList();
    });
  }

  Future<void> addGroup() async {
    var refresh = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddGroupPage()),
    );
    if (refresh == true) {
      getGroups();
    }
  }

  Future<void> editGroup(dynamic group) async {
    var refresh = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditGroupPage(group: group)),
    );
    if (refresh == true) {
      getGroups();
    }
  }

  void confirmDelete(dynamic group) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Group"),
        content: Text("Are you sure you want to delete \"${group["name"]}\"?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteGroup(group);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void deleteGroup(dynamic group) async {
    var prefs = await SharedPreferences.getInstance();
    var farm_id = prefs.getInt("farm_id");

    requestAPI(
      "delete_group",
      {"farm_id": farm_id, "id": group["id"]},
      (progress) {
        setState(() {
          showProgress = progress;
        });
      },
      (response) {
        if (response["status_code"] == 200) {
          showSnackBar(context, response["status_message"]);
          getGroups();
        }
      },
      () {
        print("Error: delete_group");
      },
    );
  }
}
