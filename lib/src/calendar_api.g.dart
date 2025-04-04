// Autogenerated from Pigeon (v24.2.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

PlatformException _createConnectionError(String channelName) {
  return PlatformException(
    code: 'channel-error',
    message: 'Unable to establish connection on channel: "$channelName".',
  );
}

/// Native data struct to represent a calendar.
///
/// [id] is a unique identifier for the calendar.
///
/// [title] is the title of the calendar.
///
/// [color] is the color of the calendar.
///
/// [isWritable] is a boolean to indicate if the calendar is writable.
///
/// [account] is the account the calendar belongs to
class Calendar {
  Calendar({
    required this.id,
    required this.title,
    required this.color,
    required this.isWritable,
    required this.account,
  });

  String id;

  String title;

  int color;

  bool isWritable;

  Account account;

  Object encode() {
    return <Object?>[
      id,
      title,
      color,
      isWritable,
      account,
    ];
  }

  static Calendar decode(Object result) {
    result as List<Object?>;
    return Calendar(
      id: result[0]! as String,
      title: result[1]! as String,
      color: result[2]! as int,
      isWritable: result[3]! as bool,
      account: result[4]! as Account,
    );
  }
}

/// Native data struct to represent an event.
///
/// [id] is a unique identifier for the event.
///
/// [title] is the title of the event.
///
/// [isAllDay] is whether or not the event is an all day.
///
/// [startDate] is the start date of the event in milliseconds since epoch.
///
/// [endDate] is the end date of the event in milliseconds since epoch.
///
/// [calendarId] is the id of the calendar that the event belongs to.
///
/// [description] is the description of the event.
///
/// [url] is the url of the event.
///
/// [reminders] is a list of minutes before the event to remind the user.
class Event {
  Event({
    required this.id,
    required this.title,
    required this.isAllDay,
    required this.startDate,
    required this.endDate,
    required this.calendarId,
    this.description,
    this.url,
    this.reminders,
  });

  String id;

  String title;

  bool isAllDay;

  int startDate;

  int endDate;

  String calendarId;

  String? description;

  String? url;

  List<int>? reminders;

  Object encode() {
    return <Object?>[
      id,
      title,
      isAllDay,
      startDate,
      endDate,
      calendarId,
      description,
      url,
      reminders,
    ];
  }

  static Event decode(Object result) {
    result as List<Object?>;
    return Event(
      id: result[0]! as String,
      title: result[1]! as String,
      isAllDay: result[2]! as bool,
      startDate: result[3]! as int,
      endDate: result[4]! as int,
      calendarId: result[5]! as String,
      description: result[6] as String?,
      url: result[7] as String?,
      reminders: (result[8] as List<Object?>?)?.cast<int>(),
    );
  }
}

class Account {
  Account({
    required this.name,
    required this.type,
  });

  String name;

  String type;

  Object encode() {
    return <Object?>[
      name,
      type,
    ];
  }

  static Account decode(Object result) {
    result as List<Object?>;
    return Account(
      name: result[0]! as String,
      type: result[1]! as String,
    );
  }
}

class _PigeonCodec extends StandardMessageCodec {
  const _PigeonCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is int) {
      buffer.putUint8(4);
      buffer.putInt64(value);
    } else if (value is Calendar) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is Event) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is Account) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 129:
        return Calendar.decode(readValue(buffer)!);
      case 130:
        return Event.decode(readValue(buffer)!);
      case 131:
        return Account.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class CalendarApi {
  /// Constructor for [CalendarApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  CalendarApi({BinaryMessenger? binaryMessenger, String messageChannelSuffix = ''})
      : pigeonVar_binaryMessenger = binaryMessenger,
        pigeonVar_messageChannelSuffix = messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
  final BinaryMessenger? pigeonVar_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = _PigeonCodec();

  final String pigeonVar_messageChannelSuffix;

  Future<bool> requestCalendarPermission() async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.eventide.CalendarApi.requestCalendarPermission$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final Future<Object?> pigeonVar_sendFuture = pigeonVar_channel.send(null);
    final List<Object?>? pigeonVar_replyList = await pigeonVar_sendFuture as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as bool?)!;
    }
  }

  Future<Calendar> createCalendar({
    required String title,
    required int color,
    required Account? account,
  }) async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.eventide.CalendarApi.createCalendar$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final Future<Object?> pigeonVar_sendFuture = pigeonVar_channel.send(<Object?>[title, color, account]);
    final List<Object?>? pigeonVar_replyList = await pigeonVar_sendFuture as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as Calendar?)!;
    }
  }

  Future<List<Calendar>> retrieveCalendars({required bool onlyWritableCalendars, required Account? from}) async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.eventide.CalendarApi.retrieveCalendars$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final Future<Object?> pigeonVar_sendFuture = pigeonVar_channel.send(<Object?>[onlyWritableCalendars, from]);
    final List<Object?>? pigeonVar_replyList = await pigeonVar_sendFuture as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as List<Object?>?)!.cast<Calendar>();
    }
  }

  Future<void> deleteCalendar({required String calendarId}) async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.eventide.CalendarApi.deleteCalendar$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final Future<Object?> pigeonVar_sendFuture = pigeonVar_channel.send(<Object?>[calendarId]);
    final List<Object?>? pigeonVar_replyList = await pigeonVar_sendFuture as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<Event> createEvent({
    required String calendarId,
    required String title,
    required int startDate,
    required int endDate,
    required bool isAllDay,
    required String? description,
    required String? url,
  }) async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.eventide.CalendarApi.createEvent$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final Future<Object?> pigeonVar_sendFuture =
        pigeonVar_channel.send(<Object?>[calendarId, title, startDate, endDate, isAllDay, description, url]);
    final List<Object?>? pigeonVar_replyList = await pigeonVar_sendFuture as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as Event?)!;
    }
  }

  Future<List<Event>> retrieveEvents({
    required String calendarId,
    required int startDate,
    required int endDate,
  }) async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.eventide.CalendarApi.retrieveEvents$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final Future<Object?> pigeonVar_sendFuture = pigeonVar_channel.send(<Object?>[calendarId, startDate, endDate]);
    final List<Object?>? pigeonVar_replyList = await pigeonVar_sendFuture as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as List<Object?>?)!.cast<Event>();
    }
  }

  Future<void> deleteEvent({required String eventId}) async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.eventide.CalendarApi.deleteEvent$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final Future<Object?> pigeonVar_sendFuture = pigeonVar_channel.send(<Object?>[eventId]);
    final List<Object?>? pigeonVar_replyList = await pigeonVar_sendFuture as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<Event> createReminder({required int reminder, required String eventId}) async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.eventide.CalendarApi.createReminder$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final Future<Object?> pigeonVar_sendFuture = pigeonVar_channel.send(<Object?>[reminder, eventId]);
    final List<Object?>? pigeonVar_replyList = await pigeonVar_sendFuture as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as Event?)!;
    }
  }

  Future<Event> deleteReminder({required int reminder, required String eventId}) async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.eventide.CalendarApi.deleteReminder$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel = BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final Future<Object?> pigeonVar_sendFuture = pigeonVar_channel.send(<Object?>[reminder, eventId]);
    final List<Object?>? pigeonVar_replyList = await pigeonVar_sendFuture as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as Event?)!;
    }
  }
}
