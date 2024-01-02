//
//  Trash.swift
//  Popper
//
//  Created by Stanley Grullon on 11/6/23.
//

import SwiftUI

struct Trash: View {
    
    @ObservedObject var sharedEditNotifier: SharedEditState
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        
        VStack {
                       
                       Spacer()
                       
                       GeometryReader { geo in
                               ZStack {
                                   Circle()
                                       .foregroundStyle(sharedEditNotifier.toDelete ? Color.red : Color.black)
                                       .opacity(sharedEditNotifier.toDelete ? 1.0 : 0.8)
                                       .frame(width: 70, height: 70)
                                   
                                   Image(systemName: "trash")
                                       .resizable()
                                       .scaledToFit()
                                       .foregroundStyle(Color.white)
                                       .frame(width: 40, height: 40)
                                       
                               }
                                   .onAppear {
                                       sharedEditNotifier.trashCanFrame = geo.frame(in: .global)
                                       
                                   }
                                   .offset(y: 70) // Workaround for the Geometry reader spawning 70 units below the actual trash can
                       }
                       .foregroundStyle(sharedEditNotifier.toDelete ? Color.red : Color.black)
                       .frame(width: 70, height: 70, alignment: .center)
                       
                   }
                   .ignoresSafeArea()
                   .padding(70)
                   
               
           
        
//        GeometryReader { geometry in
//                        // Your content here
//
//                        Image(systemName: "trash")
//                            
//                            .background(GeometryReader { trashCanGeometry in
//                                Color.clear.onAppear {
//                                    let trashCanFrame = trashCanGeometry.frame(in: .global)
//                                    sharedEditNotifier.trashCanFrame = trashCanFrame
//                                }
//                            })
//                }
//        .frame(width: 50, height: 50)
//        .foregroundStyle(sharedEditNotifier.toDelete ? Color.red : Color.black)
//        .background(Color.black)
        
//        ZStack {
//            VStack {
//                
//                Spacer()
//                
//                GeometryReader { geo in
//                    ZStack {
//                        Circle()
//                            .foregroundStyle(sharedEditNotifier.toDelete ? Color.red : Color.black)
//                            .opacity(sharedEditNotifier.toDelete ? 1.0 : 0.8)
//                            .frame(width: 70, height: 70)
//                        
//                        Image(systemName: "trash")
//                            .resizable()
//                            .scaledToFit()
//                            .foregroundStyle(Color.white)
//                            .frame(width: 40, height: 40)
//                        
//                    }
//                    .onAppear {
//                        sharedEditNotifier.trashCanFrame = geo.frame(in: .global)
//                        
//                    }
//                    
//                    .offset(y: 70) // Workaround for the Geometry reader spawning 70 units below the actual trash can
//                    //                            .position(x: 200, y: 0)
//                }
//                .frame(width: 70, height: 70, alignment: .center)
//                .foregroundStyle(sharedEditNotifier.toDelete ? Color.red : Color.black)
//                
//                
//                
//            }
//            .ignoresSafeArea()
//        }
//        .padding(70)
        
        //        VStack {
        //            Spacer()
        //
        //            ZStack {
        //                Circle()
        //                    .foregroundStyle(sharedEditNotifier.toDelete ? Color.red : Color.black)
        //                    .opacity(sharedEditNotifier.toDelete ? 1.0 : 0.8)
        //                    .frame(width: 70, height: 70)
        //
        //
        //                Image(systemName: "trash")
        //                    .resizable()
        //                    .scaledToFit()
        //                    .foregroundStyle(Color.white)
        //                    .frame(width: 40, height: 40)
        //            }
        ////            .onAppear {
        ////                sharedEditNotifier.trashCanFrame = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 70, height: 70)
        ////            }
        //            .background(GeometryReader { geometry in
        //                        Color.clear.onAppear {
        //                            sharedEditNotifier.trashCanFrame = geometry.frame(in: .global)
        //
        //                        }
        //                    })
        //        }
        //
        
