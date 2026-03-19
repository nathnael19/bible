import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: SabaColors.surface,
      appBar: AppBar(
        title: Text('Search', style: tt.headlineSmall),
        backgroundColor: SabaColors.surface.withValues(alpha: 0.9),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 8, 16, 16),
            child: TextField(
              controller: _controller,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search verses, books…',
                prefixIcon: const Icon(Icons.search_outlined,
                    color: SabaColors.onSurfaceVariant),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: SabaColors.onSurfaceVariant),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
          if (_query.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search,
                        size: 64,
                        color: SabaColors.outlineVariant),
                    const SizedBox(height: 16),
                    Text('Search the scriptures',
                        style: tt.bodyLarge!.copyWith(
                            color: SabaColors.onSurfaceVariant)),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(32, 0, 16, 32),
                itemCount: 3,
                itemBuilder: (_, i) => _SearchResultTile(
                  tt: tt,
                  query: _query,
                  index: i,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile(
      {required this.tt, required this.query, required this.index});
  final TextTheme tt;
  final String query;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1.4 * 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SabaColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Genesis ${index + 1}:1',
              style: tt.labelSmall!
                  .copyWith(color: SabaColors.secondary)),
          const SizedBox(height: 6),
          Text(
            '"…$query… In the beginning God created the heavens."',
            style: tt.bodyMedium!.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
