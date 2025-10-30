import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/login_screen.dart'; // عشان نقدر نرجع بعد اللوج آوت

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final _firestore = FirebaseFirestore.instance;
  bool _isEditing = false;
  final _nameController = TextEditingController();
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _initializeUserData();
  }

  // تحميل أو إنشاء بيانات المستخدم في Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> _initializeUserData() async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    try {
      final docSnapshot = await userDoc.get();

      // لو مفيش داتا، نضيفها افتراضياً
      if (!docSnapshot.exists) {
        await userDoc.set({
          'name': user.displayName ?? 'User',
          'email': user.email,
          'imageUrl': 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      final updatedDoc = await userDoc.get();
      final data = updatedDoc.data() ?? {};
      _nameController.text = data['name'] ?? '';
      return updatedDoc;
    } catch (e) {
      debugPrint('Error initializing user data: $e');
      rethrow; // هيتعامل معاه الـ FutureBuilder
    }
  }

  // تحديث الاسم
  Future<void> _updateName() async {
    try {
      await _firestore.collection('users').doc(user.uid).update({
        'name': _nameController.text.trim(),
      });
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Name updated successfully!')),
      );
    } catch (e) {
      debugPrint('Error updating name: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Failed to update name.')),
      );
    }
  }

  // تسجيل الخروج
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFFE74C1B),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                '⚠️ Connection error — check your internet connection.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No user data found.'));
          }

          final userData = snapshot.data!.data()!;
          final imageUrl = userData['imageUrl'] ??
              'https://cdn-icons-png.flaticon.com/512/149/149071.png';
          final name = userData['name'] ?? 'User';
          final email = userData['email'] ?? user.email ?? 'No Email';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('🖼️ Change photo coming soon!')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // الاسم (تعديل أو عرض)
                _isEditing
                    ? TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon:
                                const Icon(Icons.check, color: Colors.green),
                            onPressed: _updateName,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () =>
                                setState(() => _isEditing = !_isEditing),
                          ),
                        ],
                      ),

                const SizedBox(height: 15),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onBackground.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
