package sncf.connect.tech.eventide

import android.content.ContentResolver
import android.database.Cursor
import android.net.Uri
import android.provider.CalendarContract
import io.mockk.every
import io.mockk.mockk
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import java.time.Instant
import java.util.concurrent.CountDownLatch

class EventTests {
    private lateinit var contentResolver: ContentResolver
    private lateinit var permissionHandler: PermissionHandler
    private lateinit var calendarImplem: CalendarImplem
    private lateinit var calendarContentUri: Uri
    private lateinit var eventContentUri: Uri
    private lateinit var remindersContentUri: Uri

    @BeforeEach
    fun setup() {
        contentResolver = mockk(relaxed = true)
        permissionHandler = mockk(relaxed = true)
        calendarContentUri = mockk(relaxed = true)
        eventContentUri = mockk(relaxed = true)
        remindersContentUri = mockk(relaxed = true)

        calendarImplem = CalendarImplem(
            contentResolver = contentResolver,
            permissionHandler = permissionHandler,
            calendarContentUri = calendarContentUri,
            eventContentUri = eventContentUri,
            remindersContentUri = remindersContentUri
        )
    }

    private fun mockPermissionGranted() {
        every { permissionHandler.requestWritePermission(any()) } answers {
            firstArg<(Boolean) -> Unit>().invoke(true)
        }

        every { permissionHandler.requestReadPermission(any()) } answers {
            firstArg<(Boolean) -> Unit>().invoke(true)
        }
    }

    private fun mockPermissionDenied() {
        every { permissionHandler.requestWritePermission(any()) } answers {
            firstArg<(Boolean) -> Unit>().invoke(false)
        }
        every { permissionHandler.requestReadPermission(any()) } answers {
            firstArg<(Boolean) -> Unit>().invoke(false)
        }
    }

    private fun mockWritableCalendar() {
        val cursor = mockk<Cursor>(relaxed = true)
        every { contentResolver.query(calendarContentUri, any(), any(), any(), any()) } returns cursor
        every { cursor.moveToNext() } returns true
        every { cursor.getInt(any()) } returns CalendarContract.Calendars.CAL_ACCESS_CONTRIBUTOR
    }

    private fun mockNotWritableCalendar() {
        val cursor = mockk<Cursor>(relaxed = true)
        every { contentResolver.query(calendarContentUri, any(), any(), any(), any()) } returns cursor
        every { cursor.moveToNext() } returns true
        every { cursor.getInt(any()) } returns CalendarContract.Calendars.CAL_ACCESS_READ
    }

    private fun mockCalendarNotFound() {
        val cursor = mockk<Cursor>(relaxed = true)
        every { contentResolver.query(calendarContentUri, any(), any(), any(), any()) } returns cursor
        every { cursor.moveToNext() } returns false
    }

    private fun mockCalendarIdFound() {
        val cursor = mockk<Cursor>(relaxed = true)
        every { contentResolver.query(eventContentUri, any(), any(), any(), any()) } returns cursor
        every { cursor.moveToNext() } returns true
        every { cursor.getLong(any()) } returns 1L
    }

    private fun mockCalendarIdNotFound() {
        val cursor = mockk<Cursor>(relaxed = true)
        every { contentResolver.query(eventContentUri, any(), any(), any(), any()) } returns cursor
        every { cursor.moveToNext() } returns false
    }

    @Test
    fun createEvent_withGrantedPermission_andWritableCalendar_createsEventSuccessfully() = runTest {
        mockPermissionGranted()
        mockWritableCalendar()

        val uri = mockk<Uri>(relaxed = true)
        every { contentResolver.insert(any(), any()) } returns uri
        every { uri.lastPathSegment } returns "1"

        val startMilli = Instant.now().toEpochMilli()
        val endMilli = Instant.now().toEpochMilli()

        var result: Result<Event>? = null
        val latch = CountDownLatch(1)
        calendarImplem.createEvent(
            title = "Test Event",
            startDate = startMilli,
            endDate = endMilli,
            calendarId = "1",
            description = "Description",
            isAllDay = false,
            url = null
        ) {
            result = it
            latch.countDown()
        }

        latch.await()

        assertTrue(result!!.isSuccess)
        assertEquals(Event(
            id = "1",
            title = "Test Event",
            startDate = startMilli,
            endDate = endMilli,
            calendarId = "1",
            description = "Description",
            isAllDay = false,
        ), result!!.getOrNull()!!)
    }

