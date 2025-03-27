import 'package:flutter/material.dart';
import 'package:tragnambo/models/data_models.dart';
import 'package:tragnambo/services/connection_db.dart';

class DataTableWidget extends StatefulWidget {
  final Future<List<DataModels>> futureFilteredMembers;
  final ApiService apiService;
  final VoidCallback onDeleteSuccess;
  final Function(DataModels) onEditRequest;

  const DataTableWidget({
    super.key,
    required this.futureFilteredMembers,
    required this.apiService,
    required this.onDeleteSuccess,
    required this.onEditRequest,
  });

  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: FutureBuilder<List<DataModels>>(
            future: widget.futureFilteredMembers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Aucune donnée disponible'));
              }

              final filteredMembers = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: 24,
                    headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Matricule',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Nom',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Prenom',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Téléphone',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Logement',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Etablissement',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Niveau',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Promotion',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Statut',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Actions',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: filteredMembers.map((member) {
                      return DataRow(
                        cells: [
                          DataCell(Text(member.numero_matricule)),
                          DataCell(Text(member.nom)),
                          DataCell(Text(member.prenom)),
                          DataCell(Text(member.contact)),
                          DataCell(Text(member.logement)),
                          DataCell(Text(member.etablissement)),
                          DataCell(Text(member.niveau)),
                          DataCell(Text(member.promotion)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: member.status.trimRight() == 'Doyen(ne)'
                                    ? Colors.red[50]
                                    : member.status.trimRight() == 'Ancien(ne)'
                                        ? Colors.blue[50]
                                        : member.status.trimRight() == 'Novice'
                                            ? Colors.green[50]
                                            : Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                member.status,
                                style: TextStyle(
                                  color: member.status.trimRight() == 'Doyen(ne)'
                                      ? Colors.red[700]
                                      : member.status.trimRight() == 'Ancien(ne)'
                                          ? Colors.blue[700]
                                          : member.status.trimRight() == 'Novice'
                                              ? Colors.green[700]
                                              : Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue, size: 20),
                                  onPressed: () {
                                    widget.onEditRequest(member);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red, size: 20),
                                  onPressed: () =>
                                      _showDeleteConfirmation(context, member),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, DataModels member) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          title: const Text('Confirmer la suppression'),
          content: Text(
              'Êtes-vous sûr de vouloir supprimer l\'étudiant ${member.prenom} ${member.nom} ?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await widget.apiService.deleteData(member.numero_matricule);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Étudiant supprimé avec succès'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    widget.onDeleteSuccess();
                  }
                } catch (e) {
                  debugPrint('Erreur lors de la suppression: ${e.toString()}');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Erreur lors de la suppression: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
