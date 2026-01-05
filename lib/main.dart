import 'package:flutter/material.dart';

// ==========================================
// 1. DATA MODEL
// ==========================================
class DonationItem {
  final String id;
  final String foodItem;
  final String quantity;
  final String description;
  final DateTime timestamp;
  bool isClaimed;

  DonationItem({
    required this.id,
    required this.foodItem,
    required this.quantity,
    required this.description,
    required this.timestamp,
    this.isClaimed = false,
  });
}

// ==========================================
// 2. MAIN ENTRY
// ==========================================
void main() {
  runApp(const AnapoornaApp());
}

class AnapoornaApp extends StatelessWidget {
  const AnapoornaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anapoorna',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light grey bg
        // REMOVED cardTheme to prevent Type Error
      ),
      home: const LoginScreen(),
    );
  }
}

// ==========================================
// 3. LOGIN SCREEN
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500)); // Fake network delay
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainAppScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)], // Green gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.volunteer_activism, size: 100, color: Colors.white),
            const SizedBox(height: 16),
            const Text(
              "Anapoorna",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const Text(
              "Bridge Hunger with Hope",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 60),
            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ElevatedButton.icon(
                      onPressed: _handleLogin,
                      icon: const Icon(Icons.login),
                      label: const Text("Enter Platform"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green[800],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 50),
                        elevation: 5,
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: const Text("Create Account", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. MAIN APP SCREEN
// ==========================================
class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  // Local State "Database"
  final List<DonationItem> _donations = [
    DonationItem(
      id: '1',
      foodItem: 'Veg Biryani & Raitha',
      quantity: '15 Packets',
      description: 'Leftover from corporate lunch. Freshly packed.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    DonationItem(
      id: '2',
      foodItem: 'Bread & Jam',
      quantity: '10 Loaves',
      description: 'Bakery surplus. Good for breakfast.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isClaimed: true,
    ),
  ];

  void _addDonation(DonationItem item) {
    setState(() {
      _donations.insert(0, item);
    });
  }

  void _toggleClaim(int index) {
    setState(() {
      _donations[index].isClaimed = !_donations[index].isClaimed;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine which page to show
    final List<Widget> pages = [
      HomeFeed(
        donations: _donations,
        onToggleClaim: _toggleClaim,
      ),
      ProfileView(totalDonations: _donations.length),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? "Live Donations" : "My Profile"),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.red),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
          ),
        ],
      ),
      body: pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showAddModal(context),
              label: const Text("Donate"),
              icon: const Icon(Icons.add_location_alt),
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _showAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => AddDonationForm(onSubmit: _addDonation),
    );
  }
}

// ==========================================
// 5. HOME FEED WIDGET
// ==========================================
class HomeFeed extends StatelessWidget {
  final List<DonationItem> donations;
  final Function(int) onToggleClaim;

  const HomeFeed({
    super.key,
    required this.donations,
    required this.onToggleClaim,
  });

  @override
  Widget build(BuildContext context) {
    if (donations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 60, color: Colors.grey),
            SizedBox(height: 10),
            Text("No donations yet!", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 80),
      itemCount: donations.length,
      itemBuilder: (context, index) {
        final item = donations[index];
        return Card(
          elevation: 2, // Manually setting elevation since we removed theme
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: item.isClaimed ? Colors.grey[200] : Colors.green[50],
                      radius: 24,
                      child: Icon(
                        Icons.restaurant,
                        color: item.isClaimed ? Colors.grey : Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.foodItem,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: item.isClaimed ? TextDecoration.lineThrough : null,
                              color: item.isClaimed ? Colors.grey : Colors.black87,
                            ),
                          ),
                          Text(
                            "Posted just now",
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.isClaimed ? Colors.grey[200] : Colors.green[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.isClaimed ? "CLAIMED" : "AVAILABLE",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: item.isClaimed ? Colors.grey[700] : Colors.green[800],
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(item.quantity, style: const TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: item.isClaimed
                      ? OutlinedButton(
                          onPressed: () => onToggleClaim(index),
                          child: const Text("Undo Claim (Demo Only)"),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            onToggleClaim(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("You claimed ${item.foodItem}!"),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Claim Donation"),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==========================================
// 6. ADD DONATION FORM
// ==========================================
class AddDonationForm extends StatefulWidget {
  final Function(DonationItem) onSubmit;
  const AddDonationForm({super.key, required this.onSubmit});

  @override
  State<AddDonationForm> createState() => _AddDonationFormState();
}

class _AddDonationFormState extends State<AddDonationForm> {
  final _formKey = GlobalKey<FormState>();
  String food = '', qty = '', desc = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final newItem = DonationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        foodItem: food,
        quantity: qty,
        description: desc,
        timestamp: DateTime.now(),
      );

      widget.onSubmit(newItem);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Donation posted successfully!"), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24, 
        right: 24, 
        top: 24, 
        bottom: MediaQuery.of(context).viewInsets.bottom + 24
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("New Donation", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Food Item', 
                hintText: 'e.g., Rice, Curry',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.fastfood_outlined),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
              onSaved: (v) => food = v!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Quantity', 
                hintText: 'e.g., 5 kg, 10 packets',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.shopping_bag_outlined),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
              onSaved: (v) => qty = v!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Description', 
                hintText: 'Any specific details...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.description_outlined),
              ),
              onSaved: (v) => desc = v ?? '',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Post Donation"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 7. PROFILE VIEW
// ==========================================
class ProfileView extends StatelessWidget {
  final int totalDonations;
  const ProfileView({super.key, required this.totalDonations});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.green,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text("Demo User", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("Verified Donor", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
          const SizedBox(height: 32),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem("Donations", "$totalDonations"),
              _buildStatItem("Impact", "${totalDonations * 5} ppl"),
              _buildStatItem("Rating", "4.8 ★"),
            ],
          ),
          const SizedBox(height: 32),

          // Menu Options
          _buildMenuOption(Icons.history, "History"),
          _buildMenuOption(Icons.settings, "Settings"),
          _buildMenuOption(Icons.help_outline, "Help & Support"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildMenuOption(IconData icon, String title) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      surfaceTintColor: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}