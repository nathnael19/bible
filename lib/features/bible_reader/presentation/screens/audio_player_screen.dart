import 'package:flutter/material.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  bool _isPlaying = false;
  final double _progress = 0.35;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.onSurface, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz_rounded, color: theme.colorScheme.onSurface),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 40),
            // --- Artwork Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _PlayerArtwork(),
            ),

            const SizedBox(height: 32),
            // --- Metadata Section ---
            _PlayerMetadata(),

            const SizedBox(height: 32),
            // --- Progress Section ---
            _PlayerProgressBar(progress: _progress),

            const SizedBox(height: 32),
            // --- Primary Controls ---
            _PlayerPrimaryControls(
              isPlaying: _isPlaying,
              onToggle: () => setState(() => _isPlaying = !_isPlaying),
            ),

            const SizedBox(height: 32),
            // --- Secondary Controls ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _PlayerSecondaryControls(),
            ),

            const SizedBox(height: 48),
            // --- Playlist Section ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _PlaylistSection(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _PlayerArtwork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: 340,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1519781542704-957ff19eff00?w=800'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Overlay for manual "Logos" feel
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
                stops: const [0.6, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 24,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'አሁን በመጫወት ላይ',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Noto Serif Ethiopic',
                  ),
                ),
                Text(
                  'የዮሐንስ ወንጌል',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Noto Serif Ethiopic',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerMetadata extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Column(
      children: [
        Text(
          'ምዕራፍ ፩ (1)',
          style: tt.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'Noto Serif Ethiopic',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'የጌታችን የኢየሱስ ክርስቶስ ወንጌል',
          style: tt.bodySmall!.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontFamily: 'Noto Serif Ethiopic',
          ),
        ),
      ],
    );
  }
}

class _PlayerProgressBar extends StatelessWidget {
  final double progress;
  const _PlayerProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '04:12',
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '12:45',
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerPrimaryControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onToggle;

  const _PlayerPrimaryControls({required this.isPlaying, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.shuffle_rounded, color: theme.colorScheme.onSurfaceVariant, size: 24),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.replay_10_rounded, color: theme.colorScheme.primary, size: 32),
          onPressed: () {},
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: onToggle,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: theme.colorScheme.onPrimary,
              size: 40,
            ),
          ),
        ),
        const SizedBox(width: 24),
        IconButton(
          icon: Icon(Icons.forward_30_rounded, color: theme.colorScheme.primary, size: 32),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.repeat_rounded, color: theme.colorScheme.onSurfaceVariant, size: 24),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _PlayerSecondaryControls extends StatelessWidget {
  const _PlayerSecondaryControls();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SecondaryAction(
            icon: Icons.speed_rounded,
            label: '1.0x',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SecondaryAction(
            icon: Icons.nights_stay_outlined,
            label: 'Sleep',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SecondaryAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const Spacer(),
          Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _PlaylistSection extends StatelessWidget {
  const _PlaylistSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ተከታታይ ምዕራፎች',
              style: tt.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Noto Serif Ethiopic',
              ),
            ),
            Icon(Icons.grid_view_rounded, size: 18, color: theme.colorScheme.primary.withValues(alpha: 0.5)),
          ],
        ),
        const SizedBox(height: 20),
        // Active Tile
        const _PlayingNextTile(
          number: '፩',
          title: 'ምዕራፍ አንድ',
          subtitle: 'አሁን በመጫወት ላይ',
          duration: '12:45',
          isActive: true,
        ),
        const SizedBox(height: 12),
        const _PlayingNextTile(
          number: '፪',
          title: 'ምዕራፍ ሁለት',
          duration: '10:30',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SmallNextCard(
                number: '፫',
                title: 'ምዕራፍ ሦስት',
                duration: '09:15',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SmallNextCard(
                number: '፬',
                title: 'ምዕራፍ አራት',
                duration: '14:20',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PlayingNextTile extends StatelessWidget {
  final String number;
  final String title;
  final String? subtitle;
  final String duration;
  final bool isActive;

  const _PlayingNextTile({
    required this.number,
    required this.title,
    this.subtitle,
    required this.duration,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: isActive ? Border.all(color: theme.colorScheme.primary, width: 2) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Noto Serif Ethiopic'),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Noto Serif Ethiopic'),
                ),
                Text(
                  subtitle ?? duration,
                  style: TextStyle(
                    fontSize: 11,
                    color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'Noto Serif Ethiopic',
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            Icon(Icons.graphic_eq_rounded, color: theme.colorScheme.primary, size: 24)
          else
            Icon(Icons.play_arrow_rounded, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3), size: 20),
        ],
      ),
    );
  }
}

class _SmallNextCard extends StatelessWidget {
  final String number;
  final String title;
  final String duration;

  const _SmallNextCard({
    required this.number,
    required this.title,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Noto Serif Ethiopic'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Noto Serif Ethiopic'),
          ),
          Text(
            duration,
            style: TextStyle(
              fontSize: 10,
              color: theme.colorScheme.onSurfaceVariant,
              fontFamily: 'Noto Serif Ethiopic',
            ),
          ),
        ],
      ),
    );
  }
}
