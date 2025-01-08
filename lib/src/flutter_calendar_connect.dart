import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_connect/src/flutter_calendar_connect_exception.dart';
import 'package:flutter_calendar_connect/src/flutter_calendar_connect_platform_interface.dart';
import 'package:flutter_calendar_connect/src/calendar_api.g.dart';

class FlutterCalendarConnect extends FlutterCalendarConnectPlatform {
  final CalendarApi _calendarApi;

  FlutterCalendarConnect({
    @visibleForTesting CalendarApi? calendarApi,
  }) : _calendarApi = calendarApi ?? CalendarApi();

  @override
  Future<bool> requestCalendarPermission() async {
    try {
      return await _calendarApi.requestCalendarPermission();
    } on PlatformException catch (e) {
      throw e.toFlutterCalendarConnectException();
    }
  }

  @override
  Future<Calendar> createCalendar({required String title, required Color color}) async {
    try {
      return await _calendarApi.createCalendar(title, color.value);
    } on PlatformException catch (e) {
      throw e.toFlutterCalendarConnectException();
    }
  }

  @override
  Future<List<Calendar>> retrieveCalendars({required bool onlyWritableCalendars}) async {
    try {
      return await _calendarApi.retrieveCalendars(onlyWritableCalendars);
    } on PlatformException catch (e) {
      throw e.toFlutterCalendarConnectException();
    }
  }

  @override
  Future<void> deleteCalendar({required String calendarId}) async {
    try {
      await _calendarApi.deleteCalendar(calendarId);
    } on PlatformException catch (e) {
      throw e.toFlutterCalendarConnectException();
    }
  }

  @override
  Future<Event> createEvent({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required String calendarId,
    String? description,
    String? url,
    List<int>? reminders,
  }) async {
    try {
      final event = await _calendarApi.createEvent(
        title: title,
        startDate: startDate.millisecondsSinceEpoch,
        endDate: endDate.millisecondsSinceEpoch,
        calendarId: calendarId,
        description: description, 
        url: url,
      );

      for (final minutes in reminders ?? []) {
        await _calendarApi.createReminder(minutes, event.id);
      }

      return event.copyWith(reminders: reminders);
      
    } on PlatformException catch (e) {
      throw e.toFlutterCalendarConnectException();
    }
  }

  @override
  Future<List<Event>> retrieveEvents({required String calendarId, DateTime? startDate, DateTime? endDate}) async {
    try {
      final start = startDate ?? DateTime.now();
      final end = endDate ?? DateTime.now().add(const Duration(days: 7));
      
      final events = await _calendarApi.retrieveEvents(calendarId, start.millisecondsSinceEpoch, end.microsecondsSinceEpoch);

      final fcEvents = <Event>[];
      for (final event in events) {
        fcEvents.add(event.copyWith(
          reminders: await _calendarApi.retrieveReminders(event.id),
        ));
      }
      return fcEvents;
    } on PlatformException catch (e) {
      throw e.toFlutterCalendarConnectException();
    }
  }

  @override
  Future<void> deleteEvent({required String eventId, required String calendarId}) async {
    try {
      await _calendarApi.deleteEvent(eventId, calendarId);
    } on PlatformException catch (e) {
      throw e.toFlutterCalendarConnectException();
    }
  }

  @override
  Future<void> createReminder({required int minutes, required String eventId}) async {
    try {
      await _calendarApi.createReminder(minutes, eventId);
    } on PlatformException catch (e) {
      throw e.toFlutterCalendarConnectException();
    }
  }

  @override
  Future<List<int>> retrieveReminders({required String eventId}) async {
    try {
      return await _calendarApi.retrieveReminders(eventId);
    } on PlatformException catch (e) {
      throw e.toFlutterCalendarConnectException();
    }
  }

  @override
  Future<void> deleteReminder({required int minutes, required String eventId}) async {
    try {
      await _calendarApi.deleteReminder(minutes, eventId);
    } on PlatformException catch (e) {
      throw e.toFlutterCalendarConnectException();
    }
  }
}