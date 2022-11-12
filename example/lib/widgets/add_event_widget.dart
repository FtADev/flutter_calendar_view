import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../app_colors.dart';
import '../constants.dart';
import '../extension.dart';
import '../model/event.dart';
import 'custom_button.dart';
import 'date_time_selector.dart';

class AddEventWidget extends StatefulWidget {
  final void Function(CalendarEventData<Event>)? onEventAdd;

  const AddEventWidget({
    Key? key,
    this.onEventAdd,
  }) : super(key: key);

  @override
  _AddEventWidgetState createState() => _AddEventWidgetState();
}

class _AddEventWidgetState extends State<AddEventWidget> {
  late DateTime _startDate;
  late DateTime _endDate;

  DateTime? _startTime;

  DateTime? _endTime;

  String _title = "";

  String _description = "";

  IconData? _icon = Icons.event;

  Color _color = Colors.blue;

  late FocusNode _titleNode;

  late FocusNode _descriptionNode;

  late FocusNode _dateNode;

  final GlobalKey<FormState> _form = GlobalKey();

  late TextEditingController _startDateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();

    _titleNode = FocusNode();
    _descriptionNode = FocusNode();
    _dateNode = FocusNode();

    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _descriptionNode.dispose();
    _dateNode.dispose();

    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: AppConstants.inputDecoration.copyWith(
              labelText: "Event Title",
            ),
            style: TextStyle(
              color: AppColors.black,
              fontSize: 17.0,
            ),
            onSaved: (value) => _title = value?.trim() ?? "",
            validator: (value) {
              if (value == null || value == "")
                return "Please enter event title.";

              return null;
            },
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: DateTimeSelectorFormField(
                  controller: _startDateController,
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "Start Date",
                  ),
                  validator: (value) {
                    if (value == null || value == "")
                      return "Please select date.";

                    return null;
                  },
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  onSave: (date) => _startDate = date,
                  type: DateTimeSelectionType.date,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: DateTimeSelectorFormField(
                  controller: _endDateController,
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "End Date",
                  ),
                  validator: (value) {
                    if (value == null || value == "")
                      return "Please select date.";

                    return null;
                  },
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  onSave: (date) => _endDate = date,
                  type: DateTimeSelectionType.date,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: DateTimeSelectorFormField(
                  controller: _startTimeController,
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "Start Time",
                  ),
                  validator: (value) {
                    if (value == null || value == "")
                      return "Please select start time.";

                    return null;
                  },
                  onSave: (date) => _startTime = date,
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  type: DateTimeSelectionType.time,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: DateTimeSelectorFormField(
                  controller: _endTimeController,
                  decoration: AppConstants.inputDecoration.copyWith(
                    labelText: "End Time",
                  ),
                  validator: (value) {
                    if (value == null || value == "")
                      return "Please select end time.";

                    return null;
                  },
                  onSave: (date) => _endTime = date,
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 17.0,
                  ),
                  type: DateTimeSelectionType.time,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            focusNode: _descriptionNode,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 17.0,
            ),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            selectionControls: MaterialTextSelectionControls(),
            minLines: 1,
            maxLines: 10,
            maxLength: 1000,
            validator: (value) {
              if (value == null || value.trim() == "")
                return "Please enter event description.";

              return null;
            },
            onSaved: (value) => _description = value?.trim() ?? "",
            decoration: AppConstants.inputDecoration.copyWith(
              hintText: "Event Description",
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              Text(
                "Event Color: ",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 17,
                ),
              ),
              GestureDetector(
                onTap: _displayColorPicker,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: _color,
                ),
              ),
              Spacer(),
              Text(
                "Event Icon: ",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 17,
                ),
              ),
              GestureDetector(
                onTap: _displayIconPicker,
                child: Icon(_icon, color: _color, size: 30,),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          CustomButton(
            onTap: _createEvent,
            title: "Add Event",
          ),
        ],
      ),
    );
  }

  void _createEvent() {
    if (!(_form.currentState?.validate() ?? true)) return;

    _form.currentState?.save();

    final event = CalendarEventData<Event>(
      date: _startDate,
      color: _color,
      endTime: _endTime,
      startTime: _startTime,
      description: _description,
      endDate: _endDate,
      title: _title,
      icon: Icon(_icon, color: Colors.white,),
      event: Event(
        title: _title,
        icon: Icon(_icon, color: Colors.white,),
      ),
    );

    widget.onEventAdd?.call(event);
    _resetForm();
  }

  void _resetForm() {
    _form.currentState?.reset();
    _startDateController.text = "";
    _endTimeController.text = "";
    _startTimeController.text = "";
    _icon = Icons.event;
  }

  void _displayColorPicker() {
    var color = _color;
    showDialog(
      context: context,
      useSafeArea: true,
      barrierColor: Colors.black26,
      builder: (_) => SimpleDialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            color: AppColors.bluishGrey,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.all(20.0),
        children: [
          Text(
            "Event Color",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 25.0,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 1.0,
            color: AppColors.bluishGrey,
          ),
          ColorPicker(
            displayThumbColor: true,
            enableAlpha: false,
            pickerColor: _color,
            onColorChanged: (c) {
              color = c;
            },
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 30.0),
              child: CustomButton(
                title: "Select",
                onTap: () {
                  if (mounted)
                    setState(() {
                      _color = color;
                    });
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _displayIconPicker() {
    final List<IconData> allIcons = [
      Icons.umbrella_sharp,
      Icons.favorite,
      Icons.headphones,
      Icons.home,
      Icons.car_repair,
      Icons.settings,
      Icons.flight,
      Icons.ac_unit,
      Icons.run_circle,
      Icons.book,
      Icons.sports_rugby_rounded,
      Icons.alarm,
      Icons.call,
      Icons.snowing,
      Icons.hearing,
      Icons.music_note,
      Icons.note,
      Icons.edit,
      Icons.sunny,
      Icons.radar,

      // add more icons here if you want
    ];

    // selected icon
    // the selected icon is highlighed
    // so it looks different from the others
    IconData? selectedIcon = _icon;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Pick an Icon'),
          content: Container(
            width: 320,
            height: 400,
            alignment: Alignment.center,
            // This grid view displays all selectable icons
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 60,
                    childAspectRatio: 1 / 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: allIcons.length,
                itemBuilder: (_, index) => Container(
                  key: ValueKey(allIcons[index].codePoint),
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: IconButton(
                      // give the selected icon a different color
                      color: selectedIcon == allIcons[index]
                          ? Colors.blue
                          : Colors.black,
                      iconSize: 30,
                      icon: Icon(
                        allIcons[index],
                      ),
                      onPressed: () {
                        if (mounted)
                          setState(() {
                            _icon = allIcons[index];
                          });
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                )),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'))
          ],
        ));
  }
}
