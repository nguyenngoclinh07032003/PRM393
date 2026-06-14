# 🔥 Lấy Firebase Config - 3 Phút

## 📍 Bước 1: Mở Firebase Console

Click link này: **https://console.firebase.google.com/project/prm393-9f30f/settings/general**

(Đăng nhập bằng tài khoản Google nếu cần)

---

## 📍 Bước 2: Scroll xuống "Your apps"

Bạn sẽ thấy section **"Your apps"** ở giữa trang.

Nếu chưa có app, click button **"Add app"** hoặc icon `</>` (Web).

---

## 📍 Bước 3: Copy Firebase Config

Trong phần **SDK setup and configuration**, chọn tab **Config**:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  authDomain: "prm393-9f30f.firebaseapp.com",
  projectId: "prm393-9f30f",
  storageBucket: "prm393-9f30f.firebasestorage.app",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef123456",
};
```

**Copy 3 giá trị này:**
- ✅ `apiKey`
- ✅ `messagingSenderId`
- ✅ `appId`

---

## 📍 Bước 4: Paste vào Code

Mở file `lib/firebase_options.dart`

Tìm phần `static const FirebaseOptions web = ...`

**THAY THẾ:**

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',  // ← Paste ở đây
  appId: '1:123456789012:web:abcdef123456',        // ← Paste ở đây
  messagingSenderId: '123456789012',               // ← Paste ở đây
  projectId: 'prm393-9f30f',
  authDomain: 'prm393-9f30f.firebaseapp.com',
  storageBucket: 'prm393-9f30f.firebasestorage.app',
);
```

**Save file!**

---

## 📍 Bước 5: Enable Authentication

Click: **https://console.firebase.google.com/project/prm393-9f30f/authentication/providers**

1. Click **"Get started"** (nếu chưa enable)
2. Click **"Email/Password"**
3. Toggle **Enable** ON
4. Click **"Save"**

✅ Authentication ready!

---

## 📍 Bước 6: Enable Firestore

Click: **https://console.firebase.google.com/project/prm393-9f30f/firestore**

1. Click **"Create database"**
2. Chọn **"Start in test mode"**
3. Location: **asia-southeast1 (Singapore)**
4. Click **"Enable"**

✅ Firestore ready!

---

## 📍 Bước 7: Bật Firebase Mode

Mở file `lib/config/app_config.dart`

**THAY ĐỔI:**

```dart
const bool USE_REAL_FIREBASE = true;  // ← Đổi false thành true
```

**Save file!**

---

## 📍 Bước 8: Test

```bash
flutter run
```

**Console sẽ hiện:**
```
✅ Firebase initialized successfully!
```

**Đăng ký tài khoản mới:**
- Email: test@firebase.com
- Password: 123456

**Check Firebase Console:**
- Vào: https://console.firebase.google.com/project/prm393-9f30f/authentication/users
- **Nếu thấy user mới** → ✅ **THÀNH CÔNG!**

---

## 🎯 Tóm tắt

| Bước | Action | Link |
|------|--------|------|
| 1 | Lấy Firebase Config | [Settings](https://console.firebase.google.com/project/prm393-9f30f/settings/general) |
| 2 | Paste vào `firebase_options.dart` | - |
| 3 | Enable Authentication | [Auth](https://console.firebase.google.com/project/prm393-9f30f/authentication/providers) |
| 4 | Enable Firestore | [Firestore](https://console.firebase.google.com/project/prm393-9f30f/firestore) |
| 5 | Set `USE_REAL_FIREBASE = true` | `lib/config/app_config.dart` |
| 6 | Test app | `flutter run` |

---

## ❓ Nếu không thấy "Your apps"

**Tạo Web app mới:**

1. Vào: https://console.firebase.google.com/project/prm393-9f30f/settings/general
2. Scroll xuống **"Your apps"**
3. Click icon **`</>`** (Add web app)
4. App nickname: `Shop App Web`
5. **KHÔNG check** "Also set up Firebase Hosting"
6. Click **"Register app"**
7. Copy config từ màn hình tiếp theo

---

## 📸 Screenshot Example

Khi bạn mở Firebase Console, bạn sẽ thấy:

```
Your apps
─────────────────────────────────
📱 Android app      (nếu có)
🍎 iOS app          (nếu có)
🌐 Web app          ← Cái này!
   Shop App Web
   
   SDK setup and configuration
   
   [npm] [script] [config]  ← Click tab "config"
   
   const firebaseConfig = {
     apiKey: "AIza...",      ← Copy
     authDomain: "...",
     projectId: "...",
     storageBucket: "...",
     messagingSenderId: "...", ← Copy
     appId: "..."            ← Copy
   };
```

---

## ✅ Done!

Chỉ cần:
1. Copy 3 values từ Firebase Console
2. Paste vào `firebase_options.dart`
3. Enable Auth & Firestore
4. Set `USE_REAL_FIREBASE = true`
5. Run app!

**Tổng thời gian: ~3 phút** ⏱️
