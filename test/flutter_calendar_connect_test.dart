import 'package:flutter_test/flutter_test.dart';
import 'package:easy_calendar/src/easy_calendar.dart';
import 'package:easy_calendar/src/calendar_api.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;

class _MockCalendarApi extends Mock implements CalendarApi {}

void main() {
  tz.initializeTimeZones();
  
  late _MockCalendarApi mockCalendarApi;
  late EasyCalendar easyCalendar;
  
  final location = getLocation('UTC');
  final startDate = TZDateTime.now(location);
  final endDate = startDate.add(const Duration(hours: 1));
  final event = Event(
    id: '1', 
    title: 'Test Event',
    startDate: startDate.millisecondsSinceEpoch,
    endDate: endDate.add(const Duration(hours: 1)).millisecondsSinceEpoch,
    calendarId: '1',
    description: null,
    url: null,
    reminders: [],
  );

  setUpAll(() {
    registerFallbackValue(event);
  });

  setUp(() {
    mockCalendarApi = _MockCalendarApi();
    easyCalendar = EasyCalendar(calendarApi: mockCalendarApi);
  });

  test('createCalendar returns a Calendar', () async {
    // Given
    final calendar = Calendar(id: '1', title: 'Test Calendar', color: Colors.blue.value, isWritable: true, sourceName: 'local');
    when(() => mockCalendarApi.createCalendar(any(), any())).thenAnswer((_) async => calendar);

    // When
    final result = await easyCalendar.createCalendar(title: 'Test Calendar', color: Colors.blue);

    // Then
    expect(result, equals(calendar));
    verify(() => mockCalendarApi.createCalendar('Test Calendar', Colors.blue.value)).called(1);
  });

  test('createEvent returns true', () async {
    // Given
    final event = Event(
      id: '1', 
      title: 'Test Event',
      startDate: startDate.millisecondsSinceEpoch,
      endDate: endDate.add(const Duration(hours: 1)).millisecondsSinceEpoch,
      calendarId: '1',
    );

    when(() => mockCalendarApi.createEvent(
      title: any(named: 'title'),
      startDate: any(named: 'startDate'),
      endDate: any(named: 'endDate'),
      calendarId: any(named: 'calendarId'),
      description: any(named: 'description'),
      url: any(named: 'url'),
    )).thenAnswer((_) async => event);

    // When
    final result = await easyCalendar.createEvent(
      title: 'Test Event', 
      startDate: startDate,
      endDate: endDate,
      calendarId: '',
    );

    // Then
    expect(result.id, event.id);
    verify(() => mockCalendarApi.createEvent(
      title: any(named: 'title'),
      startDate: any(named: 'startDate'),
      endDate: any(named: 'endDate'),
      calendarId: any(named: 'calendarId'),
      description: any(named: 'description'),
      url: any(named: 'url'),
    )).called(1);
  });

  test('retrieveCalendars returns a list of Calendars', () async {
    // Given
    final calendars = [
      Calendar(id: '1', title: 'Test Calendar 1', color: Colors.blue.value, isWritable: true, sourceName: 'local'),
      Calendar(id: '2', title: 'Test Calendar 2', color: Colors.red.value, isWritable: true, sourceName: 'local'),
    ];
    when(() => mockCalendarApi.retrieveCalendars(any())).thenAnswer((_) async => calendars);

    // When
    final result = await easyCalendar.retrieveCalendars(onlyWritableCalendars: true);

    // Then
    expect(result, equals(calendars));
    verify(() => mockCalendarApi.retrieveCalendars(true)).called(1);
  });

  test('createCalendar throws an exception when API fails', () async {
    // Given
    when(() => mockCalendarApi.createCalendar(any(), any())).thenThrow(Exception('API Error'));

    // When
    Future<Calendar> call() => easyCalendar.createCalendar(title: 'Test Calendar', color: Colors.blue);

    // Then
    expect(call, throwsException);
    verify(() => mockCalendarApi.createCalendar('Test Calendar', Colors.blue.value)).called(1);
  });

  test('createEvent throws an exception when API fails', () async {
    // Given
    when(() => mockCalendarApi.createEvent(
      title: any(named: 'title'),
      startDate: any(named: 'startDate'),
      endDate: any(named: 'endDate'),
      calendarId: any(named: 'calendarId'),
      description: any(named: 'description'),
      url: any(named: 'url'),
    )).thenThrow(Exception('API Error'));

    // When
    Future<Event> call() => easyCalendar.createEvent(
      title: 'Test Event', 
      startDate: startDate,
      endDate: endDate,
      calendarId: '',
    );

    // Then
    expect(call, throwsException);
    verify(() => mockCalendarApi.createEvent(
      title: any(named: 'title'),
      startDate: any(named: 'startDate'),
      endDate: any(named: 'endDate'),
      calendarId: any(named: 'calendarId'),
      description: any(named: 'description'),
      url: any(named: 'url'),
    )).called(1);
  });

  test('createEvent with reminders returns an Event with reminders', () async {
    // Given
    when(() => mockCalendarApi.createEvent(
      title: any(named: 'title'),
      startDate: any(named: 'startDate'),
      endDate: any(named: 'endDate'),
      calendarId: any(named: 'calendarId'),
      description: any(named: 'description'),
      url: any(named: 'url'),
    )).thenAnswer((_) async => event);
    when(() => mockCalendarApi.createReminder(any(), any())).thenAnswer((_) async => {});

    // When
    final result = await easyCalendar.createEvent(
      title: 'Test Event', 
      startDate: startDate,
      endDate: endDate,
      calendarId: '1',
      reminders: [10, 20],
    );

    // Then
    expect(result.reminders, equals([10, 20]));
    verify(() => mockCalendarApi.createEvent(
      title: any(named: 'title'),
      startDate: any(named: 'startDate'),
      endDate: any(named: 'endDate'),
      calendarId: any(named: 'calendarId'),
      description: any(named: 'description'),
      url: any(named: 'url'),
    )).called(1);
    verify(() => mockCalendarApi.createReminder(10, event.id)).called(1);
    verify(() => mockCalendarApi.createReminder(20, event.id)).called(1);
  });

  test('retrieveEvents returns a list of Events with reminders', () async {
    // Given
    final events = [event];
    when(() => mockCalendarApi.retrieveEvents(any(), any(), any())).thenAnswer((_) async => events);
    when(() => mockCalendarApi.retrieveReminders(any())).thenAnswer((_) async => [10, 20]);

    // When
    final result = await easyCalendar.retrieveEvents(calendarId: '1');

    // Then
    expect(result.first.reminders, equals([10, 20]));
    verify(() => mockCalendarApi.retrieveEvents('1', any(), any())).called(1);
    verify(() => mockCalendarApi.retrieveReminders(event.id)).called(1);
  });

  test('create Event timezone management test: Paris - Montréal flight', () async {
    final parisDeparture = TZDateTime(getLocation('Europe/Paris'), 2025, 9, 8, 13, 30);
    final montrealArrival = TZDateTime(getLocation('America/Montreal'), 2025, 9, 8, 15, 00);
    final utcParisDeparture = parisDeparture.toUtc();
    final utcMontrealArrival = montrealArrival.toUtc();

    final mockEvent = Event(
      id: '1', 
      title: 'Paris - Montréal',
      startDate: utcParisDeparture.millisecondsSinceEpoch,
      endDate: utcMontrealArrival.millisecondsSinceEpoch,
      calendarId: '1',
    );

    when(() => mockCalendarApi.createEvent(
      title: any(named: 'title'),
      startDate: any(named: 'startDate'),
      endDate: any(named: 'endDate'),
      calendarId: any(named: 'calendarId'),
      description: any(named: 'description'),
      url: any(named: 'url'),
    )).thenAnswer((_) async => mockEvent);

    await easyCalendar.createEvent(
      title: 'Paris - Montréal', 
      startDate: parisDeparture,
      endDate: montrealArrival,
      calendarId: '1',
    );

    verify(() => mockCalendarApi.createEvent(
      title: 'Paris - Montréal',
      startDate: utcParisDeparture.millisecondsSinceEpoch,
      endDate: utcMontrealArrival.millisecondsSinceEpoch,
      calendarId: '1',
      description: null,
      url: null,
    )).called(1);
  });
}