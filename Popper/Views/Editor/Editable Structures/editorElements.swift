//
//  editorElements.swift
//  Popper
//
//  Created by Stanley Grullon on 11/8/23.
//

import SwiftUI

class editorElement: ObservableObject {
    @Published var element: ElementType
    
    // The structs will be able to call from this...
    
    
    init(element: ElementType) {
        self.element = element
    }
    
    enum ElementType {
        case image(editableImg)
        case video(editableVid)
        case text(editableTxt)
        case shape(editableShp)
        
        var display: Bool {
                get {
                    switch self {
                    case .image(let editableImg):
                        return editableImg.display
                    case .video(let editableVid):
                        return editableVid.display
                    case .text(let editableTxt):
                        return editableTxt.display
                    case .shape(let editableShp):
                        return editableShp.display
                    }
                }
                set {
                    switch self {
                    case .image(let editableImg):
                        editableImg.display = newValue
                    case .video(let editableVid):
                        editableVid.display = newValue
                    case .text(let editableTxt):
                        editableTxt.display = newValue
                    case .shape(let editableShp):
                        editableShp.display = newValue
                }
            }
        }
        
        var defaultDisplaySetting: Bool {
                get {
                    switch self {
                    case .image(let editableImg):
                        return editableImg.defaultDisplaySetting
                    case .video(let editableVid):
                        return editableVid.defaultDisplaySetting
                    case .text(let editableTxt):
                        return editableTxt.defaultDisplaySetting
                    case .shape(let editableShp):
                        return editableShp.defaultDisplaySetting
                    }
            }
        }
    }
}

class editorElementsArray: ObservableObject {
    @Published var elements: [Int: editorElement] = [:]
    @Published var objectsCount: Int = 0
    
}
