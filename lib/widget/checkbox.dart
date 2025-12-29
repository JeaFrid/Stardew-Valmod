import 'package:flutter/material.dart';

class NotikalyCheckBox extends StatefulWidget {
  final void Function(bool) onTap;
  final void Function(bool)? onLongPress;
  final double size;
  final Color? color;
  final bool? initStatus;
  const NotikalyCheckBox({
    super.key,
    required this.onTap,
    this.initStatus,
    this.onLongPress,
    this.color,
    required this.size,
  });

  @override
  State<NotikalyCheckBox> createState() => _CosmosCheckBoxState();
}

class _CosmosCheckBoxState extends State<NotikalyCheckBox> {
  ValueNotifier<bool> index = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    if (widget.initStatus != null) {
      index.value = widget.initStatus!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([]),
      builder: (BuildContext context, Widget? child) {
        return ValueListenableBuilder(
          valueListenable: index,
          builder: (BuildContext context, dynamic value, Widget? child) {
            return InkWell(
              onLongPress: () {
                index.value = !index.value;
                index.notifyListeners();
                if (widget.onLongPress != null) {
                  widget.onLongPress!(index.value);
                }
              },
              onTap: () {
                index.value = !index.value;
                index.notifyListeners();
                widget.onTap(index.value);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.color ?? Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: AnimatedOpacity(
                    opacity: index.value == true ? 1 : 0,
                    duration: Durations.short1,
                    child: Icon(
                      Icons.check,
                      color: widget.color ?? Colors.white,
                      size: widget.size,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
