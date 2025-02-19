import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> options;
  final String initialValue;
  final void Function(String)? onChanged;
  final String? label;

  const CustomDropdown({
    super.key,
    required this.options,
    required this.initialValue,
    this.onChanged,
    this.label,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String dropdownValue;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    widget.label!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              Flexible(
                child: MouseRegion(
                  onEnter: (_) => setState(() => isHovered = true),
                  onExit: (_) => setState(() => isHovered = false),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isHovered
                          ? const Color(0xFFF5F5F5)
                          : const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isHovered
                            ? const Color(0xFF2196F3)
                            : const Color(0xFFE0E0E0),
                        width: 1.5,
                      ),
                      boxShadow: isHovered
                          ? [
                              BoxShadow(
                                color: const Color(0xFF2196F3).withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() => dropdownValue = value);
                            widget.onChanged?.call(value);
                          }
                        },
                        items: widget.options
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF333333),
                              ),
                            ),
                          );
                        }).toList(),
                        isExpanded: true,
                        icon: AnimatedRotation(
                          duration: const Duration(milliseconds: 200),
                          turns: isHovered ? 0.25 : 0,
                          child: Icon(
                            Icons.chevron_right,
                            color: isHovered
                                ? const Color(0xFF2196F3)
                                : const Color(0xFF666666),
                          ),
                        ),
                        dropdownColor: Colors.white,
                        elevation: 8,
                        borderRadius: BorderRadius.circular(8),
                        menuMaxHeight: 300,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
