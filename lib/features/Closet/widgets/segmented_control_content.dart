import 'package:flutter/cupertino.dart';

enum Sky { midnight, viridian, cerulean }

Map<Sky, Color> skyColors = <Sky, Color>{
  Sky.midnight: const Color(0xFF545453),
  Sky.viridian: const Color(0xFF545453),
  Sky.cerulean: const Color(0xFF545453),

};

class SegmentedControlContent extends StatefulWidget {
  const SegmentedControlContent({super.key});

  @override
  State<SegmentedControlContent> createState() => _SegmentedControlContentState();
}

class _SegmentedControlContentState extends State<SegmentedControlContent> {
  Sky _selectedSegment = Sky.midnight;

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<Sky>(
      backgroundColor: CupertinoColors.systemGrey2,
      thumbColor: skyColors[_selectedSegment]!,
      groupValue: _selectedSegment,
      onValueChanged: (Sky? value) {
        if (value != null) {
          setState(() {
            _selectedSegment = value;
          });
        }
      },
      children: const <Sky, Widget>{
        Sky.midnight: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('내 옷',
            style: TextStyle(
              color: CupertinoColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Sky.viridian: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('위시리스트',
            style: TextStyle(
              color: CupertinoColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Sky.cerulean: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('기부함',
            style: TextStyle(
              color: CupertinoColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      },
    );
  }
}