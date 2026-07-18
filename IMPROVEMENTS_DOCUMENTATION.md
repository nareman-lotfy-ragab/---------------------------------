# تحسينات صفحة البروفايل والتكامل مع API

## نظرة عامة

تم تحسين صفحة البروفايل بشكل كامل لإزالة التكرار وتحسين التكامل مع API. تم إنشاء نسخ محسّنة من الملفات مع الحفاظ على الملفات الأصلية.

---

## الملفات المحسّنة

### 1. **profile_page_improved.dart**
**المسار**: `lib/features/profile/presentation/pages/profile_page_improved.dart`

#### التحسينات:
- **إزالة التكرار**: تم دمج البيانات من API بشكل أفضل دون تكرار
- **عرض بيانات إضافية**: إضافة عرض رقم الهاتف والعنوان من API
- **تحسين الواجهة**: إضافة widget `_buildInfoCard` لعرض المعلومات الإضافية بشكل منظم
- **دعم صورة البروفايل**: عرض صورة البروفايل من URL إذا كانت متاحة
- **إزالة الأقسام غير المستخدمة**: تم حذف Language و Help و About
- **إضافة قسم الأمان**: ربط مباشر لصفحة تغيير كلمة المرور

#### الميزات الجديدة:
```dart
// عرض البيانات الإضافية
if (phone.isNotEmpty || address.isNotEmpty)
  Column(
    children: [
      _buildSectionTitle('معلومات إضافية'),
      if (phone.isNotEmpty)
        _buildInfoCard('رقم الهاتف', phone, Icons.phone),
      if (address.isNotEmpty)
        _buildInfoCard('العنوان', address, Icons.location_on),
    ],
  ),

// دعم صورة البروفايل
if (profileImageUrl != null && profileImageUrl.isNotEmpty)
  CircleAvatar(
    radius: 60,
    backgroundImage: NetworkImage(profileImageUrl),
  )
```

---

### 2. **personal_info_page_improved.dart**
**المسار**: `lib/features/profile/presentation/pages/sub_pages/personal_info_page_improved.dart`

#### التحسينات:
- **إضافة حقول جديدة**: رقم الهاتف والعنوان
- **تحسين التحقق من الصحة**: validation أفضل لجميع الحقول
- **تحسين الواجهة**: تصميم أفضل للنماذج مع icons
- **إدارة أفضل للـ Controllers**: إضافة dispose صحيح
- **رسائل خطأ واضحة**: رسائل تحقق من الصحة بالعربية

#### الحقول الجديدة:
```dart
// رقم الهاتف
_phoneController = TextEditingController(
  text: widget.initialData?['phone'] ?? '',
);

// العنوان
_addressController = TextEditingController(
  text: widget.initialData?['address'] ?? '',
);
```

#### التحقق من الصحة:
```dart
validator: (value) {
  if (value != null && value.isNotEmpty) {
    if (value.length < 10) {
      return 'رقم الهاتف غير صحيح';
    }
  }
  return null;
},
```

---

### 3. **security_page.dart** (ملف جديد)
**المسار**: `lib/features/profile/presentation/pages/sub_pages/security_page.dart`

#### الميزات:
- **تغيير كلمة المرور**: واجهة آمنة وسهلة الاستخدام
- **عرض/إخفاء كلمات المرور**: toggle buttons لكل حقل
- **التحقق من التطابق**: التحقق من تطابق كلمات المرور الجديدة
- **نصائح الأمان**: عرض نصائح لإنشاء كلمات مرور قوية
- **معايير القوة**: التحقق من أن كلمة المرور تحتوي على 8 أحرف على الأقل

#### الوظائف الرئيسية:
```dart
// التحقق من تطابق كلمات المرور
if (_newPasswordController.text != _confirmPasswordController.text) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('كلمات المرور الجديدة غير متطابقة'),
      backgroundColor: Colors.red,
    ),
  );
  return;
}

// معايير كلمة المرور
if (value.length < 8) {
  return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
}
```

---

### 4. **auth_bloc_improved.dart**
**المسار**: `lib/features/auth/presentation/bloc/auth_bloc_improved.dart`

#### التحسينات:
- **إضافة معرّف المستخدم**: إضافة `userId` إلى `AuthAuthenticated` state
- **تخزين معرّف المستخدم**: حفظ user ID في SharedPreferences
- **استرجاع معرّف المستخدم**: استخراج user ID من API response

#### التغييرات الرئيسية:
```dart
class AuthAuthenticated extends AuthState {
  final String email;
  final String role;
  final String? token;
  final String? userId; // إضافة معرّف المستخدم الفريد
  
  const AuthAuthenticated(
    this.email,
    this.role, {
    this.token,
    this.userId,
  });
}
```

#### استخراج معرّف المستخدم:
```dart
final userId = data['id'] ?? data['userId'];

// حفظ في SharedPreferences
if (userId != null) {
  await prefs.setString('user_id', userId.toString());
}

// استخدام في الـ State
emit(AuthAuthenticated(
  email,
  role,
  token: token,
  userId: userId?.toString(),
));
```

---

## المشاكل التي تم حلها

### 1. **استخدام Email كـ User ID**
**المشكلة الأصلية**:
```dart
final userId = authState.email; // خطأ: استخدام email بدلاً من ID
final result = await ApiService.getProfile(userId);
```

