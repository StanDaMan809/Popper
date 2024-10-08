//
//  textToEditableImg.swift
//  Popper
//
//  Created by Stanley Grullon on 11/18/23.
//

import SwiftUI

func textToEditableImg(text: editorText, image: UIImage) -> editorImage {
    
    var imageData = editorImage(id: text.id, imgSrc: image, size: image.size, defaultDisplaySetting: text.defaultDisplaySetting)
    
    imageData.id = text.id
    imageData.currentShape = .rectangle
    imageData.position = text.position
    imageData.scalar = text.scalar
    imageData.transparency = text.transparency
    imageData.display = text.defaultDisplaySetting
    imageData.createDisplays = text.createDisplays
    imageData.disappearDisplays = text.disappearDisplays
    imageData.rotationDegrees = text.rotationDegrees
    imageData.soundOnClick = text.soundOnClick
    
    return imageData
    
}
