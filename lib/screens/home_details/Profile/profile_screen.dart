import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/app_models.dart';

// ═══════════════════════════════════════════════════════════════
//  TAB 4 — PROFILE
// ═══════════════════════════════════════════════════════════════
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          _buildStatsRow(),
          const SizedBox(height: 20),
          _buildMenuSection('My Farm', [
            MenuItem(icon: Icons.pets_rounded, title: 'My Animals', subtitle: '12 animals registered', color: const Color(0xFF6D4C41), count: '12'),
            MenuItem(icon: Icons.coronavirus_rounded, title: 'Health Records', subtitle: 'Track vaccinations & treatments', color: const Color(0xFFE53935), count: '8'),
            MenuItem(icon: Icons.pregnant_woman_rounded, title: 'Gestation Tracking', subtitle: '3 active pregnancies', color: const Color(0xFFEC407A), count: '3'),
          ]),
          _buildMenuSection('Activity', [
            MenuItem(icon: Icons.history_rounded, title: 'My Reports', subtitle: 'Disease reports submitted', color: const Color(0xFF1E88E5), count: '5'),
            MenuItem(icon: Icons.star_rounded, title: 'Saved Articles', subtitle: 'Bookmarked posts', color: const Color(0xFFFFA000), count: '14'),
            MenuItem(icon: Icons.chat_rounded, title: 'Chat History', subtitle: 'Previous AI conversations', color: const Color(0xFF8E24AA), count: '23'),
          ]),
          _buildMenuSection('Settings', [
            MenuItem(icon: Icons.person_rounded, title: 'Edit Profile', subtitle: 'Update your information', color: const Color(0xFF2E7D32)),
            MenuItem(icon: Icons.ring_volume, title: 'Notifications', subtitle: 'Manage alert preferences', color: const Color(0xFFFB8C00)),
            MenuItem(icon: Icons.help_rounded, title: 'Help & Support', subtitle: 'FAQs and contact us', color: const Color(0xFF039BE5)),
            MenuItem(icon: Icons.logout_rounded, title: 'Log Out', subtitle: 'Sign out of your account', color: const Color(0xFFE53935)),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Color(0xFF1B5E20), blurRadius: 20, offset: Offset(0, 6)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      child: Column(
        children: [
          Row(children: [
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(13), border: Border.all(color: Colors.white.withOpacity(0.1))),
                  child: const Icon(Icons.settings_rounded, color: Colors.white, size: 21)),
            ),
          ]),
          const SizedBox(height: 16),
          Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFF8F00), Color(0xFFF57C00)]),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [BoxShadow(color: const Color(0xFFF57C00).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                  border: Border.all(color: Colors.white, width: 3)),
              child: const Center(child: Text('JM', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)))),
          const SizedBox(height: 14),
          const Text('John Mukasa', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('Poultry & Cattle Farmer • Wakiso, Uganda', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
          const SizedBox(height: 12),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.15))),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.verified_rounded, color: Colors.greenAccent, size: 15),
                SizedBox(width: 5),
                Text('Verified Farmer', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ])),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _statCard('Animals', '12', Icons.pets_rounded, const Color(0xFF6D4C41)),
          const SizedBox(width: 12),
          _statCard('Reports', '5', Icons.coronavirus_rounded, const Color(0xFFE53935)),
          const SizedBox(width: 12),
          _statCard('Saved', '14', Icons.bookmark_rounded, const Color(0xFFFFA000)),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))]),
        child: Column(
          children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 20)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1F36))),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<MenuItem> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(left: 4, bottom: 10), child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36), letterSpacing: 0.3))),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))]),
            child: Column(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isLast = index == items.length - 1;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.vertical(bottom: isLast ? const Radius.circular(18) : Radius.zero),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      child: Row(
                        children: [
                          Container(width: 42, height: 42, decoration: BoxDecoration(color: item.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(item.icon, color: item.color, size: 20)),
                          const SizedBox(width: 14),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(item.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1F36))),
                            const SizedBox(height: 2),
                            Text(item.subtitle, style: TextStyle(fontSize: 11.5, color: Colors.grey[500])),
                          ])),
                          if (item.count != null) ...[
                            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: item.color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Text(item.count!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: item.color))),
                            const SizedBox(width: 8),
                          ],
                          Icon(Icons.chevron_right_rounded, color: Colors.grey[300], size: 22),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}