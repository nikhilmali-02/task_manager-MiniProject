import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/models/TaskModel.dart';

class FirestoreService {
  String get uid => FirebaseAuth.instance.currentUser!.uid;
  CollectionReference<Map<String, dynamic>> get collection => FirebaseFirestore.instance.collection('users').doc(uid).collection('tasks');

  Future<void> addTask(Taskmodel task) async{
    await collection.doc(task.id).set(task.toJson());
  }

  Future<List<Taskmodel>> loadTasks() async{
    final snapshot = await collection.get();
    final tasks = snapshot.docs.map((doc) => Taskmodel.fromJson(doc.data())).toList();
    return tasks;
  }

  Future<void> deleteTask(String id) async{
    await collection.doc(id).delete();
  }

  Future<void> updateTask(Taskmodel task) async{
    await collection.doc(task.id).update(task.toJson());
  }

  Future<void> toggleTask(String id) async{
    final doc = await collection.doc(id).get();
    final task = Taskmodel.fromJson(doc.data()!);
    final toggled = task.copyWith(isCompleted: !task.isCompleted);
    await collection.doc(toggled.id).update(toggled.toJson());
  }
}