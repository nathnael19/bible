import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible/l10n/app_localizations.dart';
import '../cubit/audio_reader_cubit.dart';
import '../../../../core/services/audio_streaming_service.dart';
import '../../../../core/di/injection_container.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AudioReaderCubit, AudioReaderState>(
      builder: (context, state) {
        if (state is AudioReaderInitial) {
          return const Scaffold(
            body: Center(child: Text('No Audio Loaded')),
          );
        }

        if (state is AudioReaderLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AudioReaderError) {
          return Scaffold(
            body: Center(child: Text('Error: ${state.message}')),
          );
        }

        if (state is AudioReaderLoaded) {
          return Scaffold(
            backgroundColor: theme.colorScheme.surface,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: theme.colorScheme.onSurface,
                  size: 32,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.more_horiz_rounded,
                    color: theme.colorScheme.onSurface,
                  ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _PlayerArtwork(state: state),
                  ),
                  const SizedBox(height: 32),
                  _PlayerMetadata(state: state),
                  const SizedBox(height: 32),
                  _PlayerProgressBar(),
                  const SizedBox(height: 32),
                  _PlayerPrimaryControls(state: state),
                  const SizedBox(height: 32),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: _PlayerSecondaryControls(),
                  ),
                  const SizedBox(height: 48),
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
        return const SizedBox.shrink();
      },
    );
  }
}

class _PlayerArtwork extends StatelessWidget {
  final AudioReaderLoaded state;
  const _PlayerArtwork({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: 340,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1519781542704-957ff19eff00?w=800',
          ),
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
                  l10n.nowPlaying,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Noto Serif Ethiopic',
                  ),
                ),
                Text(
                  'Book ${state.bookId}',
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
  final AudioReaderLoaded state;
  const _PlayerMetadata({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Column(
      children: [
        Text(
          '${l10n.chapterLabel} ${state.chapter}',
          style: tt.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'Noto Serif Ethiopic',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.gospelDescriptor,
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
  const _PlayerProgressBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioService = sl<AudioStreamingService>();

    return StreamBuilder<Duration>(
      stream: audioService.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        return StreamBuilder<Duration?>(
          stream: audioService.durationStream,
          builder: (context, dSnapshot) {
            final duration = dSnapshot.data ?? Duration.zero;
            final progress = duration.inMilliseconds > 0
                ? position.inMilliseconds / duration.inMilliseconds
                : 0.0;

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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(position),
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _formatDuration(duration),
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
          },
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _PlayerPrimaryControls extends StatelessWidget {
  final AudioReaderLoaded state;
  const _PlayerPrimaryControls({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<AudioReaderCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.shuffle_rounded,
            color: theme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            Icons.replay_10_rounded,
            color: theme.colorScheme.primary,
            size: 32,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: () => state.isPlaying ? cubit.pause() : cubit.play(),
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
              state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: theme.colorScheme.onPrimary,
              size: 40,
            ),
          ),
        ),
        const SizedBox(width: 24),
        IconButton(
          icon: Icon(
            Icons.forward_30_rounded,
            color: theme.colorScheme.primary,
            size: 32,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            Icons.repeat_rounded,
            color: theme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
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
    final l10n = AppLocalizations.of(context)!;
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
            label: l10n.sleep,
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.nextChapters,
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
        _PlayingNextTile(
          number: l10n.geeNumber1,
          title: l10n.chapterOne,
          subtitle: l10n.nowPlaying,
          duration: '12:45',
          isActive: true,
        ),
        const SizedBox(height: 12),
        _PlayingNextTile(
          number: l10n.geeNumber2,
          title: l10n.chapterTwo,
          duration: '10:30',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SmallNextCard(
                number: l10n.geeNumber3,
                title: l10n.chapterThree,
                duration: '09:15',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SmallNextCard(
                number: l10n.geeNumber4,
                title: l10n.chapterFour,
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
