//
//  postElements.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI

class postElement: ObservableObject {
    @Published var element: ElementType
    
    // The structs will be able to call from this...
    
    
    init(element: ElementType) {
        self.element = element
    }
    
    enum ElementType {
        case image(postImage)
        case video(postVideo)
        case shape(postShape)
        case poll(postPoll)
        case sticker(postSticker)
        
        var id: Int {
            switch self {
            case .image(let editableImg):
                return editableImg.id
            case .video(let editableVid):
                return editableVid.id
            case .shape(let editableShp):
                return editableShp.id
            case .poll(let editablePoll):
                return editablePoll.id
            case .sticker(let editableSticker):
                return editableSticker.id
            }
        }
        
        var display: Bool {
            get {
                switch self {
                case .image(let editableImg):
                    return editableImg.display
                case .video(let editableVid):
                    return editableVid.display
                case .shape(let editableShp):
                    return editableShp.display
                case .poll(let editablePoll):
                    return editablePoll.display
                case .sticker(let editableSticker):
                    return editableSticker.display
                }
            }
            set {
                switch self {
                case .image(let editableImg):
                    editableImg.display = newValue
                case .video(let editableVid):
                    editableVid.display = newValue
                case .shape(let editableShp):
                    editableShp.display = newValue
                case .poll(let editablePoll):
                    editablePoll.display = newValue
                case .sticker(let sticker):
                    sticker.display = newValue
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
                case .shape(let editableShp):
                    return editableShp.createDisplays
                case .poll:
                    return []
                case .sticker(let sticker):
                    return sticker.createDisplays
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
                case .shape(let editableShp):
                    return editableShp.disappearDisplays
                case .poll:
                    return []
                case .sticker(let sticker):
                    return sticker.disappearDisplays
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
                case .shape(let editableShp):
                    return editableShp.soundOnClick
                case .poll:
                    return nil
                case .sticker(let sticker):
                    return sticker.soundOnClick
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
                case .shape(let editableShp):
                    return editableShp.defaultDisplaySetting
                case .poll(let editablePoll):
                    return editablePoll.defaultDisplaySetting
                case .sticker(let sticker):
                    return sticker.defaultDisplaySetting
                }
            }
        }
    }
}

class postElementsArray: ObservableObject {
    @Published var elements: [Int: postElement] = [:]
    
}
