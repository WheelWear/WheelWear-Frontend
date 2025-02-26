import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AlertType { warning, info, success, error }

class SystemAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget>? actions;
  final AlertType alertType;

  const SystemAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    this.actions,
    this.alertType = AlertType.info,
  }) : super(key: key);

  /// 어디서든 호출할 수 있도록 static 메서드 제공
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    AlertType alertType = AlertType.info,
    List<Widget>? actions,
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => SystemAlertDialog(
        title: title,
        message: message,
        actions: actions,
        alertType: alertType,
      ),
    );
  }

  /// AlertType에 따른 아이콘 선택 (Cupertino 스타일 아이콘)
  IconData get _iconData {
    switch (alertType) {
      case AlertType.warning:
        return CupertinoIcons.exclamationmark_triangle_fill;
      case AlertType.info:
        return CupertinoIcons.info;
      case AlertType.success:
        return CupertinoIcons.check_mark_circled_solid;
      case AlertType.error:
        return CupertinoIcons.clear_circled_solid;
      default:
        return CupertinoIcons.info;
    }
  }

  /// AlertType에 따른 아이콘 색상
  Color get _iconColor {
    switch (alertType) {
      case AlertType.warning:
        return Colors.orange;
      case AlertType.info:
        return Colors.blue;
      case AlertType.success:
        return Colors.green;
      case AlertType.error:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Row(
        children: [
          Icon(_iconData, color: _iconColor),
          const SizedBox(width: 8),
          Expanded(child: Text(title)),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(message),
      ),
      actions: actions ??
          [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
    );
  }
}
