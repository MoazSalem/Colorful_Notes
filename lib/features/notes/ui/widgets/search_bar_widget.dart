import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.isSearching,
    required this.searchController,
  });
  final bool isSearching;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    if (!isSearching) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextFormField(
        autofocus: true,
        controller: searchController,
        //onChanged: (query) => search(query: query, where: "home"),
        cursorColor: theme.primary,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.primary),
          ),
          hintText: "Search".tr(),
          filled: true,
          fillColor: theme.primaryContainer,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