        //                    ZStack {
        //                        Circle()
        //                            .foregroundStyle(sharedEditNotifier.toDelete ? Color.red : Color.black)
        //                            .opacity(sharedEditNotifier.toDelete ? 1.0 : 0.8)
        //                            .frame(width: 70, height: 70)
        //
        //                        Image(systemName: "trash")
        //                            .resizable()
        //                            .scaledToFit()
        //                            .foregroundStyle(Color.white)
        //                            .frame(width: 40, height: 40)
        //                    }
        //                    .onAppear{ sharedEditNotifier.trashCanFrame = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 70, height: 70) }
        
        
        //        if sharedEditNotifier.trashCanFrame == CGRect.zero {
        //            GeometryReader { geo in
        //                ZStack {
        //                    Group {
        //                        Circle()
        //                            .foregroundStyle(sharedEditNotifier.toDelete ? Color.red : Color.black)
        //                            .opacity(sharedEditNotifier.toDelete ? 1.0 : 0.8)
        //
        //
        //                            .frame(width: 70, height: 70)
        //
        //
        //                        Image(systemName: "trash")
        //                            .resizable()
        //                            .scaledToFit()
        //                            .foregroundStyle(Color.white)
        //
        //
        //                            .frame(width: 40, height: 40)
        //                        //                        .background(Rectangle()
        //                        //                            .foregroundStyle(sharedEditNotifier.toDelete ? Color.red : Color.black)
        //                        //                            .opacity(sharedEditNotifier.toDelete ? 1.0 : 0.8)
        //                        //                            .frame(width: 70, height: 70))
        //                    }
        //                    .frame(width: 70, height: 70)
        //                    .onAppear {
        //                        sharedEditNotifier.trashCanFrame = geo.frame(in: .global)
        //                    }
        //
        //
        //                }
        
        //                .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).midY)
        //                .offset(y: geo.frame(in: .global).minY - 70)
        //                .fixedSize()
        //
        //
        //
        //                .position(x: geo.frame(in: .global).minX, y: geo.frame(in: .global).minY)
        //
        //                .position(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).midY)
        //
        //                .frame(width: 70, height: 70, alignment: .center)
        
        
        //            }
        //
        //            .frame(width: 70, height: 70)
    }
    //        } else {
    //            ZStack {
    //                Circle()
    //                    .foregroundStyle(sharedEditNotifier.toDelete ? Color.red : Color.black)
    //                    .opacity(sharedEditNotifier.toDelete ? 1.0 : 0.8)
    //                    .frame(width: 70, height: 70)
    //
    //
    //                Image(systemName: "trash")
    //                    .resizable()
    //                    .scaledToFit()
    //                    .foregroundStyle(Color.white)
    //
    //
    //                    .frame(width: 40, height: 40)
    //
    //            }
    //            .frame(width: 70, height: 70)
    //            .offset(x: sharedEditNotifier.trashCanFrame.maxX, y: sharedEditNotifier.trashCanFrame.maxY)
    //            .onAppear{print("hello")}
    //        }
    
    
    
    //        ZStack {
    //            Circle()
    //                .foregroundStyle(sharedEditNotifier.toDelete ? Color.red : Color.black)
    //                .opacity(sharedEditNotifier.toDelete ? 1.0 : 0.8)
    //                .frame(width: 70, height: 70)
    //
    //            Image(systemName: "trash")
    //                .resizable()
    //                .scaledToFit()
    //                .foregroundStyle(Color.white)
    //                .frame(width: 40, height: 40)
    //
    //        }
    //        .frame(width: 70, height: 70)
    //        .overlay(GeometryReader { geo in
    //            Rectangle().onAppear(sharedEditNotifier.trashCanFrame = geo.frame(in: .global))
    //        })
    
    //    }
}

struct GeometryThingy: View {
    @ObservedObject var sharedEditNotifier: SharedEditState
    
    var body: some View {
        GeometryReader { geo in
            
            Rectangle()
                .onAppear {
                    sharedEditNotifier.trashCanFrame = geo.frame(in: .global)
                }
        }
        
    }
    
}
