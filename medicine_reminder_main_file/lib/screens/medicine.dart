import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineWidget extends StatefulWidget {
  final String brandId; // Accept brand ID instead of brand name

  const MedicineWidget({required this.brandId, super.key});

  @override
  State<MedicineWidget> createState() => _MedicineWidgetState();
}

class _MedicineWidgetState extends State<MedicineWidget> {
  Map<String, dynamic>? medicineDetails;

  @override
  void initState() {
    super.initState();
    _fetchMedicineDetails();
  }

  /// Fetches medicine details from Firestore using brand ID.
  Future<void> _fetchMedicineDetails() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('medicine_details') // Replace with your collection name
          .doc(widget.brandId)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          medicineDetails = docSnapshot.data();
        });
      } else {
        setState(() {
          medicineDetails = {'error': 'No details found for the selected medicine.'};
        });
      }
    } catch (e) {
      setState(() {
        medicineDetails = {'error': 'Failed to fetch data: ${e.toString()}.'};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(
            medicineDetails?['brand name'] ?? 'Loading...',
            style: const TextStyle(fontSize: 20),
          ),
          centerTitle: true,
        ),
        backgroundColor: const Color(0xFFF9FAFB),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: medicineDetails == null
                ? const Center(child: CircularProgressIndicator())
                : medicineDetails!.containsKey('error')
                ? Center(
              child: Text(
                medicineDetails!['error']!,
                style: const TextStyle(color: Colors.red, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            )
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 16),
                  _buildDetailsCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medical_information_rounded, size: 40, color: Colors.teal),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    medicineDetails?['brand name'] ?? "No information available",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A202C),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Type: ${medicineDetails?['type'] ?? "No information available"}',
              style: const TextStyle(fontSize: 16, color: Color(0xFF718096)),
            ),
            const SizedBox(height: 4),
            Text(
              'Dosage Form: ${medicineDetails?['dosage form'] ?? "No information available"}',
              style: const TextStyle(fontSize: 16, color: Color(0xFF718096)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildMedicineDetailRow(
              icon: Icons.science,
              label: 'Generic Name',
              value: medicineDetails?['generic'],
              iconColor: Colors.blue,
            ),
            _buildMedicineDetailRow(
              icon: Icons.straighten,
              label: 'Strength',
              value: medicineDetails?['strength'],
              iconColor: Colors.orange,
            ),
            _buildMedicineDetailRow(
              icon: Icons.factory,
              label: 'Manufacturer',
              value: medicineDetails?['manufacturer'],
              iconColor: Colors.green,
            ),
            _buildMedicineDetailRow(
              icon: Icons.inventory_2,
              label: 'Package Container',
              value: medicineDetails?['package container'],
              iconColor: Colors.red,
            ),
            _buildMedicineDetailRow(
              icon: Icons.format_list_numbered,
              label: 'Package Size',
              value: medicineDetails?['Package Size'],
              iconColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineDetailRow({
    required IconData icon,
    required String label,
    String? value,
    required Color iconColor,
  }) {
    return value == null || value.isEmpty
        ? Container() // If value is null or empty, don't display the row
        : Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value ?? "No information available",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1A202C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
