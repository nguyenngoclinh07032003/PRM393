// ═══════════════════════════════════════════════════════════════════════════
// 🔥 APP CONFIGURATION
// ═══════════════════════════════════════════════════════════════════════════
// 
// ⚙️ MOCK MODE vs FIREBASE MODE
// 
// Set to FALSE to use mock authentication (no Firebase needed for testing)
// Set to TRUE to use real Firebase (requires firebase_options.dart configured)
//
// HOW TO SWITCH:
// 1. Change this value below
// 2. Hot restart app (not just hot reload)
// 
// ═══════════════════════════════════════════════════════════════════════════

/// Set to false for testing without Firebase, true for production
const bool USE_REAL_FIREBASE = false;

// ═══════════════════════════════════════════════════════════════════════════
// MOCK MODE (USE_REAL_FIREBASE = false)
// ═══════════════════════════════════════════════════════════════════════════
// ✅ No Firebase configuration needed
// ✅ Works offline
// ✅ Fast for testing UI/UX
// ❌ Data stored in memory (lost on app restart)
// ❌ No real backend
//
// FIREBASE MODE (USE_REAL_FIREBASE = true)
// ═══════════════════════════════════════════════════════════════════════════
// ✅ Real backend with Firestore
// ✅ Data persists across sessions
// ✅ Multi-device sync
// ❌ Requires Firebase configuration
// ❌ Needs internet connection
//
// TO CONFIGURE FIREBASE:
// 1. Install FlutterFire CLI: dart pub global activate flutterfire_cli
// 2. Run: flutterfire configure --project=prm393-9f30f
// 3. Enable Authentication & Firestore in Firebase Console
// 4. Set USE_REAL_FIREBASE = true above
// ═══════════════════════════════════════════════════════════════════════════
