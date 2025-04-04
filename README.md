## 📆 Eventide

[![pub package](https://img.shields.io/pub/v/eventide.svg)](https://pub.dev/packages/eventide) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Tests](https://github.com/sncf-connect-tech/eventide/actions/workflows/ci.yml/badge.svg)](https://github.com/sncf-connect-tech/eventide/actions/workflows/ci.yml) [![codecov](https://codecov.io/gh/sncf-connect-tech/eventide/graph/badge.svg?token=jxA8pZnWmR)](https://codecov.io/gh/sncf-connect-tech/eventide)

Eventide provides a easy-to-use flutter interface to access & modify native device calendars (iOS & Android).

---

### 🔥 Features
|    | Eventide |
---- | --------------------------------
:white_check_mark: | Automatic permission handling
:white_check_mark: | Create/retrieve/delete calendars
:white_check_mark: | Create/retrieve/delete events
:white_check_mark: | Create/delete reminders
:white_check_mark: | Custom exceptions
:construction: | Recurring events
:construction: | Attendees
:construction: | Streams

NOTE: Eventide handles timezones as UTC. Make sure the right data is feed to the plugin with a [timezone aware DateTime class](https://pub.dev/packages/timezone).

---

### 🔨 Getting Started

#### Android

Nothing to add on your side. All is already declared in eventide's AndroidManifest.xml

#### iOS

To read/write calendar data, your app must include the following permissions in its info.plist file.

```xml
<key>NSCalendarsUsageDescription</key>
<string>We need access to your calendar to add information about your trip.</string>
<key>NSCalendarsFullAccessUsageDescription</key>
<string>We need access to your calendar to add information about your trip.</string>
<key>NSCalendarsWriteOnlyAccessUsageDescription</key>
<string>We need access to your calendar to add information about your trip.</string>
```

---

### 🚀 Quick start

```dart
import 'package:eventide/eventide.dart';

final eventide = Eventide();

final calendar = await eventide.createCalendar('Work', Colors.red);

final event = await eventide.createEvent(
    calendarId: calendar.id,
    title: 'Meeting',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(hours: 1)),
    reminders: [
        const Duration(hours: 1)
        const Duration(minutes: 15),
    ],
);

final updatedEvent = await eventide.deleteReminder(
    durationBeforeEvent: Duration(minutes: 15),
    eventId: event.id,
);
```

You can find more in the example app.

---

### License

Copyright © 2025 SNCF Connect & Tech. This project is licensed under the MIT License - see the LICENSE file for details.

### Feedback

Please file any issues, bugs or feature requests as an issue on the [Github page](https://github.com/sncf-connect-tech/eventide/issues).