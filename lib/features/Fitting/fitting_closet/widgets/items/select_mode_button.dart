import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/selection_provider.dart';
import '../../providers/clothing_confirmation_provider.dart';
import 'package:wheelwear_frontend/utils/system_alert_dialog.dart'; // 모달 위젯 import

class SelectModeButton extends StatelessWidget {
  // FittingScreen에서 전달한 콜백을 저장하는 변수
  final VoidCallback onExitClosetScreen;

  // 생성자에서 콜백을 받아옵니다.
  const SelectModeButton({Key? key, required this.onExitClosetScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 다른 Provider도 필요한 경우 가져옴 (여기서는 selectionProvider만 업데이트에 반응하도록 Consumer 사용)
    return Consumer<SelectionProvider>(
      builder: (context, selectionProvider, child) {
        // 선택 상태에 따라 아이콘과 텍스트의 색상 변경
        final Color iconColor = selectionProvider.hasSelection
            ? Colors.white
            : CupertinoColors.white;
        final Color textColor = selectionProvider.hasSelection
            ? Colors.white
            : CupertinoColors.white;
        final Color bgColor = selectionProvider.hasSelection
            ? CupertinoColors.activeBlue
            : Colors.grey;
        // hasSelection에 따라 pressedOpacity 결정 (효과 없는게 1)
        final double pressedOpacity =
        selectionProvider.hasSelection ? 0.4 : 1.0;

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CupertinoButton(
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              pressedOpacity: pressedOpacity,
              child: Row(
                mainAxisSize: MainAxisSize.min, // 내부 콘텐츠만큼 크기 조절
                children: [
                  SvgPicture.asset(
                    'assets/fitting/try_on_btn.svg',
                    width: 20,
                    height: 20,
                    color: iconColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Try On",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 23,
                    ),
                  ),
                ],
              ),
              onPressed: () async {
                if (selectionProvider.selectedItems.length > 2) {
                  // 선택된 항목이 2개를 초과하는 경우 모달창 띄우기
                  SystemAlertDialog.show(
                    context: context,
                    title: '경고',
                    message: '2개 이하로 선택해주세요.',
                    alertType: AlertType.warning,
                  );
                  return;
                }
                if (selectionProvider.hasSelection) {
                  // ClothingConfirmationProvider 인스턴스를 가져옵니다.
                  final confirmationProvider =
                  Provider.of<ClothingConfirmationProvider>(context, listen: false);
                  // 선택된 항목 목록은 'selectedItems'로 접근합니다.
                  confirmationProvider.confirmSelection(selectionProvider.selectedItems);
                  debugPrint("Try On 버튼이 탭되었습니다.");
                  debugPrint("확정된 아이템들: ${confirmationProvider.confirmedClothes}");
                  onExitClosetScreen();
                } else {
                  debugPrint("옷을 선택해주세요.");
                }
              },
            ),
          ],
        );
      },
    );
  }
}
