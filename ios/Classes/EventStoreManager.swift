//
//  EventStoreManager.swift
//  flutter_calendar_connect
//
//  Created by CHOUPAULT Alexis on 31/12/2024.
//

import Foundation
import EventKit

class EventStoreManager: ObservableObject {
    static let shared = EventStoreManager()
    
    let eventStore: EKEventStore
    
    private init() {
        self.eventStore = EKEventStore()
    }
}
