import 'package:employees_catalogue/data/component.dart';
import 'package:employees_catalogue/data/person.dart';
import 'package:employees_catalogue/person_details_page.dart';
import 'package:employees_catalogue/widget_keys.dart';
import 'package:flutter/material.dart';
import 'package:employees_catalogue/data/extensions.dart';

class PeopleListPage extends StatefulWidget {
  final String title;

  const PeopleListPage({Key? key, required this.title}) : super(key: key);

  @override
  _PeopleListPageState createState() => _PeopleListPageState();
}

class _PeopleListPageState extends State<PeopleListPage> {
  late List<Person> people;
  late TextEditingController _searchController;
  bool _isSearching = false;
  Responsibility? responsibilityFilter;
  String previousQuery = '';

  @override
  void initState() {
    _searchController = TextEditingController();
    people = Component.instance.api.searchPeople();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: LeadingWidget(
            isSearching: _isSearching,
            onClick: () {
              _isSearching = !_isSearching;
              _searchController.text = '';
              previousQuery = '';
              people = Component.instance.api.searchPeople(
                  query: previousQuery, responsibility: responsibilityFilter);
              setState(() {});
              // TODO
            },
          ),
          title: _isSearching
              ? TextField(
                  key: WidgetKey.search,
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Search employee...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white30),
                  ),
                  onChanged: (text) {
                    previousQuery = text;
                    people = Component.instance.api.searchPeople(
                        query: previousQuery,
                        responsibility: responsibilityFilter);
                    setState(() {});
                  },
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                )
              : Text(widget.title),
          actions: [
            responsibilityFilter != null
                ? InkWell(
                    key: WidgetKey.clearFilter,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('CLEAR'),
                    )),
                    onTap: () {
                      responsibilityFilter = null;
                      people = Component.instance.api.searchPeople(
                          query: previousQuery,
                          responsibility: responsibilityFilter);
                      setState(() {});
                      // TODO
                    },
                  )
                : PopupMenuButton<Responsibility>(
                    key: WidgetKey.filter,
                    icon: Icon(Icons.filter_list),
                    onSelected: (responsibility) {
                      responsibilityFilter = responsibility;
                      people = Component.instance.api.searchPeople(
                          query: previousQuery,
                          responsibility: responsibilityFilter);
                      setState(() {});
                      // TODO
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          child: Text(Responsibility.Accounting.toNameString()),
                          value: Responsibility.Accounting,
                        ),
                        PopupMenuItem(
                          child: Text(Responsibility.DevOps.toNameString()),
                          value: Responsibility.DevOps,
                        ),
                        PopupMenuItem(
                          child: Text(Responsibility.IT_Support.toNameString()),
                          value: Responsibility.IT_Support,
                        ),
                        PopupMenuItem(
                          child: Text(
                              Responsibility.Infrastructure.toNameString()),
                          value: Responsibility.Infrastructure,
                        ),
                        PopupMenuItem(
                          child: Text(Responsibility.Marketing.toNameString()),
                          value: Responsibility.Marketing,
                        ),
                        PopupMenuItem(
                          child: Text(Responsibility.Sales.toNameString()),
                          value: Responsibility.Sales,
                        ),
                      ]; // TODO
                    },
                  )
          ],
        ),
        body: ListView.builder(
          key: WidgetKey.listOfPeople,
          itemBuilder: (context, index) {
            return PersonItemWidget(
              fullName: people[index].fullName,
              id: people[index].id,
              responsibility: people[index].responsibility.toNameString(),
            ); // TODO
          },
          itemCount: people.length,
        ));
  }
}

class LeadingWidget extends StatelessWidget {
  final bool isSearching;
  final Function() onClick;

  const LeadingWidget(
      {Key? key, this.isSearching = false, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isSearching ? const Icon(Icons.clear) : const Icon(Icons.search),
      onPressed: () {
        onClick();
      },
    );
  }
}

class PersonItemWidget extends StatelessWidget {
  final int id;
  final String fullName;
  final String responsibility;

  const PersonItemWidget(
      {Key? key,
      required this.id,
      required this.fullName,
      this.responsibility = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PersonDetailsPage(
                    personId: id,
                  )),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(fullName),
            Text(responsibility),
          ],
        ),
      ),
    ); // TODO
  }
}
