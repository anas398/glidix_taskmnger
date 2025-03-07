import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/providers/task_provider.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({super.key});

  Future<void> _selectDate(BuildContext context) async {
    final dateProvider = Provider.of<TaskProvider>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      dateProvider.setSelectedDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateProvider = Provider.of<TaskProvider>(context);

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today, color: Colors.black),
            const SizedBox(width: 8),
            Text(
              dateProvider.formattedDate,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
