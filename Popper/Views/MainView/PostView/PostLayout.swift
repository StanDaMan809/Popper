//
//  PostLayout.swift
//  Popper
//
//  Created by Stanley Grullon on 11/27/23.
//

import SwiftUI

struct PostLayout: Layout {
    @Binding var elementsArray: [String: postElement]
    
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        
        // Calculate and return the size of the layout container.
        var highestPoint: Double = 400
        var lowestPoint: Double = -400
        
        for (_, value) in elementsArray {
            
            
            
            let element = value
            
            // Take the highest position, add the height of the tallest element to the highest position
            // Take the lowest position, add the height of the lowest element to the lowest position
            
            // To track displacement by rotation
//            var displacementTracker = 0.0
//            var longerSide = 0.0
//            var shorterSide = 0.0
//            
//            if element.rotationDegrees.degrees != 0.0 {
//                if element.size.width > element.size.height {
//                    longerSide = element.size.width * cos(element.rotationDegrees.degrees)
//                    shorterSide = element.size.height * sin(element.rotationDegrees.degrees)
//                    displacementTracker = (0.5) * (longerSide + shorterSide)
//                    
//                } else if element.size.width < element.size.height {
//                    longerSide = element.size.height * cos(element.rotationDegrees.degrees)
//                    shorterSide = element.size.width * sin(element.rotationDegrees.degrees)
//                    displacementTracker = (0.5) * (longerSide + shorterSide)
//                } else {
//                    longerSide = element.size.height * cos(element.rotationDegrees.degrees)
//                    displacementTracker = (0.5) * (1 - longerSide)
//                }
//            }
            
            
            
            
            
            let currentHighPoint = element.position.height - (element.size.height / 2) /*+ displacementTracker*/
            let currentLowPoint = (element.size.height / 2) + element.position.height /*+ displacementTracker*/
            
            highestPoint = min(currentHighPoint, highestPoint)
            
            lowestPoint = max(currentLowPoint, lowestPoint)
            
            // Vertical Displacement = 1 / 2(acos(θ)+bsin(θ)), where a is their longer side and b is their shorter side
            
            //
            
            // Highest height + position
        }
        
        highestPoint = min(abs(highestPoint), UIScreen.main.bounds.maxY)
        lowestPoint = min(lowestPoint, UIScreen.main.bounds.maxY)
        let peak = max(lowestPoint, highestPoint)

        return CGSize(width: Int(UIScreen.main.bounds.width), height: Int(peak * 2))
        
    }
    
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        for (_, subview) in subviews.enumerated() {
            // ask this view for its ideal size
            let viewSize = subview.sizeThatFits(.unspecified)
            
            // position this view relative to our centre, using its natural size ("unspecified")
            let point = CGPoint(x: bounds.midX, y: bounds.midY)
            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
}
