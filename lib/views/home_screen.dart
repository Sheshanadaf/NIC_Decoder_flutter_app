import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nic_controller.dart';

class HomeScreen extends StatelessWidget {
  final NicController controller = Get.put(NicController());
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NIC Decoder'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromRGBO(193, 70, 0, 1),
      ),
      body: Container(
        // Background color and gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromRGBO(229, 208, 172, 1),  // Gradient from top-left
              Colors.white,            // to bottom-right (white)
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 120.0, right: 120), // Add space at the top and left
              child: Opacity(
                opacity: 1, // Adjust opacity to make it subtle
                child: Image.asset(
                  'assets/lion.png',
                  width: double.infinity,
                  fit: BoxFit.contain, // Keeps image at the top
                ),
              ),
            ),

            // Space between image and NIC Decoder elements (Adjust this value)
            const SizedBox(height: 40),

            // Main Content Below the Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const Text(
                    'NIC Decoder',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(193, 70, 0, 1),
                      fontFamily: 'Arial', 
                    ),
                  ),

                  // Space Between Title & Input
                  const SizedBox(height: 20),

                  // NIC Input Field
                  TextField(
                    controller: controller.nicController,
                    decoration: InputDecoration(
                      labelText: 'Enter NIC Number',
                      labelStyle: const TextStyle(color: Color.fromRGBO(193, 70, 0, 1)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color.fromRGBO(255, 110, 64, 1), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 20),

                  // Decode Button
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
                      String nic = controller.nicController.text.trim();
                      if (nic.isNotEmpty && (nic.length == 10 || nic.length == 12)) {
                        if (nic.length == 10) {
                          // Check if first 9 characters are digits and last character is either 'X' or 'F'
                          if (RegExp(r'^\d{9}[XxVv]$').hasMatch(nic)) {
                            controller.decodeNIC(nic);
                            Get.toNamed('/result')!.then((_) {
                              controller.nicController.clear();
                            });
                          } else {
                            Get.snackbar("Invalid NIC", "Try Again");
                          }
                        } else if (nic.length == 12) {
                          // Check if all characters are digits
                          if (RegExp(r'^\d{12}$').hasMatch(nic)) {
                            controller.decodeNIC(nic);
                            Get.toNamed('/result')!.then((_) {
                              controller.nicController.clear();
                            });
                          } else {
                            Get.snackbar("Invalid NIC", "Try Again");
                          }
                        }
                      } else {
                        Get.snackbar("Invalid NIC", "Please enter a valid NIC number.");
                      }
                                          },
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : const Text('Decode'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
