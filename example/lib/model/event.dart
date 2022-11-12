import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class Event {
  final String title;
  final Widget? icon;

  const Event({this.title = "Title", this.icon});

  @override
  bool operator ==(Object other) => other is Event && title == other.title;

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => title;
}
