import 'package:flutter/material.dart';
import 'package:sorttasks/widgets/Misc/sorting_ui.dart';

class TaskList<T> extends StatelessWidget {
  final ScrollController scrollController;
  final TextEditingController searchController;
  final Future<List<T>> fetchDataFuture;
  final String sortField;
  final bool isDescending;
  final bool isDarkTheme;
  final Function(String field, bool descending) changeSortOrder;
  final bool showArchiveDate;
  final Widget Function(T task) buildTaskItem;

  const TaskList({
    super.key,
    required this.scrollController,
    required this.searchController,
    required this.fetchDataFuture,
    required this.sortField,
    required this.isDescending,
    required this.isDarkTheme,
    required this.changeSortOrder,
    required this.showArchiveDate,
    required this.buildTaskItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SortingAndSearchUI(
          searchController: searchController,
          changeSortOrder: changeSortOrder,
          isDarkTheme: isDarkTheme,
          showArchiveDate: showArchiveDate,
        ),
        Expanded(
          child: FutureBuilder<List<T>>(
            future: fetchDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                List<T> tasks = snapshot.data ?? [];

                return Container(
                  decoration: BoxDecoration(
                    color: isDarkTheme ? const Color.fromRGBO(45, 45, 45, 1) : Colors.white,
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: tasks.isEmpty
                          ? Center(
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Text(
                                  'No tasks owned.',
                                  style: TextStyle(
                                    color: isDarkTheme ? Colors.yellow : const Color.fromARGB(255, 210, 14, 0),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              shrinkWrap: true,
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                T task = tasks[index];
                                return buildTaskItem(task);
                              },
                            ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
