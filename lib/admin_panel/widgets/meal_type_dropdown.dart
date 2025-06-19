import 'package:flutter/material.dart';

class GradientDropdown extends StatefulWidget {
  final String label;
  final List<String> options;
  final TextEditingController controller;

  const GradientDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.controller,
  });

  @override
  State<GradientDropdown> createState() => _GradientDropdownState();
}

class _GradientDropdownState extends State<GradientDropdown> {
  String? selectedValue;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeDropdown();
      }
    });
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _focusNode.requestFocus();
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _removeDropdown();
    }
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width,
            left: offset.dx,
            top: offset.dy + size.height + 5,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 0, 0, 0), Color(0xFF040B90)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(42),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        widget.options.map((value) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedValue = value;
                                widget.controller.text = value;
                              });
                              _toggleDropdown();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 26,
                              ),
                              child: Text(
                                value,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _removeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Focus(
        focusNode: _focusNode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _toggleDropdown,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedValue ?? 'Select ${widget.label}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
