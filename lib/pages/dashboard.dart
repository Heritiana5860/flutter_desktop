import 'package:flutter/material.dart';
import 'package:tragnambo/components/dashboard_card/cards.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = 300.0;
    final availableWidth = screenSize.width - 48.0;
    (availableWidth / (cardWidth + 20.0)).floor();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tableau de Bord",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Ouvrir les paramètres
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                const Text(
                  'Bienvenue',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Gérez nos membres facilement',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 40),

                // Section principale - Limité à deux lignes
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Première ligne
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildDashboardCard(
                              context,
                              '/formpage',
                              'Ajouter\nun membre',
                              Icons.person_add,
                            ),
                            const SizedBox(width: 20),
                            _buildDashboardCard(
                              context,
                              '/liste',
                              'Voir\nla liste\ndes membres',
                              Icons.list_alt,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Deuxième ligne
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildDashboardCard(
                              context,
                              '/stats',
                              'Statistiques',
                              Icons.bar_chart,
                            ),
                            const SizedBox(width: 20),
                            _buildDashboardCard(
                              context,
                              '/settings',
                              'Paramètres',
                              Icons.settings,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String route,
    String label,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          NeonGradientCardDemo(
            onTap: () => Navigator.pushNamed(context, route),
            label: label,
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFF00AA),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
