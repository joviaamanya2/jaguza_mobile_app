// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // class GestationTrackerScreen extends StatefulWidget {
// //   const GestationTrackerScreen({super.key});

// //   @override
// //   State<GestationTrackerScreen> createState() => _GestationTrackerScreenState();
// // }

// // class _GestationTrackerScreenState extends State<GestationTrackerScreen> {
// //   int _selectedTab = 0;
  
// //   // Sample gestation records
// //   List<GestationRecord> _gestationRecords = [
// //     GestationRecord(
// //       id: '1',
// //       animalName: 'Bella',
// //       animalType: 'Cattle',
// //       animalId: 'CT-001',
// //       breedingDate: DateTime(2024, 6, 15),
// //       expectedDueDate: DateTime(2025, 3, 22),
// //       confirmedDate: DateTime(2024, 7, 1),
// //       status: GestationStatus.confirmed,
// //       notes: 'Healthy pregnancy, good weight gain',
// //     ),
// //     GestationRecord(
// //       id: '2',
// //       animalName: 'Daisy',
// //       animalType: 'Cattle',
// //       animalId: 'CT-003',
// //       breedingDate: DateTime(2024, 7, 20),
// //       expectedDueDate: DateTime(2025, 4, 26),
// //       confirmedDate: DateTime(2024, 8, 10),
// //       status: GestationStatus.confirmed,
// //       notes: 'First pregnancy, monitoring closely',
// //     ),
// //     GestationRecord(
// //       id: '3',
// //       animalName: 'Stella',
// //       animalType: 'Goat',
// //       animalId: 'GT-005',
// //       breedingDate: DateTime(2024, 8, 5),
// //       expectedDueDate: DateTime(2025, 1, 12),
// //       confirmedDate: DateTime(2024, 8, 25),
// //       status: GestationStatus.confirmed,
// //       notes: 'Triplets expected, extra nutrition needed',
// //     ),
// //     GestationRecord(
// //       id: '4',
// //       animalName: 'Molly',
// //       animalType: 'Sheep',
// //       animalId: 'SH-002',
// //       breedingDate: DateTime(2024, 9, 1),
// //       expectedDueDate: DateTime(2025, 2, 8),
// //       confirmedDate: DateTime(2024, 9, 20),
// //       status: GestationStatus.confirmed,
// //       notes: 'Healthy ewe, good condition',
// //     ),
// //     GestationRecord(
// //       id: '5',
// //       animalName: 'Goldie',
// //       animalType: 'Pig',
// //       animalId: 'PG-008',
// //       breedingDate: DateTime(2024, 10, 10),
// //       expectedDueDate: DateTime(2025, 2, 4),
// //       confirmedDate: DateTime(2024, 11, 1),
// //       status: GestationStatus.confirmed,
// //       notes: 'Good litter expected',
// //     ),
// //   ];

// //   // Gestation Period Reference
// //   final List<GestationInfo> _gestationInfo = [
// //     GestationInfo(
// //       animalType: 'Cattle',
// //       averageDays: 283,
// //       range: '279-290 days',
// //       icon: Icons.pets_rounded,
// //       color: Color(0xFF6D4C41),
// //       details: 'Most common for local and dairy breeds',
// //     ),
// //     GestationInfo(
// //       animalType: 'Goat',
// //       averageDays: 150,
// //       range: '145-155 days',
// //       icon: Icons.grass_rounded,
// //       color: Color(0xFF8E24AA),
// //       details: 'Variation depends on breed and nutrition',
// //     ),
// //     GestationInfo(
// //       animalType: 'Sheep',
// //       averageDays: 147,
// //       range: '142-152 days',
// //       icon: Icons.agriculture_rounded,
// //       color: Color(0xFF43A047),
// //       details: 'Similar to goats, slightly shorter',
// //     ),
// //     GestationInfo(
// //       animalType: 'Pig',
// //       averageDays: 114,
// //       range: '112-116 days',
// //       icon: Icons.set_meal_rounded,
// //       color: Color(0xFFE65100),
// //       details: 'Exact duration varies with litter size',
// //     ),
// //     GestationInfo(
// //       animalType: 'Poultry',
// //       averageDays: 21,
// //       range: '20-22 days',
// //       icon: Icons.egg_rounded,
// //       color: Color(0xFFD84315),
// //       details: 'Incubation period for chicken eggs',
// //     ),
// //     GestationInfo(
// //       animalType: 'Rabbit',
// //       averageDays: 31,
// //       range: '28-32 days',
// //       icon: Icons.pets_rounded,
// //       color: Color(0xFF9C27B0),
// //       details: 'Short gestation, frequent breeding',
// //     ),
// //   ];

// //   // Sample health check reminders
// //   final List<HealthReminder> _reminders = [
// //     HealthReminder(
// //       title: 'Vaccination Due',
// //       description: 'Daisy needs her pregnancy vaccination',
// //       dueDate: DateTime(2024, 12, 15),
// //       priority: Priority.high,
// //     ),
// //     HealthReminder(
// //       title: 'Weight Check',
// //       description: 'Bella - Monthly weight monitoring',
// //       dueDate: DateTime(2024, 12, 20),
// //       priority: Priority.medium,
// //     ),
// //     HealthReminder(
// //       title: 'Nutrition Review',
// //       description: 'Stella - Increase feed for triplets',
// //       dueDate: DateTime(2024, 12, 25),
// //       priority: Priority.medium,
// //     ),
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF5F5F5),
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         foregroundColor: Colors.black87,
// //         elevation: 0,
// //         title: const Text(
// //           'Gestation Tracker',
// //           style: TextStyle(
// //             fontSize: 18,
// //             fontWeight: FontWeight.w700,
// //             color: Color(0xFF1A1F36),
// //           ),
// //         ),
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back_ios_new, size: 20),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //         actions: [
// //           TextButton.icon(
// //             onPressed: () => _showAddGestationDialog(context),
// //             icon: const Icon(Icons.add_rounded, size: 18),
// //             label: const Text('Add Record'),
// //             style: TextButton.styleFrom(
// //               backgroundColor: const Color(0xFF2E7D32),
// //               foregroundColor: Colors.white,
// //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           _buildTabBar(),
// //           Expanded(
// //             child: IndexedStack(
// //               index: _selectedTab,
// //               children: [
// //                 _buildGestationList(),
// //                 _buildGestationReference(),
// //                 _buildRemindersList(),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ═══════════════════════════════════════
// //   //  TAB BAR
// //   // ═══════════════════════════════════════
// //   Widget _buildTabBar() {
// //     final tabs = [
// //       {'icon': Icons.pets_rounded, 'label': 'Records'},
// //       {'icon': Icons.info_rounded, 'label': 'Periods'},
// //       {'icon': Icons.notifications_rounded, 'label': 'Reminders'},
// //     ];

