# 🔥 Hướng dẫn cấu hình Firebase

## 📋 Checklist

Để Firebase hoạt động, bạn cần:
- [ ] Lấy API keys từ Firebase Console
- [ ] Cập nhật file `firebase_options.dart`
- [ ] Enable Authentication trong Firebase
- [ ] Enable Firestore trong Firebase
- [ ] Set `USE_REAL_FIREBASE = true`

---

## 🎯 Cách 1: Tự động (Khuyến nghị)

### Bước 1: Cài FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### Bước 2: Cấu hình Firebase

```bash
flutterfire configure --project=prm393-9f30f
```

**Lệnh này sẽ:**
- ✅ Tự động lấy API keys từ Firebase Console
- ✅ Tạo file `firebase_options.dart` với values thật
- ✅ Cấu hình cho Web, Android, iOS

**Output mẫu:**
```
i Firebase project prm393-9f30f found.
i Registered platforms:
  • Web
  • Android
  • iOS
✓ Generated firebase_options.dart file.
```

### Bước 3: Enable services trong Firebase Console

1. **Vào Firebase Console:**
   https://console.firebase.google.com/project/prm393-9f30f

2. **Enable Authentication:**
   - Click **Authentication** → **Get started**
   - Tab **Sign-in method**
   - Enable **Email/Password**
   - Click **Save**

3. **Enable Firestore:**
   - Click **Firestore Database** → **Create database**
   - Chọn **Start in test mode**
   - Chọn region: **asia-southeast1** (Singapore)
   - Click **Enable**

### Bước 4: Bật Firebase mode

```dart
// lib/config/app_config.dart
const bool USE_REAL_FIREBASE = true;  // ← Đổi thành true
```

### Bước 5: Test

```bash
flutter run
```

---

## 🔧 Cách 2: Thủ công (Nếu Cách 1 không work)

### Bước 1: Vào Firebase Console

Truy cập: https://console.firebase.google.com/project/prm393-9f30f

### Bước 2: Lấy Web API Key

1. Click **⚙️ Project Settings** (góc trên bên trái)
2. Scroll xuống phần **Your apps**
3. Click vào **Web app** (icon `</>`)
4. Copy các giá trị sau:

```javascript
// Firebase SDK snippet
const firebaseConfig = {
  apiKey: "AIza...",           // ← Copy cái này
  authDomain: "prm393-9f30f.firebaseapp.com",
  projectId: "prm393-9f30f",
  storageBucket: "prm393-9f30f.firebasestorage.app",
  messagingSenderId: "123...",  // ← Copy cái này
  appId: "1:123...",            // ← Copy cái này
};
```

### Bước 3: Update firebase_options.dart

Mở file `lib/firebase_options.dart` và thay thế:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIza...',  // ← Paste apiKey ở đây
  appId: '1:123...',  // ← Paste appId ở đây
  messagingSenderId: '123...',  // ← Paste messagingSenderId ở đây
  projectId: 'prm393-9f30f',
  authDomain: 'prm393-9f30f.firebaseapp.com',
  storageBucket: 'prm393-9f30f.firebasestorage.app',
);
```

### Bước 4: Enable services (giống Cách 1)

---

## 🧪 Test Firebase Connection

### Option 1: Test trong code

Thêm vào `main.dart`:

```dart
import 'test_firebase_connection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (USE_REAL_FIREBASE) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  
  // Uncomment để test Firebase
  // runApp(MaterialApp(home: TestFirebaseScreen()));
  
  runApp(const Ecommerce());
}
```

Chạy app → Nếu không có lỗi → Firebase đã khởi tạo thành công!

### Option 2: Test bằng đăng ký/đăng nhập

1. Set `USE_REAL_FIREBASE = true`
2. Run app
3. Đăng ký tài khoản mới
4. Check console logs:

**Nếu thành công:**
```
✅ Firebase initialized
✅ User registered successfully
```

**Nếu lỗi:**
```
❌ [firebase_auth/invalid-api-key] Your API key is invalid
❌ [firebase_auth/network-request-failed] Network error
```

---

## 🔍 Troubleshooting

### Lỗi: "Invalid API key"

**Nguyên nhân:** File `firebase_options.dart` vẫn chứa placeholder `YOUR_WEB_API_KEY`

**Giải pháp:**
- Chạy lại `flutterfire configure --project=prm393-9f30f`
- Hoặc copy API key thủ công từ Firebase Console

### Lỗi: "Firebase project not found"

**Nguyên nhân:** Project ID sai hoặc không tồn tại

**Giải pháp:**
1. Vào https://console.firebase.google.com/
2. Kiểm tra project name
3. Đảm bảo project ID đúng là `prm393-9f30f`

### Lỗi: "Network request failed"

**Nguyên nhân:** Không có kết nối internet

**Giải pháp:** Kiểm tra kết nối mạng

### App bị crash khi khởi động

**Nguyên nhân:** Firebase chưa được khởi tạo đúng

**Kiểm tra:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // ← Có dòng này chưa?
  await Firebase.initializeApp(...);           // ← Có await chưa?
  runApp(...);
}
```

