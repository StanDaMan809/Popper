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
        
        var id: Int {
            switch self {
                case .image(let editableImg):
                    return editableImg.id
                case .video(let editableVid):
                    return editableVid.id
                case .text(let editableTxt):
                    return editableTxt.id
                case .shape(let editableShp):
                    return editableShp.id
            }
        }
        
        var currentShape: ClippableShape {
            get {
                switch self {
                case .image(let editableImg):
                    return editableImg.currentShape
                case .video(let editableVid):
                    return editableVid.currentShape
                case .text( _):
                    return .rectangle
                case .shape(let editableShp):
                    return editableShp.currentShape
                }
            }
            set {
                switch self {
                case .image(let editableImg):
                    editableImg.currentShape = newValue
                case .video(let editableVid):
                    editableVid.currentShape = newValue
                case .text( _):
                    print("Cannot set currentshape to text.")
                case .shape(let editableShp):
                    editableShp.currentShape = newValue
                }
            }
        }
        
        var totalOffset: CGPoint {
            get {
                switch self {
                case .image(let editableImg):
                    return editableImg.totalOffset
                case .video(let editableVid):
                    return editableVid.totalOffset
                case .text(let editableTxt):
                    return editableTxt.totalOffset
                case .shape(let editableShp):
                    return editableShp.totalOffset
                }
            }
            set {
                switch self {
                case .image(let editableImg):
                    editableImg.totalOffset = newValue
                case .video(let editableVid):
                    editableVid.totalOffset = newValue
                case .text(let editableTxt):
                    editableTxt.totalOffset = newValue
                case .shape(let editableShp):
                    editableShp.totalOffset = newValue
                }
            }
        }
        
        var size: CGSize {
            get {
                switch self {
                case .image(let editableImg):
                    return editableImg.size
                case .video(let editableVid):
                    return editableVid.size
                case .text(let editableTxt):
                    return editableTxt.size
                case .shape(let editableShp):
                    return editableShp.size
                }
            }
            set {
                switch self {
                case .image(let editableImg):
                    editableImg.size = newValue
                case .video(let editableVid):
                    editableVid.size = newValue
                case .text(let editableTxt):
                    editableTxt.size = newValue
                case .shape(let editableShp):
                    editableShp.size = newValue
                }
            }
        }
        
        var startPosition: CGPoint {
            get {
                switch self {
                case .image(let editableImg):
                    return editableImg.startPosition
                case .video(let editableVid):
                    return editableVid.startPosition
                case .text(let editableTxt):
                    return editableTxt.startPosition
                case .shape(let editableShp):
                    return editableShp.startPosition
                }
            }
            set {
                switch self {
                case .image(let editableImg):
                    editableImg.startPosition = newValue
                case .video(let editableVid):
                    editableVid.startPosition = newValue
                case .text(let editableTxt):
                    editableTxt.startPosition = newValue
                case .shape(let editableShp):
                    editableShp.startPosition = newValue
                }
            }
        }
        
        var scalar: Double {
            get {
                switch self {
                case .image(let editableImg):
                    return editableImg.scalar
                case .video(let editableVid):
                    return editableVid.scalar
                case .text(let editableTxt):
                    return editableTxt.scalar
                case .shape(let editableShp):
                    return editableShp.scalar
                }
            }
            set {
                switch self {
                case .image(let editableImg):
                    editableImg.scalar = newValue
                case .video(let editableVid):
                    editableVid.scalar = newValue
                case .text(let editableTxt):
                    editableTxt.scalar = newValue
                case .shape(let editableShp):
                    editableShp.scalar = newValue
                }
            }
        }
        
        var transparency: Double {
            get {
                switch self {
                case .image(let editableImg):
                    return editableImg.transparency
                case .video(let editableVid):
                    return editableVid.transparency
                case .text(let editableTxt):
                    return editableTxt.transparency
                case .shape(let editableShp):
                    return editableShp.transparency
                }
            }
            set {
                switch self {
                case .image(let editableImg):
                    editableImg.transparency = newValue
                case .video(let editableVid):
                    editableVid.transparency = newValue
                case .text(let editableTxt):
                    editableTxt.transparency = newValue
                case .shape(let editableShp):
                    editableShp.transparency = newValue
                }
            }
        }
        
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
        
        var createDisplays: [Int] {
                get {
                    switch self {
                    case .image(let editableImg):
                        return editableImg.createDisplays
                    case .video(let editableVid):
                        return editableVid.createDisplays
                    case .text(let editableTxt):
                        return editableTxt.createDisplays
                    case .shape(let editableShp):
                        return editableShp.createDisplays
                    }
                }
                set {
                    switch self {
                    case .image(let editableImg):
                        editableImg.createDisplays = newValue
                    case .video(let editableVid):
                        editableVid.createDisplays = newValue
                    case .text(let editableTxt):
                        editableTxt.createDisplays = newValue
                    case .shape(let editableShp):
                        editableShp.createDisplays = newValue
                }
            }
        }
        
        var disappearDisplays: [Int] {
                get {
                    switch self {
                    case .image(let editableImg):
                        return editableImg.disappearDisplays
                    case .video(let editableVid):
                        return editableVid.disappearDisplays
                    case .text(let editableTxt):
                        return editableTxt.disappearDisplays
                    case .shape(let editableShp):
                        return editableShp.disappearDisplays
                    }
                }
                set {
                    switch self {
                    case .image(let editableImg):
                        editableImg.disappearDisplays = newValue
                    case .video(let editableVid):
                        editableVid.disappearDisplays = newValue
                    case .text(let editableTxt):
                        editableTxt.disappearDisplays = newValue
                    case .shape(let editableShp):
                        editableShp.disappearDisplays = newValue
                }
            }
        }
        
        var rotationDegrees: Angle {
                get {
                    switch self {
                    case .image(let editableImg):
                        return editableImg.rotationDegrees
                    case .video(let editableVid):
                        return editableVid.rotationDegrees
                    case .text(let editableTxt):
                        return editableTxt.rotationDegrees
                    case .shape(let editableShp):
                        return editableShp.rotationDegrees
                    }
                }
                set {
                    switch self {
                    case .image(let editableImg):
                        editableImg.rotationDegrees = newValue
                    case .video(let editableVid):
                        editableVid.rotationDegrees = newValue
                    case .text(let editableTxt):
                        editableTxt.rotationDegrees = newValue
                    case .shape(let editableShp):
                        editableShp.rotationDegrees = newValue
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


