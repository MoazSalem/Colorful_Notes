import 'package:colorful_notes/old_logic/notes_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.C,
  });
  final bool isSearching;
  final TextEditingController searchController;
  final NotesCubit C;

  @override
  Widget build(BuildContext context) {
    if (!isSearching) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextFormField(
        autofocus: true,
        controller: searchController,
        onChanged: (query) => C.search(query: query, where: "home"),
        cursorColor: C.theme.primary,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: C.isTablet ? 20 : 5,
            horizontal: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: C.theme.primary),
          ),
          hintText: "Search".tr(),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
