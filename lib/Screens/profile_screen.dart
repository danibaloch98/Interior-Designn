import 'package:flutter/material.dart';
import 'package:interior_design_project/Screens/order_history_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = "";
  String _email = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "Unknown User";
      _email = prefs.getString('email') ?? "No Email";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/profile.png"), // Replace with network image
                  ),
                  const SizedBox(height: 10),
                  Text(_username, style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 3),
                  Text(_email, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),

            // Profile Options
            _buildProfileOption(Icons.shopping_bag, "My Orders", () {
              Navigator.push(context, MaterialPageRoute(builder:(context)=>OrderHistoryScreen()) );
            }),
            _buildProfileOption(Icons.location_on, "Saved Addresses", () {
             Navigator.push(context, MaterialPageRoute(builder:(context)=>AddressScreen()) );
            }),
            _buildProfileOption(Icons.settings, "Settings", () {}),
            _buildProfileOption(Icons.help_outline, "Help & Support", () {}),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text("Logout", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
      onTap: onTap,
    );
  }
}
class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _streetController.text = prefs.getString('address_street') ?? '';
      _cityController.text = prefs.getString('address_city') ?? '';
      _zipController.text = prefs.getString('address_zip') ?? '';
      _countryController.text = prefs.getString('address_country') ?? '';
    });
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('address_street', _streetController.text.trim());
    await prefs.setString('address_city', _cityController.text.trim());
    await prefs.setString('address_zip', _zipController.text.trim());
    await prefs.setString('address_country', _countryController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Address saved successfully')),
    );
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Address")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_streetController, "Street", Icons.home),
              const SizedBox(height: 15),
              _buildTextField(_cityController, "City", Icons.location_city),
              const SizedBox(height: 15),
              _buildTextField(_zipController, "Zip Code", Icons.markunread_mailbox, isNumber: true),
              const SizedBox(height: 15),
              _buildTextField(_countryController, "Country", Icons.flag),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveAddress,
                child: const Text("Save Address"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        bool isNumber = false,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) => value == null || value.trim().isEmpty ? "$label is required" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}