// //     return Container(
// //       color: Colors.white,
// //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
// //       child: Row(
// //         children: tabs.asMap().entries.map((entry) {
// //           final index = entry.key;
// //           final tab = entry.value;
// //           final isActive = _selectedTab == index;
// //           return Expanded(
// //             child: GestureDetector(
// //               onTap: () {
// //                 setState(() {
// //                   _selectedTab = index;
// //                 });
// //               },
// //               child: Container(
// //                 padding: const EdgeInsets.symmetric(vertical: 8),
// //                 decoration: BoxDecoration(
// //                   color: isActive ? const Color(0xFF2E7D32).withOpacity(0.08) : Colors.transparent,
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     Icon(
// //                       tab['icon'] as IconData,
// //                       size: 20,
// //                       color: isActive ? const Color(0xFF2E7D32) : Colors.grey[500],
// //                     ),
// //                     const SizedBox(height: 2),
// //                     Text(
// //                       tab['label'] as String,
// //                       style: TextStyle(
// //                         fontSize: 10,
// //                         fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
// //                         color: isActive ? const Color(0xFF2E7D32) : Colors.grey[500],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }

// //   // ═══════════════════════════════════════
// //   //  GESTATION LIST
// //   // ═══════════════════════════════════════
// //   Widget _buildGestationList() {
// //     if (_gestationRecords.isEmpty) {
// //       return _buildEmptyState(
// //         icon: Icons.pets_rounded,
// //         title: 'No Gestation Records',
// //         subtitle: 'Start tracking your animals pregnancies',
// //       );
// //     }

// //     return ListView.builder(
// //       padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
// //       physics: const BouncingScrollPhysics(),
// //       itemCount: _gestationRecords.length,
// //       itemBuilder: (context, index) => _buildGestationCard(_gestationRecords[index]),
// //     );
// //   }

// //   Widget _buildGestationCard(GestationRecord record) {
// //     final gestationDays = _getGestationDays(record.animalType);
// //     final daysPregnant = DateTime.now().difference(record.breedingDate).inDays;
// //     final daysToGo = record.expectedDueDate.difference(DateTime.now()).inDays;
// //     final progress = daysPregnant / gestationDays;
// //     final isOverdue = daysToGo < 0;

// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: const Color(0xFFE8E8E8)),
// //       ),
// //       child: Material(
// //         color: Colors.transparent,
// //         child: InkWell(
// //           borderRadius: BorderRadius.circular(12),
// //           onTap: () => _showGestationDetails(context, record),
// //           child: Padding(
// //             padding: const EdgeInsets.all(14),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   children: [
// //                     Container(
// //                       width: 44,
// //                       height: 44,
// //                       decoration: BoxDecoration(
// //                         color: _getAnimalColor(record.animalType).withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                       child: Icon(
// //                         _getAnimalIcon(record.animalType),
// //                         size: 22,
// //                         color: _getAnimalColor(record.animalType),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             record.animalName,
// //                             style: const TextStyle(
// //                               fontSize: 15,
// //                               fontWeight: FontWeight.w700,
// //                               color: Color(0xFF1A1F36),
// //                             ),
// //                           ),
// //                           const SizedBox(height: 2),
// //                           Row(
// //                             children: [
// //                               Expanded(
// //                                 child: Text(
// //                                   '${record.animalType} • ${record.animalId}',
// //                                   overflow: TextOverflow.ellipsis,
// //                                   style: TextStyle(
// //                                     fontSize: 12,
// //                                     color: Colors.grey[500],
// //                                   ),
// //                                 ),
// //                               ),
// //                               const SizedBox(width: 8),
// //                               Container(
// //                                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
// //                                 decoration: BoxDecoration(
// //                                   color: record.status == GestationStatus.confirmed
// //                                       ? Colors.green.withOpacity(0.1)
// //                                       : Colors.orange.withOpacity(0.1),
// //                                   borderRadius: BorderRadius.circular(4),
// //                                 ),
// //                                 child: Text(
// //                                   record.status == GestationStatus.confirmed ? 'Confirmed' : 'Suspected',
// //                                   style: TextStyle(
// //                                     fontSize: 9,
// //                                     fontWeight: FontWeight.w600,
// //                                     color: record.status == GestationStatus.confirmed
// //                                         ? Colors.green[700]
// //                                         : Colors.orange[700],
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                       decoration: BoxDecoration(
// //                         color: _getSeverityColor(daysToGo).withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       child: Text(
// //                         daysToGo > 0 ? '${daysToGo}d left' : 'Overdue',
// //                         style: TextStyle(
// //                           fontSize: 11,
// //                           fontWeight: FontWeight.w600,
// //                           color: _getSeverityColor(daysToGo),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 12),
                
// //                 // Progress Bar
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Text(
// //                           '$daysPregnant days pregnant',
// //                           style: const TextStyle(
// //                             fontSize: 12,
// //                             fontWeight: FontWeight.w600,
// //                             color: Color(0xFF2E7D32),
// //                           ),
// //                         ),
// //                         Text(
// //                           '${(progress * 100).toInt()}%',
// //                           style: TextStyle(
// //                             fontSize: 12,
// //                             fontWeight: FontWeight.w600,
// //                             color: Colors.grey[600],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 4),
// //                     ClipRRect(
// //                       borderRadius: BorderRadius.circular(4),
// //                       child: LinearProgressIndicator(
// //                         value: progress > 1 ? 1 : progress,
// //                         backgroundColor: Colors.grey[200],
// //                         color: _getProgressColor(progress),
// //                         minHeight: 6,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 10),
                
// //                 // Quick Info Row
// //                 Row(
// //                   children: [
// //                     _infoChip(
// //                       Icons.calendar_today_rounded,
// //                       'Due: ${_formatDate(record.expectedDueDate)}',
// //                       Colors.grey[600]!,
// //                     ),
// //                     const SizedBox(width: 8),
// //                     _infoChip(
// //                       Icons.timer_rounded,
// //                       '${gestationDays} days',
// //                       Colors.grey[600]!,
// //                     ),
// //                     const Spacer(),
// //                     Icon(
// //                       Icons.chevron_right_rounded,
// //                       color: Colors.grey[400],
// //                       size: 20,
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _infoChip(IconData icon, String label, Color color) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.08),
// //         borderRadius: BorderRadius.circular(6),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(icon, size: 12, color: color),
// //           const SizedBox(width: 4),
// //           Text(
// //             label,
// //             style: TextStyle(
// //               fontSize: 11,
// //               color: color,
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ═══════════════════════════════════════
// //   //  GESTATION REFERENCE
// //   // ═══════════════════════════════════════
// //   Widget _buildGestationReference() {
// //     return SingleChildScrollView(
// //       physics: const BouncingScrollPhysics(),
// //       padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(12),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFFE8F5E9),
// //               borderRadius: BorderRadius.circular(10),
// //               border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.15)),
// //             ),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFF2E7D32).withOpacity(0.1),
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: const Icon(
// //                     Icons.info_rounded,
// //                     color: Color(0xFF2E7D32),
// //                     size: 20,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 const Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         'Gestation Period Guide',
// //                         style: TextStyle(
// //                           fontSize: 14,
// //                           fontWeight: FontWeight.w700,
// //                           color: Color(0xFF2E7D32),
// //                         ),
// //                       ),
// //                       Text(
// //                         'Average gestation periods for different animals',
// //                         style: TextStyle(
// //                           fontSize: 12,
// //                           color: Color(0xFF2E7D32),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           ..._gestationInfo.map((info) => _buildGestationInfoCard(info)),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildGestationInfoCard(GestationInfo info) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 10),
// //       padding: const EdgeInsets.all(14),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: const Color(0xFFE8E8E8)),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 44,
// //             height: 44,
// //             decoration: BoxDecoration(
// //               color: info.color.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //             child: Icon(
// //               info.icon,
// //               size: 22,
// //               color: info.color,
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   info.animalType,
// //                   style: const TextStyle(
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.w700,
// //                     color: Color(0xFF1A1F36),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 2),
// //                 Row(
// //                   children: [
// //                     Text(
// //                       '${info.averageDays} days',
// //                       style: TextStyle(
// //                         fontSize: 13,
// //                         fontWeight: FontWeight.w600,
// //                         color: info.color,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Text(
// //                       info.range,
// //                       style: TextStyle(
// //                         fontSize: 12,
// //                         color: Colors.grey[500],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 2),
// //                 Text(
// //                   info.details,
// //                   style: TextStyle(
// //                     fontSize: 11,
// //                     color: Colors.grey[500],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //             decoration: BoxDecoration(
// //               color: info.color.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Text(
// //               '${info.averageDays}d',
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.w700,
// //                 color: info.color,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ═══════════════════════════════════════
// //   //  REMINDERS LIST
// //   // ═══════════════════════════════════════
// //   Widget _buildRemindersList() {
// //     return SingleChildScrollView(
// //       physics: const BouncingScrollPhysics(),
// //       padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(12),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFFFFF3E0),
// //               borderRadius: BorderRadius.circular(10),
// //               border: Border.all(color: const Color(0xFFFFE0B2)),
// //             ),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                     color: Colors.orange.withOpacity(0.1),
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: const Icon(
// //                     Icons.notifications_active_rounded,
// //                     color: Colors.orange,
// //                     size: 20,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 const Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         'Health Reminders',
// //                         style: TextStyle(
// //                           fontSize: 14,
// //                           fontWeight: FontWeight.w700,
// //                           color: Colors.orange,
// //                         ),
// //                       ),
// //                       Text(
// //                         '3 reminders pending',
// //                         style: TextStyle(
// //                           fontSize: 12,
// //                           color: Colors.orange,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           ..._reminders.map((reminder) => _buildReminderCard(reminder)),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildReminderCard(HealthReminder reminder) {
// //     final daysToDue = reminder.dueDate.difference(DateTime.now()).inDays;
// //     final isOverdue = daysToDue < 0;
    
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 10),
// //       padding: const EdgeInsets.all(14),
// //       decoration: BoxDecoration(
// //         color: isOverdue ? Colors.red.withOpacity(0.04) : Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(
// //           color: isOverdue ? Colors.red.withOpacity(0.3) : const Color(0xFFE8E8E8),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 40,
// //             height: 40,
// //             decoration: BoxDecoration(
// //               color: _getPriorityColor(reminder.priority).withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //             child: Icon(
// //               reminder.priority == Priority.high 
// //                   ? Icons.priority_high_rounded 
// //                   : Icons.notifications_rounded,
// //               color: _getPriorityColor(reminder.priority),
// //               size: 20,
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   reminder.title,
// //                   style: const TextStyle(
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.w600,
// //                     color: Color(0xFF1A1F36),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 2),
// //                 Text(
// //                   reminder.description,
// //                   style: TextStyle(
// //                     fontSize: 12,
// //                     color: Colors.grey[500],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Row(
// //                   children: [
// //                     Icon(
// //                       Icons.access_time_rounded,
// //                       size: 12,
// //                       color: isOverdue ? Colors.red : Colors.grey[400],
// //                     ),
// //                     const SizedBox(width: 4),
// //                     Text(
// //                       isOverdue 
// //                           ? 'Overdue by ${-daysToDue} days' 
// //                           : 'Due in $daysToDue days',
// //                       style: TextStyle(
// //                         fontSize: 11,
// //                         color: isOverdue ? Colors.red : Colors.grey[500],
// //                         fontWeight: isOverdue ? FontWeight.w600 : FontWeight.w400,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //             decoration: BoxDecoration(
// //               color: _getPriorityColor(reminder.priority).withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(6),
// //             ),
// //             child: Text(
// //               reminder.priority.name.toUpperCase(),
// //               style: TextStyle(
// //                 fontSize: 9,
// //                 fontWeight: FontWeight.w700,
// //                 color: _getPriorityColor(reminder.priority),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ═══════════════════════════════════════
// //   //  GESTATION DETAILS DIALOG
// //   // ═══════════════════════════════════════
// //   void _showGestationDetails(BuildContext context, GestationRecord record) {
// //     final gestationDays = _getGestationDays(record.animalType);
// //     final daysPregnant = DateTime.now().difference(record.breedingDate).inDays;
// //     final progress = (daysPregnant / gestationDays * 100).toInt();

// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       builder: (context) => Container(
// //         height: MediaQuery.of(context).size.height * 0.7,
// //         decoration: const BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //         ),
// //         child: Column(
// //           children: [
// //             Container(
// //               margin: const EdgeInsets.symmetric(vertical: 12),
// //               width: 40,
// //               height: 4,
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[300],
// //                 borderRadius: BorderRadius.circular(2),
// //               ),
// //             ),
// //             Expanded(
// //               child: SingleChildScrollView(
// //                 padding: const EdgeInsets.all(20),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Row(
// //                       children: [
// //                         Container(
// //                           width: 56,
// //                           height: 56,
// //                           decoration: BoxDecoration(
// //                             color: _getAnimalColor(record.animalType).withOpacity(0.1),
// //                             borderRadius: BorderRadius.circular(14),
// //                           ),
// //                           child: Icon(
// //                             _getAnimalIcon(record.animalType),
// //                             size: 28,
// //                             color: _getAnimalColor(record.animalType),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 14),
// //                         Expanded(
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(
// //                                 record.animalName,
// //                                 style: const TextStyle(
// //                                   fontSize: 20,
// //                                   fontWeight: FontWeight.w800,
// //                                   color: Color(0xFF1A1F36),
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 2),
// //                               Text(
// //                                 '${record.animalType} • ID: ${record.animalId}',
// //                                 style: TextStyle(
// //                                   fontSize: 14,
// //                                   color: Colors.grey[500],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         Container(
// //                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //                           decoration: BoxDecoration(
// //                             color: record.status == GestationStatus.confirmed
// //                                 ? Colors.green.withOpacity(0.1)
// //                                 : Colors.orange.withOpacity(0.1),
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           child: Text(
// //                             record.status == GestationStatus.confirmed ? 'Confirmed' : 'Suspected',
// //                             style: TextStyle(
// //                               fontSize: 11,
// //                               fontWeight: FontWeight.w700,
// //                               color: record.status == GestationStatus.confirmed
// //                                   ? Colors.green[700]
// //                                   : Colors.orange[700],
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
                    
// //                     const SizedBox(height: 20),
// //                     _buildDetailSection('Pregnancy Progress'),
// //                     const SizedBox(height: 12),
                    
// //                     // Progress
// //                     Container(
// //                       padding: const EdgeInsets.all(14),
// //                       decoration: BoxDecoration(
// //                         color: const Color(0xFFF5F5F5),
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                       child: Column(
// //                         children: [
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Text(
// //                                 '$daysPregnant days pregnant',
// //                                 style: const TextStyle(
// //                                   fontSize: 14,
// //                                   fontWeight: FontWeight.w700,
// //                                   color: Color(0xFF2E7D32),
// //                                 ),
// //                               ),
// //                               Text(
// //                                 '$progress% complete',
// //                                 style: TextStyle(
// //                                   fontSize: 14,
// //                                   fontWeight: FontWeight.w700,
// //                                   color: Colors.grey[600],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                           const SizedBox(height: 8),
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(4),
// //                             child: LinearProgressIndicator(
// //                               value: progress / 100,
// //                               backgroundColor: Colors.grey[200],
// //                               color: _getProgressColor(progress / 100),
// //                               minHeight: 8,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 8),
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Text(
// //                                 'Breeding Date',
// //                                 style: TextStyle(
// //                                   fontSize: 11,
// //                                   color: Colors.grey[500],
// //                                 ),
// //                               ),
// //                               Text(
// //                                 'Expected Due Date',
// //                                 style: TextStyle(
// //                                   fontSize: 11,
// //                                   color: Colors.grey[500],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Text(
// //                                 _formatDate(record.breedingDate),
// //                                 style: const TextStyle(
// //                                   fontSize: 12,
// //                                   fontWeight: FontWeight.w600,
// //                                   color: Color(0xFF1A1F36),
// //                                 ),
// //                               ),
// //                               Text(
// //                                 _formatDate(record.expectedDueDate),
// //                                 style: const TextStyle(
// //                                   fontSize: 12,
// //                                   fontWeight: FontWeight.w600,
// //                                   color: Color(0xFF2E7D32),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ),
                    
// //                     const SizedBox(height: 20),
// //                     _buildDetailSection('Pregnancy Information'),
// //                     const SizedBox(height: 12),
                    
// //                     Container(
// //                       padding: const EdgeInsets.all(14),
// //                       decoration: BoxDecoration(
// //                         color: const Color(0xFFF5F5F5),
// //                         borderRadius: BorderRadius.circular(10),
// //                       ),
// //                       child: Column(
// //                         children: [
// //                           Row(
// //                             children: [
// //                               Icon(Icons.info_rounded, size: 16, color: Colors.grey[600]),
// //                               const SizedBox(width: 8),
// //                               Text(
// //                                 'Gestation Period',
// //                                 style: TextStyle(
// //                                   fontSize: 12,
// //                                   color: Colors.grey[500],
// //                                 ),
// //                               ),
// //                               const Spacer(),
// //                               Text(
// //                                 '$gestationDays days',
// //                                 style: const TextStyle(
// //                                   fontSize: 13,
// //                                   fontWeight: FontWeight.w600,
// //                                   color: Color(0xFF2E7D32),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                           const SizedBox(height: 8),
// //                           Row(
// //                             children: [
// //                               Icon(Icons.note_rounded, size: 16, color: Colors.grey[600]),
// //                               const SizedBox(width: 8),
// //                               Text(
// //                                 'Notes',
// //                                 style: TextStyle(
// //                                   fontSize: 12,
// //                                   color: Colors.grey[500],
// //                                 ),
// //                               ),
// //                               const Spacer(),
// //                               Expanded(
// //                                 child: Text(
// //                                   record.notes,
// //                                   style: const TextStyle(
// //                                     fontSize: 13,
// //                                     fontWeight: FontWeight.w500,
// //                                     color: Color(0xFF1A1F36),
// //                                   ),
// //                                   textAlign: TextAlign.right,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ),
                    
// //                     const SizedBox(height: 20),
                    
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: OutlinedButton.icon(
// //                             onPressed: () {
// //                               Navigator.pop(context);
// //                               _showAddHealthRecordDialog(context, record);
// //                             },
// //                             icon: const Icon(Icons.add_rounded, size: 18),
// //                             label: const Text('Add Health Record'),
// //                             style: OutlinedButton.styleFrom(
// //                               foregroundColor: const Color(0xFF2E7D32),
// //                               padding: const EdgeInsets.symmetric(vertical: 10),
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(10),
// //                               ),
// //                               side: const BorderSide(color: Color(0xFF2E7D32)),
// //                             ),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 10),
// //                         Expanded(
// //                           child: ElevatedButton.icon(
// //                             onPressed: () => Navigator.pop(context),
// //                             icon: const Icon(Icons.check_rounded, size: 18),
// //                             label: const Text('Close'),
// //                             style: ElevatedButton.styleFrom(
// //                               backgroundColor: const Color(0xFF2E7D32),
// //                               foregroundColor: Colors.white,
// //                               padding: const EdgeInsets.symmetric(vertical: 10),
// //                               shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(10),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildDetailSection(String title) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(vertical: 4),
// //       child: Text(
// //         title,
// //         style: const TextStyle(
// //           fontSize: 14,
// //           fontWeight: FontWeight.w700,
// //           color: Color(0xFF1A1F36),
// //         ),
// //       ),
// //     );
// //   }

// //   // ═══════════════════════════════════════
// //   //  ADD GESTATION DIALOG
// //   // ═══════════════════════════════════════
// //   void _showAddGestationDialog(BuildContext context) {
// //     final nameController = TextEditingController();
// //     final animalIdController = TextEditingController();
// //     DateTime selectedBreedingDate = DateTime.now();
// //     String selectedAnimalType = 'Cattle';
// //     String selectedStatus = 'Confirmed';

// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //         title: const Text('Add Gestation Record'),
// //         content: SingleChildScrollView(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               DropdownButtonFormField<String>(
// //                 value: selectedAnimalType,
// //                 decoration: const InputDecoration(
// //                   labelText: 'Animal Type *',
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 items: const [
// //                   'Cattle', 'Goat', 'Sheep', 'Pig', 'Other'
// //                 ].map((type) => DropdownMenuItem(
// //                   value: type,
// //                   child: Text(type),
// //                 )).toList(),
// //                 onChanged: (value) {
// //                   selectedAnimalType = value ?? 'Cattle';
// //                 },
// //               ),
// //               const SizedBox(height: 12),
// //               TextField(
// //                 controller: nameController,
// //                 decoration: const InputDecoration(
// //                   labelText: 'Animal Name *',
// //                   hintText: 'e.g., Bella',
// //                   border: OutlineInputBorder(),
// //                 ),
// //               ),
// //               const SizedBox(height: 12),
// //               TextField(
// //                 controller: animalIdController,
// //                 decoration: const InputDecoration(
// //                   labelText: 'Animal ID *',
// //                   hintText: 'e.g., CT-001',
// //                   border: OutlineInputBorder(),
// //                 ),
// //               ),
// //               const SizedBox(height: 12),
// //               ListTile(
// //                 title: const Text('Breeding Date *'),
// //                 subtitle: Text(_formatDate(selectedBreedingDate)),
// //                 trailing: const Icon(Icons.calendar_today_rounded),
// //                 onTap: () async {
// //                   final date = await showDatePicker(
// //                     context: context,
// //                     initialDate: selectedBreedingDate,
// //                     firstDate: DateTime(2023),
// //                     lastDate: DateTime.now(),
// //                   );
// //                   if (date != null) {
// //                     selectedBreedingDate = date;
// //                   }
// //                 },
// //               ),
// //               const SizedBox(height: 12),
// //               DropdownButtonFormField<String>(
// //                 value: selectedStatus,
// //                 decoration: const InputDecoration(
// //                   labelText: 'Status *',
// //                   border: OutlineInputBorder(),
// //                 ),
// //                 items: const [
// //                   'Confirmed', 'Suspected'
// //                 ].map((status) => DropdownMenuItem(
// //                   value: status,
// //                   child: Text(status),
// //                 )).toList(),
// //                 onChanged: (value) {
// //                   selectedStatus = value ?? 'Confirmed';
// //                 },
// //               ),
// //             ],
// //           ),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               if (nameController.text.isNotEmpty && animalIdController.text.isNotEmpty) {
// //                 final gestationDays = _getGestationDays(selectedAnimalType);
// //                 final newRecord = GestationRecord(
// //                   id: DateTime.now().toString(),
// //                   animalName: nameController.text,
// //                   animalType: selectedAnimalType,
// //                   animalId: animalIdController.text,
// //                   breedingDate: selectedBreedingDate,
// //                   expectedDueDate: selectedBreedingDate.add(Duration(days: gestationDays)),
// //                   confirmedDate: selectedStatus == 'Confirmed' ? DateTime.now() : null,
// //                   status: selectedStatus == 'Confirmed' 
// //                       ? GestationStatus.confirmed 
// //                       : GestationStatus.suspected,
// //                   notes: 'New pregnancy record',
// //                 );
                
// //                 setState(() {
// //                   _gestationRecords.add(newRecord);
// //                 });
                
// //                 Navigator.pop(context);
                
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                   const SnackBar(
// //                     content: Text('Gestation record added successfully'),
// //                     backgroundColor: Color(0xFF2E7D32),
// //                   ),
// //                 );
// //               }
// //             },
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: const Color(0xFF2E7D32),
// //               foregroundColor: Colors.white,
// //             ),
// //             child: const Text('Add Record'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _showAddHealthRecordDialog(BuildContext context, GestationRecord record) {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //         title: const Text('Add Health Record'),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Text(
// //               'Adding health record for ${record.animalName}',
// //               style: const TextStyle(
// //                 fontSize: 14,
// //                 color: Colors.grey,
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             const TextField(
// //               decoration: InputDecoration(
// //                 labelText: 'Health Note',
// //                 hintText: 'e.g., Weight check, vaccination, etc.',
// //                 border: OutlineInputBorder(),
// //               ),
// //               maxLines: 3,
// //             ),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
// //           ),
// //           ElevatedButton(
// //             onPressed: () => Navigator.pop(context),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: const Color(0xFF2E7D32),
// //               foregroundColor: Colors.white,
// //             ),
// //             child: const Text('Add Record'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ═══════════════════════════════════════
// //   //  HELPERS
// //   // ═══════════════════════════════════════
// //   int _getGestationDays(String animalType) {
// //     switch (animalType.toLowerCase()) {
// //       case 'cattle':
// //         return 283;
// //       case 'goat':
// //         return 150;
// //       case 'sheep':
// //         return 147;
// //       case 'pig':
// //         return 114;
// //       case 'poultry':
// //         return 21;
// //       case 'rabbit':
// //         return 31;
// //       default:
// //         return 283;
// //     }
// //   }

// //   List<GestationRecord> _getUpcomingBirths() {
// //     final now = DateTime.now();
// //     return _gestationRecords
// //         .where((record) => record.expectedDueDate.difference(now).inDays <= 30)
// //         .toList();
// //   }

// //   String _formatDate(DateTime date) {
// //     return '${date.day}/${date.month}/${date.year}';
// //   }

// //   Color _getAnimalColor(String type) {
// //     switch (type.toLowerCase()) {
// //       case 'cattle':
// //         return const Color(0xFF6D4C41);
// //       case 'goat':
// //         return const Color(0xFF8E24AA);
// //       case 'sheep':
// //         return const Color(0xFF43A047);
// //       case 'pig':
// //         return const Color(0xFFE65100);
// //       case 'poultry':
// //         return const Color(0xFFD84315);
// //       case 'rabbit':
// //         return const Color(0xFF9C27B0);
// //       default:
// //         return const Color(0xFF2E7D32);
// //     }
// //   }

// //   IconData _getAnimalIcon(String type) {
// //     switch (type.toLowerCase()) {
// //       case 'cattle':
// //         return Icons.pets_rounded;
// //       case 'goat':
// //         return Icons.grass_rounded;
// //       case 'sheep':
// //         return Icons.agriculture_rounded;
// //       case 'pig':
// //         return Icons.set_meal_rounded;
// //       case 'poultry':
// //         return Icons.egg_rounded;
// //       case 'rabbit':
// //         return Icons.pets_rounded;
// //       default:
// //         return Icons.pets_rounded;
// //     }
// //   }

// //   Color _getProgressColor(double progress) {
// //     if (progress < 0.25) return Colors.blue;
// //     if (progress < 0.5) return Colors.green;
// //     if (progress < 0.75) return Colors.orange;
// //     if (progress < 0.9) return Colors.orange;
// //     return Colors.red;
// //   }

// //   Color _getSeverityColor(int daysToGo) {
// //     if (daysToGo < 0) return Colors.red;
// //     if (daysToGo < 7) return Colors.orange;
// //     if (daysToGo < 14) return Colors.orange;
// //     return Colors.green;
// //   }

// //   Color _getPriorityColor(Priority priority) {
// //     switch (priority) {
// //       case Priority.high:
// //         return Colors.red;
// //       case Priority.medium:
// //         return Colors.orange;
// //       case Priority.low:
// //         return Colors.blue;
// //     }
// //   }

// //   Widget _buildEmptyState({required IconData icon, required String title, required String subtitle}) {
// //     return Center(
// //       child: Padding(
// //         padding: const EdgeInsets.all(40),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Icon(icon, size: 64, color: Colors.grey[300]),
// //             const SizedBox(height: 16),
// //             Text(
// //               title,
// //               style: const TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w700,
// //                 color: Color(0xFF1A1F36),
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               subtitle,
// //               style: TextStyle(
// //                 fontSize: 14,
// //                 color: Colors.grey[500],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ═══════════════════════════════════════
// // //  DATA MODELS
// // // ═══════════════════════════════════════
// // enum GestationStatus { confirmed, suspected }

// // enum Priority { high, medium, low }

// // class GestationRecord {
// //   final String id;
// //   final String animalName;
// //   final String animalType;
// //   final String animalId;
// //   final DateTime breedingDate;
// //   final DateTime expectedDueDate;
// //   final DateTime? confirmedDate;
// //   final GestationStatus status;
// //   final String notes;

// //   GestationRecord({
// //     required this.id,
// //     required this.animalName,
// //     required this.animalType,
// //     required this.animalId,
// //     required this.breedingDate,
// //     required this.expectedDueDate,
// //     this.confirmedDate,
// //     required this.status,
// //     required this.notes,
// //   });
// // }

// // class HealthReminder {
// //   final String title;
// //   final String description;
// //   final DateTime dueDate;
// //   final Priority priority;

// //   HealthReminder({
// //     required this.title,
// //     required this.description,
// //     required this.dueDate,
// //     required this.priority,
// //   });
// // }

// // class GestationInfo {
// //   final String animalType;
// //   final int averageDays;
// //   final String range;
// //   final IconData icon;
// //   final Color color;
// //   final String details;

// //   GestationInfo({
// //     required this.animalType,
// //     required this.averageDays,
// //     required this.range,
// //     required this.icon,
// //     required this.color,
// //     required this.details,
// //   });
// // }
// import 'package:flutter/material.dart';

// // ═══════════════════════════════════════════════════
// //  DATA MODELS
// // ═══════════════════════════════════════════════════
// enum GestationStatus { confirmed, suspected }
// enum Priority { high, medium, low }

// class GestationRecord {
//   final String id;
//   final String animalName;
//   final String animalType;
//   final String animalId;
//   final DateTime breedingDate;
//   final DateTime expectedDueDate;
//   final DateTime? confirmedDate;
//   final GestationStatus status;
//   final String notes;

//   GestationRecord({
//     required this.id,
//     required this.animalName,
//     required this.animalType,
//     required this.animalId,
//     required this.breedingDate,
//     required this.expectedDueDate,
//     this.confirmedDate,
//     required this.status,
//     required this.notes,
//   });
// }

// class GestationInfo {
//   final String animalType;
//   final int averageDays;
//   final String range;
//   final IconData icon;
//   final Color color;
//   final String simpleNote;

//   GestationInfo({
//     required this.animalType,
//     required this.averageDays,
//     required this.range,
//     required this.icon,
//     required this.color,
//     required this.simpleNote,
//   });
// }

// class HealthReminder {
//   final String title;
//   final String description;
//   final DateTime dueDate;
//   final Priority priority;

//   HealthReminder({
//     required this.title,
//     required this.description,
//     required this.dueDate,
//     required this.priority,
//   });
// }

// // ═══════════════════════════════════════════════════
// //  MAIN SCREEN
// // ═══════════════════════════════════════════════════
// class GestationTrackerScreen extends StatefulWidget {
//   const GestationTrackerScreen({super.key});

//   @override
//   State<GestationTrackerScreen> createState() => _GestationTrackerScreenState();
// }

// class _GestationTrackerScreenState extends State<GestationTrackerScreen> {
//   int _selectedTab = 0;

//   // ── Sample Data ──
//   final List<GestationRecord> _gestationRecords = [
//     GestationRecord(
//       id: '1',
//       animalName: 'Bella',
//       animalType: 'Cattle',
//       animalId: 'CT-001',
//       breedingDate: DateTime(2024, 6, 15),
//       expectedDueDate: DateTime(2025, 3, 22),
//       confirmedDate: DateTime(2024, 7, 1),
//       status: GestationStatus.confirmed,
//       notes: 'Healthy pregnancy, good weight gain',
//     ),
//     GestationRecord(
//       id: '2',
//       animalName: 'Daisy',
//       animalType: 'Cattle',
//       animalId: 'CT-003',
//       breedingDate: DateTime(2024, 7, 20),
//       expectedDueDate: DateTime(2025, 4, 26),
//       confirmedDate: DateTime(2024, 8, 10),
//       status: GestationStatus.confirmed,
//       notes: 'First pregnancy, keep a close watch',
//     ),
//     GestationRecord(
//       id: '3',
//       animalName: 'Stella',
//       animalType: 'Goat',
//       animalId: 'GT-005',
//       breedingDate: DateTime(2024, 8, 5),
//       expectedDueDate: DateTime(2025, 1, 12),
//       confirmedDate: DateTime(2024, 8, 25),
//       status: GestationStatus.confirmed,
//       notes: 'Triplets expected, give extra feed',
//     ),
//     GestationRecord(
//       id: '4',
//       animalName: 'Molly',
//       animalType: 'Sheep',
//       animalId: 'SH-002',
//       breedingDate: DateTime(2024, 9, 1),
//       expectedDueDate: DateTime(2025, 2, 8),
//       confirmedDate: DateTime(2024, 9, 20),
//       status: GestationStatus.confirmed,
//       notes: 'Healthy ewe, doing well',
//     ),
//     GestationRecord(
//       id: '5',
//       animalName: 'Goldie',
//       animalType: 'Pig',
//       animalId: 'PG-008',
//       breedingDate: DateTime(2024, 10, 10),
//       expectedDueDate: DateTime(2025, 2, 4),
//       confirmedDate: DateTime(2024, 11, 1),
//       status: GestationStatus.confirmed,
//       notes: 'Good litter expected',
//     ),
//   ];

//   final List<GestationInfo> _gestationInfo = [
//     GestationInfo(
//       animalType: 'Cattle (Cow/Buffalo)',
//       averageDays: 283,
//       range: '279–290 days',
//       icon: Icons.pets_rounded,
//       color: Color(0xFF6D4C41),
//       simpleNote: 'Roughly 9 months and 2 weeks — similar to humans!',
//     ),
//     GestationInfo(
//       animalType: 'Goat',
//       averageDays: 150,
//       range: '145–155 days',
//       icon: Icons.grass_rounded,
//       color: Color(0xFF8E24AA),
//       simpleNote: 'About 5 months. Give extra nutrition in last month.',
//     ),
//     GestationInfo(
//       animalType: 'Sheep',
//       averageDays: 147,
//       range: '142–152 days',
//       icon: Icons.agriculture_rounded,
//       color: Color(0xFF43A047),
//       simpleNote: 'About 5 months. Keep separate in last 2 weeks.',
//     ),
//     GestationInfo(
//       animalType: 'Pig',
//       averageDays: 114,
//       range: '112–116 days',
//       icon: Icons.set_meal_rounded,
//       color: Color(0xFFE65100),
//       simpleNote: 'About 3 months and 3 weeks. "3 months, 3 weeks, 3 days" is the easy rule.',
//     ),
//     GestationInfo(
//       animalType: 'Poultry (Hen)',
//       averageDays: 21,
//       range: '20–22 days',
//       icon: Icons.egg_rounded,
//       color: Color(0xFFD84315),
//       simpleNote: 'Just 3 weeks from egg to chick under a broody hen or incubator.',
//     ),
//     GestationInfo(
//       animalType: 'Rabbit',
//       averageDays: 31,
//       range: '28–32 days',
//       simpleNote: 'Only 1 month! Provide nesting box a few days before.',
//       icon: Icons.pets_rounded,
//       color: Color(0xFF9C27B0),
//     ),
//   ];

//   final List<HealthReminder> _reminders = [
//     HealthReminder(
//       title: 'Vaccination Due',
//       description: 'Daisy needs her pregnancy vaccination',
//       dueDate: DateTime(2024, 12, 15),
//       priority: Priority.high,
//     ),
//     HealthReminder(
//       title: 'Weight Check',
//       description: 'Bella — monthly weight check',
//       dueDate: DateTime(2024, 12, 20),
//       priority: Priority.medium,
//     ),
//     HealthReminder(
//       title: 'Extra Feed Needed',
//       description: 'Stella — increase feed, triplets expected',
//       dueDate: DateTime(2024, 12, 25),
//       priority: Priority.medium,
//     ),
//   ];

//   // ═══════════════════════════════════════════════════
//   //  BUILD
//   // ═══════════════════════════════════════════════════
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0,
//         title: const Text(
//           'Pregnancy Tracker',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF1A1F36),
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           TextButton.icon(
//             onPressed: () => _showAddGestationDialog(context),
//             icon: const Icon(Icons.add_rounded, size: 18),
//             label: const Text('Add New'),
//             style: TextButton.styleFrom(
//               backgroundColor: const Color(0xFF2E7D32),
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//         ],
//       ),
//       body: Column(
//         children: [
//           _buildTabBar(),
//           Expanded(
//             child: IndexedStack(
//               index: _selectedTab,
//               children: [
//                 _buildGestationList(),
//                 _buildGestationReference(),
//                 _buildRemindersList(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ═══════════════════════════════════════════════════
//   //  TAB BAR — simple labels a farmer can read
//   // ═══════════════════════════════════════════════════
//   Widget _buildTabBar() {
//     final tabs = [
//       {'icon': Icons.pets_rounded, 'label': 'My Animals'},
//       {'icon': Icons.help_outline_rounded, 'label': 'How Long?'},
//       {'icon': Icons.notifications_rounded, 'label': 'Reminders'},
//     ];

//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       child: Row(
//         children: tabs.asMap().entries.map((entry) {
//           final index = entry.key;
//           final tab = entry.value;
//           final isActive = _selectedTab == index;
//           return Expanded(
//             child: GestureDetector(
//               onTap: () => setState(() => _selectedTab = index),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 decoration: BoxDecoration(
//                   color: isActive
//                       ? const Color(0xFF2E7D32).withOpacity(0.08)
//                       : Colors.transparent,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       tab['icon'] as IconData,
//                       size: 20,
//                       color: isActive
//                           ? const Color(0xFF2E7D32)
//                           : Colors.grey[500],
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       tab['label'] as String,
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight:
//                             isActive ? FontWeight.w600 : FontWeight.w400,
//                         color: isActive
//                             ? const Color(0xFF2E7D32)
//                             : Colors.grey[500],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   // ═══════════════════════════════════════════════════
//   //  TAB 1 — MY ANIMALS (simplified cards)
//   // ═══════════════════════════════════════════════════
//   Widget _buildGestationList() {
//     if (_gestationRecords.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.pets_rounded, size: 64, color: Colors.grey[300]),
//             const SizedBox(height: 16),
//             Text(
//               'No animals added yet',
//               style: TextStyle(fontSize: 16, color: Colors.grey[500]),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Tap "Add New" to start tracking',
//               style: TextStyle(fontSize: 13, color: Colors.grey[400]),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
//       physics: const BouncingScrollPhysics(),
//       itemCount: _gestationRecords.length,
//       itemBuilder: (context, index) =>
//           _buildSimpleCard(_gestationRecords[index]),
//     );
//   }

//   // ───────────────────────────────────────────────────
//   //  THE SIMPLIFIED CARD — no red line, no %, no raw days
//   // ───────────────────────────────────────────────────
//   Widget _buildSimpleCard(GestationRecord record) {
//     final gestationDays = _getGestationDays(record.animalType);
//     final daysPregnant =
//         DateTime.now().difference(record.breedingDate).inDays;
//     final daysToGo = record.expectedDueDate.difference(DateTime.now()).inDays;
//     final progress = daysPregnant / gestationDays;

//     // ── Decide stage ──
//     int currentStage;
//     String stageLabel;
//     Color stageColor;

//     if (progress >= 0.85 || daysToGo <= 30) {
//       currentStage = 3;
//       stageLabel = 'Almost Ready';
//       stageColor = Colors.red.shade700;
//     } else if (progress >= 0.45) {
//       currentStage = 2;
//       stageLabel = 'Half Way';
//       stageColor = Colors.orange.shade700;
//     } else {
//       currentStage = 1;
//       stageLabel = 'Just Started';
//       stageColor = Colors.green.shade700;
//     }

//     // ── "How long left" in plain words ──
//     String timeLeftText;
//     bool isUrgent = false;
//     if (daysToGo < 0) {
//       timeLeftText = 'Past due date! Check on her now';
//       isUrgent = true;
//     } else if (daysToGo <= 7) {
//       timeLeftText = 'Any day now! Stay alert';
//       isUrgent = true;
//     } else if (daysToGo <= 30) {
//       final w = (daysToGo / 7).round();
//       timeLeftText = 'About $w week${w == 1 ? '' : 's'} to go';
//       isUrgent = true;
//     } else if (daysToGo <= 60) {
//       final m = (daysToGo / 30).round();
//       timeLeftText = 'About $m month to go';
//     } else {
//       final m = (daysToGo / 30).round();
//       timeLeftText = 'About $m months to go';
//     }

//     // ── "How far along" in plain words ──
//     String howFarText;
//     if (daysPregnant < 30) {
//       howFarText = '$daysPregnant days since mating';
//     } else {
//       final months = (daysPregnant / 30).floor();
//       final extra = daysPregnant % 30;
//       howFarText = '$months month${months == 1 ? '' : 's'} $extra days since mating';
//     }

//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: stageColor.withOpacity(0.35), width: 1.5),
//         boxShadow: [
//           BoxShadow(
//             color: stageColor.withOpacity(0.06),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(14),
//           onTap: () => _showSimpleDetails(context, record),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ── Row 1: Name + badge ──
//                 Row(
//                   children: [
//                     Container(
//                       width: 46,
//                       height: 46,
//                       decoration: BoxDecoration(
//                         color: _getAnimalColor(record.animalType)
//                             .withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Icon(
//                         _getAnimalIcon(record.animalType),
//                         size: 24,
//                         color: _getAnimalColor(record.animalType),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             record.animalName,
//                             style: const TextStyle(
//                               fontSize: 17,
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xFF1A1F36),
//                             ),
//                           ),
//                           Text(
//                             '${record.animalType}  •  ${record.animalId}',
//                             style: TextStyle(
//                                 fontSize: 12, color: Colors.grey[500]),
//                           ),
//                         ],
//                       ),
//                     ),
//                     _buildStatusBadge(record.status),
//                   ],
//                 ),

//                 const SizedBox(height: 18),

//                 // ── Row 2: 3-Stage Visual ──
//                 _buildStageIndicator(currentStage, stageColor, stageLabel),

//                 const SizedBox(height: 16),

//                 // ── Row 3: Simple info box ──
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF8F9FA),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     children: [
//                       _infoRow(
//                         icon: Icons.calendar_today,
//                         label: 'Mated on:',
//                         value: _formatDate(record.breedingDate),
//                       ),
//                       const SizedBox(height: 8),
//                       _infoRow(
//                         icon: Icons.child_care,
//                         label: 'Baby expected on:',
//                         value: _formatDate(record.expectedDueDate),
//                         valueColor: const Color(0xFF2E7D32),
//                       ),
//                       const SizedBox(height: 8),
//                       _infoRow(
//                         icon: Icons.alarm,
//                         label: '',
//                         value: timeLeftText,
//                         valueColor: isUrgent ? stageColor : null,
//                         bold: isUrgent,
//                       ),
//                       const SizedBox(height: 8),
//                       _infoRow(
//                         icon: Icons.timeline,
//                         label: '',
//                         value: howFarText,
//                       ),
//                       if (record.notes.isNotEmpty) ...[
//                         const SizedBox(height: 8),
//                         _infoRow(
//                           icon: Icons.edit_note,
//                           label: 'Note:',
//                           value: record.notes,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 8),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: Text(
//                     'Tap for details →',
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: Colors.grey[400],
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ── 3-Stage dot indicator ──
//   Widget _buildStageIndicator(int stage, Color color, String label) {
//     return Row(
//       children: [
//         _stageDot(filled: stage >= 1, color: color, text: 'Early'),
//         _stageLine(filled: stage >= 2, color: color),
//         _stageDot(filled: stage >= 2, color: color, text: 'Middle'),
//         _stageLine(filled: stage >= 3, color: color),
//         _stageDot(filled: stage >= 3, color: color, text: 'Ready'),
//         const Spacer(),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(6),
//           ),
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//               color: color,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _stageDot({
//     required bool filled,
//     required Color color,
//     required String text,
//   }) {
//     return Column(
//       children: [
//         Container(
//           width: 18,
//           height: 18,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: filled ? color : Colors.grey[300],
//             border: Border.all(
//                 color: filled ? color : Colors.grey[400]!, width: 2),
//           ),
//           child: filled
//               ? const Icon(Icons.check, size: 11, color: Colors.white)
//               : null,
//         ),
//         const SizedBox(height: 4),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 9,
//             fontWeight: filled ? FontWeight.w600 : FontWeight.w400,
//             color: filled ? color : Colors.grey[500],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _stageLine({required bool filled, required Color color}) {
//     return Expanded(
//       child: Container(
//         height: 3,
//         margin: const EdgeInsets.only(bottom: 20),
//         decoration: BoxDecoration(
//           color: filled ? color : Colors.grey[300],
//           borderRadius: BorderRadius.circular(2),
//         ),
//       ),
//     );
//   }

//   // ── Simple info row inside the card ──
//   Widget _infoRow({
//     required IconData icon,
//     required String label,
//     required String value,
//     Color? valueColor,
//     bool bold = false,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, size: 16, color: Colors.grey[600]),
//         const SizedBox(width: 8),
//         if (label.isNotEmpty) ...[
//           Text(
//             label,
//             style:  TextStyle(
//               fontSize: 13,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(width: 4),
//         ],
//         Expanded(
//           child: Text(
//             value,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
//               color: valueColor ?? const Color(0xFF333333),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ── Confirmed / Not Sure badge ──
//   Widget _buildStatusBadge(GestationStatus status) {
//     final confirmed = status == GestationStatus.confirmed;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: confirmed
//             ? Colors.green.withOpacity(0.1)
//             : Colors.orange.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             confirmed ? Icons.check_circle : Icons.help_outline,
//             size: 13,
//             color: confirmed ? Colors.green[700] : Colors.orange[700],
//           ),
//           const SizedBox(width: 3),
//           Text(
//             confirmed ? 'Confirmed' : 'Not Sure',
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               color: confirmed ? Colors.green[700] : Colors.orange[700],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ═══════════════════════════════════════════════════
//   //  TAB 2 — HOW LONG? (simplified reference)
//   // ═══════════════════════════════════════════════════
//   Widget _buildGestationReference() {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Tip box
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: const Color(0xFFE8F5E9),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                   color: const Color(0xFF2E7D32).withOpacity(0.2)),
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Icon(Icons.lightbulb_rounded,
//                     color: Color(0xFF2E7D32), size: 22),
//                 const SizedBox(width: 12),
//                 const Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'How long does pregnancy last?',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xFF2E7D32),
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         'Every animal is different. Use this table as a rough guide. If your animal is close to the date below, keep a close watch!',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Color(0xFF2E7D32),
//                           height: 1.4,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           ..._gestationInfo.map((info) => _buildSimpleReferenceCard(info)),
//         ],
//       ),
//     );
//   }

//   Widget _buildSimpleReferenceCard(GestationInfo info) {
//     // Convert days to months for easy understanding
//     String inMonths;
//     if (info.averageDays <= 31) {
//       inMonths = 'Less than 1 month';
//     } else {
//       final m = (info.averageDays / 30).floor();
//       final extra = info.averageDays % 30;
//       if (extra == 0) {
//         inMonths = 'About $m month${m == 1 ? '' : 's'}';
//       } else {
//         inMonths = 'About $m month${m == 1 ? '' : 's'} and $extra days';
//       }
//     }

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE8E8E8)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: info.color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(info.icon, size: 24, color: info.color),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   info.animalType,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF1A1F36),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   inMonths,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: info.color,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   '(${info.averageDays} days roughly)',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   info.simpleNote,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                     height: 1.3,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ═══════════════════════════════════════════════════
//   //  TAB 3 — REMINDERS (simplified)
//   // ═══════════════════════════════════════════════════
//   Widget _buildRemindersList() {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Info box
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFFF3E0),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: const Color(0xFFFFE0B2)),
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Icon(Icons.notifications_active_rounded,
//                     color: Colors.orange, size: 22),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Things To Do',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.orange,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         '${_reminders.length} pending task${_reminders.length == 1 ? '' : 's'}. Don\'t forget these!',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.orange,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           ..._reminders.map((r) => _buildSimpleReminder(r)),
//         ],
//       ),
//     );
//   }

//   Widget _buildSimpleReminder(HealthReminder reminder) {
//     final daysToDue = reminder.dueDate.difference(DateTime.now()).inDays;
//     final isOverdue = daysToDue < 0;
//     final isUrgent = reminder.priority == Priority.high || isOverdue;

//     String whenText;
//     if (isOverdue) {
//       whenText = 'Overdue by ${-daysToDue} day${-daysToDue == 1 ? '' : 's'}!';
//     } else if (daysToDue == 0) {
//       whenText = 'Do it today!';
//     } else if (daysToDue <= 7) {
//       whenText = 'Due in $daysToDue day${daysToDue == 1 ? '' : 's'}';
//     } else {
//       whenText = 'Due in ${(daysToDue / 7).round()} week${(daysToDue / 7).round() == 1 ? '' : 's'}';
//     }

//     String urgencyLabel;
//     Color urgencyColor;
//     IconData urgencyIcon;

//     if (isOverdue) {
//       urgencyLabel = 'Overdue!';
//       urgencyColor = Colors.red;
//       urgencyIcon = Icons.error_rounded;
//     } else if (isUrgent) {
//       urgencyLabel = 'Do Soon';
//       urgencyColor = Colors.orange;
//       urgencyIcon = Icons.priority_high_rounded;
//     } else {
//       urgencyLabel = 'Can Wait';
//       urgencyColor = Colors.blue;
//       urgencyIcon = Icons.schedule_rounded;
//     }

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: isOverdue ? Colors.red.shade50 : Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isOverdue
//               ? Colors.red.withOpacity(0.3)
//               : const Color(0xFFE8E8E8),
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 42,
//             height: 42,
//             decoration: BoxDecoration(
//               color: urgencyColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(urgencyIcon, color: urgencyColor, size: 22),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   reminder.title,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF1A1F36),
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   reminder.description,
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   children: [
//                     Icon(Icons.access_time_rounded,
//                         size: 13, color: urgencyColor),
//                     const SizedBox(width: 4),
//                     Text(
//                       whenText,
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: urgencyColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: urgencyColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Text(
//               urgencyLabel,
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w700,
//                 color: urgencyColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ═══════════════════════════════════════════════════
//   //  DETAIL SHEET — also simplified
//   // ═══════════════════════════════════════════════════
//   void _showSimpleDetails(BuildContext context, GestationRecord record) {
//     final gestationDays = _getGestationDays(record.animalType);
//     final daysPregnant =
//         DateTime.now().difference(record.breedingDate).inDays;
//     final daysToGo = record.expectedDueDate.difference(DateTime.now()).inDays;
//     final progress = daysPregnant / gestationDays;

//     int currentStage;
//     String stageLabel;
//     Color stageColor;

//     if (progress >= 0.85 || daysToGo <= 30) {
//       currentStage = 3;
//       stageLabel = 'Almost Ready';
//       stageColor = Colors.red.shade700;
//     } else if (progress >= 0.45) {
//       currentStage = 2;
//       stageLabel = 'Half Way';
//       stageColor = Colors.orange.shade700;
//     } else {
//       currentStage = 1;
//       stageLabel = 'Just Started';
//       stageColor = Colors.green.shade700;
//     }

//     String timeLeftText;
//     if (daysToGo < 0) {
//       timeLeftText = 'Past due date! Check on her now';
//     } else if (daysToGo <= 7) {
//       timeLeftText = 'Any day now! Stay alert';
//     } else if (daysToGo <= 30) {
//       final w = (daysToGo / 7).round();
//       timeLeftText = 'About $w week${w == 1 ? '' : 's'} to go';
//     } else if (daysToGo <= 60) {
//       timeLeftText = 'About ${(daysToGo / 30).round()} month to go';
//     } else {
//       timeLeftText = 'About ${(daysToGo / 30).round()} months to go';
//     }

//     String howFarText;
//     if (daysPregnant < 30) {
//       howFarText = '$daysPregnant days since mating';
//     } else {
//       final months = (daysPregnant / 30).floor();
//       final extra = daysPregnant % 30;
//       howFarText =
//           '$months month${months == 1 ? '' : 's'} $extra days since mating';
//     }

//     // What to do tips
//     String tipText;
//     if (currentStage == 1) {
//       tipText = 'Make sure she gets good feed and clean water. No heavy work.';
//     } else if (currentStage == 2) {
//       tipText = 'Increase her feed gradually. Watch for any swelling or discharge. Call vet if something looks wrong.';
//     } else {
//       tipText = 'Keep her in a clean, quiet place. Check frequently — she could deliver anytime!';
//     }

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.75,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 12),
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header
//                     Row(
//                       children: [
//                         Container(
//                           width: 56,
//                           height: 56,
//                           decoration: BoxDecoration(
//                             color: _getAnimalColor(record.animalType)
//                                 .withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Icon(
//                             _getAnimalIcon(record.animalType),
//                             size: 28,
//                             color: _getAnimalColor(record.animalType),
//                           ),
//                         ),
//                         const SizedBox(width: 14),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 record.animalName,
//                                 style: const TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.w800,
//                                   color: Color(0xFF1A1F36),
//                                 ),
//                               ),
//                               Text(
//                                 '${record.animalType}  •  ID: ${record.animalId}',
//                                 style: TextStyle(
//                                     fontSize: 14, color: Colors.grey[500]),
//                               ),
//                             ],
//                           ),
//                         ),
//                         _buildStatusBadge(record.status),
//                       ],
//                     ),

//                     const SizedBox(height: 24),

//                     // Stage visual
//                     const Text(
//                       'Where is she now?',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF1A1F36),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     _buildStageIndicator(
//                         currentStage, stageColor, stageLabel),

//                     const SizedBox(height: 24),

//                     // Key dates
//                     const Text(
//                       'Important Dates',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF1A1F36),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Container(
//                       padding: const EdgeInsets.all(14),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF8F9FA),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Column(
//                         children: [
//                           _detailRow(
//                             icon: Icons.favorite,
//                             iconColor: Colors.pink,
//                             label: 'Mating date',
//                             value: _formatDate(record.breedingDate),
//                           ),
//                           const SizedBox(height: 10),
//                           _detailRow(
//                             icon: Icons.child_care,
//                             iconColor: const Color(0xFF2E7D32),
//                             label: 'Expected delivery',
//                             value: _formatDate(record.expectedDueDate),
//                           ),
//                           const SizedBox(height: 10),
//                           _detailRow(
//                             icon: Icons.alarm,
//                             iconColor: stageColor,
//                             label: 'Time left',
//                             value: timeLeftText,
//                             valueColor: stageColor,
//                           ),
//                            SizedBox(height: 10),
//                           _detailRow(
//                             icon: Icons.timeline,
//                             iconColor: Colors.grey,
//                             label: 'How far along',
//                             value: howFarText,
//                           ),
//                           if (record.confirmedDate != null) ...[
//                             const SizedBox(height: 10),
//                             _detailRow(
//                               icon: Icons.verified,
//                               iconColor: Colors.green,
//                               label: 'Pregnancy confirmed on',
//                               value: _formatDate(record.confirmedDate!),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Tip box
//                     Container(
//                       padding: const EdgeInsets.all(14),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFFF8E1),
//                         borderRadius: BorderRadius.circular(12),
//                         border:
//                             Border.all(color: Colors.amber.withOpacity(0.3)),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Icon(Icons.lightbulb_rounded,
//                               color: Colors.amber, size: 22),
//                           const SizedBox(width: 12),
//                           const Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'What to do now',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.amber,
//                                   ),
//                                 ),
//                                 SizedBox(height: 4),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 34),
//                       child: Text(
//                         tipText,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.amber.shade900,
//                           height: 1.4,
//                         ),
//                       ),
//                     ),

//                     if (record.notes.isNotEmpty) ...[
//                       const SizedBox(height: 16),
//                       Container(
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF0F4F8),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(Icons.edit_note,
//                                 size: 20, color: Colors.grey[600]),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Your Notes',
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     record.notes,
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       color: Colors.grey[600],
//                                       height: 1.4,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],

//                     const SizedBox(height: 24),

//                     // Buttons
//                     Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton.icon(
//                             onPressed: () {
//                               Navigator.pop(context);
//                               _showAddHealthNoteDialog(context, record);
//                             },
//                             icon: const Icon(Icons.add_rounded, size: 18),
//                             label: const Text('Add Note'),
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: const Color(0xFF2E7D32),
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               side: const BorderSide(
//                                   color: Color(0xFF2E7D32)),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             onPressed: () => Navigator.pop(context),
//                             icon: const Icon(Icons.check_rounded, size: 18),
//                             label: const Text('Close'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF2E7D32),
//                               foregroundColor: Colors.white,
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _detailRow({
//     required IconData icon,
//     required Color iconColor,
//     required String label,
//     required String value,
//     Color? valueColor,
//   }) {
//     return Row(
//       children: [
//         Icon(icon, size: 20, color: iconColor),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(fontSize: 11, color: Colors.grey[500]),
//               ),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: valueColor ?? const Color(0xFF1A1F36),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // ═══════════════════════════════════════════════════
//   //  ADD GESTATION DIALOG — simpler wording
//   // ═══════════════════════════════════════════════════
//   void _showAddGestationDialog(BuildContext context) {
//     final nameController = TextEditingController();
//     final animalIdController = TextEditingController();
//     DateTime selectedDate = DateTime.now();
//     String selectedType = 'Cattle';
//     String selectedStatus = 'Confirmed';

//     showDialog(
//       context: context,
//       builder: (ctx) => StatefulBuilder(
//         builder: (ctx, setDialogState) => AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: const Text(
//             'Add Pregnant Animal',
//             style: TextStyle(fontWeight: FontWeight.w700),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 DropdownButtonFormField<String>(
//                   initialValue: selectedType,
//                   decoration: const InputDecoration(
//                     labelText: 'Animal Type',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.pets_rounded),
//                   ),
//                   items: const [
//                     'Cattle',
//                     'Goat',
//                     'Sheep',
//                     'Pig',
//                     'Other'
//                   ]
//                       .map((t) => DropdownMenuItem(value: t, child: Text(t)))
//                       .toList(),
//                   onChanged: (v) => setDialogState(() {
//                     selectedType = v ?? 'Cattle';
//                     selectedDate = DateTime.now();
//                   }),
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: nameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Animal Name',
//                     hintText: 'e.g. Lakshmi, Bella',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.label_rounded),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: animalIdController,
//                   decoration: const InputDecoration(
//                     labelText: 'Animal ID / Tag Number',
//                     hintText: 'e.g. CT-001',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.tag_rounded),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 InkWell(
//                   borderRadius: BorderRadius.circular(8),
//                   onTap: () async {
//                     final picked = await showDatePicker(
//                       context: ctx,
//                       initialDate: selectedDate,
//                       firstDate: DateTime(2023),
//                       lastDate: DateTime.now(),
//                     );
//                     if (picked != null) {
//                       setDialogState(() => selectedDate = picked);
//                     }
//                   },
//                   child: InputDecorator(
//                     decoration: const InputDecoration(
//                       labelText: 'When was she mated?',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.calendar_today_rounded),
//                     ),
//                     child: Text(
//                       _formatDate(selectedDate),
//                       style: const TextStyle(fontSize: 15),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 DropdownButtonFormField<String>(
//                   initialValue: selectedStatus,
//                   decoration: const InputDecoration(
//                     labelText: 'Is pregnancy confirmed?',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.help_outline_rounded),
//                   ),
//                   items: const [
//                     DropdownMenuItem(
//                         value: 'Confirmed', child: Text('Yes, confirmed')),
//                     DropdownMenuItem(
//                         value: 'Suspected',
//                         child: Text('Not sure yet')),
//                   ],
//                   onChanged: (v) =>
//                       setDialogState(() => selectedStatus = v ?? 'Confirmed'),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'We will calculate the expected delivery date for you.',
//                   style: TextStyle(fontSize: 12, color: Colors.grey[500]),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: Text('Cancel',
//                   style: TextStyle(color: Colors.grey[600])),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (nameController.text.isNotEmpty &&
//                     animalIdController.text.isNotEmpty) {
//                   final days = _getGestationDays(selectedType);
//                   final newRecord = GestationRecord(
//                     id: DateTime.now().toString(),
//                     animalName: nameController.text,
//                     animalType: selectedType,
//                     animalId: animalIdController.text,
//                     breedingDate: selectedDate,
//                     expectedDueDate:
//                         selectedDate.add(Duration(days: days)),
//                     confirmedDate: selectedStatus == 'Confirmed'
//                         ? DateTime.now()
//                         : null,
//                     status: selectedStatus == 'Confirmed'
//                         ? GestationStatus.confirmed
//                         : GestationStatus.suspected,
//                     notes: 'Newly added',
//                   );
//                   setState(() => _gestationRecords.add(newRecord));
//                   Navigator.pop(ctx);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Animal added! We calculated the due date for you.'),
//                       backgroundColor: Color(0xFF2E7D32),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Please fill in the name and ID'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF2E7D32),
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('Add Animal'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showAddHealthNoteDialog(
//       BuildContext context, GestationRecord record) {
//     final noteController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Text('Add Note for ${record.animalName}'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Write any observation — weight, feeding, vet visit, etc.',
//               style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: noteController,
//               decoration: const InputDecoration(
//                 labelText: 'Your note',
//                 hintText: 'e.g. Gave extra mineral mix today',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child:
//                 Text('Cancel', style: TextStyle(color: Colors.grey[600])),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (noteController.text.isNotEmpty) {
//                 setState(() {
//                   final idx = _gestationRecords
//                       .indexWhere((r) => r.id == record.id);
//                   if (idx != -1) {
//                     _gestationRecords[idx] = GestationRecord(
//                       id: record.id,
//                       animalName: record.animalName,
//                       animalType: record.animalType,
//                       animalId: record.animalId,
//                       breedingDate: record.breedingDate,
//                       expectedDueDate: record.expectedDueDate,
//                       confirmedDate: record.confirmedDate,
//                       status: record.status,
//                       notes:
//                           '${record.notes}\n${_formatDate(DateTime.now())}: ${noteController.text}',
//                     );
//                   }
//                 });
//               }
//               Navigator.pop(ctx);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Note saved!'),
//                   backgroundColor: Color(0xFF2E7D32),
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF2E7D32),
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Save Note'),
//           ),
//         ],
//       ),
//     );
//   }

//   // ═══════════════════════════════════════════════════
//   //  HELPERS
//   // ═══════════════════════════════════════════════════
//   int _getGestationDays(String animalType) {
//     switch (animalType.toLowerCase()) {
//       case 'cattle':
//         return 283;
//       case 'goat':
//         return 150;
//       case 'sheep':
//         return 147;
//       case 'pig':
//         return 114;
//       case 'poultry':
//         return 21;
//       case 'rabbit':
//         return 31;
//       default:
//         return 283;
//     }
//   }

//   String _formatDate(DateTime date) {
//     const months = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//     ];
//     return '${date.day} ${months[date.month - 1]} ${date.year}';
//   }

//   IconData _getAnimalIcon(String type) {
//     switch (type.toLowerCase()) {
//       case 'cattle':
//         return Icons.pets_rounded;
//       case 'goat':
//         return Icons.grass_rounded;
//       case 'sheep':
//         return Icons.agriculture_rounded;
//       case 'pig':
//         return Icons.set_meal_rounded;
//       case 'poultry':
//         return Icons.egg_rounded;
//       case 'rabbit':
//         return Icons.pets_rounded;
//       default:
//         return Icons.pets_rounded;
//     }
//   }

//   Color _getAnimalColor(String type) {
//     switch (type.toLowerCase()) {
//       case 'cattle':
//         return const Color(0xFF6D4C41);
//       case 'goat':
//         return const Color(0xFF8E24AA);
//       case 'sheep':
//         return const Color(0xFF43A047);
//       case 'pig':
//         return const Color(0xFFE65100);
//       case 'poultry':
//         return const Color(0xFFD84315);
//       case 'rabbit':
//         return const Color(0xFF9C27B0);
//       default:
//         return const Color(0xFF6D4C41);
//     }
//   }
// }
import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════
//  DATA MODELS
// ═══════════════════════════════════════════════════
enum GestationStatus { confirmed, suspected }
enum Priority { high, medium, low }

class GestationRecord {
  final String id;
  final String animalName;
  final String animalType;
  final String animalId;
  final DateTime breedingDate;
  final DateTime expectedDueDate;
  final DateTime? confirmedDate;
  final GestationStatus status;
  final String notes;

  GestationRecord({
    required this.id,
    required this.animalName,
    required this.animalType,
    required this.animalId,
    required this.breedingDate,
    required this.expectedDueDate,
    this.confirmedDate,
    required this.status,
    required this.notes,
  });
}

class GestationInfo {
  final String animalType;
  final int averageDays;
  final String range;
  final IconData icon;
  final Color color;
  final String simpleNote;

  GestationInfo({
    required this.animalType,
    required this.averageDays,
    required this.range,
    required this.icon,
    required this.color,
    required this.simpleNote,
  });
}

class HealthReminder {
  final String title;
  final String description;
  final DateTime dueDate;
  final Priority priority;

  HealthReminder({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
  });
}

// ═══════════════════════════════════════════════════
//  MAIN SCREEN
// ═══════════════════════════════════════════════════
class GestationTrackerScreen extends StatefulWidget {
  const GestationTrackerScreen({super.key});

  @override
  State<GestationTrackerScreen> createState() => _GestationTrackerScreenState();
}

class _GestationTrackerScreenState extends State<GestationTrackerScreen> {
  int _selectedTab = 0;

  // ── Sample Data ──
  final List<GestationRecord> _gestationRecords = [
    GestationRecord(
      id: '1',
      animalName: 'Bella',
      animalType: 'Cattle',
      animalId: 'CT-001',
      breedingDate: DateTime(2024, 6, 15),
      expectedDueDate: DateTime(2025, 3, 22),
      confirmedDate: DateTime(2024, 7, 1),
      status: GestationStatus.confirmed,
      notes: 'Healthy pregnancy, good weight gain',
    ),
    GestationRecord(
      id: '2',
      animalName: 'Daisy',
      animalType: 'Cattle',
      animalId: 'CT-003',
      breedingDate: DateTime(2024, 7, 20),
      expectedDueDate: DateTime(2025, 4, 26),
      confirmedDate: DateTime(2024, 8, 10),
      status: GestationStatus.confirmed,
      notes: 'First pregnancy, keep a close watch',
    ),
    GestationRecord(
      id: '3',
      animalName: 'Stella',
      animalType: 'Goat',
      animalId: 'GT-005',
      breedingDate: DateTime(2024, 8, 5),
      expectedDueDate: DateTime(2025, 1, 12),
      confirmedDate: DateTime(2024, 8, 25),
      status: GestationStatus.confirmed,
      notes: 'Triplets expected, give extra feed',
    ),
    GestationRecord(
      id: '4',
      animalName: 'Molly',
      animalType: 'Sheep',
      animalId: 'SH-002',
      breedingDate: DateTime(2024, 9, 1),
      expectedDueDate: DateTime(2025, 2, 8),
      confirmedDate: DateTime(2024, 9, 20),
      status: GestationStatus.confirmed,
      notes: 'Healthy ewe, doing well',
    ),
    GestationRecord(
      id: '5',
      animalName: 'Goldie',
      animalType: 'Pig',
      animalId: 'PG-008',
      breedingDate: DateTime(2024, 10, 10),
      expectedDueDate: DateTime(2025, 2, 4),
      confirmedDate: DateTime(2024, 11, 1),
      status: GestationStatus.confirmed,
      notes: 'Good litter expected',
    ),
  ];

  final List<GestationInfo> _gestationInfo = [
    GestationInfo(
      animalType: 'Cattle (Cow/Buffalo)',
      averageDays: 283,
      range: '279–290 days',
      icon: Icons.pets_rounded,
      color: Color(0xFF6D4C41),
      simpleNote: 'Roughly 9 months and 2 weeks — similar to humans!',
    ),
    GestationInfo(
      animalType: 'Goat',
      averageDays: 150,
      range: '145–155 days',
      icon: Icons.grass_rounded,
      color: Color(0xFF8E24AA),
      simpleNote: 'About 5 months. Give extra nutrition in last month.',
    ),
    GestationInfo(
      animalType: 'Sheep',
      averageDays: 147,
      range: '142–152 days',
      icon: Icons.agriculture_rounded,
      color: Color(0xFF43A047),
      simpleNote: 'About 5 months. Keep separate in last 2 weeks.',
    ),
    GestationInfo(
      animalType: 'Pig',
      averageDays: 114,
      range: '112–116 days',
      icon: Icons.set_meal_rounded,
      color: Color(0xFFE65100),
      simpleNote: 'About 3 months and 3 weeks. "3 months, 3 weeks, 3 days" is the easy rule.',
    ),
    GestationInfo(
      animalType: 'Poultry (Hen)',
      averageDays: 21,
      range: '20–22 days',
      icon: Icons.egg_rounded,
      color: Color(0xFFD84315),
      simpleNote: 'Just 3 weeks from egg to chick under a broody hen or incubator.',
    ),
    GestationInfo(
      animalType: 'Rabbit',
      averageDays: 31,
      range: '28–32 days',
      simpleNote: 'Only 1 month! Provide nesting box a few days before.',
      icon: Icons.pets_rounded,
      color: Color(0xFF9C27B0),
    ),
  ];

  final List<HealthReminder> _reminders = [
    HealthReminder(
      title: 'Vaccination Due',
      description: 'Daisy needs her pregnancy vaccination',
      dueDate: DateTime(2024, 12, 15),
      priority: Priority.high,
    ),
    HealthReminder(
      title: 'Weight Check',
      description: 'Bella — monthly weight check',
      dueDate: DateTime(2024, 12, 20),
      priority: Priority.medium,
    ),
    HealthReminder(
      title: 'Extra Feed Needed',
      description: 'Stella — increase feed, triplets expected',
      dueDate: DateTime(2024, 12, 25),
      priority: Priority.medium,
    ),
  ];

  // ═══════════════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Pregnancy Tracker',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _buildComingSoonContent(),
                _buildComingSoonContent(),
                _buildComingSoonContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  COMING SOON CONTENT
  // ═══════════════════════════════════════════════════
  Widget _buildComingSoonContent() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.construction_rounded,
              size: 64,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Coming Soon!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1F36),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF2E7D32).withOpacity(0.15),
              ),
            ),
            child: const Text(
              'We\'re working hard to bring you this feature.\nStay tuned for updates!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF1A1F36),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Go Back'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  TAB BAR
  // ═══════════════════════════════════════════════════
  Widget _buildTabBar() {
    final tabs = [
      {'icon': Icons.pets_rounded, 'label': 'My Animals'},
      {'icon': Icons.help_outline_rounded, 'label': 'How Long?'},
      {'icon': Icons.notifications_rounded, 'label': 'Reminders'},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isActive = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedTab = index);
                _showComingSoonDialog(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF2E7D32).withOpacity(0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tab['icon'] as IconData,
                      size: 20,
                      color: isActive
                          ? const Color(0xFF2E7D32)
                          : Colors.grey[500],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tab['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive
                            ? const Color(0xFF2E7D32)
                            : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  COMING SOON DIALOG
  // ═══════════════════════════════════════════════════
  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.construction_rounded,
                color: Color(0xFF2E7D32),
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Coming Soon!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1F36),
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This feature is currently under development.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF1A1F36),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We\'re working on making it better for you.\nCheck back soon!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  HELPERS (kept for reference but not used)
  // ═══════════════════════════════════════════════════
  int _getGestationDays(String animalType) {
    switch (animalType.toLowerCase()) {
      case 'cattle':
        return 283;
      case 'goat':
        return 150;
      case 'sheep':
        return 147;
      case 'pig':
        return 114;
      case 'poultry':
        return 21;
      case 'rabbit':
        return 31;
      default:
        return 283;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  IconData _getAnimalIcon(String type) {
    switch (type.toLowerCase()) {
      case 'cattle':
        return Icons.pets_rounded;
      case 'goat':
        return Icons.grass_rounded;
      case 'sheep':
        return Icons.agriculture_rounded;
      case 'pig':
        return Icons.set_meal_rounded;
      case 'poultry':
        return Icons.egg_rounded;
      case 'rabbit':
        return Icons.pets_rounded;
      default:
        return Icons.pets_rounded;
    }
  }

  Color _getAnimalColor(String type) {
    switch (type.toLowerCase()) {
      case 'cattle':
        return const Color(0xFF6D4C41);
      case 'goat':
        return const Color(0xFF8E24AA);
      case 'sheep':
        return const Color(0xFF43A047);
      case 'pig':
        return const Color(0xFFE65100);
      case 'poultry':
        return const Color(0xFFD84315);
      case 'rabbit':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF6D4C41);
    }
  }
}