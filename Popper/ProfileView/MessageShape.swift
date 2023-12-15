//
//  MessageShape.swift
//  Popper
//
//  Created by Stanley Grullon on 12/14/23.
//

import SwiftUI

struct MessageShape: Shape {
    let cornerRadius: CGFloat
    let arrowHeight: CGFloat
    let arrowWidth: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height

        let arrowHeight = min(self.arrowHeight, height / 2)
        let arrowWidth = min(self.arrowWidth, width)

        path.move(to: CGPoint(x: arrowWidth, y: 0))
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)
        path.addLine(to: CGPoint(x: width, y: height - cornerRadius - arrowHeight))
        path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius - arrowHeight),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: arrowWidth + arrowWidth / 2, y: height - arrowHeight))
        path.addLine(to: CGPoint(x: arrowWidth, y: height))
        path.addLine(to: CGPoint(x: arrowWidth / 2, y: height - arrowHeight))
        path.addLine(to: CGPoint(x: cornerRadius, y: height - arrowHeight))
        path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius - arrowHeight),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: -90),
                    clockwise: false)

        return path
    }
}

#Preview {
    HStack {
        VStack (alignment: .leading, spacing: 1) {
            Text("oh my god LMFAOOOOO...")
                .padding()
                .foregroundStyle(Color.white)
                .background(RoundedRectangle(cornerRadius: 25).foregroundStyle(Color.blue))
            Text("WAIT NOOO CUZ WHY WAS HE SO ANNOYING")
                .padding()
                .foregroundStyle(Color.white)
                .background(RoundedRectangle(cornerRadius: 25).foregroundStyle(Color.blue))
        }
        Spacer()
    }
    .padding()
//        .padding()
//        .background(RoundedRectangle(cornerRadius: 40).foregroundStyle(Color.blue))
//    
     
}
