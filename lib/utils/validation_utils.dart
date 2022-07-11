import '../constants/app_constants.dart';
import '../constants/regex_constants.dart';

class ValidationUtils
{

  // empty check for task
  static validateTaskIfEmptyOnly(String username)
  {
    if(username.trim().length == 0)
    {
      return AppConstants.enterTaskString;
    }
    return null;
  }

  // empty check for assignee
  static validateAssigneeIfEmptyOnly(String assignee)
  {
    if(assignee.trim().length == 0)
    {
      return AppConstants.enterAssigneeString;
    }
    return null;
  }

  // empty check for email
  static validateEmailIfEmptyOnly(String email)
  {
    if(email.trim().length == 0)
    {
      return AppConstants.enterValidEmailString;
    }
    return null;
  }

  // empty check for phone number
  static validatePhoneNumberIfEmptyOnly(String phoneNumber)
  {
    bool phoneNumberValid = RegExp(RegexConstants.phoneNumberRegex).hasMatch(phoneNumber);
    if(phoneNumber == "")
    {
      return AppConstants.enterValidContactNumberString;
    }
    else if (!phoneNumberValid) {
      return AppConstants.enterValidContactNumberString;
    }
    return null;
  }
}