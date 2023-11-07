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
                ForEach(Array(colorsArray.enumerated()), id: \.offset) { index, color in
                        Circle()
                            .fill(color)
                            .frame(width: 40, height: 40)
                            .onTapGesture(count: 2){
                                if colorSelected {
                                    colorsArray = standardColors
                                    colorSelected = false
                                } else {
                                    colorsArray = sortedColors[index]
                                    colorSelected = true
                                }
                            }
                            .onTapGesture {
                                elementColor = color
                            }
                    }
                    .padding(.horizontal, 5)
                    
                    if colorSelected == false {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                            .padding(.horizontal, 5)
                            .onTapGesture {
                                elementColor = .white
                            }
                    
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 40, height: 40)
                            .padding(.horizontal, 5)
                            .onTapGesture {
                                elementColor = .gray
                            }
                    
                        Circle()
                            .fill(Color.black)
                            .frame(width: 40, height: 40)
                            .padding(.horizontal, 5)
                            .onTapGesture {
                                elementColor = .black
                            }
                        
                        
                    }
                
                    // Will add a button in the future for custom colors
                
            }
            
        }
    }
}
