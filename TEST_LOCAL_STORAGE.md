# 💾 TEST LOCAL STORAGE - Data Lưu Vĩnh Viễn

## 🎯 Tính năng mới

**Trước đây (Memory only):**
- ❌ Đăng ký tài khoản → Restart app → **Data mất hết**
- ❌ Phải đăng ký lại mỗi lần restart

**Bây giờ (Local Storage):**
- ✅ Đăng ký tài khoản → Restart app → **Data vẫn còn**
- ✅ Đăng nhập lại được với tài khoản đã tạo
- ✅ Data lưu trên máy (không cần Firebase)

---

## 🧪 Hướng dẫn test

### Bước 1: Đảm bảo Mock mode đang BẬT

```dart
// lib/config/app_config.dart
const bool USE_REAL_FIREBASE = false;  // ← Phải là false
```

### Bước 2: Chạy app lần đầu

```bash
flutter run
```

### Bước 3: Đăng ký tài khoản

1. Skip onboarding
2. Chọn **"Đăng ký"**
3. Nhập thông tin:
   ```
   Tên: Nguyễn Văn A
   Email: test1@gmail.com
   SĐT: 0123456789
   Mật khẩu: 123456
   Xác nhận: 123456
   ```
4. Bấm **"Đăng ký"**

**Console sẽ hiện:**
```
💾 LOCAL: User saved - test1@gmail.com
✅ MOCK: User registered - test1@gmail.com (1 total users in local storage)
```

### Bước 4: Đăng nhập

1. Dùng email/password vừa tạo
2. Bấm **"Đăng nhập"**

**Console sẽ hiện:**
```
💾 LOCAL: User authenticated - test1@gmail.com
✅ MOCK: User logged in - test1@gmail.com (from local storage)
💾 MOCK: Loaded user from local storage - test1@gmail.com
```

✅ Vào được Home screen

### Bước 5: Test data persistence (Phần quan trọng!)

**A. Stop app:**
- Nhấn **q** trong terminal
- Hoặc click Stop button

**B. Run lại app:**
```bash
flutter run
```

**C. Thử đăng nhập lại:**
- Email: `test1@gmail.com`
- Password: `123456`

**✅ KẾT QUẢ MONG ĐỢI:**
- Login thành công! 🎉
- Vào được Home
- User name vẫn hiển thị đúng
- **Data không bị mất!**

### Bước 6: Test nhiều tài khoản

Đăng ký thêm các tài khoản khác:

```
User 2:
- Email: user2@gmail.com
- Password: 123456

User 3:
- Email: admin@gmail.com
- Password: 123456
```

**Console sẽ hiện:**
```
💾 LOCAL: User saved - user2@gmail.com
✅ MOCK: User registered - user2@gmail.com (2 total users in local storage)

💾 LOCAL: User saved - admin@gmail.com
✅ MOCK: User registered - admin@gmail.com (3 total users in local storage)
```

**Restart app và test:**
- Đăng nhập bằng `user2@gmail.com` → ✅ Thành công
- Logout → Đăng nhập bằng `admin@gmail.com` → ✅ Thành công
- Logout → Đăng nhập bằng `test1@gmail.com` → ✅ Thành công

**Tất cả tài khoản đều được lưu và có thể login lại!**

---

## 🔍 Chi tiết kỹ thuật

### Nơi data được lưu

**Windows:**
```
C:\Users\<YourName>\AppData\Roaming\<AppName>\shared_preferences\
```

**macOS:**
```
~/Library/Preferences/<AppName>.plist
```

**Android:**
```
/data/data/<package_name>/shared_prefs/
```

### Data được lưu gì?

```json
{
  "mock_users": {
    "test1@gmail.com": {
      "email": "test1@gmail.com",
      "password": "123456",
      "name": "Nguyễn Văn A",
      "phone": "0123456789",
      "address": "123 Đường ABC, Quận 1, TP.HCM",
      "avatarColorIndex": 0,
      "createdAt": "2024-06-14T10:30:00.000Z"
    },
    "user2@gmail.com": { ... },
    "admin@gmail.com": { ... }
  },
  "current_user_email": "test1@gmail.com"
}
```

### Console logs giải thích

