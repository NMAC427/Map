//
//  UserTrackingMode.swift
//  Map
//
//  Created by Paul Kraft on 09.02.23.
//

import MapKit

public enum UserTrackingMode {

    // MARK: Cases

    case none
    case follow

    @available(tvOS, unavailable)
    @available(macOS, unavailable)
    case followWithHeading

    // MARK: Computed Properties

#if !os(watchOS)
    @available(macOS 11, *)
    var actualValue: MKUserTrackingMode {
        switch self {
        case .none:
            return .none
        case .follow:
            return .follow
        #if !os(macOS) && !os(tvOS)
        case .followWithHeading:
            return .followWithHeading
        #endif
            
        }
    }
#endif

}
