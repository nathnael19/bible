import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseSyncService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseSyncService(this._firestore, this._auth);

  String? get _uid => _auth.currentUser?.uid;

  DocumentReference? get _userDoc {
    final uid = _uid;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid);
  }

  // ── Bookmarks ──────────────────────────────────────────────────────────────

  Future<void> syncBookmarks(String bookId, int chapter, Set<int> verses) async {
    final userDoc = _userDoc;
    if (userDoc == null) return;

    final bookmarkKey = '${bookId}_$chapter';
    await userDoc.collection('bookmarks').doc(bookmarkKey).set({
      'bookId': bookId,
      'chapter': chapter,
      'verses': verses.toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, Set<int>>> getAllBookmarks() async {
    final userDoc = _userDoc;
    if (userDoc == null) return {};

    final snapshot = await userDoc.collection('bookmarks').get();
    final allBookmarks = <String, Set<int>>{};
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final verses = List<int>.from(data['verses'] ?? []);
      allBookmarks[doc.id] = verses.toSet();
    }
    return allBookmarks;
  }

  // ── Stats & History ────────────────────────────────────────────────────────

  Future<void> syncStats({
    int? totalVersesRead,
    List<String>? readingHistory,
    Map<String, dynamic>? lastReadLocation,
  }) async {
    final userDoc = _userDoc;
    if (userDoc == null) return;

    final data = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (totalVersesRead != null) data['totalVersesRead'] = totalVersesRead;
    if (readingHistory != null) data['readingHistory'] = readingHistory;
    if (lastReadLocation != null) data['lastReadLocation'] = lastReadLocation;

    await userDoc.set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getStats() async {
    final userDoc = _userDoc;
    if (userDoc == null) return null;

    final doc = await userDoc.get();
    return doc.data() as Map<String, dynamic>?;
  }

  // ── Activity Log ──────────────────────────────────────────────────────────

  Future<void> logActivity(Map<String, dynamic> activity) async {
    final userDoc = _userDoc;
    if (userDoc == null) return;

    await userDoc.collection('activity_log').add({
      ...activity,
      'syncedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getActivityLog() async {
    final userDoc = _userDoc;
    if (userDoc == null) return [];

    final snapshot = await userDoc
        .collection('activity_log')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // ── Reading Plans ──────────────────────────────────────────────────────────

  Future<void> syncPlanProgress(String planId, List<String> completedTaskIds) async {
    final userDoc = _userDoc;
    if (userDoc == null) return;

    await userDoc.collection('reading_plans').doc(planId).set({
      'completedTaskIds': completedTaskIds,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, List<String>>> getAllPlanProgress() async {
    final userDoc = _userDoc;
    if (userDoc == null) return {};

    final snapshot = await userDoc.collection('reading_plans').get();
    final allProgress = <String, List<String>>{};
    for (var doc in snapshot.docs) {
      final data = doc.data();
      allProgress[doc.id] = List<String>.from(data['completedTaskIds'] ?? []);
    }
    return allProgress;
  }
}
