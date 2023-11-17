//
//  GifSelector.swift
//  Popper
//
//  Created by Stanley Grullon on 11/16/23.
//

import SwiftUI
import GiphyUISDK
import GiphyUISDKWrapper

struct GIFController: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return GIFController.Coordinator(parent: self)
    }
    
    
    //    let giphy = GiphyViewController()
    
    @Binding var show: Bool
    @ObservedObject var sharedEditNotifier: SharedEditState
    @ObservedObject var elementsArray: editorElementsArray
    //    @Binding var mediaView: GPHMediaView
    
    func makeUIViewController(context: Context) -> GiphyViewController {
        
        let giphy = GiphyViewController()
        
        giphy.mediaTypeConfig = [.recents, .stickers, .text, .emoji]
        giphy.theme = GPHTheme(type: .lightBlur)
        giphy.stickerColumnCount = GPHStickerColumnCount.three
        GiphyViewController.trayHeightMultiplier = 1.05
        giphy.delegate = context.coordinator
        
        return giphy
    }
    
    func updateUIViewController(_ uiViewController: GiphyViewController, context: Context) {
        
    }
    
    class Coordinator : NSObject, GiphyDelegate {
        
        var parent: GIFController
        
        init(parent: GIFController) {
            self.parent = parent
        }
        
        func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia)   {
            
            // your user tapped a GIF!
            let url = media.url(rendition: .fixedWidth, fileType: .gif)
            
            if let urlToUse = url, let urlConverted = URL(string: urlToUse) {
                stickerAdd(url: urlConverted, elementsArray: parent.elementsArray, sharedEditNotifier: parent.sharedEditNotifier)
            }
            
            //                parent.mediaView.media = media
            parent.show.toggle()
        }
        
        func didDismiss(controller: GiphyViewController?) {
            // your user dismissed the controller without selecting a GIF.
        }
    }
    
}

