import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/core/theme/app_dimens.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/currency_entity.dart';
import 'package:flutter_currency_converter/features/currency/presentation/widgets/common/currency_flag_icon.dart';

class SearchableCurrencyPicker extends StatefulWidget {
  final String selectedCode;
  final List<CurrencyEntity> currencies;
  final ValueChanged<String?> onChanged;

  const SearchableCurrencyPicker({
    super.key,
    required this.selectedCode,
    required this.currencies,
    required this.onChanged,
  });

  @override
  State<SearchableCurrencyPicker> createState() => _SearchableCurrencyPickerState();
}

class _SearchableCurrencyPickerState extends State<SearchableCurrencyPicker> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<CurrencyEntity> _filteredCurrencies = [];
  bool _isDropdownOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _filteredCurrencies = widget.currencies;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(SearchableCurrencyPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currencies != widget.currencies) {
      _filteredCurrencies = widget.currencies;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _isDropdownOpen) {
      _closeDropdown();
    }
  }

  void _filterCurrencies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencies = widget.currencies;
      } else {
        final lowerQuery = query.toLowerCase();
        
        final startsWithQuery = <CurrencyEntity>[];
        final containsQuery = <CurrencyEntity>[];
        
        for (final currency in widget.currencies) {
          final code = currency.code.toLowerCase();
          final name = currency.name.toLowerCase();
          
          if (code.startsWith(lowerQuery) || name.startsWith(lowerQuery)) {
            startsWithQuery.add(currency);
          } else if (code.contains(lowerQuery) || name.contains(lowerQuery)) {
            containsQuery.add(currency);
          }
        }
        
        _filteredCurrencies = [...startsWithQuery, ...containsQuery];
      }
    });
    _updateOverlay();
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _closeDropdown() {
    _removeOverlay();
    setState(() {
      _isDropdownOpen = false;
      _searchController.clear();
      _filteredCurrencies = widget.currencies;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _selectCurrency(CurrencyEntity currency) {
    widget.onChanged(currency.code);
    _closeDropdown();
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closeDropdown,
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 4),
                child: GestureDetector(
                  onTap: () {},
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(AppDimens.base / 2),
                            child: TextField(
                              controller: _searchController,
                              focusNode: _focusNode,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Search currency...',
                                prefixIcon: const Icon(Icons.search, size: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.base / 2,
                                  vertical: AppDimens.base / 2,
                                ),
                                isDense: true,
                              ),
                              onChanged: _filterCurrencies,
                            ),
                          ),
                          const Divider(height: 1),
                          Flexible(
                            child: _filteredCurrencies.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(AppDimens.base),
                                    child: Text(
                                      'No currencies found',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: _filteredCurrencies.length,
                                    itemBuilder: (context, index) {
                                      final currency = _filteredCurrencies[index];
                                      final isSelected = currency.code == widget.selectedCode;
                                      
                                      return InkWell(
                                        onTap: () => _selectCurrency(currency),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppDimens.base / 1.5,
                                            vertical: AppDimens.base / 1.5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
                                                : null,
                                          ),
                                          child: Row(
                                            children: [
                                              CurrencyFlagIcon(countryCode: currency.countryCode),
                                              const SizedBox(width: AppDimens.base / 2),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      currency.code,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                        color: isSelected
                                                            ? Theme.of(context).colorScheme.primary
                                                            : null,
                                                      ),
                                                    ),
                                                    Text(
                                                      currency.name,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (isSelected)
                                                Icon(
                                                  Icons.check,
                                                  size: 20,
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CurrencyEntity get _selectedCurrency {
    if (widget.currencies.isEmpty) {
      return const CurrencyEntity(code: '', name: '', countryCode: '');
    }

    return widget.currencies.cast<CurrencyEntity>().firstWhere(
      (c) => c.code == widget.selectedCode,
      orElse: () => widget.currencies.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedCurrency = _selectedCurrency;

    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: _toggleDropdown,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.base / 1.5,
            vertical: AppDimens.base / 1.5,
          ),
          decoration: BoxDecoration(
            color: theme.inputDecorationTheme.fillColor ?? Colors.grey[200],
            borderRadius: BorderRadius.circular(12.0),
            border: _isDropdownOpen
                ? Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Row(
            children: [
              CurrencyFlagIcon(countryCode: selectedCurrency.countryCode),
              const SizedBox(width: AppDimens.base / 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedCurrency.code,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      selectedCurrency.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                _isDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 20,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
