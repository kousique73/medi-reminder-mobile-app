import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowDoctorDetailsWidget extends StatefulWidget {
  final String location;

  const ShowDoctorDetailsWidget({super.key, required this.location});

  @override
  State<ShowDoctorDetailsWidget> createState() =>
      _ShowDoctorDetailsWidgetState();
}

class _ShowDoctorDetailsWidgetState extends State<ShowDoctorDetailsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> subCollections = ['d1', 'd2', 'd3','d4', 'd5', 'd6', 'd7']; // Define known subcollections

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF0F5F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFF009588),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Hospital Details',
            style: TextStyle(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('hos_search')
                .where('Location', isEqualTo: widget.location) // Query by location
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('Hospital not found. Please check the location.'),
                );
              }

              final hospitalData = snapshot.data!.docs[0]; // Get the first document
              final hosName = (hospitalData['HospitalName'] ?? 'Unknown').toString();
              final address = (hospitalData['Address'] ?? 'No address provided').toString();
              final contact = (hospitalData['Contact'] ?? 'No contact available').toString();
              final location = (hospitalData['Location'] ?? 'Unknown location').toString();

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(24.0),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hosName,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFF161C24),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _infoRow(Icons.location_on, location),
                          const SizedBox(height: 16),
                          _infoRow(Icons.home, address),
                          const SizedBox(height: 16),
                          _infoRow(Icons.phone, contact),
                        ],
                      ),
                    ),
                    // Doctors List Section
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Available Doctors',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF161C24),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Fetch doctors from predefined subcollections
                          FutureBuilder<List<Widget>>(
                            future: _getDoctors(hospitalData.id),
                            builder: (context, doctorSnapshot) {
                              if (!doctorSnapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (doctorSnapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text('No doctors available.'),
                                );
                              }

                              return Column(
                                children: doctorSnapshot.data!,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Function to fetch doctors from each subcollection
  Future<List<Widget>> _getDoctors(String hospitalId) async {
    List<Widget> doctorWidgets = [];

    // Iterate over predefined subcollections (e.g., 'd1', 'd2', 'd3')
    for (var subCollectionName in subCollections) {
      final subCollectionSnapshot = await FirebaseFirestore.instance
          .collection('hos_search')
          .doc(hospitalId)
          .collection(subCollectionName)
          .get();

      if (subCollectionSnapshot.docs.isNotEmpty) {
        // Extract doctors from the subcollection
        for (var doctorDoc in subCollectionSnapshot.docs) {
          final doctorName = (doctorDoc['DoctorName'] ?? 'Unknown').toString();
          final specialty = (doctorDoc['Specialist'] ?? 'Unknown').toString();

          doctorWidgets.add(_doctorCard(doctorName, specialty, 'Available: Mon-Fri, 9AM-5PM'));
        }
      }
    }

    return doctorWidgets;
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF2797FF),
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Manrope',
              color: Color(0xFF161C24),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _doctorCard(String name, String specialty, String availability) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF161C24),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              specialty,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                color: Color(0xFF636F81),
              ),
            ),
            Text(
              availability,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                color: Color(0xFF636F81),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
