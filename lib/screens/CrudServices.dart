import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

 String getCurrentUserId() {
    final User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception("No user logged in");
    }
  }

  // Get the collection reference for the current user's projects
  CollectionReference get userProjects {
    final String uid = getCurrentUserId();
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('projects'); // Projects specific to this user
  }

  Stream<List<List<double>>> getWeeklySummary() {
    return userProjects.snapshots().map((snapshot) {
      List<double> ongoingCounts = List.generate(7, (_) => 0);
      List<double> doneCounts = List.generate(7, (_) => 0);
      List<double> canceledCounts = List.generate(7, (_) => 0);

      for (final doc in snapshot.docs) {
        final projectData = doc.data() as Map<String, dynamic>;
        final status = projectData['status'] ?? 'ongoing';
        final dayOfWeek = projectData['timeStamp'].toDate().weekday;

        int index = (dayOfWeek == 7 ? 0 : dayOfWeek - 1); // Sunday to index 0
        switch (status) {
          case 'done':
            doneCounts[index] += 1;
            break;
          case 'canceled':
            canceledCounts[index] += 1;
            break;
          default:
            ongoingCounts[index] += 1;
            break;
        }
      }

      return [ongoingCounts, doneCounts, canceledCounts];
    });
  }

   Future<void> addProject({
    required String projectName,
    required String clientName,
    required String projectDescription,
  }) {
    return userProjects.add({
      'project': projectName,
      'clientName': clientName,
      'projectDescription': projectDescription,
      'timeStamp': Timestamp.now(),
      'status': 'ongoing'
    });
  }

   Stream<QuerySnapshot> getProjectStream() {
    return userProjects.orderBy('timeStamp', descending: true).snapshots();
  }

 Future<void> updateProject({
  required String docId,
  required String newProject,
  required String newClientName,
  required String newProjectDescription,
  required String newStatus,
}) {
  return userProjects.doc(docId).update({
    'project': newProject,
    'clientName': newClientName,
    'projectDescription': newProjectDescription,
    'status': newStatus,
  });
}

  Future<void> deleteProject(String docID) {
    return userProjects.doc(docID).delete();
  }
}