### Authentication không hoạt động

**Kiểm tra Firebase Console:**
1. **Authentication** → **Sign-in method**
2. **Email/Password** phải **Enabled** (màu xanh)
3. Nếu chưa → Click vào → Toggle Enable → Save

### Firestore không hoạt động

**Kiểm tra Firebase Console:**
1. **Firestore Database** phải đã được created
2. Rules phải allow read/write (test mode):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;  // ← Test mode
    }
  }
}
```

---

## 📊 So sánh Mock vs Firebase

| Feature | Mock Mode | Firebase Mode |
|---------|-----------|---------------|
| Config | ❌ Không cần | ✅ Cần setup |
| Internet | ❌ Không cần | ✅ Cần |
| Data persistence | ✅ Local only | ✅ Cloud + Local |
| Multi-device sync | ❌ Không | ✅ Có |
| Security | ⚠️ Không có | ✅ Firebase Auth |
| Cost | 💰 Free | 💰 Free (Spark plan) |

---

## 🎯 Khuyến nghị

### Dùng Mock mode khi:
- ✅ Đang development/testing UI
- ✅ Không có internet
- ✅ Chưa cần backend thật
- ✅ Demo nhanh

### Dùng Firebase mode khi:
- ✅ Cần data sync
- ✅ Deploy production
- ✅ Nhiều users
- ✅ Cần security

---

## 📝 Checklist hoàn chỉnh

### Setup Firebase
- [ ] Chạy `flutterfire configure`
- [ ] File `firebase_options.dart` có API keys thật
- [ ] Enable Authentication (Email/Password)
- [ ] Enable Firestore Database
- [ ] Firestore rules set to test mode

### Setup App
- [ ] `USE_REAL_FIREBASE = true` trong `app_config.dart`
- [ ] `firebase_options.dart` không bị gitignore (đã có trong repo)
- [ ] Đã chạy `flutter pub get`
- [ ] Hot restart app (R)

### Test
- [ ] App khởi động không crash
- [ ] Đăng ký tài khoản → Thành công
- [ ] Check Firebase Console → Users tab → Có user mới
- [ ] Logout → Login lại → Thành công
- [ ] Check Firestore → Có collection `users`

---

## 🚀 Next Steps

Sau khi Firebase hoạt động:

1. **Update Firestore Rules** (quan trọng cho security):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    match /orders/{orderId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

2. **Enable other Firebase services:**
   - Cloud Storage (cho upload ảnh)
   - Cloud Functions (backend logic)
   - Firebase Analytics (tracking)

3. **Deploy app:**
   - Web: `flutter build web`
   - Android: `flutter build apk`
   - iOS: `flutter build ios`

---

**Cần help?** Chạy test Firebase và gửi logs cho tôi!
