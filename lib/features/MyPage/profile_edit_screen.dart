import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_service.dart'; // 백엔드 통신 서비스
import 'profile_image_section.dart'; // 프로필 이미지 위젯
import 'profile_provider.dart';

class ProfileEditScreen extends StatefulWidget {
  final ProfileProvider profileProvider;

  ProfileEditScreen({required this.profileProvider});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final ProfileService _profileService = ProfileService();
  bool _isSaving = false;
  Future<Map<String, dynamic>?>? _profileFuture;

  late TextEditingController _nameController;
  late TextEditingController _genderController;
  late TextEditingController _birthDateController;
  late TextEditingController _bioController;
  late TextEditingController _phoneController;

  File? _profileImageFile; // 선택된 프로필 이미지 파일
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _profileFuture = _profileService.fetchProfile(context);
  }

  /// 갤러리에서 이미지를 선택하는 메서드
  Future<void> _pickProfileImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImageFile = File(pickedFile.path);
      });
    }
  }

  /// 백엔드에 업데이트 요청 후 알림 다이얼로그를 표시합니다.
  Future<void> _updateProfile() async {
    setState(() {
      _isSaving = true;
    });

    final updatedData = {
      "name": _nameController.text,
      "gender": _genderController.text,
      "birth_date": _birthDateController.text,
      "bio": _bioController.text,
      "phone_number": _phoneController.text,
    };

    bool success = await _profileService.updateProfile(
      context,
      updatedData,
      profileImage: _profileImageFile,
    );

    setState(() {
      _isSaving = false;
    });
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text("알림"),
        content: Text(success ? "프로필이 업데이트되었습니다." : "업데이트에 실패했습니다."),
        actions: [
          CupertinoDialogAction(
            child: Text("확인"),
            onPressed: () {
              Navigator.pop(context);
              if (success) {
                // Provider의 상태를 업데이트하여 MyPageScreen에 반영
                widget.profileProvider.loadProfile(context);
                setState(() {
                  _profileFuture = _profileService.fetchProfile(context);
                  _profileImageFile = null;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  /// 개별 입력 필드를 생성하는 메서드
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? placeholder,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        CupertinoTextField(
          controller: controller,
          obscureText: obscureText,
          placeholder: placeholder,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  /// 모든 입력 필드를 리스트로 생성합니다.
  List<Widget> _buildInputFields() {
    final fieldsData = [
      {"label": "이름", "controller": _nameController, "placeholder": "이름"},
      {
        "label": "성별",
        "controller": _genderController,
        "placeholder": "M or F"
      },
      {
        "label": "생년월일",
        "controller": _birthDateController,
        "placeholder": "YYYY-MM-DD"
      },
      {
        "label": "자기소개",
        "controller": _bioController,
        "placeholder": "자기소개를 입력하세요"
      },
      {
        "label": "전화번호",
        "controller": _phoneController,
        "placeholder": "010-0000-0000"
      },
    ];

    return fieldsData
        .map((field) => Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: _buildInputField(
        label: field["label"] as String,
        controller: field["controller"] as TextEditingController,
        placeholder: field["placeholder"] as String,
      ),
    ))
        .toList();
  }

  /// 프로필 섹션(프로필 이미지와 이름, 전화번호)을 생성합니다.
  Widget _buildProfileSection(String? imageUrl) {
    return Row(
      children: [
        ProfileImageSection(
          imageFile: _profileImageFile,
          imageUrl: imageUrl,
          onImageTap: _pickProfileImage,
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _nameController.text.isNotEmpty ? _nameController.text : "이름",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              _phoneController.text.isNotEmpty ? _phoneController.text : "전화번호",
              style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("프로필 편집"),
        automaticallyImplyLeading: true,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: _isSaving
              ? CupertinoActivityIndicator()
              : Text("수정", style: TextStyle(color: CupertinoColors.activeBlue)),
          onPressed: _isSaving ? null : _updateProfile,
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CupertinoActivityIndicator());
            }
            if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text("프로필 정보를 불러오지 못했습니다."));
            }

            final profileData = snapshot.data!;
            // 컨트롤러 초기화 (한번만 초기화)
            _nameController =
                TextEditingController(text: profileData['name'] ?? '');
            _genderController =
                TextEditingController(text: profileData['gender'] ?? '');
            _birthDateController =
                TextEditingController(text: profileData['birth_date'] ?? '');
            _bioController =
                TextEditingController(text: profileData['bio'] ?? '');
            _phoneController =
                TextEditingController(text: profileData['phone_number'] ?? '');
            String? imageUrl = profileData['profile_picture'];

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  _buildProfileSection(imageUrl),
                  SizedBox(height: 30),
                  ..._buildInputFields(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
