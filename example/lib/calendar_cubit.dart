import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_connect/flutter_calendar_connect.dart';
import 'package:flutter_calendar_connect/calendar_api.g.dart';
import 'package:flutter_calendar_connect_example/calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final FlutterCalendarConnect _calendarPlugin;

  CalendarCubit({
    @visibleForTesting FlutterCalendarConnect? calendarActions,
  }) : _calendarPlugin = calendarActions ?? FlutterCalendarConnect(),
        super(const CalendarInitial());

  Future<void> createCalendar({
    required String title,
    required Color color,
  }) async {
    final calendar = await _calendarPlugin.createCalendar(
      title: title,
      color: color,
    );
      
    if (state is CalendarSuccess) {
      final calendars = (state as CalendarSuccess).calendars;
      emit(CalendarSuccess(calendars: [...calendars, calendar]));
    } else {
      fetchCalendars(onlyWritable: false);
    }
  }

  Future<void> fetchCalendars({required bool onlyWritable}) async {
    try {
      final calendars = await _calendarPlugin.retrieveCalendars(onlyWritableCalendars: onlyWritable);
      if (calendars.isEmpty) {
        emit(const CalendarNoValue());
      } else {
        emit(CalendarSuccess(calendars: calendars));
      }
    } catch (e) {
      emit(CalendarError(message: e.toString()));
    }
  }

  Future<bool> createOrUpdateEvent({
    required String calendarId,
    String? id,
  }) async {
    final event = Event(
      title: 'Event title',
      description: 'Event description',
      startDate: DateTime.now().millisecondsSinceEpoch,
      endDate: DateTime.now().add(const Duration(hours: 2)).millisecondsSinceEpoch,
      timeZone: 'UTC',
      calendarId: calendarId,
      id: id,
      alarms: [],
    );
    
    return await _calendarPlugin.createOrUpdateEvent(event: event);
  }
}