import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/core/theme/app_dimens.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/currency_entity.dart';
import 'package:flutter_currency_converter/features/currency/presentation/widgets/common/currency_flag_icon.dart';

class CurrencyPicker extends StatelessWidget {
  final String selectedCode;
  final List<CurrencyEntity> currencies;
  final ValueChanged<String?> onChanged;

  const CurrencyPicker({
    super.key,
    required this.selectedCode,
    required this.currencies,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedEntity = currencies.firstWhere(
          (c) => c.code == selectedCode,
      orElse: () => currencies.isNotEmpty
          ? currencies.first
          : const CurrencyEntity(code: "USD", name: "Dollar", countryCode: "US"),
    );

    return InkWell(
      onTap: () => _showSearchableBottomSheet(context),
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.base / 1.5,
          vertical: AppDimens.base / 1.5,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CurrencyFlagIcon(countryCode: selectedEntity.countryCode),
            const SizedBox(width: AppDimens.base / 2),
            Text(
              selectedEntity.code,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(width: 4.0),
            const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showSearchableBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) => _SearchBottomSheet(
        currencies: currencies,
        onSelect: (code) {
          onChanged(code);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _SearchBottomSheet extends StatefulWidget {
  final List<CurrencyEntity> currencies;
  final ValueChanged<String> onSelect;

  const _SearchBottomSheet({required this.currencies, required this.onSelect});

  @override
  State<_SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<_SearchBottomSheet> {
  late List<CurrencyEntity> _filteredList;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredList = widget.currencies;
  }

  void _filter(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredList = widget.currencies;
      } else {
        _filteredList = widget.currencies.where((c) {
          return c.code.toLowerCase().contains(query.toLowerCase()) ||
              c.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(AppDimens.base),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppDimens.base),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search currency",
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.all(AppDimens.base),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: _filter,
              ),
              const SizedBox(height: AppDimens.base),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: _filteredList.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final currency = _filteredList[index];
                    return ListTile(
                      leading: CurrencyFlagIcon(countryCode: currency.countryCode),
                      title: Text(currency.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(currency.name),
                      onTap: () => widget.onSelect(currency.code),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}