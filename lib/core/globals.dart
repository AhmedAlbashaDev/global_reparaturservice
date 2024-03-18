// baseUrl

String baseUrl = 'https://smart-intercom.de/api/';
// String baseUrl = 'https://workshop.anothercars.com/api/';


// Media Query Screen Sizes

late double screenHeight;
late double screenWidth;

// Validate Email
bool isValidEmail({String? text}) {

  const String emailPattern = r"^((([a-z]|[A-Z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";

  RegExp regExp = RegExp(emailPattern);

  return regExp.hasMatch(text ?? '');
}

// Validate Phone Number
bool isNumeric(String? s) {
  if(s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

// Google Map API Key

// const kGoogleApiKey = "AIzaSyBrfjwqJ1lK61Q_SpHjz4aIjjdh9Oh96eA";
// const kGoogleApiKey = "AIzaSyAy2tmmHCmR0pej48ZGs6Grhjd-vI34EFg";
const kGoogleApiKey = "AIzaSyDGvpd0TiZ8YtuLWlpZ8ZYzSZEtasSUrEs";
//AIzaSyC95kdIk-zL-KFFysNUC5GQKDnbx7wYmqE
//AIzaSyBRlt7gIugQ9Hs726pgbfD6YRMcdmW4bRM


/// Center Location
///
String centerLat = '52.5200';
String centerLng = '13.4050';


//Maximum File Size
int maxFileSize = 30 * 1048576;