//
//  FontPicker.swift
//  Popper
//
//  Created by Stanley Grullon on 11/6/23.
//

import SwiftUI

struct FontPicker: View {
    
    @Binding var textFont: Font
    @ObservedObject var sharedEditNotifier: SharedEditState
    
    let fonts: [Font] = [
        Font.system(size: defaultTextSize),
        Font.custom("AcademyEngravedLetPlain", size: defaultTextSize),
        Font.custom("AmericanTypewriter", size: defaultTextSize),
        Font.custom("ArialRoundedMTBold", size: defaultTextSize),
        Font.custom("AvenirNextCondensed-HeavyItalic", size: defaultTextSize),
        Font.custom("Baskerville", size: defaultTextSize),
        Font.custom("ChalkboardSE-Regular", size: defaultTextSize),
        Font.custom("Chalkduster", size: defaultTextSize),
        Font.custom("Copperplate", size: defaultTextSize),
        Font.custom("Futura-CondensedMedium", size: defaultTextSize),
        Font.custom("Futura-CondensedExtraBold", size: defaultTextSize),
        Font.custom("Helvetica", size: defaultTextSize),
        Font.custom("Papyrus", size: defaultTextSize),
        Font.custom("SavoyeLetPlain", size: defaultTextSize),
        Font.custom("SnellRoundhand", size: defaultTextSize),
        Font.custom("TimesNewRomanPSMT", size: defaultTextSize)
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center) {
                ForEach(Array(fonts.enumerated()), id: \.offset) { index, font in
                    Text("Text")
                        .font(font)
                        .foregroundStyle(Color.white)
                        .background(Color.black)
//                        .frame(height: 25)
                        .onTapGesture {
                            textFont = font
                            print("Font Changed!")
                        }
                }
                .padding(.horizontal, 5)
            }
        }
    }
}
