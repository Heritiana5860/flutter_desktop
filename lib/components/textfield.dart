import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {
  const MyTextfield({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    required this.prefixIcon,
    this.label,
    this.validator,
    this.focusNode,
    this.nextFocus,
  });

  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final IconData prefixIcon;
  final String? label;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  bool isHovered = false;
  bool isFocused = false;

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
                  child: Focus(
                    onFocusChange: (focused) =>
                        setState(() => isFocused = focused),
                    child: TextFormField(
                      controller: widget.controller,
                      keyboardType: widget.keyboardType,
                      validator: widget.validator,
                      focusNode: widget.focusNode,
                      onFieldSubmitted: (_) {
                        if (widget.nextFocus != null) {
                          FocusScope.of(context).requestFocus(widget.nextFocus);
                        }
                      },
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF333333),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          widget.prefixIcon,
                          color: isFocused || isHovered
                              ? const Color(0xFF2196F3)
                              : const Color(0xFF666666),
                        ),
                        filled: true,
                        fillColor: isHovered || isFocused
                            ? const Color(0xFFF5F5F5)
                            : const Color(0xFFFAFAFA),
                        hintText: widget.hintText,
                        hintStyle: const TextStyle(
                          color: Color(0xFF757575),
                          fontSize: 15,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: const Color(0xFFE0E0E0),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: const Color(0xFFE0E0E0),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF2196F3),
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.red.shade400,
                            width: 1.5,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.red.shade400,
                            width: 1.5,
                          ),
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
