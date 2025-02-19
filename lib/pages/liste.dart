import 'package:flutter/material.dart';
import 'package:tragnambo/components/data_table.dart';
import 'package:tragnambo/models/data_models.dart';
import 'package:tragnambo/pages/form_page.dart';
import 'package:tragnambo/services/connection_db.dart';

class MembersList extends StatefulWidget {
  const MembersList({super.key});

  @override
  State<MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = "";
  late Future<Map<String, dynamic>> futureData;
  final ApiService _apiService = ApiService();
  int totalMembers = 0;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      futureData = _apiService.getAllData();
    });
  }

  // Exemple de données
  Future<List<DataModels>> getFilteredMembers() async {
    final data = await futureData;
    final List<DataModels> membersList = data["etudiants"];
    totalMembers = data['total'];

    if (_searchQuery.isEmpty) return membersList;
    return membersList.where((member) {
      return member.nom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          member.prenom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          member.contact.contains(_searchQuery) ||
          member.logement.contains(_searchQuery) ||
          member.promotion.contains(_searchQuery) ||
          member.etablissement.contains(_searchQuery) ||
          member.niveau.contains(_searchQuery) ||
          member.contact.contains(_searchQuery) ||
          member.status.contains(_searchQuery) ||
          member.numero_matricule.contains(_searchQuery);
    }).toList();
  }

  Future<void> _editMember(DataModels member) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormPage(studentToEdit: member),
      ),
    );
    if (result == true) {
      _refreshData();
    }
  }

  void _exportToPDF() {
    // Implémenter la logique d'export PDF ici
  }

  void _exportToDoc() {
    // Implémenter la logique d'export DOC ici
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/dashboard");
                    },
                    icon: Icon(Icons.arrow_back)),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                          _isSearching = value.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Rechercher un membre...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _isSearching
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = "";
                                    _isSearching = false;
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'pdf') {
                      _exportToPDF();
                    } else if (value == 'doc') {
                      _exportToDoc();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.download, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Exporter',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'pdf',
                      child: Row(
                        children: [
                          Icon(Icons.picture_as_pdf),
                          SizedBox(width: 8),
                          Text('Exporter en PDF'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'doc',
                      child: Row(
                        children: [
                          Icon(Icons.document_scanner),
                          SizedBox(width: 8),
                          Text('Exporter en DOC'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          DataTableWidget(
            futureFilteredMembers: getFilteredMembers(),
            apiService: _apiService,
            onDeleteSuccess: _refreshData,
            onEditRequest: _editMember,
          ),
        ],
      ),
    );
  }
}
