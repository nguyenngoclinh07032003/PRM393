# 🛍️ E-commerce Flutter App

App bán hàng hiện đại với UI/UX đẹp mắt, animations mượt mà và Firebase backend.

## ✨ Tính năng

- 🔐 **Authentication**: Đăng ký, đăng nhập, reset password
- 🏠 **Home**: Search & filter sản phẩm real-time
- 📦 **Products**: Chi tiết sản phẩm với animations đẹp
- 🛒 **Cart**: Giỏ hàng với swipe-to-delete
- 💳 **Checkout**: Thanh toán với nhiều phương thức
- 👤 **Profile**: Quản lý đơn hàng, yêu thích, địa chỉ
- 🎨 **Onboarding**: 3 màn hình giới thiệu app

## 🚀 Bắt đầu

### 1. Clone repository

```bash
git clone https://github.com/nguyenngoclinh07032003/PRM393.git
cd appbanhang
```

### 2. Cài đặt dependencies

```bash
flutter pub get
```

### 3. Chọn chế độ chạy

App hỗ trợ 2 chế độ:

#### 📱 MOCK MODE (Không cần Firebase - Dùng để test nhanh)

Mở file `lib/services/auth_service.dart` và đặt:

```dart
const bool USE_REAL_FIREBASE = false;
```

✅ **Ưu điểm**: 
- Chạy ngay không cần cấu hình Firebase
- Data lưu trong memory
- Dùng cho demo và test UI

❌ **Nhược điểm**:
- Data mất khi restart app
- Không có backend thật

#### 🔥 FIREBASE MODE (Backend thật)

**Bước 1**: Cấu hình Firebase

```bash
# Cài FlutterFire CLI
dart pub global activate flutterfire_cli

# Cấu hình Firebase (tự động)
flutterfire configure --project=prm393-9f30f
```

**Bước 2**: Mở `lib/services/auth_service.dart` và đặt:

```dart
const bool USE_REAL_FIREBASE = true;
```

**Bước 3**: Enable Authentication & Firestore trong Firebase Console:

1. Vào [Firebase Console](https://console.firebase.google.com/project/prm393-9f30f)
2. **Authentication** → **Sign-in method** → Enable **Email/Password**
3. **Firestore Database** → **Create database** → **Start in test mode**

### 4. Chạy app

```bash
flutter run
```

Chọn device (Windows, Chrome, hoặc Mobile emulator)

## 📁 Cấu trúc thư mục

```
lib/
├── main.dart                 # Entry point
├── models/                   # Data models
│   ├── product.dart
│   ├── cart_item.dart
│   └── order.dart
├── providers/                # State management
│   ├── app_provider.dart
│   └── cart_provider.dart
├── screens/                  # UI screens
│   ├── onboarding/
│   ├── auth/                 # Login, Register, Reset Password
│   ├── home/
│   ├── product/
│   ├── cart/
│   ├── checkout/
│   └── profile/
├── services/                 # Backend services
│   ├── auth_service.dart     # Authentication (Mock + Firebase)
│   ├── user_service.dart
│   ├── order_service.dart
│   └── favorite_service.dart
├── widgets/                  # Reusable widgets
│   └── common_widgets.dart
└── utils/                    # Utilities
    └── format.dart           # Colors, shadows, constants
```

## 🎨 UI/UX Features

### ✨ Animations
- Hero animations giữa screens
- Fade & slide animations
- Scale animations khi tap
- Shimmer loading effects
- Success checkmark animations

### 🎯 Interactions
- Haptic feedback
- Pull-to-refresh
- Swipe-to-delete
- Bottom sheets
- Snackbars đẹp

### 📱 Components
- Gradient buttons
- Card với shadows
- Empty states
- Loading overlays
- Badge số lượng
- Scale buttons

## 🔧 Công nghệ

- **Flutter** 3.0+
- **Firebase Auth** - Authentication
- **Cloud Firestore** - Database
- **Provider** - State management
- **Material 3** - Design system

## 📝 Lưu ý

### Mock Mode
- Dữ liệu user lưu trong memory (mất khi restart)
- Mỗi email chỉ đăng ký được 1 lần trong 1 session
- Console sẽ hiển thị log: `✅ MOCK: User registered/logged in`

### Firebase Mode
- Cần cấu hình Firebase trước khi chạy
- Data được lưu vĩnh viễn trên Firestore
- Cần kết nối internet

### Chuyển đổi Mode
1. Mở `lib/services/auth_service.dart`
2. Thay đổi `USE_REAL_FIREBASE` thành `true` hoặc `false`
3. Hot restart app (không chỉ hot reload)

## 🐛 Troubleshooting

### Lỗi: "Firebase not configured"
→ Đặt `USE_REAL_FIREBASE = false` trong `auth_service.dart`

### Lỗi: "Invalid API key"
→ Chạy `flutterfire configure --project=prm393-9f30f`

### App không đăng nhập được
→ Kiểm tra console log xem đang ở Mock mode hay Firebase mode

### Data bị mất
→ Đang dùng Mock mode, chuyển sang Firebase mode để lưu data thật

## 📸 Screenshots

[Thêm screenshots ở đây]

## 👨‍💻 Developer

**Nguyễn Ngọc Linh**
- GitHub: [@nguyenngoclinh07032003](https://github.com/nguyenngoclinh07032003)
- Project: [PRM393](https://github.com/nguyenngoclinh07032003/PRM393)

## 📄 License

MIT License
