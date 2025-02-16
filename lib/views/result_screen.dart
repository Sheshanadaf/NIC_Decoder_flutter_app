import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nic_controller.dart';

class ResultScreen extends StatelessWidget {
  final NicController controller = Get.find<NicController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NIC Details'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromRGBO(193, 70, 0, 1),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(229, 208, 172, 1),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(  // Scrollable content to ensure usability on smaller screens
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _infoCard(
                    'NIC FORMAT',
                    controller.nicFormat.value,
                    Icons.perm_identity,
                    Color.fromRGBO(255, 152, 0, 1),
                    controller.birthDate.value,
                    controller.age.toString(),
                    controller.weekday.value,
                    controller.gender.value,
                  ),
                  
                  // Voting eligibility bar for old NIC format
                  if (controller.nicFormat.value == 'Old NIC (9 digits)')
                    _infoCardWithProgress(
                      'VOTING ELIGIBILITY',
                      controller.votingStatus.value == 'Can Vote' ? 100 : 0,
                    )
                  
                  // Voting eligibility bar for new NIC format
                  else if (controller.nicFormat.value == 'New NIC (12 digits)')
                    _infoCardWithProgress(
                      'VOTING ELIGIBILITY',
                      controller.age.value > 18 ? 100 : 0,
                    ),


                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(193, 70, 0, 1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Back to Home', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  

  // Widget to display all info in a single card
  Widget _infoCard(
    String title,
    String nicFormat,
    IconData icon,
    Color color,
    String birthDate,
    String age,
    String weekday,
    String gender,
  ) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 30),
                const SizedBox(width: 20),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _infoDetailRow('NIC Format', nicFormat),
            _infoDetailRow('Date of Birth', birthDate),
            _infoDetailRow('Age', age),
            _infoDetailRow('Weekday', weekday),
            _infoDetailRow('Gender', gender),
          ],
        ),
      ),
    );
  }

  // Row with title and value
  Widget _infoDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Color.fromRGBO(22, 64, 77, 1)),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to display progress bar (for voting eligibility)
  Widget _infoCardWithProgress(String title, double value) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(193, 70, 0, 1),
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey[300],
              color: value == 100 ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 10),
            Text(
              value == 100 ? 'Eligible for Voting' : 'Not Eligible for Voting',
              style: TextStyle(
                fontSize: 16,
                color: value == 100 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
