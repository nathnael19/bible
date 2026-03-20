import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Icon(Icons.menu_book_rounded, color: SabaColors.primary, size: 28),
        ),
        title: Text(
          'የቅዱስ ጽሑፋት',
          style: TextStyle(
            color: SabaColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Noto Serif Ethiopic',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black54),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // --- Avatar Section ---
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: SabaColors.primary.withValues(alpha: 0.1), width: 4),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: SabaColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'አበባ ከበደ',
              style: tt.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Noto Serif Ethiopic',
              ),
            ),
            Text(
              'abeba.kebede@example.com',
              style: tt.bodySmall!.copyWith(color: Colors.black38),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(label: 'የመገለጫ ሰረዝ', isActive: true),
                const SizedBox(width: 12),
                _ActionButton(label: 'አጋራ', isActive: false),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // --- Streak Card ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F2F1).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.whatshot, color: SabaColors.primary, size: 28),
                    const SizedBox(height: 8),
                    const Text('15', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: SabaColors.primary)),
                    Text('ተከታታይ ቀናት', style: tt.bodySmall!.copyWith(color: Colors.black45)),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // --- Grid Stats ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.menu_book_outlined,
                      value: '1,240',
                      label: 'የንባብ ምዕራፍ',
                      color: const Color(0xFFFFF4E0),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.calendar_today_outlined,
                      value: '3',
                      label: 'የቃላት ጥናት',
                      color: const Color(0xFFE5E5E5).withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // --- Level Progress ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _LevelCard(),
            ),
            
            const SizedBox(height: 32),
            
            // --- Settings Menus ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'መለያ እና ምርጫዎች',
                    style: tt.titleMedium!.copyWith(fontWeight: FontWeight.bold, fontFamily: 'Noto Serif Ethiopic'),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        _MenuTile(icon: Icons.note_alt_outlined, label: 'የኔ ማህደሮች'),
                        _MenuTile(icon: Icons.bookmark_outline, label: 'ምዕራፍ የተደረገባቸው'),
                        _MenuTile(icon: Icons.history, label: 'የንባብ ታሪክ', isLast: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        _MenuTile(icon: Icons.settings_outlined, label: 'የመተግበሪያ ቅንብሮች'),
                        _MenuTile(icon: Icons.language_outlined, label: 'ቋንቋ', subLabel: 'አማርኛ', isLast: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // --- Logout ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout_outlined, size: 20),
                label: const Text('ከመለያ ውጣ', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Noto Serif Ethiopic')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: SabaColors.primary,
                  side: BorderSide(color: SabaColors.primary.withValues(alpha: 0.1), width: 1),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: SabaColors.primary.withValues(alpha: 0.02),
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool isActive;
  const _ActionButton({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? SabaColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isActive ? null : Border.all(color: Colors.black12),
        boxShadow: isActive ? [BoxShadow(color: SabaColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))] : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          fontFamily: 'Noto Serif Ethiopic',
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _InfoCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: SabaColors.primary.withValues(alpha: 0.6), size: 24),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: SabaColors.primary)),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black45, fontFamily: 'Noto Serif Ethiopic'),
          ),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: SabaColors.primary, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.stars_rounded, color: Colors.white, size: 28),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                child: const Text('LEVEL 4', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('85%', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const Text('የዕድገት ደረጃ', style: TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'Noto Serif Ethiopic')),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.85,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subLabel;
  final bool isLast;
  const _MenuTile({required this.icon, required this.label, this.subLabel, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF4F2F1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.black54, size: 20),
          ),
          title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Noto Serif Ethiopic')),
          subtitle: subLabel != null ? Text(subLabel!, style: const TextStyle(fontSize: 10, color: SabaColors.primary, fontWeight: FontWeight.bold)) : null,
          trailing: const Icon(Icons.chevron_right, color: Colors.black26, size: 20),
          onTap: () {},
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: Colors.black.withValues(alpha: 0.05)),
          ),
      ],
    );
  }
}
