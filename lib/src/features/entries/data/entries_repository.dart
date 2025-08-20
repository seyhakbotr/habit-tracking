import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/authentication/domain/app_user.dart';
import 'package:starter_architecture_flutter_firebase/src/features/entries/domain/entry.dart';
import 'package:starter_architecture_flutter_firebase/src/features/habits/domain/habit.dart';

part 'entries_repository.g.dart';

class EntriesRepository {
  const EntriesRepository(this._firestore);
  final FirebaseFirestore _firestore;

  static String entryPath(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entriesPath(String uid) => 'users/$uid/entries';

  // create
  Future<void> addEntry({
    required UserID uid,
    required HabitID habitId,
    required DateTime start,
    required DateTime end,
    required String comment,
  }) =>
      _firestore.collection(entriesPath(uid)).add({
        'habitId': habitId,
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
        'comment': comment,
      });

  // update
  Future<void> updateEntry({
    required UserID uid,
    required Entry entry,
  }) =>
      _firestore.doc(entryPath(uid, entry.id)).update(entry.toMap());

  // delete
  Future<void> deleteEntry({required UserID uid, required EntryID entryId}) =>
      _firestore.doc(entryPath(uid, entryId)).delete();

  // read
  Stream<List<Entry>> watchEntries({required UserID uid, HabitID? habitId}) =>
      queryEntries(uid: uid, habitId: habitId)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Query<Entry> queryEntries({required UserID uid, HabitID? habitId}) {
    Query<Entry> query =
        _firestore.collection(entriesPath(uid)).withConverter<Entry>(
              fromFirestore: (snapshot, _) =>
                  Entry.fromMap(snapshot.data()!, snapshot.id),
              toFirestore: (entry, _) => entry.toMap(),
            );
    if (habitId != null) {
      query = query.where('habitId', isEqualTo: habitId);
    }
    return query;
  }
}

@riverpod
EntriesRepository entriesRepository(Ref ref) {
  return EntriesRepository(FirebaseFirestore.instance);
}

@riverpod
Query<Entry> habitEntriesQuery(Ref ref, HabitID habitId) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null when fetching habits');
  }
  final repository = ref.watch(entriesRepositoryProvider);
  return repository.queryEntries(uid: user.uid, habitId: habitId);
}
