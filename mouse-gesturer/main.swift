//
//  main.swift
//  mouse-gesturer
//
//  Created by Tan Kim Yong on 14/11/20.
//

import Foundation
import Cocoa

var onSimulation = false

func CGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    
    let cocoaEventType = NSEvent.EventType(rawValue: UInt(type.rawValue))

    if [ NSEvent.EventType.gesture ].contains(cocoaEventType) {
        let cocoaEvent = NSEvent(cgEvent: event)
        let touches = cocoaEvent?.allTouches()
        if let tt = touches {
            for (i,t) in tt.enumerated() {
                let x = NSString(format: "%.2f", t.normalizedPosition.x)
                let y = NSString(format: "%.2f", t.normalizedPosition.y)
                print("Touches [\(i)] x:\(x) y:\(y)")
            }
        }
    }

    
    return Unmanaged.passRetained(event)
}

// allow all event
let eventMask = UINT64_MAX

guard let eventTap = CGEvent.tapCreate(
    tap: .cgSessionEventTap,
    place: .headInsertEventTap,
    options: .defaultTap,
    eventsOfInterest: CGEventMask(eventMask),
    callback: CGEventCallback,
    userInfo: nil)
else {
    print("Failed to create event tap")
    exit(1)
}

let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
CGEvent.tapEnable(tap: eventTap, enable: true)
CFRunLoopRun()
