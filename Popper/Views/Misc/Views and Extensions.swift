//
//  Views and Extensions.swift
//  Popper
//
//  Created by Stanley Grullon on 9/30/23.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

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

extension Color {
    
    // Reds
    
    static let lightPink = Color(red: 1.0, green: 0.713, blue: 0.756)
    static let salmonRed = Color(red: 0.980, green: 0.502, blue: 0.447)
    static let coralRed = Color(red: 1.0, green: 0.25, blue: 0.25)
    static let rubyRed = Color(red: 0.878, green: 0.066, blue: 0.372)
    static let firebrickRed = Color(red: 0.698, green: 0.133, blue: 0.133)
    static let darkSalmonRed = Color(red: 0.914, green: 0.588, blue: 0.478)
    static let crimsonRed = Color(red: 0.862, green: 0.078, blue: 0.235)
    static let indianRed = Color(red: 0.804, green: 0.361, blue: 0.361)
    static let barnRed = Color(red: 0.647, green: 0.165, blue: 0.165)
    static let imperialRed = Color(red: 0.929, green: 0.161, blue: 0.224)
    static let cherryRed = Color(red: 0.871, green: 0.175, blue: 0.29)
    static let scarletRed = Color(red: 1.0, green: 0.141, blue: 0)
    
    // Greens
    static let mintGreen = Color(red: 0.678, green: 1.0, blue: 0.184)
    static let oliveGreen = Color(red: 0.333, green: 0.419, blue: 0.184)
    static let limeGreen = Color(red: 0.196, green: 0.804, blue: 0.196)
    static let forestGreen = Color(red: 0.133, green: 0.545, blue: 0.133)
    static let jadeGreen = Color(red: 0.000, green: 0.657, blue: 0.420)
    static let hunterGreen = Color(red: 0.209, green: 0.369, blue: 0.231)
    static let fernGreen = Color(red: 0.309, green: 0.474, blue: 0.258)
    static let pineGreen = Color(red: 0.173, green: 0.365, blue: 0.333)
    static let seaGreen = Color(red: 0.180, green: 0.545, blue: 0.341)
    static let shamrockGreen = Color(red: 0.000, green: 0.608, blue: 0.278)
    static let emeraldGreen = Color(red: 0.314, green: 0.784, blue: 0.471)
    static let malachiteGreen = Color(red: 0.043, green: 0.854, blue: 0.318)
    
    // Blues
    static let azureBlue = Color(red: 0.0, green: 0.498, blue: 1.0)
    static let cornflowerBlue = Color(red: 0.392, green: 0.584, blue: 0.929)
    static let skyBlue = Color(red: 0.529, green: 0.808, blue: 0.922)
    static let navyBlue = Color(red: 0.0, green: 0.0, blue: 0.502)
    static let royalBlue = Color(red: 0.255, green: 0.412, blue: 0.882)
    static let steelBlue = Color(red: 0.275, green: 0.510, blue: 0.706)
    static let carolinaBlue = Color(red: 0.6, green: 0.729, blue: 0.949)
    static let turquoiseBlue = Color(red: 0.251, green: 0.878, blue: 0.816)
    static let tealBlue = Color(red: 0.0, green: 0.502, blue: 0.502)
    static let sapphireBlue = Color(red: 0.059, green: 0.322, blue: 0.729)
    static let denimBlue = Color(red: 0.082, green: 0.376, blue: 0.741)
    static let dodgerBlue = Color(red: 0.118, green: 0.565, blue: 1.0)
    
    // Oranges
    static let apricotOrange = Color(red: 1.0, green: 0.584, blue: 0.486)
    static let bronzeOrange = Color(red: 0.804, green: 0.498, blue: 0.196)
    static let carrotOrange = Color(red: 0.929, green: 0.569, blue: 0.129)
    static let neonOrange = Color(red: 1.0, green: 0.643, blue: 0.0)
    static let sunsetOrange = Color(red: 0.992, green: 0.368, blue: 0.325)
    static let clementineOrange = Color(red: 1.0, green: 0.471, blue: 0.153)
    static let bloodOrange = Color(red: 0.851, green: 0.259, blue: 0.118)
    static let persimmonOrange = Color(red: 0.925, green: 0.345, blue: 0.0)
    static let pumpkinOrange = Color(red: 1.0, green: 0.459, blue: 0.094)
    static let gingerOrange = Color(red: 0.690, green: 0.396, blue: 0.0)
    static let spiceOrange = Color(red: 1.0, green: 0.549, blue: 0.0)
    static let tangerineOrange = Color(red: 0.949, green: 0.522, blue: 0.0)
    
