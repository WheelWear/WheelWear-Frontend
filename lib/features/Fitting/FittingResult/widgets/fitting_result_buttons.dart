// fitting_result_buttons.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelwear_frontend/utils/system_alert_dialog.dart';
import '../../fitting_service.dart';
import 'retry_fitting.dart';
import '../fitting_result_provider.dart'; // Provider 임포트
import 'package:wheelwear_frontend/utils/retryable_cached_network_image.dart';

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
                () async {
              try {
                final result = await vton_image_saved(context);
                if (result) {
                  // 성공 시 성공 다이얼로그 처리
                  await SystemAlertDialog.show(
                    context: context,
                    title: "코디 저장 완료",
                    message: "코디 저장이 완료되었습니다.",
                    alertType: AlertType.success,
                  );
                } else {
                  // 실패 시 실패 다이얼로그 처리
                  await SystemAlertDialog.show(
                    context: context,
                    title: "오류",
                    message: "코디 저장에 실패하였습니다.",
                    alertType: AlertType.error,
                  );
                }
              } catch (e) {
                // 예상치 못한 예외 처리
                await SystemAlertDialog.show(
                  context: context,
                  title: "오류",
                  message: "특정 로직 수행 중 오류가 발생하였습니다:\n$e",
                  alertType: AlertType.error,
                );
              }
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildTextButton(
                CupertinoIcons.arrow_right_arrow_left,
                "추가 피팅하기",
                    () async {
                  // 로딩 다이얼로그 표시 (barrierDismissible: false)
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return Center(
                        child: CupertinoActivityIndicator(radius: 15),
                      );
                    },
                  );

                  try {
                    final result_first = await vton_image_saved(context);
                    if (result_first) {
                      // vton 이미지 저장 성공 후, 바디 이미지 저장
                      final result_second = await patch_body_image(context);
                      // 로딩 다이얼로그 제거
                      Navigator.of(context).pop();
                      if (result_second) {
                        await SystemAlertDialog.show(
                          context: context,
                          title: "성공",
                          message: "바디 이미지 저장에 성공하였습니다.",
                          alertType: AlertType.success,
                        );
                        Navigator.of(context).pop();
                      } else {
                        await SystemAlertDialog.show(
                          context: context,
                          title: "오류",
                          message: "바디 이미지 저장에 실패하였습니다.",
                          alertType: AlertType.error,
                        );
                      }
                    } else {
                      // vton 이미지 저장 실패 시 로딩 제거 후 오류 다이얼로그 표시
                      Navigator.of(context).pop();
                      await SystemAlertDialog.show(
                        context: context,
                        title: "오류",
                        message: "코디 저장에 실패하였습니다.",
                        alertType: AlertType.error,
                      );
                    }
                  } catch (e) {
                    // 예외 발생 시 로딩 제거 후 오류 다이얼로그 표시
                    Navigator.of(context).pop();
                    await SystemAlertDialog.show(
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