    @Test
    fun createEvent_withGrantedPermission_andNotWritableCalendar_returnsNotEditableError() = runTest {
        mockPermissionGranted()
        mockNotWritableCalendar()

        var result: Result<Event>? = null
        val latch = CountDownLatch(1)
        calendarImplem.createEvent(
            title = "Test Event",
            startDate = Instant.now().toEpochMilli(),
            endDate = Instant.now().toEpochMilli(),
            calendarId = "1",
            description = "Description",
            isAllDay = false,
            url = null
        ) {
            result = it
            latch.countDown()
        }

        latch.await()

        assertTrue(result!!.isFailure)
        assertEquals("NOT_EDITABLE", (result!!.exceptionOrNull() as FlutterError).code)
    }

    @Test
    fun createEvent_withGrantedPermission_andNotFoundCalendar_returnsNotFoundError() = runTest {
        mockPermissionGranted()
        mockCalendarNotFound()

        var result: Result<Event>? = null
        val latch = CountDownLatch(1)
        calendarImplem.createEvent(
            title = "Test Event",
            startDate = Instant.now().toEpochMilli(),
            endDate = Instant.now().toEpochMilli(),
            calendarId = "1",
            description = "Description",
            isAllDay = false,
            url = null
        ) {
            result = it
            latch.countDown()
        }

        latch.await()

        assertTrue(result!!.isFailure)
        assertEquals("NOT_FOUND", (result!!.exceptionOrNull() as FlutterError).code)
    }

    @Test
    fun createEvent_withDeniedPermission_returnsAccessRefusedError() = runTest {
        mockPermissionDenied()

        var result: Result<Event>? = null
        calendarImplem.createEvent(
            title = "Test Event",
            startDate = Instant.now().toEpochMilli(),
            endDate = Instant.now().toEpochMilli(),
            calendarId = "1",
            description = "Description",
            isAllDay = false,
            url = null
        ) {
            result = it
        }

        assertTrue(result!!.isFailure)
        assertEquals("ACCESS_REFUSED", (result!!.exceptionOrNull() as FlutterError).code)
    }

    @Test
    fun createEvent_withInvalidUri_returnsNotFoundError() = runTest {
        mockPermissionGranted()

        every { contentResolver.insert(any(), any()) } returns null

        var result: Result<Event>? = null
        val latch = CountDownLatch(1)
        calendarImplem.createEvent(
            title = "Test Event",
            startDate = Instant.now().toEpochMilli(),
            endDate = Instant.now().toEpochMilli(),
            calendarId = "1",
            description = "Description",
            isAllDay = false,
            url = null
        ) {
            result = it
            latch.countDown()
        }

        latch.await()

        assertTrue(result!!.isFailure)
        assertEquals("NOT_FOUND", (result!!.exceptionOrNull() as FlutterError).code)
    }

    @Test
    fun retrieveEvents_withGrantedPermission_returnsEvents() = runTest {
        mockPermissionGranted()

        val cursor = mockk<Cursor>(relaxed = true)

        CalendarContract.Events.ALL_DAY
        every { contentResolver.query(eventContentUri, any(), any(), any(), any()) } returns cursor
        every { cursor.moveToNext() } returnsMany listOf(true, false)
        every { cursor.getLong(cursor.getColumnIndexOrThrow(CalendarContract.Events._ID)) } returns 1L
        every { cursor.getString(any()) } returnsMany listOf("Test Event", "Description")
        every { cursor.getLong(any()) } returns 0L
        every { cursor.getInt(cursor.getColumnIndexOrThrow(CalendarContract.Events.ALL_DAY)) } returns 0

        var result: Result<List<Event>>? = null
        val latch = CountDownLatch(1)
        calendarImplem.retrieveEvents("1", 0L, 0L) {
            result = it
            latch.countDown()
        }

        latch.await()

        assertTrue(result!!.isSuccess)
        assertEquals(1, result!!.getOrNull()?.size)
        assertEquals("Test Event", result!!.getOrNull()?.get(0)?.title)
    }

