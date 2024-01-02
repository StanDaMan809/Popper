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
    @Published var selectedElement: editableElement?
    @Published var editorDisplayed = EditorDisplayed.none
    @Published var pressedButton: UIButtonPress = .noButton
    @Published var rewindButtonPresent: Bool = false
    @Published var objectsCount: Int = 0
    @Published var backgroundEdit: Bool = false
    @Published var bgObjectsCount: Int = 0
    @Published var delete: Bool = false
    @Published var trashCanFrame = CGRect.zero
    @Published var toDelete = false
    @Published var profileEdit = false
    
    init(currentlyEdited: Bool = false, buttonDim: Double = 1, disabled: Bool = false, selectedElement: editableElement? = nil, editorDisplayed: EditorDisplayed = EditorDisplayed.none, pressedButton: UIButtonPress = .noButton, rewindButtonPresent: Bool = false, objectsCount: Int = 0, backgroundEdit: Bool = false, bgObjectsCount: Int = 0, delete: Bool = false, trashCanFrame: CoreFoundation.CGRect = CGRect.zero, toDelete: Bool = false, profileEdit: Bool = false) {
        self.currentlyEdited = currentlyEdited
        self.buttonDim = buttonDim
        self.disabled = disabled
        self.selectedElement = selectedElement
        self.editorDisplayed = editorDisplayed
        self.pressedButton = pressedButton
        self.rewindButtonPresent = rewindButtonPresent
        self.objectsCount = objectsCount
        self.backgroundEdit = backgroundEdit
        self.bgObjectsCount = bgObjectsCount
        self.delete = delete
        self.trashCanFrame = trashCanFrame
        self.toDelete = toDelete
        self.profileEdit = profileEdit
    }
    
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
    
    
    func selectElement(element: editableElement) {
        selectedElement = element
        
        switch type(of: element) {
        case is editorImage.Type:
            pressedButton = .imageEdit
        case is editorVideo.Type:
            pressedButton = .imageEdit // this will be changed if i decide to implement video-specific changes later... but im not quite sure ab that
        case is editorText.Type:
            pressedButton = .textEdit
        case is editorShape.Type:
            pressedButton = .shapeEdit
        case is editorSticker.Type:
            pressedButton = .stickerEdit
        case is editorPoll.Type:
            pressedButton = .pollEdit
        default:
            pressedButton = .noButton
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
        if selectedElement is editorText {
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
