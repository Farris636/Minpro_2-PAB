import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/armada_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/theme_provider.dart';
import 'auth/login_page.dart';
import 'armada_page.dart';
import 'add_armada_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ArmadaProvider>().loadArmada();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArmadaProvider>(context);

    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? "User";

    final username = email.split('@')[0];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Good Morning,",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  PopupMenuButton(
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.orange.shade200,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),

                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(
                              Theme.of(context).brightness == Brightness.dark
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              Theme.of(context).brightness == Brightness.dark
                                  ? "Light Mode"
                                  : "Dark Mode",
                            ),
                          ],
                        ),
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            context.read<ThemeProvider>().toggleTheme();
                          });
                        },
                      ),

                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.logout, size: 20),
                            SizedBox(width: 10),
                            Text("Logout"),
                          ],
                        ),
                        onTap: () async {
                          Future.delayed(Duration.zero, () async {
                            await Supabase.instance.client.auth.signOut();

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Fleet Overview",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 18),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.4,

                children: [
                  dashboardCard(
                    "Total Fleet",
                    provider.totalFleet.toString(),
                    Colors.blue,
                  ),

                  dashboardCard(
                    "Active",
                    provider.activeCount.toString(),
                    Colors.green,
                  ),

                  dashboardCard(
                    "Maintenance",
                    provider.maintenanceCount.toString(),
                    Colors.orange,
                  ),

                  dashboardCard(
                    "Inactive",
                    provider.inactiveCount.toString(),
                    Colors.grey,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Quick Actions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ArmadaPage()),
                        );
                      },
                      child: Container(
                        height: 100,

                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2D6CDF), Color(0xFF1E4DB7)],
                          ),

                          borderRadius: BorderRadius.circular(20),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),

                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(
                              Icons.directions_bus,
                              color: Colors.white,
                              size: 28,
                            ),

                            SizedBox(height: 10),

                            Text(
                              "View Fleet",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddArmadaPage(),
                          ),
                        );
                      },
                      child: actionCard(
                        context,
                        Icons.add_circle_outline,
                        "Add New",
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget dashboardCard(String title, String value, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),

          const Spacer(),

          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget actionCard(BuildContext context, IconData icon, String title) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue, size: 26),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
