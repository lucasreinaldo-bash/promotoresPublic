import 'package:flutter/material.dart';

import 'checkbox_model.dart';

class CheckboxWidget extends StatefulWidget {
  const CheckboxWidget({Key key, this.item}) : super(key: key);

  final CheckBoxModel item;

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: CheckboxListTile(
        title: Text("< 5"),
        value: widget.item.checked,
        onChanged: (bool value) {
          setState(() {
            widget.item.checked = value;
          });
        },
      ),
    );
  }
}
