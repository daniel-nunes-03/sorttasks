import 'package:flutter/material.dart';

class SortingAndSearchUI extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String, bool) changeSortOrder;
  final bool isDarkTheme;
  final bool showArchiveDate;

  const SortingAndSearchUI({
    super.key,
    required this.searchController,
    required this.changeSortOrder,
    required this.isDarkTheme,
    required this.showArchiveDate,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.only(left: 40, top: 10, right: 20),
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(
                      width: 175,
                      height: 45,
                      child: TextField(
                        controller: searchController,
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Search tasks',
                          labelStyle: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isDarkTheme ? Colors.white : Colors.black,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isDarkTheme 
                                ? const Color.fromARGB(255, 218, 150, 255)
                                : const Color.fromARGB(255, 166, 0, 255),
                            ),
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: isDarkTheme? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildSortButton('A-Z', 'title', false),
                    _buildSortButton('Z-A', 'title', true),
                    _buildSortButton('Reset', 'taskPriority', true, icon: Icons.filter_alt_off),
                  ],
                ),
                const SizedBox(height: 5),
                _buildSortRow('Creation Date:', 'creationDateHour'),
                _buildSortRow('Finish Date:', 'finishDateHour'),
                if (showArchiveDate) _buildSortRow('Archive Date:', 'archivedDateHour'),
                _buildSortRow('Priority:', 'taskPriority'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortButton(String text, String field, bool descending, {IconData? icon}) {
    return SizedBox(
      width: 50,
      child: TextButton(
        onPressed: () => changeSortOrder(field, descending),
        child: icon != null
          ? Icon(icon, color: isDarkTheme ? const Color.fromARGB(255, 218, 150, 255) : null)
          : Text(
              text,
              style: TextStyle(
                color: isDarkTheme ? const Color.fromARGB(255, 218, 150, 255) : null,
              ),
            ),
      ),
    );
  }

  Widget _buildSortRow(String label, String field) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: TextButton(
            onPressed: () => changeSortOrder(field, false),
            child: Text(
              'Older-Newer',
              style: TextStyle(
                color: isDarkTheme ? const Color.fromARGB(255, 218, 150, 255) : null,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: TextButton(
            onPressed: () => changeSortOrder(field, true),
            child: Text(
              'Newer-Older',
              style: TextStyle(
                color: isDarkTheme ? const Color.fromARGB(255, 218, 150, 255) : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
