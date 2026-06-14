import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

/// Screen để test Firebase connection
/// Chỉ dùng để kiểm tra Firebase đã hoạt động chưa
class TestFirebaseScreen extends StatefulWidget {
  const TestFirebaseScreen({super.key});

  @override
  State<TestFirebaseScreen> createState() => _TestFirebaseScreenState();
}

class _TestFirebaseScreenState extends State<TestFirebaseScreen> {
  final List<String> _logs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _testFirebase();
  }

  void _addLog(String message, {bool isError = false}) {
    setState(() {
      _logs.add('${isError ? "❌" : "✅"} $message');
    });
    print(message);
  }

  Future<void> _testFirebase() async {
    setState(() {
      _isLoading = true;
      _logs.clear();
    });

    try {
      // Test 1: Firebase Initialization
      _addLog('🔧 Testing Firebase initialization...');
      await Future.delayed(const Duration(milliseconds: 500));

      try {
        // Try to get current Firebase app
        Firebase.app();
        _addLog('Firebase đã được khởi tạo');
      } catch (e) {
        // If not initialized, try to initialize
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        _addLog('Firebase khởi tạo thành công');
      }

      // Test 2: Firebase Auth
      _addLog('\n🔐 Testing Firebase Authentication...');
      await Future.delayed(const Duration(milliseconds: 500));

      try {
        final auth = FirebaseAuth.instance;
        _addLog('Auth instance: OK');
        _addLog('Current user: ${auth.currentUser?.email ?? "None"}');
        _addLog('Firebase Auth hoạt động tốt');
      } catch (e) {
        _addLog('Firebase Auth error: $e', isError: true);
      }

      // Test 3: Firestore
      _addLog('\n📦 Testing Cloud Firestore...');
      await Future.delayed(const Duration(milliseconds: 500));

      try {
        final firestore = FirebaseFirestore.instance;
        _addLog('Firestore instance: OK');

        // Try to read/write test data
        final testDoc = firestore.collection('_test').doc('connection_test');

        // Write test
        await testDoc.set({
          'timestamp': FieldValue.serverTimestamp(),
          'message': 'Test connection from Flutter',
        });
        _addLog('✍️ Write test: OK');

        // Read test
        final snapshot = await testDoc.get();
        if (snapshot.exists) {
          _addLog('📖 Read test: OK');
          _addLog('Data: ${snapshot.data()}');
        }

        // Clean up test data
        await testDoc.delete();
        _addLog('🗑️ Cleanup: OK');

        _addLog('Cloud Firestore hoạt động tốt');
      } catch (e) {
        _addLog('Firestore error: $e', isError: true);
      }

      // Test 4: Summary
      _addLog('\n' + '=' * 50);
      final hasErrors = _logs.any((log) => log.contains('❌'));
      if (hasErrors) {
        _addLog('⚠️ CÓ LỖI - Firebase chưa hoạt động hoàn toàn', isError: true);
      } else {
        _addLog('🎉 TẤT CẢ ĐỀU OK - Firebase hoạt động tốt!');
      }
      _addLog('=' * 50);
    } catch (e) {
      _addLog('\n💥 CRITICAL ERROR: $e', isError: true);
      _addLog(
        '\n📋 Kiểm tra:\n'
        '1. File firebase_options.dart có API keys thật chưa?\n'
        '2. Firebase Console đã enable Authentication & Firestore?\n'
        '3. Có kết nối internet?',
        isError: true,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Firebase Connection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _testFirebase,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                final isError = log.contains('❌');
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    log,
                    style: TextStyle(
                      color: isError ? Colors.red : Colors.black87,
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _testFirebase,
        label: const Text('Test lại'),
        icon: const Icon(Icons.play_arrow),
      ),
    );
  }
}