| Log | Ý nghĩa |
|-----|---------|
| `💾 LOCAL: User saved` | User được lưu vào local storage |
| `💾 LOCAL: User authenticated` | Login thành công, data từ local storage |
| `💾 MOCK: Loaded user from local storage` | Load thông tin user sau login |
| `(X total users in local storage)` | Tổng số users đã đăng ký |

---

## ✅ Test Checklist

### Đăng ký
- [ ] Đăng ký tài khoản mới → Thành công
- [ ] Console hiện "💾 LOCAL: User saved"
- [ ] Đăng ký trùng email → Báo lỗi "Email đã được sử dụng"

### Đăng nhập
- [ ] Login với tài khoản vừa tạo → Thành công
- [ ] Console hiện "💾 LOCAL: User authenticated"
- [ ] Login sai email → Báo lỗi "Không tìm thấy tài khoản"
- [ ] Login sai password → Báo lỗi "Mật khẩu không đúng"

### Data Persistence
- [ ] Đăng ký → Restart app → Login lại → ✅ Thành công
- [ ] Đăng ký nhiều user → Restart → Login từng user → ✅ Tất cả OK
- [ ] Logout → Close app → Open app → Login lại → ✅ Thành công

### User Info
- [ ] Sau login, Home hiển thị đúng tên user
- [ ] Profile hiển thị đúng email, phone
- [ ] Update thông tin → Restart app → ✅ Thông tin vẫn còn

---

## 🐛 Troubleshooting

### Lỗi: "Email đã được sử dụng" nhưng không nhớ password
**Giải pháp:** Reset app data

Thêm code debug vào `main.dart`:

```dart
// Uncomment để xóa toàn bộ data (reset app)
// import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // RESET APP DATA (chỉ dùng khi debug)
  // await LocalStorageService.clearAll();
  // print('🗑️ All data cleared!');
  
  // ... rest of code
}
```

Hot restart app → Tất cả data sẽ bị xóa

### Console không hiện "💾 LOCAL: ..."
**Nguyên nhân:** Đang dùng Firebase mode

**Giải pháp:**
```dart
// lib/config/app_config.dart
const bool USE_REAL_FIREBASE = false;  // ← Đảm bảo = false
```

### Data vẫn mất sau khi restart
**Kiểm tra:**
1. Có thấy log "💾 LOCAL: User saved" khi đăng ký không?
2. Có chạy `flutter pub get` sau khi add `shared_preferences` không?
3. Có hot restart (R) sau khi đổi code không?

---

## 🎓 So sánh các chế độ

| Feature | Memory Only (Cũ) | Local Storage (Mới) | Firebase |
|---------|------------------|---------------------|----------|
| Data persistence | ❌ Mất khi restart | ✅ Lưu vĩnh viễn | ✅ Lưu vĩnh viễn |
| Cần config | ❌ Không | ❌ Không | ✅ Có |
| Cần internet | ❌ Không | ❌ Không | ✅ Có |
| Multi-device sync | ❌ Không | ❌ Không | ✅ Có |
| Tốc độ | ⚡ Rất nhanh | ⚡ Rất nhanh | 🐌 Phụ thuộc mạng |
| Dùng cho | ❌ Không khuyến nghị | ✅ Development | ✅ Production |

---

## 📝 Lưu ý quan trọng

### Security
- ⚠️ **Password được lưu dạng plain text** (không mã hóa)
- ⚠️ Chỉ dùng cho **development/testing**
- ⚠️ Production nên dùng **Firebase mode** với authentication bảo mật

### Data Migration
Nếu bạn chuyển từ Local Storage sang Firebase:
- Data local KHÔNG tự động sync lên Firebase
- Cần đăng ký lại tài khoản trên Firebase
- Hoặc viết script migration (nâng cao)

### Xóa data
Uninstall app hoặc clear app data sẽ xóa toàn bộ local storage.

---

## 🚀 Ready to test!

1. ✅ Chạy `flutter run`
2. ✅ Đăng ký tài khoản
3. ✅ Restart app
4. ✅ Login lại với tài khoản vừa tạo
5. ✅ **Success!** Data vẫn còn! 🎉

---

**Link GitHub:** https://github.com/nguyenngoclinh07032003/PRM393

**Latest commit:** "Them Local Storage: Data duoc luu vinh vien tren may"
