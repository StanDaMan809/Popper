//
//  SharedEditState.swift
//  Popper
//
//  Created by Stanley Grullon on 11/17/23.
//

import SwiftUI

class SharedEditState: ObservableObject {
    
    @Published var currentlyEdited: Bool = false
    @Published var buttonDim: Double = 1
    @Published var disabled: Bool = false
    @Published var selectedElement: editorElement?
    @Published var editorDisplayed = EditorDisplayed.none
    @Published var pressedButton: UIButtonPress = .noButton
    @Published var rewindButtonPresent: Bool = false
    @Published var objectsCount: Int = 0
    @Published var backgroundEdit: Bool = false
    @Published var bgObjectsCount: Int = 0
    @Published var delete: Bool = false
    @Published var trashCanFrame = CGRect.zero
    @Published var toDelete = false
    
    func editToggle()
    {
        if self.currentlyEdited
        {
            self.buttonDim = 0.4
            self.disabled = true
        }
        else
        {
            self.buttonDim = 1
            self.disabled = false
        }
    }
    
    
    func selectElement(element: editorElement) {
        selectedElement = element
        
        switch element.element {
        case .image:
            pressedButton = .imageEdit
        case .video:
            pressedButton = .imageEdit // this will be changed if i decide to implement video-specific changes later... but im not quite sure ab that
        case .text:
            pressedButton = .textEdit
        case .shape:
            pressedButton = .shapeEdit
        case .sticker:
            pressedButton = .stickerEdit
        case .poll:
            pressedButton = .pollEdit
        }
    }
    
    func restoreDefaults() { // For when you need to make sure that everything is fine
        deselectAll()
        editorDisplayed = .none
        pressedButton = .noButton
    }
    
    func deselectAll() {
        selectedElement = nil
    }
    
    func textEdited() -> Bool {
        if case .text = selectedElement?.element {
            return true
        } else {
            return false
        }
    }
    
    
    enum EditorDisplayed: Int {
        
        case none
        case linkEditor
        case transparencySlider
        case photoAppear
        case elementDisappear
        case colorPickerText
        case colorPickerTextBG
        case colorPickerShape
        case colorPickerPollTop
        case colorPickerPollBG
        case colorPickerPollButton
        case fontPicker
        case voiceRecorder
    }
    
    enum UIButtonPress {
        
        case noButton
        case imageEdit
        case bgButton
        case extrasButton
        case disappeared
        case textEdit
        case shapeEdit
        case stickerEdit
        case pollEdit
        case elementAppear
        
    }
}
