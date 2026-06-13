# 🚀 QUICK START - Test App Ngay Lập Tức

## ⚡ Chạy app trong 30 giây

### Bước 1: Install dependencies
```bash
flutter pub get
```

### Bước 2: Chạy app
```bash
flutter run
```
Chọn device (Windows, Chrome, hoặc Mobile)

### Bước 3: Test flow
1. **Onboarding** → Bấm "Bắt đầu" hoặc "Bỏ qua"
2. **Đăng ký** → Nhập thông tin và đăng ký
   - Email: `test@gmail.com`
   - Password: `123456`
   - Tên: `Test User`
   - SĐT: `0123456789`
3. **Đăng nhập** → Dùng email/password vừa tạo
4. **Home** → Tìm kiếm, filter, xem sản phẩm
5. **Mua hàng** → Thêm vào giỏ → Thanh toán

---

## 🔧 Cấu hình chế độ

### 📍 Vị trí file cấu hình

**File duy nhất cần chỉnh**: `lib/config/app_config.dart`

```dart
const bool USE_REAL_FIREBASE = false;  // ← Thay đổi ở đây
```

### 🟢 Mock Mode (Mặc định - Không cần Firebase)

```dart
const bool USE_REAL_FIREBASE = false;
```

**Console log khi chạy:**
```
🔶 RUNNING IN MOCK MODE - No Firebase connection needed
✅ MOCK: User registered - test@gmail.com
✅ MOCK: User logged in - test@gmail.com
```

**Đặc điểm:**
- ✅ Chạy ngay không cần config
- ✅ Không cần internet
- ✅ Đăng ký/đăng nhập local
- ❌ Data mất khi restart app

### 🔥 Firebase Mode (Production)

```dart
const bool USE_REAL_FIREBASE = true;
```

**Yêu cầu:**
1. Đã chạy `flutterfire configure --project=prm393-9f30f`
2. Enable Authentication trong Firebase Console
3. Enable Firestore Database
4. Có kết nối internet

**Đặc điểm:**
- ✅ Data lưu vĩnh viễn
- ✅ Đồng bộ multi-device
- ✅ Backend thật
- ❌ Cần cấu hình Firebase

---

## 🐛 Troubleshooting

### Lỗi: App không đăng nhập được / Không chuyển sang Home
**Nguyên nhân**: Đang bật Firebase mode nhưng chưa config Firebase

**Giải pháp**:
```dart
// lib/config/app_config.dart
const bool USE_REAL_FIREBASE = false;  // ← Đổi thành false
```

Sau đó **hot restart** app (không chỉ hot reload)

---

### Lỗi: "Firebase not initialized"
**Giải pháp**: Đảm bảo `USE_REAL_FIREBASE = false` hoặc chạy:
```bash
flutterfire configure --project=prm393-9f30f
```

---

### Data bị mất sau khi restart app
**Nguyên nhân**: Đang dùng Mock mode (data lưu trong memory)

**Giải pháp**: Chuyển sang Firebase mode để lưu data thật

---

### Console không hiện log "MOCK: ..."
**Kiểm tra**:
1. Mở `lib/config/app_config.dart`
2. Đảm bảo `USE_REAL_FIREBASE = false`
3. Hot restart app (R trong terminal, hoặc stop và run lại)

---

## 📋 Test Checklist

Sau khi chạy app, test các tính năng:

### ✅ Authentication
- [ ] Xem onboarding (3 pages)
- [ ] Đăng ký tài khoản mới
- [ ] Đăng nhập với tài khoản vừa tạo
- [ ] Quên mật khẩu (nhập email → nhận OTP → đặt password mới)

### ✅ Home & Products
- [ ] Xem sản phẩm trên home
- [ ] Search sản phẩm (gõ tên sản phẩm)
- [ ] Filter theo category (Thời trang, Điện tử, Phụ kiện, Giày dép)
- [ ] Tap vào sản phẩm → xem chi tiết
- [ ] Thêm vào yêu thích (tap icon tim)
- [ ] Pull-to-refresh (kéo xuống để refresh)

### ✅ Product Detail
- [ ] Xem chi tiết sản phẩm
- [ ] Chọn size (S, M, L, XL)
- [ ] Tăng/giảm số lượng
- [ ] Thêm vào giỏ hàng
- [ ] Mua ngay → chuyển sang checkout

### ✅ Cart
- [ ] Xem giỏ hàng (tab Giỏ hàng)
- [ ] Tăng/giảm số lượng sản phẩm
- [ ] Xóa sản phẩm (vuốt sang trái hoặc tap icon xóa)
- [ ] Xóa tất cả sản phẩm
- [ ] Nhập mã giảm giá
- [ ] Thanh toán

### ✅ Checkout & Orders
- [ ] Kiểm tra địa chỉ giao hàng
- [ ] Chọn phương thức thanh toán (Ví điện tử, Thẻ, Tiền mặt)
- [ ] Hoàn tất thanh toán
- [ ] Xem màn hình success
- [ ] "Về trang chủ" → quay về home
- [ ] "Xem đơn hàng" → xem lịch sử

### ✅ Profile
- [ ] Xem thông tin cá nhân
- [ ] Xem đơn hàng của tôi
- [ ] Mua lại đơn hàng
- [ ] Xem sản phẩm yêu thích
- [ ] Chỉnh sửa địa chỉ giao hàng
- [ ] Cài đặt (chỉnh sửa thông tin, đổi màu avatar)
- [ ] Đăng xuất

---

## 💡 Tips

### Dữ liệu mẫu test

**Đăng ký nhiều tài khoản:**
```
Email: user1@test.com - Password: 123456
Email: user2@test.com - Password: 123456
Email: admin@test.com - Password: 123456
```

### Hot Restart vs Hot Reload

**Hot Reload** (r): Chỉ cập nhật UI
**Hot Restart** (R): Khởi động lại toàn bộ app (cần khi đổi config)

Sau khi đổi `USE_REAL_FIREBASE`, bạn PHẢI hot restart!

### Xem console logs

Khi chạy `flutter run`, console sẽ hiện:
- `🔶 RUNNING IN MOCK MODE` → Đang dùng Mock mode
- `✅ MOCK: User registered` → Đăng ký thành công (Mock)
- `✅ MOCK: User logged in` → Đăng nhập thành công (Mock)

Không thấy logs trên → Đang dùng Firebase mode

---

## 🎯 Development Workflow

### For UI/UX Development
```dart
const bool USE_REAL_FIREBASE = false;  // Mock mode
```
→ Nhanh, không cần config, dễ test

### For Backend Integration
```dart
const bool USE_REAL_FIREBASE = true;   // Firebase mode
```
→ Cần config Firebase, test tích hợp thật

### For Demo/Presentation
```dart
const bool USE_REAL_FIREBASE = false;  // Mock mode
```
→ Đảm bảo app chạy ngay trên mọi máy

---

## 📞 Support

Gặp vấn đề? Kiểm tra:
1. `lib/config/app_config.dart` → `USE_REAL_FIREBASE = false`
2. Đã chạy `flutter pub get`
3. Đã hot restart app (R)
4. Console có hiện "🔶 RUNNING IN MOCK MODE"

Vẫn lỗi? Mở issue trên GitHub!
