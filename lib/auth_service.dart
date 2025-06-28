import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String email;

  AppUser({required this.id, required this.email});
}

class AuthService {
  static AppUser? currentUser;

  /// 🔐 Register pengguna baru dan simpan ke koleksi `users`
  static Future<AppUser> register(String email, String password) async {
    final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = cred.user!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'createdAt': DateTime.now().toIso8601String(),
    });

    final user = AppUser(id: uid, email: email);
    return currentUser = user;
  }

  /// 🔑 Login dan muat info user dari Firestore
  static Future<AppUser> login(String email, String password) async {
    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception("Data user tidak ditemukan di Firestore.");
    }

    final data = doc.data()!;
    final user = AppUser(id: uid, email: data['email']);
    return currentUser = user;
  }

  /// 🚪 Logout
  static void logout() {
    FirebaseAuth.instance.signOut();
    currentUser = null;
  }
}
