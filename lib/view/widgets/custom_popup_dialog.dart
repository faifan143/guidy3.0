import 'package:flutter/material.dart';
import 'package:flutter_custom_selector/widget/flutter_single_select.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:guidy/core/classes/AddType.dart';

import '../../controllers/main_screen_controller.dart';

class CustomPopupDialog extends GetView<MainScreenController> {
  CustomPopupDialog({
    Key? key,
    required this.label1,
    required this.title1,
    required this.onSubmit1,
    required this.addType,
    this.name
  }) : super(key: key);

  final String label1;
  final String title1;
  final void Function(String text)? onSubmit1;
  String? name;

  final TextEditingController _textController1 = TextEditingController();
  final AddType addType;

  @override
  Widget build(BuildContext context) {
    _textController1.text = name??'';

    return AlertDialog(
      title: Text(title1),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          if (addType == AddType.SUB)
            CustomSingleSelectField<dynamic>(
              items: controller.mainCategories.values.toList(),
              title: "Main Categories".tr,
              onSelectionDone: (value) {
                controller.selectedMainForSubAdd = value;
              },
              itemAsString: (item) => item,
            ),
          TextField(
            controller: _textController1,
            decoration: InputDecoration(
              labelText: label1,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'.tr),
        ),
        ElevatedButton(
          onPressed: () {
            if (onSubmit1 != null) {
              onSubmit1!(_textController1.text);
            }
          },
          child: Text('Submit'.tr),
        ),
      ],
    );
  }
}
