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
        Font.custom("Cabin-Bold", size: defaultTextSize),
        Font.custom("Roboto-Bold", size: defaultTextSize),
        Font.custom("Louis George Cafe", size: defaultTextSize),
        Font.custom("Montserrat-ExtraBold", size: defaultTextSize),
        Font.custom("PlayfairDisplay-Regular", size: defaultTextSize),
        Font.custom("Nunito-ExtraBold", size: defaultTextSize),
        Font.custom("Lato-Regular", size: defaultTextSize),
        Font.custom("Rubik-Regular", size: defaultTextSize),
        Font.custom("JosefinSans-Regular", size: defaultTextSize),
        Font.custom("BebasNeue-Regular", size: defaultTextSize),
        Font.custom("BarlowCondensed-Bold", size: defaultTextSize),
        Font.custom("SourceCodePro-Regular", size: defaultTextSize),
        Font.custom("DancingScript-Bold", size: defaultTextSize),
        Font.custom("Pacifico-Regular", size: defaultTextSize),
        Font.custom("Caveat-SemiBold", size: defaultTextSize),
        Font.custom("ShadowsIntoLight-Regular", size: defaultTextSize),
        Font.custom("ChakraPetch-Bold", size: defaultTextSize),
        Font.custom("IndieFlower-Regular", size: defaultTextSize),
        Font.custom("AmaticSC-Bold", size: defaultTextSize),
        Font.custom("Kalam-Regular", size: defaultTextSize),
        Font.custom("GreatVibes-Regular", size: defaultTextSize),
        Font.custom("CaviarDreams_Italic", size: defaultTextSize),
        Font.custom("PermanentMarker-Regular", size: defaultTextSize),
        Font.custom("OldLondon", size: defaultTextSize)
    ]
    
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center) {
                ForEach(Array(fonts.enumerated()), id: \.offset) { index, font in
                    ZStack {
                        Circle()
                            .foregroundStyle(Color.black)
                            .frame(width: 50, height: 50)
                            .opacity(0.8)
                        
                        Text("Abc")
                            .font(font)
                            .foregroundStyle(Color.white)
                    }
                    //                        .frame(height: 25)
                        .onTapGesture {
                            textFont = font
                            print("Font Changed!")
                        }
                }
                .padding(.horizontal, 5)
            }
        }
        .padding(.top, 10)
        .backgroundStyle(Color.clear)
    }
}
