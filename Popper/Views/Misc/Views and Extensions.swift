//
//  Views and Extensions.swift
//  Popper
//
//  Created by Stanley Grullon on 9/30/23.
//

import SwiftUI

extension View {
    
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func disableWithOpacity(_ condition: Bool)-> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    
    func hAlign(_ alignment: Alignment)-> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment)-> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func border(_ width: CGFloat,_ color: Color)-> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
   
    // Custom Fill View with Padding
        func fillView(_ color: Color)-> some View {
            self
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(color)
                }
    }
}

extension UIImage {
    func downsample(to targetSize: CGSize) -> UIImage? {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

extension Date {
    func timeAgoDisplay() -> String {
 
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff)s"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff)m"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff)h"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff)d"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff)w"
    }
}