    // Purples
    static let lavenderPurple = Color(red: 0.709, green: 0.494, blue: 0.862)
        static let violetPurple = Color(red: 0.933, green: 0.510, blue: 0.933)
        static let plumPurple = Color(red: 0.557, green: 0.169, blue: 0.886)
        static let orchidPurple = Color(red: 0.854, green: 0.439, blue: 0.839)
        static let amethystPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
        static let mauvePurple = Color(red: 0.878, green: 0.694, blue: 1.0)
        static let magentaPurple = Color(red: 0.784, green: 0.082, blue: 0.522)
        static let mulberryPurple = Color(red: 0.772, green: 0.294, blue: 0.549)
        static let grapePurple = Color(red: 0.447, green: 0.259, blue: 0.596)
        static let eggplantPurple = Color(red: 0.38, green: 0.25, blue: 0.32)
        static let royalPurple = Color(red: 0.471, green: 0.318, blue: 0.663)
        static let periwinklePurple = Color(red: 0.8, green: 0.8, blue: 1.0)

    
    // Pink
    static let salmonPink = Color(red: 1.0, green: 0.765, blue: 0.686)
        static let rosePink = Color(red: 1.0, green: 0.753, blue: 0.796)
        static let fuchsiaPink = Color(red: 1.0, green: 0.0, blue: 1.0)
        static let blushPink = Color(red: 0.871, green: 0.722, blue: 0.529)
        static let hotPink = Color(red: 1.0, green: 0.411, blue: 0.706)
        static let punchPink = Color(red: 0.859, green: 0.0, blue: 0.255)
        static let flamingoPink = Color(red: 0.988, green: 0.557, blue: 0.675)
        static let watermelonPink = Color(red: 0.992, green: 0.356, blue: 0.505)
        static let bubblegumPink = Color(red: 0.992, green: 0.752, blue: 0.784)
        static let balletPink = Color(red: 0.894, green: 0.659, blue: 0.733)
        static let coralPink = Color(red: 0.973, green: 0.513, blue: 0.475)
        static let peachPink = Color(red: 1.0, green: 0.8, blue: 0.678)
    
    // Yellows
    
    static let lemonYellow = Color(red: 1.0, green: 1.0, blue: 0.196)
    static let goldYellow = Color(red: 1.0, green: 0.843, blue: 0.0)
    static let mustardYellow = Color(red: 1.0, green: 0.859, blue: 0.345)
    static let flaxenYellow = Color(red: 0.933, green: 0.863, blue: 0.509)
    static let creamYellow = Color(red: 1.0, green: 0.992, blue: 0.816)
    static let mellowYellow = Color(red: 0.972, green: 0.972, blue: 0.588)
    static let saffronYellow = Color(red: 0.957, green: 0.769, blue: 0.039)
    static let honeyYellow = Color(red: 0.99, green: 0.875, blue: 0.364)
    static let daffodilYellow = Color(red: 1.0, green: 1.0, blue: 0.19)
    static let bumblebeeYellow = Color(red: 0.953, green: 0.8, blue: 0.008)
    static let cyberYellow = Color(red: 1.0, green: 0.827, blue: 0.0)
    static let canaryYellow = Color(red: 1.0, green: 0.937, blue: 0.0)
    
    // Browns
    
    static let caramelBrown = Color(red: 0.686, green: 0.435, blue: 0.184)
    static let walnutBrown = Color(red: 0.435, green: 0.306, blue: 0.216)
    static let beaverBrown = Color(red: 0.624, green: 0.506, blue: 0.439)
    static let umberBrown = Color(red: 0.388, green: 0.318, blue: 0.278)
    static let burntBrown = Color(red: 0.592, green: 0.298, blue: 0.0)
    static let sepiaBrown = Color(red: 0.439, green: 0.258, blue: 0.078)
    static let siennaBrown = Color(red: 0.627, green: 0.322, blue: 0.176)
    static let sableBrown = Color(red: 0.545, green: 0.271, blue: 0.075)
    static let mahoganyBrown = Color(red: 0.753, green: 0.251, blue: 0.0)
    static let fawnBrown = Color(red: 0.898, green: 0.667, blue: 0.439)
    static let taupeBrown = Color(red: 0.282, green: 0.239, blue: 0.545)
    static let espressoBrown = Color(red: 0.233, green: 0.192, blue: 0.173)
}
