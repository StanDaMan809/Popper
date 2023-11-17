//
//  ColorPicker.swift
//  Popper
//
//  Created by Stanley Grullon on 11/3/23.
//

import SwiftUI

struct ColorPicker: View {
    
    //    @Published var elementColor: Color
    
    @Binding var elementColor: Color
    @State var colorToWatch: Color = Color.clear
    @ObservedObject var sharedEditNotifier: SharedEditState
    
    @State var colorsArray: [Color] = [.red, .green, .blue, .orange, .purple, .pink, .yellow, .brown]
    
    @State var colorSelected: Bool = false
    
    
    
    let standardColors: [Color] = [.red, .green, .blue, .orange, .purple, .pink, .yellow, .brown]
    
    let sortedColors: [[Color]] = [
        [
            .red,
            .lightPink,
            .salmonRed,
            .coralRed,
            .darkSalmonRed,
            .indianRed,
            .cherryRed,
            .imperialRed,
            .scarletRed,
            .rubyRed,
            .firebrickRed,
            .crimsonRed,
            .barnRed
        ],
        [
            .green, // Assuming this is the base green color you're referring to
            .mintGreen,
            .limeGreen,
            .emeraldGreen,
            .malachiteGreen,
            .shamrockGreen,
            .seaGreen,
            .fernGreen,
            .oliveGreen,
            .pineGreen,
            .hunterGreen,
            .forestGreen,
            .jadeGreen
        ] ,
        [
            .blue, // Assuming this is the base blue color you're referring to
            .azureBlue,
            .dodgerBlue,
            .carolinaBlue,
            .skyBlue,
            .cornflowerBlue,
            .turquoiseBlue,
            .royalBlue,
            .steelBlue,
            .tealBlue,
            .denimBlue,
            .sapphireBlue,
            .navyBlue
        ],
        [
            .orange, // Assuming this is the base orange color you're referring to
            .apricotOrange,
            .peachPink,
            .sunsetOrange,
            .neonOrange,
            .clementineOrange,
            .carrotOrange,
            .pumpkinOrange,
            .tangerineOrange,
            .gingerOrange,
            .bloodOrange,
            .persimmonOrange,
            .bronzeOrange,
            .spiceOrange
        ],
        [
            .purple, // Assuming this is the base purple color you're referring to
            .periwinklePurple,
            .mauvePurple,
            .lavenderPurple,
            .violetPurple,
            .orchidPurple,
            .amethystPurple,
            .royalPurple,
            .mulberryPurple,
            .magentaPurple,
            .grapePurple,
            .plumPurple,
            .eggplantPurple
        ],
        [
            .pink, // Assuming this is the base pink color you're referring to
            .peachPink,
            .salmonPink,
            .rosePink,
            .balletPink,
            .bubblegumPink,
            .flamingoPink,
            .coralPink,
            .watermelonPink,
            .hotPink,
            .punchPink,
            .fuchsiaPink
        ],
        [.yellow, .lemonYellow, .goldYellow, .mustardYellow, .flaxenYellow, .creamYellow, .mellowYellow, .saffronYellow, .honeyYellow, .daffodilYellow, .bumblebeeYellow, .canaryYellow],
        [.brown, .caramelBrown, .walnutBrown, .beaverBrown, .umberBrown, .burntBrown, .sepiaBrown, .siennaBrown, .sableBrown, .mahoganyBrown, .fawnBrown, .espressoBrown]
    ]
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                
                if sharedEditNotifier.editorDisplayed == .colorPickerTextBG {
                    Image(systemName: "circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(.horizontal, 5)
                        .onTapGesture {
                            colorToWatch = Color.clear
                            elementColor = Color.clear
                        }
                }
                
                ForEach(Array(colorsArray.enumerated()), id: \.offset) { index, color in
                            if colorToWatch != color {
                                Circle()
                                    .fill(color)
                                    .frame(width: 40, height: 40)
                                    .onTapGesture() {
                                        elementColor = color
                                        colorToWatch = color
                                    }
                                    
                            } else {
                                ZStack {
                                    Circle()
                                        .fill(Color.black)
                                        .opacity(0.8)
                                        .frame(width: 40, height: 40)
                                        
                                    Circle()
                                        .fill(color)
                                        .frame(width: 20, height: 20)
                                }
                                .onTapGesture() {
                                    if colorSelected {
                                        colorsArray = standardColors
                                        colorSelected = false
                                    } else {
                                        colorsArray = sortedColors[index]
                                        colorSelected = true
                                    }
                                }
                            }
                    }
                    .padding(.horizontal, 5)
                
                    
                    if colorSelected == false {
                        ColorPickerCircle(parent: self, color: Color.white)
                        ColorPickerCircle(parent: self, color: Color.gray)
                        ColorPickerCircle(parent: self, color: Color.black)
                    }
                
                    // Will add a button in the future for custom colors
                
            }
            
        }
        .backgroundStyle(Color.clear)
        .padding(.top, 10)
        .ignoresSafeArea()
        .onAppear() {
            colorToWatch = elementColor
        }
    }
    
    struct ColorPickerCircle: View {
        let parent: ColorPicker
        let color: Color
        
        var body: some View {
            Group {
                if parent.colorToWatch != color {
                    Circle()
                        .fill(color)
                        .frame(width: 40, height: 40)
                        .onTapGesture() {
                            parent.elementColor = color
                            parent.colorToWatch = color
                        }
                        
                } else {
                    ZStack {
                        Circle()
                            .fill(Color.black)
                            .opacity(0.8)
                            .frame(width: 40, height: 40)
                            
                        Circle()
                            .fill(color)
                            .frame(width: 20, height: 20)
                    }
                }
            }
            .padding(.horizontal, 5)
        }
    }

}
