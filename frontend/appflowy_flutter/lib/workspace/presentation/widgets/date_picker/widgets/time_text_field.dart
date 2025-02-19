import 'package:flutter/material.dart';

import 'package:appflowy_backend/protobuf/flowy-database2/date_entities.pbenum.dart';
import 'package:appflowy_popover/appflowy_popover.dart';
import 'package:flowy_infra_ui/style_widget/text_field.dart';

const _maxLengthTwelveHour = 8;
const _maxLengthTwentyFourHour = 5;

class TimeTextField extends StatefulWidget {
  const TimeTextField({
    super.key,
    required this.isEndTime,
    required this.timeFormat,
    this.timeHintText,
    this.parseEndTimeError,
    this.parseTimeError,
    this.timeStr,
    this.endTimeStr,
    this.popoverMutex,
    this.onSubmitted,
  });

  final bool isEndTime;
  final TimeFormatPB timeFormat;
  final String? timeHintText;
  final String? parseEndTimeError;
  final String? parseTimeError;
  final String? timeStr;
  final String? endTimeStr;
  final PopoverMutex? popoverMutex;
  final Function(String timeStr)? onSubmitted;

  @override
  State<TimeTextField> createState() => _TimeTextFieldState();
}

class _TimeTextFieldState extends State<TimeTextField> {
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _textController = TextEditingController()
    ..text = widget.timeStr ?? "";
  String text = "";

  @override
  void initState() {
    super.initState();

    if (widget.isEndTime) {
      _textController.text = widget.endTimeStr ?? "";
    } else {
      _textController.text = widget.timeStr ?? "";
    }

    if (!widget.isEndTime && widget.timeStr != null) {
      text = widget.timeStr!;
    } else if (widget.endTimeStr != null) {
      text = widget.endTimeStr!;
    }

    _focusNode.addListener(_focusNodeListener);
    widget.popoverMutex?.listenOnPopoverChanged(_popoverListener);
  }

  @override
  void dispose() {
    widget.popoverMutex?.removePopoverListener(_popoverListener);
    _textController.dispose();
    _focusNode.removeListener(_focusNodeListener);
    _focusNode.dispose();
    super.dispose();
  }

  void _focusNodeListener() {
    if (_focusNode.hasFocus) {
      widget.popoverMutex?.close();
    }
  }

  void _popoverListener() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: FlowyTextField(
        text: text,
        focusNode: _focusNode,
        controller: _textController,
        submitOnLeave: true,
        hintText: widget.timeHintText,
        errorText:
            widget.isEndTime ? widget.parseEndTimeError : widget.parseTimeError,
        maxLength: widget.timeFormat == TimeFormatPB.TwelveHour
            ? _maxLengthTwelveHour
            : _maxLengthTwentyFourHour,
        showCounter: false,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
