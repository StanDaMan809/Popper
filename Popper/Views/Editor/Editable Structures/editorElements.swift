//
//  editorElements.swift
//  Popper
//
//  Created by Stanley Grullon on 11/8/23.
//

import SwiftUI

class editorElement: ObservableObject, Equatable {
    static func == (lhs: editorElement, rhs: editorElement) -> Bool {
        lhs.element.id == rhs.element.id
    }
    
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
        case sticker(editableStick)
        case poll(editablePoll)
        
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
            case .sticker(let editableStick):
                return editableStick.id
            case .poll(let editablePoll):
                return editablePoll.id
            }
        }
        
        var currentShape: ClippableShape {
            get {
                switch self {
                case .image(let editableImg):
                    return editableImg.currentShape
                case .video(let editableVid):
                    return editableVid.currentShape
                case .text(let editableTxt):
                    return editableTxt.currentShape
                case .shape(let editableShp):
                    return editableShp.currentShape
                case .sticker(let editableStick):
                    return editableStick.currentShape
                case .poll:
                    return .square
                }
            }
            set {
                switch self {
                case .image(let editableImg):
                    editableImg.currentShape = newValue
                case .video(let editableVid):
                    editableVid.currentShape = newValue
                case .text(let editableTxt):
                    editableTxt.currentShape = newValue
                case .shape(let editableShp):
                    editableShp.currentShape = newValue
                case .sticker(let editableStick):
                    editableStick.currentShape = newValue
                case .poll:
                    print("Poll has no member currentShape")
                }
            }
        }
        
        var position: CGSize {
            get {
                switch self {
                case .image(let editableImg):
                    return editableImg.position
                case .video(let editableVid):
                    return editableVid.position
                case .text(let editableTxt):
                    return editableTxt.position
                case .shape(let editableShp):
                    return editableShp.position
                case .sticker(let editableStick):
                    return editableStick.position
                case .poll(let editablePoll):
                    return editablePoll.position
                }
            }
            set {
                switch self {
                case .image(let editableImg):
                    editableImg.position = newValue
                case .video(let editableVid):
                    editableVid.position = newValue
                case .text(let editableTxt):
                    editableTxt.position = newValue
                case .shape(let editableShp):
                    editableShp.position = newValue
                case .sticker(let editableStick):
                    editableStick.position = newValue
                case .poll(let editablePoll):
                    editablePoll.position = newValue
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
                case .sticker(let sticker):
                    return CGSize(width: 100 * sticker.scalar, height: 100 * sticker.scalar)
                case .poll:
                    return CGSize(width: 0, height: 0)
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
                case .sticker:
                    print("Cannot set sticker size")
                case .poll:
                    print("Cannot set sticker size")
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
                case .sticker(let editableStick):
                    return editableStick.startPosition
                case .poll(let editablePoll):
                    return editablePoll.startPosition
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
                case .sticker(let editableStick):
                    editableStick.startPosition = newValue
                case .poll(let editablePoll):
                    editablePoll.startPosition = newValue
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
                case .sticker(let editableStick):
                    return editableStick.scalar
                case .poll(let editablePoll):
                    return editablePoll.scalar
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
                case .sticker(let editableStick):
                    editableStick.scalar = newValue
                case .poll(let editablePoll):
                    editablePoll.scalar = newValue
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
                case .sticker(let editableStick):
                    return editableStick.transparency
                case .poll(let editablePoll):
                    return editablePoll.transparency
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
                case .sticker(let editableStick):
                    editableStick.transparency = newValue
                case .poll(let editablePoll):
                    editablePoll.transparency = newValue
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
                case .sticker(let editableStick):
                    return editableStick.display
                case .poll(let editablePoll):
                    return editablePoll.display
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
                case .sticker(let editableStick):
                    editableStick.display = newValue
                case .poll(let editablePoll):
                    editablePoll.display = newValue
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
                case .sticker(let editableStick):
                    return editableStick.createDisplays
                case .poll:
                    return []
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
                case .sticker(let editableStick):
                    editableStick.createDisplays = newValue
                case .poll:
                    print("polls cannot create elemetns")
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
                case .sticker(let editableStick):
                    return editableStick.disappearDisplays
                case .poll:
                    return []
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
                case .sticker(let editableStick):
                    editableStick.disappearDisplays = newValue
                case .poll:
                    print("Cannot retrieve disappeardisplays from a poll")
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
                case .sticker(let editableStick):
                    return editableStick.rotationDegrees
                case .poll(let editablePoll):
                    return editablePoll.rotationDegrees
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
                case .sticker(let editableStick):
                    editableStick.rotationDegrees = newValue
                case .poll(let editablePoll):
                    editablePoll.rotationDegrees = newValue
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
                case .sticker(let editableStick):
                    return editableStick.defaultDisplaySetting
                case .poll(let editablePoll):
                    return editablePoll.defaultDisplaySetting
                }
            }
        }
        
        var lock: Bool {
            get {
                switch self {
                case .image(let editableImg):
                    return editableImg.lock
                case .video(let editableVid):
                    return editableVid.lock
                case .text(let editableTxt):
                    return editableTxt.lock
                case .shape(let editableShp):
                    return editableShp.lock
                case .sticker(let editableStick):
                    return editableStick.lock
                case .poll(let editablePoll):
                    return editablePoll.lock
                }
            }
            set {
                switch self {
                case .image(let editableImg):
                    editableImg.lock = newValue
                case .video(let editableVid):
                    editableVid.lock = newValue
                case .text(let editableTxt):
                    editableTxt.lock = newValue
                case .shape(let editableShp):
                    editableShp.lock = newValue
                case .sticker(let editableStick):
                    editableStick.lock = newValue
                case .poll(let editablePoll):
                    editablePoll.lock = newValue
                }
            }
        }
        
        var soundOnClick: URL? {
            get {
                switch self {
                case .image(let editableImg):
                    return editableImg.soundOnClick
                case .video(let editableVid):
                    return editableVid.soundOnClick
                case .text(let editableTxt):
                    return editableTxt.soundOnClick
                case .shape(let editableShp):
                    return editableShp.soundOnClick
                case .sticker(let editableStick):
                    return editableStick.soundOnClick
                case .poll(let editablePoll):
                    return editablePoll.soundOnClick
                }
            }
            set {
                switch self {
                case .image(let editableImg):
                    editableImg.soundOnClick = newValue
                case .video(let editableVid):
                    editableVid.soundOnClick = newValue
                case .text(let editableTxt):
                    editableTxt.soundOnClick = newValue
                case .shape(let editableShp):
                    editableShp.soundOnClick = newValue
                case .sticker(let editableStick):
                    editableStick.soundOnClick = newValue
                case .poll(let editablePoll):
                    editablePoll.soundOnClick = newValue
                }
            }
        }
    }
}

class editorElementsArray: ObservableObject {
    @Published var elements: [Int: editorElement] = [:]
    @Published var objectsCount: Int = 0
    
}


