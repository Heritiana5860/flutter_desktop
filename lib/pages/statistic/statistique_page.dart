import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tragnambo/pages/statistic/build_legend_item.dart';
import 'package:tragnambo/pages/statistic/build_stat_card.dart';
import 'package:tragnambo/services/connection_db.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  // Filtre de période sélectionnée
  String _selectedPeriod = 'Mois';
  final List<String> _periods = ['Semaine', 'Mois', 'Trimestre', 'Année'];

  final ApiService apiService = ApiService();
  Map<String, dynamic>? _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await apiService.getAllData();
      setState(() {
        _data = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Gérer l'erreur selon vos besoins
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Statistiques",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Période sélectionnée
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Aperçu des statistiques',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPeriod,
                            items: _periods.map((String period) {
                              return DropdownMenuItem<String>(
                                value: period,
                                child: Text(period),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedPeriod = newValue!;
                              });
                            },
                            icon: const Icon(Icons.keyboard_arrow_down),
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Cartes de résumé - Adaptative pour petits écrans
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                        return Column(
                          children: [
                            FutureBuilder(
                                future: apiService.getAllData(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final total = snapshot.data!['total'];
                                    return BuildStatCard(
                                        title: 'Total membres',
                                        value: total.toString(),
                                        icon: Icons.people,
                                        color: Colors.blue[700]!,
                                        subtitle: '+24 ce mois');
                                  } else if (snapshot.hasError) {
                                    return BuildStatCard(
                                        title: 'Total membres',
                                        value: "Erreur",
                                        icon: Icons.error,
                                        color: Colors.red[700]!,
                                        subtitle:
                                            'Impossible de charger les données');
                                  }

                                  return BuildStatCard(
                                      title: 'Total membres',
                                      value: "...",
                                      icon: Icons.people,
                                      color: Colors.blue[700]!,
                                      subtitle: 'Chargement...');
                                }),
                            const SizedBox(height: 16),
                            BuildStatCard(
                                title: 'Taux de participation',
                                value: '78%',
                                icon: Icons.trending_up,
                                color: Colors.green[700]!,
                                subtitle: '+5% depuis dernier mois'),
                            const SizedBox(height: 16),
                            BuildStatCard(
                                title: 'Status moyen',
                                value: '32 ans',
                                icon: Icons.calendar_today,
                                color: Colors.orange[700]!,
                                subtitle: 'Stable depuis 3 mois'),
                            const SizedBox(height: 16),
                            BuildStatCard(
                                title: 'Membres actifs',
                                value: '289',
                                icon: Icons.directions_run,
                                color: Colors.purple[700]!,
                                subtitle: '81% du total'),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Row(
                              children: [
                                FutureBuilder(
                                    future: apiService.getAllData(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final total = snapshot.data!['total'];
                                        return Expanded(
                                          child: BuildStatCard(
                                              title: 'Total membres',
                                              value: total.toString(),
                                              icon: Icons.people,
                                              color: Colors.blue[700]!,
                                              subtitle: '+24 ce mois'),
                                        );
                                      } else if (snapshot.hasError) {
                                        return BuildStatCard(
                                            title: 'Total membres',
                                            value: "Erreur",
                                            icon: Icons.error,
                                            color: Colors.red[700]!,
                                            subtitle:
                                                'Impossible de charger les données');
                                      }

                                      return BuildStatCard(
                                          title: 'Total membres',
                                          value: "...",
                                          icon: Icons.people,
                                          color: Colors.blue[700]!,
                                          subtitle: 'Chargement...');
                                    }),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: BuildStatCard(
                                      title: 'Taux de participation',
                                      value: '78%',
                                      icon: Icons.trending_up,
                                      color: Colors.green[700]!,
                                      subtitle: '+5% depuis dernier mois'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: BuildStatCard(
                                      title: 'Membre moyenne',
                                      value: 'Ancien(ne)',
                                      icon: Icons.calendar_today,
                                      color: Colors.orange[700]!,
                                      subtitle: 'Stable depuis 3 mois'),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: BuildStatCard(
                                      title: 'Membres actifs',
                                      value: '289',
                                      icon: Icons.directions_run,
                                      color: Colors.purple[700]!,
                                      subtitle: '81% du total'),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 32),

                  // Graphique d'évolution des inscriptions
                  Text(
                    'Évolution des inscriptions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 250,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: LineChart(
                      _membershipLineChartData(),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Distribution par catégorie
                  Text(
                    'Distribution par catégorie',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 250,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 500) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 140,
                                child: PieChart(
                                  _membershipPieChartData({
                                    'total_doyen': _data!['total_doyen'],
                                    'total_ancien': _data!['total_ancien'],
                                    'total_novice': _data!['total_novice'],
                                  }),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FutureBuilder(
                                            future: apiService.getAllData(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final totalDoyen = snapshot
                                                    .data!['total_doyen'];
                                                return BuildLegendItem(
                                                    label: 'Doyen(ne)',
                                                    color: Colors.blue[400]!,
                                                    count: '$totalDoyen');
                                              } else if (snapshot.hasError) {
                                                return BuildLegendItem(
                                                    label: 'Doyen(ne)',
                                                    color: Colors.red[400]!,
                                                    count: 'Error');
                                              }

                                              return BuildLegendItem(
                                                  label: 'Doyen(ne)',
                                                  color: Colors.blue[400]!,
                                                  count: '...');
                                            }),
                                        const SizedBox(height: 8),
                                        FutureBuilder(
                                            future: apiService.getAllData(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final totalAncien = snapshot
                                                    .data!['total_ancien'];
                                                return BuildLegendItem(
                                                    label: 'Ancien(ne)',
                                                    color: Colors.green[400]!,
                                                    count: '$totalAncien');
                                              } else if (snapshot.hasError) {
                                                return BuildLegendItem(
                                                    label: 'Ancien(ne)',
                                                    color: Colors.red[400]!,
                                                    count: 'Error');
                                              }

                                              return BuildLegendItem(
                                                  label: 'Ancien(ne)',
                                                  color: Colors.blue[400]!,
                                                  count: '...');
                                            }),
                                        const SizedBox(height: 8),
                                        FutureBuilder(
                                            future: apiService.getAllData(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final totalNovice = snapshot
                                                    .data!['total_novice'];
                                                return BuildLegendItem(
                                                    label: 'Novice',
                                                    color: Colors.orange[400]!,
                                                    count: '$totalNovice');
                                              } else if (snapshot.hasError) {
                                                return BuildLegendItem(
                                                    label: 'Novice',
                                                    color: Colors.red[400]!,
                                                    count: 'Error');
                                              }

                                              return BuildLegendItem(
                                                  label: 'Novice',
                                                  color: Colors.blue[400]!,
                                                  count: '...');
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: PieChart(
                                  _membershipPieChartData({
                                    'total_doyen': _data!['total_doyen'],
                                    'total_ancien': _data!['total_ancien'],
                                    'total_novice': _data!['total_novice'],
                                  }),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder(
                                        future: apiService.getAllData(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final totalDoyen =
                                                snapshot.data!['total_doyen'];
                                            return BuildLegendItem(
                                                label: 'Doyen(ne)',
                                                color: Colors.blue[400]!,
                                                count: '$totalDoyen');
                                          } else if (snapshot.hasError) {
                                            return BuildLegendItem(
                                                label: 'Doyen(ne)',
                                                color: Colors.red[400]!,
                                                count: 'Error');
                                          }

                                          return BuildLegendItem(
                                              label: 'Doyen(ne)',
                                              color: Colors.blue[400]!,
                                              count: '...');
                                        }),
                                    const SizedBox(height: 12),
                                    FutureBuilder(
                                        future: apiService.getAllData(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final totalAncien =
                                                snapshot.data!['total_ancien'];
                                            return BuildLegendItem(
                                                label: 'Ancien(ne)',
                                                color: Colors.green[400]!,
                                                count: '$totalAncien');
                                          } else if (snapshot.hasError) {
                                            return BuildLegendItem(
                                                label: 'Ancien(ne)',
                                                color: Colors.red[400]!,
                                                count: 'Error');
                                          }

                                          return BuildLegendItem(
                                              label: 'Ancien(ne)',
                                              color: Colors.blue[400]!,
                                              count: '...');
                                        }),
                                    const SizedBox(height: 12),
                                    FutureBuilder(
                                        future: apiService.getAllData(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final totalNovice =
                                                snapshot.data!['total_novice'];
                                            return BuildLegendItem(
                                                label: 'Novice',
                                                color: Colors.orange[400]!,
                                                count: '$totalNovice');
                                          } else if (snapshot.hasError) {
                                            return BuildLegendItem(
                                                label: 'Novice',
                                                color: Colors.red[400]!,
                                                count: 'Error');
                                          }

                                          return BuildLegendItem(
                                              label: 'Novice',
                                              color: Colors.blue[400]!,
                                              count: '...');
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  LineChartData _membershipLineChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 50,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[200],
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              switch (value.toInt()) {
                case 0:
                  return const Text('Jan');
                case 2:
                  return const Text('Mar');
                case 4:
                  return const Text('Mai');
                case 6:
                  return const Text('Juil');
                case 8:
                  return const Text('Sep');
                case 10:
                  return const Text('Nov');
                default:
                  return const Text('');
              }
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 50,
            getTitlesWidget: (value, meta) {
              return Text('${value.toInt()}');
            },
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
          left: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 200,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 50),
            FlSpot(1, 55),
            FlSpot(2, 70),
            FlSpot(3, 85),
            FlSpot(4, 100),
            FlSpot(5, 120),
            FlSpot(6, 130),
            FlSpot(7, 135),
            FlSpot(8, 140),
            FlSpot(9, 150),
            FlSpot(10, 165),
            FlSpot(11, 180),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1E88E5).withOpacity(0.8),
              const Color(0xFF1E88E5).withOpacity(0.3),
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1E88E5).withOpacity(0.3),
                const Color(0xFF1E88E5).withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Map<String, double> calculatePercentages({
    required int totalDoyen,
    required int totalAncien,
    required int totalNovice,
  }) {
    final int total = totalDoyen + totalAncien + totalNovice;

    return {
      'doyen': (totalDoyen / total * 100).roundToDouble(),
      'ancien': (totalAncien / total * 100).roundToDouble(),
      'novice': (totalNovice / total * 100).roundToDouble(),
    };
  }

  PieChartData _membershipPieChartData(Map<String, int> counts) {
    final percentages = calculatePercentages(
      totalDoyen: counts['total_doyen']!,
      totalAncien: counts['total_ancien']!,
      totalNovice: counts['total_novice']!,
    );
    return PieChartData(
      startDegreeOffset: 180,
      sectionsSpace: 2,
      centerSpaceRadius: 40,
      sections: [
        PieChartSectionData(
          color: Colors.blue[400],
          value: counts['total_doyen']!.toDouble(),
          title: '${percentages['doyen']}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: Colors.green[400],
          value: counts['total_ancien']!.toDouble(),
          title: '${percentages['ancien']}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          color: Colors.orange[400],
          value: counts['total_novice']!.toDouble(),
          title: '${percentages['novice']}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
