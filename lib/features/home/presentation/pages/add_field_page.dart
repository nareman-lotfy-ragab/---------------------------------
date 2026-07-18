import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/services/api_service.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddFieldPage extends StatefulWidget {
  const AddFieldPage({super.key});

  @override
  State<AddFieldPage> createState() => _AddFieldPageState();
}

class _AddFieldPageState extends State<AddFieldPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _acresController = TextEditingController();
  
  String? _selectedGovernment;
  String? _selectedCity;
  bool _isLoading = false;
  @override
void initState() {
  super.initState();

  _governments = _egyptData.keys.toList()..sort();
}
  late final List<String> _governments;

  final Map<String, List<String>> _egyptData = {
  "Cairo": [
    "Nasr City",
    "Heliopolis",
    "Maadi",
    "New Cairo",
    "Shubra",
    "Ain Shams",
    "El Marg",
    "Helwan",
    "El Salam",
    "Mokattam",
    "Downtown",
    "Zamalek",
    "Garden City",
    "El Rehab",
    "Badr"
  ],

  "Giza": [
    "6th of October",
    "Sheikh Zayed",
    "Dokki",
    "Haram",
    "Faisal",
    "Agouza",
    "Mohandessin",
    "Imbaba",
    "Bulaq",
    "Kerdasa",
    "Abu Rawash",
    "Hawamdeya",
    "El Saf",
    "Atfih"
  ],

  "Alexandria": [
    "Smouha",
    "Sidi Gaber",
    "Stanley",
    "Miami",
    "Mandara",
    "Agami",
    "Borg El Arab",
    "Montaza",
    "Gleem",
    "Raml Station",
    "Sporting",
    "Victoria"
  ],

  "Dakahlia": [
    "Mansoura",
    "Talkha",
    "Mit Ghamr",
    "Belqas",
    "Sherbin",
    "Dekernes",
    "Aga",
    "El Senbellawein",
    "Gamasa"
  ],

  "Sharqia": [
    "Zagazig",
    "10th of Ramadan",
    "Belbeis",
    "Abu Hammad",
    "Minya El Qamh",
    "Faqous",
    "Kafr Saqr",
    "Husseiniya"
  ],

  "Beheira": [
    "Damanhur",
    "Kafr El Dawwar",
    "Rashid",
    "Edku",
    "Abu Hummus",
    "Kom Hamada",
    "Itay El Barud",
    "Shubrakhit"
  ],

  "Beni Suef": [
    "Beni Suef",
    "Nasser",
    "Ehnasia",
    "Biba",
    "El Fashn",
    "Somosta",
    "Al Wasta"
  ],

  "Fayoum": [
    "Fayoum",
    "Senouris",
    "Ibshaway",
    "Tamiya",
    "Youssef El Seddik",
    "Itsa"
  ],

  "Minya": [
    "Minya",
    "Mallawi",
    "Samalut",
    "Beni Mazar",
    "Maghagha",
    "Abu Qurqas",
    "Deir Mawas"
  ],

  "Assiut": [
    "Assiut",
    "Dairut",
    "Manfalut",
    "Abnoub",
    "El Badari",
    "Abu Tig",
    "Sahel Selim"
  ],

  "Sohag": [
    "Sohag",
    "Tahta",
    "Akhmim",
    "Girga",
    "El Balyana",
    "Juhayna"
  ],

  "Qena": [
    "Qena",
    "Qus",
    "Nag Hammadi",
    "Deshna",
    "Farshut"
  ],

  "Luxor": [
    "Luxor",
    "Esna",
    "Armant",
    "El Tod",
    "Qurna"
  ],

  "Aswan": [
    "Aswan",
    "Kom Ombo",
    "Edfu",
    "Daraw",
    "Abu Simbel"
  ],

  "Ismailia": [
    "Ismailia",
    "Fayed",
    "Qantara East",
    "Qantara West",
    "Abu Suwir"
  ],

  "Port Said": [
    "Port Said",
    "Port Fouad"
  ],

  "Suez": [
    "Suez",
    "Ataqah",
    "Arbaeen",
    "Ganayen"
  ],

  "North Sinai": [
    "Arish",
    "Bir El Abd",
    "Sheikh Zuweid",
    "Rafah",
    "Nakhl"
  ],

  "South Sinai": [
    "Sharm El Sheikh",
    "Dahab",
    "Nuweiba",
    "Taba",
    "Saint Catherine",
    "El Tor"
  ],

  "Red Sea": [
    "Hurghada",
    "Safaga",
    "El Quseir",
    "Marsa Alam",
    "Ras Gharib"
  ],

  "Matrouh": [
    "Marsa Matrouh",
    "El Alamein",
    "Siwa",
    "Sallum"
  ],

  "Kafr El Sheikh": [
    "Kafr El Sheikh",
    "Desouk",
    "Baltim",
    "Fuwwah",
    "Sidi Salem"
  ],

  "Gharbia": [
    "Tanta",
    "El Mahalla",
    "Kafr El Zayat",
    "Zefta",
    "Basyoun"
  ],

  "Monufia": [
    "Shebin El Kom",
    "Menouf",
    "Ashmoun",
    "Quesna",
    "Sadat City"
  ],

  "Damietta": [
    "Damietta",
    "New Damietta",
    "Ras El Bar",
    "Kafr Saad",
    "Ezbet El Borj"
  ]
};
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedGovernment == null || _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);

    final userId = int.tryParse(ApiService.currentUserId ?? '0') ?? 0;
    
    final fieldData = {
      "id": 0,
      "userId": userId,
      "field_Name": _nameController.text,
      "acres": double.tryParse(_acresController.text) ?? 0.0,
      "status": "Active",
      "quality": "Good",
      "government": _selectedGovernment,
      "city": _selectedCity
    };

    try {
      final result = await ApiService.addField(fieldData);
      if (result['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Field added successfully!'), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${result['message']}'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add New Field', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Field Name', _nameController, 'e.g. North Farm'),
              const SizedBox(height: 16),
              _buildTextField('Area (Acres)', _acresController, 'e.g. 10.5', isNumber: true),
              const SizedBox(height: 16),
              DropdownSearch<String>(
  items: (filter, infiniteScrollProps) => _governments,

  selectedItem: _selectedGovernment,

  popupProps: const PopupProps.menu(
    showSearchBox: true,
    searchFieldProps: TextFieldProps(
      decoration: InputDecoration(
        hintText: "Search Government...",
      ),
    ),
  ),

  decoratorProps: const DropDownDecoratorProps(
    decoration: InputDecoration(
      labelText: "Government",
      border: OutlineInputBorder(),
    ),
  ),

  onChanged: (value) {
    setState(() {
      _selectedGovernment = value;
      _selectedCity = null;
    });
  },
),
              const SizedBox(height: 16),
              DropdownSearch<String>(
  enabled: _selectedGovernment != null,
  items: (filter, infiniteScrollProps) {
  if (_selectedGovernment == null) return [];

  final cities = List<String>.from(
    _egyptData[_selectedGovernment]!,
  )..sort();

  return cities;
},

  selectedItem: _selectedCity,

  popupProps: const PopupProps.menu(
    showSearchBox: true,
    searchFieldProps: TextFieldProps(
      decoration: InputDecoration(
        hintText: "Search City...",
      ),
    ),
  ),

  decoratorProps: const DropDownDecoratorProps(
    decoration: InputDecoration(
      labelText: "City",
      border: OutlineInputBorder(),
    ),
  ),

  onChanged: (value) {
    setState(() {
      _selectedCity = value;
    });
  },
),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: _isLoading ? 'Saving...' : 'Save Field',
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _submit,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, ValueChanged<String?> onChanged, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: enabled ? Colors.grey.shade50 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text('Select $label', style: TextStyle(color: Colors.grey.shade400)),
              items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }
}
