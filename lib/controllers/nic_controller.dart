import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/nic_parser.dart';

class NicController extends GetxController {
  var nicFormat = ''.obs;
  var birthDate = ''.obs;
  var age = 0.obs;
  var weekday = ''.obs;
  var gender = ''.obs;
  var votingStatus = ''.obs; // Added voting status
  final TextEditingController nicController = TextEditingController(); // Added TextEditingController

  void decodeNIC(String nic) {
    Map<String, dynamic> details = NicParser.parseNIC(nic);
    nicFormat.value = details['format'];
    birthDate.value = details['dob'];
    age.value = details['age'];
    weekday.value = details['weekday'];
    gender.value = details['gender'];

    // Determine voting eligibility for old NICs
    if (nicFormat.value == 'Old NIC (9 digits)') {
      votingStatus.value = details['voting_status'];
    } else {
      votingStatus.value = ''; // Reset if it's not an old NIC
    }
  }

  @override
  void onClose() {
    nicController.clear(); // Clear NIC input when controller is disposed
    super.onClose();
  }
}
