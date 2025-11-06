import 'package:flutter/material.dart';
import 'order_page.dart';
import 'map_page.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({super.key});

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  String _selectedFilter = 'Tous'; // Filtre sélectionné
  int _currentIndex = 0; // Index pour la bottom navigation

  // Données d'exemple des boutiques
  final List<Map<String, dynamic>> _boutiques = [
    {
      'name': 'Boutique Yopougon Centre',
      'distance': '0.8 km',
      'address': 'Rue Princesse, Yopougon',
      'phone': '+225 07 12 34 56 78',
      'products': [
        {'type': 'B6', 'price': '3500', 'available': true},
        {'type': 'B12', 'price': '6500', 'available': true},
      ],
    },
    {
      'name': 'Gaz Service Cocody',
      'distance': '1.2 km',
      'address': 'Boulevard Latrille, Cocody',
      'phone': '+225 07 23 45 67 89',
      'products': [
        {'type': 'B6', 'price': '3600', 'available': true},
        {'type': 'B12', 'price': '6600', 'available': false},
      ],
    },
    {
      'name': 'ProxiGaz Adjamé',
      'distance': '1.5 km',
      'address': 'Marché Adjamé, Zone 4',
      'phone': '+225 07 34 56 78 90',
      'products': [
        {'type': 'B6', 'price': '3400', 'available': true},
        {'type': 'B12', 'price': '6400', 'available': true},
      ],
    },
    {
      'name': 'Station Gaz Abobo',
      'distance': '2.1 km',
      'address': 'Abobo Gare, Rue 12',
      'phone': '+225 07 45 67 89 01',
      'products': [
        {'type': 'B6', 'price': '3500', 'available': false},
        {'type': 'B12', 'price': '6500', 'available': true},
      ],
    },
    {
      'name': 'Boutique Koumassi Express',
      'distance': '2.8 km',
      'address': 'Koumassi Remblais',
      'phone': '+225 07 56 78 90 12',
      'products': [
        {'type': 'B6', 'price': '3550', 'available': true},
        {'type': 'B12', 'price': '6550', 'available': true},
      ],
    },
  ];

  List<Map<String, dynamic>> get _filteredBoutiques {
    if (_selectedFilter == 'Tous') {
      return _boutiques;
    }
    // Filtrer par type de bouteille disponible
    return _boutiques.where((boutique) {
      return boutique['products'].any((product) =>
          product['type'] == _selectedFilter && product['available'] == true);
    }).toList();
  }

  void _callBoutique(String phone) {
    // TODO: Implémenter l'appel téléphonique
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appeler $phone')),
    );
  }

  void _orderFromBoutique(Map<String, dynamic> boutique) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderPage(boutique: boutique),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header orange
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 232, 90, 20),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Disponibilité',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Yopougon, Abidjan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Changer de localisation
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Changer de localisation')),
                          );
                        },
                        child: const Text(
                          'Changer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Section filtres
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Icon(Icons.filter_list, color: Colors.grey[700], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Filtrer par taille :',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  _buildFilterButton('Tous'),
                  const SizedBox(width: 8),
                  _buildFilterButton('B6'),
                  const SizedBox(width: 8),
                  _buildFilterButton('B12'),
                ],
              ),
            ),
            // Bouton voir sur la carte
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.location_on, color: Colors.white),
                label: const Text(
                  'Voir sur la carte',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A), // Bleu foncé
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            // Résumé
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    '${_filteredBoutiques.length} boutiques trouvées',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Liste des boutiques
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filteredBoutiques.length,
                itemBuilder: (context, index) {
                  final boutique = _filteredBoutiques[index];
                  return _BoutiqueCard(
                    boutique: boutique,
                    onCall: () => _callBoutique(boutique['phone']),
                    onOrder: () => _orderFromBoutique(boutique),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomNavItem(
                  icon: Icons.home,
                  label: 'Accueil',
                  isActive: _currentIndex == 0,
                  onTap: () {
                    setState(() => _currentIndex = 0);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
                _BottomNavItem(
                  icon: Icons.map,
                  label: 'Carte',
                  isActive: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nouvelle annonce')),
                    );
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 232, 90, 20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                _BottomNavItem(
                  icon: Icons.shopping_bag,
                  label: 'Commande',
                  isActive: _currentIndex == 3,
                  onTap: () => setState(() => _currentIndex = 3),
                ),
                _BottomNavItem(
                  icon: Icons.person,
                  label: 'Profil',
                  isActive: _currentIndex == 4,
                  onTap: () => setState(() => _currentIndex = 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromARGB(255, 232, 90, 20) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Color.fromARGB(255, 232, 90, 20): Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _BoutiqueCard extends StatelessWidget {
  final Map<String, dynamic> boutique;
  final VoidCallback onCall;
  final VoidCallback onOrder;

  const _BoutiqueCard({
    required this.boutique,
    required this.onCall,
    required this.onOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec nom et badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  boutique['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.shade300, width: 1),
                ),
                child: Text(
                  'Disponible',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Distance et adresse
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey[600], size: 16),
              const SizedBox(width: 4),
              Text(
                boutique['distance'],
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            boutique['address'],
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          // Liste des produits
          ...boutique['products'].map<Widget>((product) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  // Icône B6 ou B12
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Center(
                      child: Text(
                        product['type'],
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Bouteille ${product['type']}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '${product['price']} FCFA',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 232, 90, 20),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: product['available']
                          ? Colors.green
                          : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 16),
          // Boutons d'action
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCall,
                  icon: Icon(Icons.phone, color: Colors.grey[700], size: 20),
                  label: Text(
                    'Appeler',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 232, 90, 20),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Commander',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Color.fromARGB(255, 232, 90, 20) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Color.fromARGB(255, 232, 90, 20): Colors.grey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