**الحل**:
```dart
// في AuthBloc
final userId = data['id'] ?? data['userId'];

// في ProfilePage
final userId = authState.userId ?? authState.email; // استخدام ID أولاً
```

### 2. **التكرار بين ProfilePage و PersonalInfoPage**
**المشكلة الأصلية**:
- نفس البيانات (fullName, email, role) معروضة في مكانين

**الحل**:
- ProfilePage تعرض البيانات بشكل read-only
- PersonalInfoPage تسمح بالتعديل فقط
- إزالة الأقسام غير المستخدمة

### 3. **عدم استخدام البيانات الإضافية من API**
**المشكلة الأصلية**:
- API يرجع phone و address لكن لا يتم عرضها

**الحل**:
- إضافة عرض للبيانات الإضافية في ProfilePage
- إضافة حقول للتعديل على هذه البيانات في PersonalInfoPage

### 4. **عدم وجود وظيفة تغيير كلمة المرور**
**المشكلة الأصلية**:
- API يوفر endpoint لتغيير كلمة المرور لكن لا يتم استخدامه

**الحل**:
- إنشاء SecurityPage جديدة
- تطبيق واجهة آمنة لتغيير كلمة المرور

---

## خطوات التطبيق

### الخطوة 1: استبدال الملفات
```bash
# استبدال profile_page.dart
cp lib/features/profile/presentation/pages/profile_page_improved.dart \
   lib/features/profile/presentation/pages/profile_page.dart

# استبدال personal_info_page.dart
cp lib/features/profile/presentation/pages/sub_pages/personal_info_page_improved.dart \
   lib/features/profile/presentation/pages/sub_pages/personal_info_page.dart

# إضافة security_page.dart
cp lib/features/profile/presentation/pages/sub_pages/security_page.dart \
   lib/features/profile/presentation/pages/sub_pages/security_page.dart

# استبدال auth_bloc.dart
cp lib/features/auth/presentation/bloc/auth_bloc_improved.dart \
   lib/features/auth/presentation/bloc/auth_bloc.dart
```

### الخطوة 2: تحديث الـ Imports
تأكد من تحديث جميع الـ imports في الملفات التي تستخدم ProfilePage و PersonalInfoPage

### الخطوة 3: اختبار الوظائف
- اختبر تسجيل الدخول والتحقق من حفظ user ID
- اختبر عرض البيانات الإضافية (phone, address)
- اختبر تحديث البيانات
- اختبر تغيير كلمة المرور

---

## API Endpoints المستخدمة

| الـ Endpoint | الطريقة | الوصف |
|-----------|--------|-------|
| `/api/Profile/{id}` | GET | الحصول على بيانات البروفايل |
| `/api/Profile/{id}` | PUT | تحديث بيانات البروفايل |
| `/api/Profile/change-password` | PUT | تغيير كلمة المرور |
| `/api/Profile/{id}/notifications` | GET | الحصول على الإشعارات |
| `/api/ProfileImage/upload` | POST | رفع صورة البروفايل |

---

## الملاحظات المهمة

### 1. **معرّف المستخدم**
- تأكد من أن API يرجع `id` أو `userId` في response تسجيل الدخول
- إذا كان الـ API يستخدم اسم مختلف، قم بتحديث الكود:
```dart
final userId = data['customIdField']; // استبدل customIdField بالاسم الفعلي
```

### 2. **تغيير كلمة المرور**
- تحقق من API documentation للـ endpoint الدقيق
- قد يكون الـ endpoint `PUT /api/Profile/change-password` أو مختلف
- تأكد من أن الـ API يتطلب كلمة المرور الحالية للتحقق

### 3. **صور البروفايل**
- إذا كنت تريد دعم رفع صور، قم بتطبيق:
```dart
// استخدام image_picker لاختيار الصورة
// ثم استدعاء ApiService.uploadProfileImage()
```

### 4. **التحقق من الصحة**
- تأكد من تحديث معايير التحقق حسب متطلبات التطبيق
- يمكن إضافة معايير إضافية مثل التحقق من صيغة البريد الإلكتروني

---

## الاختبار

### اختبار الوظائف الأساسية:
1. تسجيل الدخول والتحقق من حفظ user ID
2. عرض البيانات الإضافية (phone, address)
3. تحديث البيانات الشخصية
4. تغيير كلمة المرور
5. عرض الإشعارات

### اختبار الأخطاء:
1. محاولة تحديث ببيانات غير صحيحة
2. محاولة تغيير كلمة المرور بكلمة ضعيفة
3. محاولة تغيير كلمة المرور بكلمات غير متطابقة
4. فقدان الاتصال بالإنترنت

---

## الخلاصة

تم تحسين صفحة البروفايل بشكل كامل من خلال:
- ✅ إزالة التكرار في الواجهة
- ✅ تحسين التكامل مع API
- ✅ إضافة وظائف مفقودة (تغيير كلمة المرور)
- ✅ عرض جميع البيانات المتاحة من API
- ✅ تحسين تجربة المستخدم
- ✅ إضافة معايير أمان أفضل

جميع الملفات المحسّنة جاهزة للاستخدام والاختبار.
