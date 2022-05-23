import 'package:employees_catalogue/data/component.dart';
import 'package:employees_catalogue/data/person.dart';
import 'package:employees_catalogue/people_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:employees_catalogue/data/extensions.dart';

class PersonDetailsPage extends StatefulWidget {
  final int? personId;

  const PersonDetailsPage({Key? key, required this.personId}) : super(key: key);

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  Person? person;

  @override
  void initState() {
    if (widget.personId != null) {
      person = Component.instance.api.getPerson(widget.personId);
      if (person == null) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            Navigator.pop(context);
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Person details'), leading: CloseButton()),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('${person?.id}'),
              Text('${person?.fullName}'),
              Text('${person?.responsibility.toNameString()}'),
              Text('${person?.room}'),
              Text('${person?.phone}'),
              Text('${person?.email}'),
            ],
          ),
        )); // TODO
  }
}
