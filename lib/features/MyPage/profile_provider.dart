import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  String? _name;
  String? _gender;
  String? _birthDate;
  int? _age;
  String? _bio;
  String? _phoneNumber;
  String? _profilePicture;
  bool? _isReformProvider;
  bool _isLoading = false;

  // 새롭게 추가: 사용자가 선택한 이미지 파일 (업데이트 전)
  File? _profileImageFile;

  String? get name => _name;
  String? get gender => _gender;
  String? get birthDate => _birthDate;
  int? get age => _age;
  String? get bio => _bio;
  String? get phoneNumber => _phoneNumber;
  String? get profilePicture => _profilePicture;
  bool? get isReformProvider => _isReformProvider;
  bool get isLoading => _isLoading;

  // 새롭게 추가: 선택된 이미지 파일 getter
  File? get profileImageFile => _profileImageFile;

  void updateProfile({
    String? name,
    String? gender,
    String? birthDate,
    int? age,
    String? bio,
    String? phoneNumber,
    String? profilePicture,
    bool? isReformProvider,
  }) {
    if (name != null) _name = name;
    if (gender != null) _gender = gender;
    if (birthDate != null) _birthDate = birthDate;
    if (age != null) _age = age;
    if (bio != null) _bio = bio;
    if (phoneNumber != null) _phoneNumber = phoneNumber;
    if (profilePicture != null) _profilePicture = profilePicture;
    if (isReformProvider != null) _isReformProvider = isReformProvider;
    notifyListeners();
  }

  // 새롭게 추가: 이미지 파일 업데이트 메서드
  void setProfileImage(File? image) {
    _profileImageFile = image;
    notifyListeners();
  }

  /// 백엔드에서 프로필 정보를 불러와서 업데이트합니다.
  Future<void> loadProfile(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    ProfileService profileService = ProfileService();
    final data = await profileService.fetchProfile(context);
    if (data != null) {
      updateProfile(
        name: data['name'] as String?,
        gender: data['gender'] as String?,
        birthDate: data['birth_date'] as String?,
        age: data['age'] as int?,
        bio: data['bio'] as String?,
        phoneNumber: data['phone_number'] as String?,
        profilePicture: data['profile_picture'] as String?,
        isReformProvider: data['is_reform_provider'] as bool?,
      );
      // 이미지 파일은 새로 선택하지 않았다면 초기화
      setProfileImage(null);
    }
    _isLoading = false;
    notifyListeners();
  }

  /// 프로필 정보를 백엔드로 업데이트합니다.
  /// profileImage가 제공되면 해당 이미지를 multipart로 업로드합니다.
  Future<bool> submitProfileUpdate(BuildContext context, {File? profileImage}) async {
    ProfileService profileService = ProfileService();
    final profileData = {
      "name": _name,
      "gender": _gender,
      "birth_date": _birthDate,
      "age": _age,
      "bio": _bio,
      "phone_number": _phoneNumber,
      "profile_picture": _profilePicture,
      "is_reform_provider": _isReformProvider,
    };

    bool success = await profileService.updateProfile(
      context,
      profileData,
      profileImage: profileImage,
    );
    if (success) {
      // 업데이트 성공 시 선택된 이미지 파일은 초기화합니다.
      setProfileImage(null);
    }
    return success;
  }
}
