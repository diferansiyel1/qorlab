import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_vitro/src/data/inventory_repository.dart';
import 'package:in_vitro/src/domain/chemical.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final chemicalsAsync = ref.watch(chemicalListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chemical Inventory'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Chemicals',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  _query = val.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: chemicalsAsync.when(
              data: (chemicals) {
                final filtered = chemicals.where((c) {
                  return c.name.toLowerCase().contains(_query) ||
                         c.formula.toLowerCase().contains(_query);
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No chemicals found.'));
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final chemical = filtered[index];
                    return ListTile(
                      title: Text(chemical.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${chemical.formula} • MW: ${chemical.molecularWeight} g/mol"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(context, chemical);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
