import 'package:flutter/material.dart';

class TreeDecorateSheet extends StatelessWidget {
  const TreeDecorateSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.20,
      initialChildSize: 0.22,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.22, 0.5, 0.88],
      builder: (context, controller) {
        return Container(
          decoration: ShapeDecoration(
            color: Color(0xFFFFFFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 66,
                  height: 4,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: EdgeInsets.zero,
                  children: const [SizedBox(height: 1)],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
