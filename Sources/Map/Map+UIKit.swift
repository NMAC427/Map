//
//  Map+UIKit.swift
//  Map
//
//  Created by Paul Kraft on 25.04.22.
//

#if canImport(UIKit) && !os(watchOS)

import MapKit
import UIKit
import SwiftUI

class MKMapViewWithCustomLegalPosition: MKMapView {
    private var legalPosition: MapLegalPosition?
    private var yPadding: CGFloat! = nil

    override func frame(forAlignmentRect alignmentRect: CGRect) -> CGRect {
        if let legalPosition {
            updateLegalPosition(legalPosition)
        }

        return super.frame(forAlignmentRect: alignmentRect)
    }

    func updateLegalPosition(_ legalPosition: MapLegalPosition) {
        self.legalPosition = legalPosition

        DispatchQueue.main.async { [self] in
            guard let logoView, let legalView else { return }
            
            if yPadding == nil {
                yPadding = frame.height - safeAreaInsets.bottom - min(logoView.frame.maxY, legalView.frame.maxY)
            }

            switch legalPosition {
            case .bottom:
                let yOffset = self.frame.height - safeAreaInsets.bottom - yPadding - min(logoView.frame.maxY, legalView.frame.maxY)

                logoView.frame.origin.y += yOffset
                legalView.frame.origin.y += yOffset
            case .top:
                let yOffset = safeAreaInsets.top + yPadding - min(logoView.frame.minY, legalView.frame.minY)

                logoView.frame.origin.y += yOffset
                legalView.frame.origin.y += yOffset
            }
        }
    }

    var logoView: UIView? {
        for subview in subviews {
            if String.init(describing: subview).localizedCaseInsensitiveContains("MKAppleLogo") {
                return subview
            }
        }
        return nil
    }

    var legalView: UIView? {
        for subview in subviews {
            if String.init(describing: subview).localizedCaseInsensitiveContains("MKAttribution") {
                return subview
            }
        }
        return nil
    }
}

extension Map: UIViewRepresentable {

    public func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapViewWithCustomLegalPosition()
        mapView.delegate = context.coordinator
        updateUIView(mapView, context: context)
        return mapView
    }

    public func updateUIView(_ mapView: MKMapView, context: Context) {
        context.coordinator.update(mapView, from: self, context: context)
    }

}

#endif
