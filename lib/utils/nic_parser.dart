import 'package:intl/intl.dart';

class NicParser {
  static Map<String, dynamic> parseNIC(String nic) {
    bool isOldFormat = nic.length == 10;
    bool isNewFormat = nic.length == 12;

    if (!isOldFormat && !isNewFormat) {
      return {'error': 'Invalid NIC format'};
    }

    int birthYear;
    int dayOfYear;
    String gender;
    String? votingStatus;

    if (isOldFormat) {
      birthYear = 1900 + int.parse(nic.substring(0, 2));
      dayOfYear = int.parse(nic.substring(2, 5));

      // Check the last letter for voting status
      String lastChar = nic.substring(9).toUpperCase();
      if (lastChar.toUpperCase() == 'V') {
        votingStatus = 'Can Vote';
      } else if (lastChar.toUpperCase() == 'X') {
        votingStatus = 'Cannot Vote';
      }
    } else {
      birthYear = int.parse(nic.substring(0, 4));
      dayOfYear = int.parse(nic.substring(4, 7));
    }

    // Determine gender and adjust day of year
    if (dayOfYear > 500) {
      gender = 'Female';
      dayOfYear -= 500;
    } else {
      gender = 'Male';
    }

    // Check if the birth year is a leap year
    bool isLeapYear = (birthYear % 4 == 0 && birthYear % 100 != 0) || (birthYear % 400 == 0);

    // Days in each month (adjusting for leap years)
    List<int> daysInMonth = [
      31, // January
      isLeapYear ? 29 : 28, // February
      31, // March
      30, // April
      31, // May
      30, // June
      31, // July
      31, // August
      30, // September
      31, // October
      30, // November
      31  // December
    ];

    // Determine the birth month and day
    int month = 1;
    int day = dayOfYear;

    for (int i = 0; i < 12; i++) {
      if (day > daysInMonth[i]) {
        day -= daysInMonth[i];
        month++;
      } else {
        break;
      }
    }

    // Construct the birth date
    DateTime birthDate = DateTime(birthYear, month, day);
    String dobFormatted = DateFormat('yyyy-MM-dd').format(birthDate);
    String weekday = DateFormat('EEEE').format(birthDate);
    int age = DateTime.now().year - birthYear;

    return {
      'format': isOldFormat ? 'Old NIC (9 digits)' : 'New NIC (12 digits)',
      'dob': dobFormatted,
      'age': age,
      'weekday': weekday,
      'gender': gender,
      if (isOldFormat) 'voting_status': votingStatus, // Include voting status only for old NIC
    };
  }
}
