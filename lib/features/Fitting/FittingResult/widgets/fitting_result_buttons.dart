// fitting_result_buttons.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheelwear_frontend/utils/system_alert_dialog.dart';
import 'retry_fitting.dart';

class FittingResultButtons extends StatelessWidget {
  const FittingResultButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildTextButton(
                CupertinoIcons.back,
                "처음으로",
                    () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          _buildMainButton(
            CupertinoIcons.arrow_down_circle_fill,
            "코디에 저장",
                () {
              print("✅ 코디 저장 기능");
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildTextButton(
                CupertinoIcons.arrow_right_arrow_left,
                "추가 피팅하기",
                    () async {
                  try {
                    bool result = await performSpecificLogic();
                    if (result) {
                      Navigator.pop(context);
                    } else {
                      SystemAlertDialog.show(
                        context: context,
                        title: "오류",
                        message: "특정 로직 수행 중 문제가 발생하였습니다.",
                        alertType: AlertType.error,
                      );

                    }
                  } catch (e) {
                    SystemAlertDialog.show(
                      context: context,
                      title: "오류",
                      message: "특정 로직 수행 중 오류가 발생하였습니다:\n$e",
                      alertType: AlertType.error,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextButton(IconData icon, String label, VoidCallback onPressed) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Icon(icon, size: 24, color: CupertinoColors.systemGrey),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton(IconData icon, String label, VoidCallback onPressed) {
    return CupertinoButton.filled(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      borderRadius: BorderRadius.circular(30),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: CupertinoColors.white, size: 18),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: CupertinoColors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
