import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/bible_version.dart';
import '../../domain/usecases/get_bible_versions.dart';

// ── States ────────────────────────────────────────────────────────────────────

abstract class VersionSelectorState extends Equatable {
  const VersionSelectorState();
  @override
  List<Object?> get props => [];
}

class VersionSelectorLoading extends VersionSelectorState {
  const VersionSelectorLoading();
}

class VersionSelectorLoaded extends VersionSelectorState {
  final List<BibleVersion> versions;
  final String? selectedId;

  const VersionSelectorLoaded({required this.versions, this.selectedId});

  VersionSelectorLoaded copyWith({
    List<BibleVersion>? versions,
    String? selectedId,
  }) =>
      VersionSelectorLoaded(
        versions: versions ?? this.versions,
        selectedId: selectedId ?? this.selectedId,
      );

  @override
  List<Object?> get props => [versions, selectedId];
}

class VersionSelectorError extends VersionSelectorState {
  final String message;
  const VersionSelectorError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class VersionSelectorCubit extends Cubit<VersionSelectorState> {
  final GetBibleVersions _getBibleVersions;

  VersionSelectorCubit(this._getBibleVersions)
      : super(const VersionSelectorLoading());

  Future<void> loadVersions() async {
    emit(const VersionSelectorLoading());
    try {
      final versions = await _getBibleVersions();
      emit(VersionSelectorLoaded(versions: versions));
    } catch (e) {
      emit(VersionSelectorError(e.toString()));
    }
  }

  void selectVersion(String id) {
    if (state is VersionSelectorLoaded) {
      emit((state as VersionSelectorLoaded).copyWith(selectedId: id));
    }
  }

  BibleVersion? get selectedVersion {
    if (state is VersionSelectorLoaded) {
      final loaded = state as VersionSelectorLoaded;
      if (loaded.selectedId == null) return null;
      return loaded.versions
          .where((v) => v.id == loaded.selectedId)
          .firstOrNull;
    }
    return null;
  }
}
