import 'package:get/get.dart';

class LocalString extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'hi_IN': {
          'hello': 'नमस्ते', //hindi
          'message': "यह संदेश है",
          'title': 'सेंसर ऐप',
          'water': 'जल',
          'gas': 'हवा',
          'soil': 'मिट्टी',
          'CO2':'कार्बन डाइआक्साइड',
          'SO2': 'सल्फर डाइऑक्साइड',
          'NO2': 'नाइट्रोजन डाइऑक्साइड',
          'Concentration':'एकाग्रता',
          'Pure':'शुद्ध',
          "Good":'ठीक',
          "Moderate":"मध्यम",
          "Unhealthy": "अस्वस्थ",
          "Hazardous": "खतरनाक",
        },
        'en_US': {
          'hello': 'Welcome', //englishwater

          'message': "this is message",
          "title": "Sensor App",
          'water': 'water',
          'gas': 'gas',
          'soil': 'soil',
          'CO2':'Carbon Dioxide',
          'SO2': 'Sulphur Dioxide',
          'NO2': 'Nitrogen Dioxide',
          'Concentration':'Concentration',
          'Pure':'Pure',
          "Good":'Good',
          "Moderate":"Moderate",
          "Unhealthy": "Unhealthy",
          "Hazardous": "Hazardous",
        },
      };
}
