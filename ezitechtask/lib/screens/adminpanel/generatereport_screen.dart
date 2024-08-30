import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GenerateReportsScreen extends StatefulWidget {
  @override
  _GenerateReportsScreenState createState() => _GenerateReportsScreenState();
}

class _GenerateReportsScreenState extends State<GenerateReportsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  Future<void> _generateReport() async {
    DateTime fromDate = DateTime.parse(_fromDateController.text);
    DateTime toDate = DateTime.parse(_toDateController.text);

    QuerySnapshot querySnapshot = await _firestore
        .collection('attendance')
        .where('date', isGreaterThanOrEqualTo: fromDate.toIso8601String())
        .where('date', isLessThanOrEqualTo: toDate.toIso8601String())
        .get();

    // Process and display the report
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _fromDateController,
              decoration: InputDecoration(labelText: 'From Date (YYYY-MM-DD)'),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (date != null) {
                  _fromDateController.text = date.toIso8601String().substring(0, 10);
                }
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _toDateController,
              decoration: InputDecoration(labelText: 'To Date (YYYY-MM-DD)'),
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (date != null) {
                  _toDateController.text = date.toIso8601String().substring(0, 10);
                }
              },
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _generateReport,
              child: Text('Generate Report'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue[900],
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                shadowColor: Colors.deepPurple,
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