    @Test
    fun retrieveEvents_withDeniedPermission_returnsAccessRefusedError() = runTest {
        mockPermissionDenied()

        var result: Result<List<Event>>? = null
        calendarImplem.retrieveEvents("1", 0L, 0L) {
            result = it
        }

        assertTrue(result!!.isFailure)
        assertEquals("ACCESS_REFUSED", (result!!.exceptionOrNull() as FlutterError).code)
    }

    @Test
    fun retrieveEvents_withEmptyCursor_returnsEmptyList() = runTest {
        mockPermissionGranted()

        val cursor = mockk<Cursor>(relaxed = true)
        every { contentResolver.query(eventContentUri, any(), any(), any(), any()) } returns cursor
        every { cursor.moveToNext() } returns false

        var result: Result<List<Event>>? = null
        val latch = CountDownLatch(1)
        calendarImplem.retrieveEvents("1", 0L, 0L) {
            result = it
            latch.countDown()
        }

        latch.await()

        assertTrue(result!!.isSuccess)
        assertTrue(result!!.getOrNull()?.isEmpty()!!)
    }

    @Test
    fun retrieveEvents_withException_returnsGenericError() = runTest {
        mockPermissionGranted()

        every { contentResolver.query(eventContentUri, any(), any(), any(), any()) } throws Exception("Query failed")

        var result: Result<List<Event>>? = null
        val latch = CountDownLatch(1)
        calendarImplem.retrieveEvents("1", 0L, 0L) {
            result = it
            latch.countDown()
        }

        latch.await()

        assertTrue(result!!.isFailure)
        assertEquals("GENERIC_ERROR", (result!!.exceptionOrNull() as FlutterError).code)
    }

    @Test
    fun deleteEvent_withGrantedPermission_deletesEventSuccessfully() = runTest {
        mockPermissionGranted()
        mockCalendarIdFound()
        mockWritableCalendar()

        every { contentResolver.delete(eventContentUri, any(), any()) } returns 1

        var result: Result<Unit>? = null
        val latch = CountDownLatch(1)
        calendarImplem.deleteEvent("1") {
            result = it
            latch.countDown()
        }

        latch.await()

        assertTrue(result!!.isSuccess)
    }

    @Test
    fun deleteEvent_withDeniedPermission_returnsAccessRefusedError() = runTest {
        mockPermissionDenied()

        var result: Result<Unit>? = null
        calendarImplem.deleteEvent("1") {
            result = it
        }

        assertTrue(result!!.isFailure)
    }

    @Test
    fun deleteEvent_withException_returnsGenericError() = runTest {
        mockPermissionGranted()
        mockCalendarIdFound()
        mockWritableCalendar()

        every { contentResolver.delete(eventContentUri, any(), any()) } throws Exception("Delete failed")

        var result: Result<Unit>? = null
        val latch = CountDownLatch(1)
        calendarImplem.deleteEvent("1") {
            result = it
            latch.countDown()
        }

        latch.await()

        assertTrue(result!!.isFailure)
        assertEquals("GENERIC_ERROR", (result!!.exceptionOrNull() as FlutterError).code)
    }

    @Test
    fun deleteEvent_withNoRowsDeleted_returnsNotFoundError() = runTest {
        mockPermissionGranted()
        mockCalendarIdFound()
        mockWritableCalendar()

        every { contentResolver.delete(eventContentUri, any(), any()) } returns 0

        var result: Result<Unit>? = null
        val latch = CountDownLatch(1)
        calendarImplem.deleteEvent("1") {
            result = it
            latch.countDown()
        }

        latch.await()

        assertTrue(result!!.isFailure)
        assertEquals("NOT_FOUND", (result!!.exceptionOrNull() as FlutterError).code)
    }

    @Test
    fun deleteEvent_withCalendarIdNotFound_returnsNotFoundError() = runTest {
        mockPermissionGranted()
        mockCalendarIdNotFound()

        var result: Result<Unit>? = null
        val latch = CountDownLatch(1)
        calendarImplem.deleteEvent("1") {
            result = it
            latch.countDown()
        }

        latch.await()

        assertTrue(result!!.isFailure)
        assertEquals("NOT_FOUND", (result!!.exceptionOrNull() as FlutterError).code)
    }
}
