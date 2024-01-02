//
//  Profile.swift
//  Popper
//
//  Created by Stanley Grullon on 11/24/23.
//

import SwiftUI
import WrappingHStack
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SDWebImageSwiftUI

struct customProfileView: View {
    var profile: Profile
    @State var draggedItem: profileElementClass?
    @Binding var displayPost: Bool
    @Binding var postToDisplay: Post?
    @Binding var profileElementsArray: [profileElement]
    @Binding var classElementsArray: [profileElementClass]
    @Binding var profileEdit: Bool
    @Binding var selectedElement: profileElementClass?
    let userUID: String
    
    var body: some View {
        
        NavigationStack {
            WrappingHStack(alignment: .center, horizontalSpacing: 5, verticalSpacing: 5, fitContentWidth: true) {
                ForEach(classElementsArray) { element in
                    if element.pinned {
                        ProfileElementView(parent: self, element: element)
                        
                    }
                }
                
                
                
                ForEach(classElementsArray) { element in
                    if !element.pinned {
                        Group {
                            switch element.redirect {
                            case .post(let postID):
                                if postID != "" {
                                    NavigationLink {
                                        wrappedPostDisplay(postID: postID)
                                    } label: {
                                        ProfileElementView(parent: self, element: element)
                                    }
                                } else {
                                    ProfileElementView(parent: self, element: element)
                                }
                                
                            case .profile(let profileID):
                                
                                Text("Stop")
                                
                            case .website(let profileID):
                                
                                Text("Stop")
                            }
                        }
                        .onDrag {
                            if profileEdit {
                                self.draggedItem = element
                            }
                            return NSItemProvider()
                        }
                        .onDrop(of: [.text],
                                delegate: DropViewDelegate(destinationItem: element, elements: $classElementsArray, draggedItem: $draggedItem)
                        )
                    }
                }
            }
        }
        
        //        .fullScreenCover(isPresented: $displayPost, content: {
        //                wrappedPostDisplay(postToDisplay: $postToDisplay, displayPost: $displayPost)
        //        })
        
        .task {
            if classElementsArray == [] {
                await downloadElements(userUID: userUID, sortedElementArray: &classElementsArray)
            }
        }
        
        .onChange(of: profileEdit) { _ in
            if profileEdit == false {
                selectedElement = nil
            }
            
            for element in classElementsArray {
                
                if element.changed, let elementID = element.id {
                    let userDocRef = Firestore.firestore().collection("Users").document(userUID).collection("elements").document(elementID)
                    let elementForUpload = profileElement(from: element)
                    
                    do {
                        try userDocRef.setData(from: elementForUpload)
                        element.changed = false
                    } catch {
                        print("Error uploading data")
                    }
                    
                    
                }
            }
            
            let userDocRef = Firestore.firestore().collection("Users").document(userUID)
            
            do {
                userDocRef.getDocument { (document, error) in
                    if let error = error {
                        print("Error getting user document: \(error)")
                        return
                    }
                    
                    guard let document = document, document.exists else {
                        print("User document does not exist")
                        return
                    }
                    
                    if let data = document.data(), let profileHead = data["profile"] as? [String : Any], let head = profileHead["head"] as? String, classElementsArray.indices.contains(0), head != classElementsArray[0].id {
                        
                        // Setting head to the first value if it's not the same as the regular one
                        
                        Firestore.firestore().collection("Users").document(userUID).setData(["profile" : ["head" : classElementsArray[0].id]], merge: true)
                        
                        print(classElementsArray[0].id ?? "")
                        
                        
                    } else {
                        print("Error retrieving profile.head")
                    }
                }
            }
            
        }
    }
    
    
    struct DropViewDelegate: DropDelegate {
        
        let destinationItem: profileElementClass
        @Binding var elements: [profileElementClass]
        @Binding var draggedItem: profileElementClass?
        
        func dropUpdated(info: DropInfo) -> DropProposal? {
            return DropProposal(operation: .move)
        }
        
        func performDrop(info: DropInfo) -> Bool {
            
            
            
            draggedItem = nil
            return true
        }
        
        func dropEntered(info: DropInfo) {
            // Swap Items
            if let draggedItem {
                let fromIndex = elements.firstIndex(of: draggedItem)
                if let fromIndex {
                    let toIndex = elements.firstIndex(of: destinationItem)
                    if let toIndex, fromIndex != toIndex {
                        withAnimation {
                            
                            // Updating the elements that were at the initial location of the drop
                            
                            if elements.indices.contains(fromIndex + 1) && elements.indices.contains(fromIndex - 1) {
                                // make previous item.next = current next item
                                // make next item.previous = current previous item
                                
                                elements[fromIndex - 1].next = draggedItem.next
                                
                                elements[fromIndex + 1].previous = draggedItem.previous
                                
                                elements[fromIndex - 1].changed = true
                                elements[fromIndex + 1].changed = true
                                
                                
                            } else if elements.indices.contains(fromIndex + 1) {
                                // make next item previous = nil
                                // designate as head
                                
                                elements[fromIndex + 1].previous = nil
                                elements[fromIndex + 1].changed = true
                                
                                // Needs designation as head
                                
                            } else if elements.indices.contains(fromIndex - 1) {
                                // make previous item next = nil
                                
                                elements[fromIndex - 1].next = nil
                                elements[fromIndex - 1].changed = true
                            }
                            
                            self.elements.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                            
                            draggedItem.changed = true
                            
                            // Changing the elements currently at the drop location
                            
                            // Previous one gets updated on the right side
                            
                            // This one gets updated on both sides
                            
                            // Next one gets updated on the left side
                            
                            if elements.indices.contains(toIndex + 1) {
                                
                                elements[toIndex].next = elements[toIndex + 1].id
                                elements[toIndex + 1].previous = elements[toIndex].id
                                
                                elements[toIndex + 1].changed = true
                                elements[toIndex].changed = true
                                
                            }
                            
                            if elements.indices.contains(toIndex - 1) {
                                elements[toIndex - 1].next = elements[toIndex].id
                                elements[toIndex].previous = elements[toIndex - 1].id
                                
                                
                                elements[toIndex - 1].changed = true
                                elements[toIndex].changed = true
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    
    func downloadElements(userUID: String, sortedElementArray: inout [profileElementClass])async {
        
        
        
        let userDocRef = Firestore.firestore().collection("Users").document(userUID)
        var node: String?
        var presortedElementArray: [profileElement] = []
        
        
        
        do {
            userDocRef.getDocument { (document, error) in
                if let error = error {
                    print("Error getting user document: \(error)")
                    return
                }
                
                guard let document = document, document.exists else {
                    print("User document does not exist")
                    return
                }
                
                if let data = document.data(), let profileHead = data["profile"] as? [String : Any], let head = profileHead["head"] as? String {
                    
                    print(head)
                    node = head
                    
                    
                } else {
                    print("Error retrieving profile.head")
                }
            }
            
            print(node ?? "")
            
            let elementsRef = try await userDocRef.collection("elements").getDocuments()
            //
            //            while node != nil {
            //                elementsRef.document(node!).compactMap { doc -> profileElement }
            //            }
            
            let fetchedElements = elementsRef.documents.compactMap { doc -> profileElement? in
                try? doc.data(as: profileElement.self)
                
            }
            
            presortedElementArray.append(contentsOf: fetchedElements)
            
            print(presortedElementArray.count)
            
            
            // Linked list algorithm to generate elements in their proper order
            
            while node != nil {
                for element in presortedElementArray {
                    if node == element.id {
                        sortedElementArray.append(profileElementClass(from: element))
                        node = element.next
                    }
                }
            }
            
            print(sortedElementArray.count)
            
            
            
            // while node != nil
            // var node = profileHead
            // append node to the thing
            // node = node.next else node = nil
            
            
            
        }
        catch {
            print("Error")
        }
    }
    
}


func sizeify(element: profileElementClass) -> CGSize {
    
    let spacingWidth: CGFloat = 5.0
    var width: CGFloat = UIScreen.main.bounds.width - (spacingWidth * 2)
    var height: CGFloat = UIScreen.main.bounds.width - (spacingWidth * 2)
    
    // THESE FORMULAS WERE GEOMETRICALLY CALCULATED, OKAY! IM A WIZ!!
    
    if 1 <= element.width, element.width <= 8 {
        switch element.width {
        case 1:
            width = UIScreen.main.bounds.width - (spacingWidth * 2) // Whole row
        case 2:
            width = UIScreen.main.bounds.width - (spacingWidth * 3) - ((UIScreen.main.bounds.width - (spacingWidth * 6)) / 5) // Takes up 4/5 of the row, meant to fit with a size 8
        case 3:
            width = UIScreen.main.bounds.width - (spacingWidth * 3) - ((UIScreen.main.bounds.width - (spacingWidth * 5)) / 4) // Takes up 3/4 of the row, meant to fit with a size 7
        case 4:
            width = UIScreen.main.bounds.width - (spacingWidth * 3) - ((UIScreen.main.bounds.width - (spacingWidth * 4)) / 3) // Takes up 1/3 of the row, meant to fit with a size 6
        case 5:
            width = (UIScreen.main.bounds.width - (spacingWidth * 3)) / 2 // Takes up 1/2 of the row
        case 6:
            width = (UIScreen.main.bounds.width - (spacingWidth * 4)) / 3 // Takes up 1/3rd of the row
        case 7:
            width = (UIScreen.main.bounds.width - (spacingWidth * 5)) / 4 // Takes up 1/4 of the row
        case 8:
            width = (UIScreen.main.bounds.width - (spacingWidth * 6)) / 5 // Takes up 1/5 of the row
        default:
            width = UIScreen.main.bounds.width - (spacingWidth * 2)
        }
    } else {
        width = (UIScreen.main.bounds.width - (spacingWidth * 4)) / 3
    }
    
    if 1 <= element.height, element.height <= 8 {
        switch element.height {
        case 1:
            height = UIScreen.main.bounds.width - (spacingWidth * 2) // Whole row
        case 2:
            height = UIScreen.main.bounds.width - (spacingWidth * 3) - ((UIScreen.main.bounds.width - (spacingWidth * 6)) / 5) // Takes up 4/5 of the row, meant to fit with a size 8
        case 3:
            height = UIScreen.main.bounds.width - (spacingWidth * 3) - ((UIScreen.main.bounds.width - (spacingWidth * 5)) / 4) // Takes up 3/4 of the row, meant to fit with a size 7
        case 4:
            height = UIScreen.main.bounds.width - (spacingWidth * 3) - ((UIScreen.main.bounds.width - (spacingWidth * 4)) / 3) // Takes up 1/3 of the row, meant to fit with a size 6
        case 5:
            height = (UIScreen.main.bounds.width - (spacingWidth * 3)) / 2 // Takes up 1/2 of the row
        case 6:
            height = (UIScreen.main.bounds.width - (spacingWidth * 4)) / 3 // Takes up 1/3rd of the row
        case 7:
            height = (UIScreen.main.bounds.width - (spacingWidth * 5)) / 4 // Takes up 1/4 of the row
        case 8:
            height = (UIScreen.main.bounds.width - (spacingWidth * 6)) / 5 // Takes up 1/5 of the row
        default:
            width = UIScreen.main.bounds.width - (spacingWidth * 2)
        }
    }
    
    return CGSize(width: width, height: height)
    
    
}

struct Profile: Codable, Equatable, Hashable {
    
    var head: String?
    var elements: [profileElement] = []
    var background: URL?
    var song: URL?
    
    enum CodingKeys: CodingKey {
        case elements
        case background
        case song
    }
    
}

func downloadPost(postID: String)async -> Post? {
    do {
        let doc = try await Firestore.firestore().collection("Posts").document(postID).getDocument()
        
        let fetchedPost = try doc.data(as: Post.self)
        
        return fetchedPost
        
        
    } catch {
        print(error.localizedDescription)
        
        return nil
    }
}

struct wrappedPostDisplay: View {
    let postID: String
    @State var isLoading: Bool = true
    @State var postToRedirect: Post?
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                VStack {
                    if let post = postToRedirect {
                        PostCardView(post: post, onUpdate: {updatedPost in }, onDelete: { })
                    }
                    
                    Spacer()
                }
            }
        }
        .task {
            postToRedirect = await downloadPost(postID: postID)
            
            if let post = postToRedirect {
                isLoading = false
            }
        }
        .onAppear {
            print("hey")
        }
        
        .gesture(
            DragGesture()
                .onChanged { value in
                    // Detect rightward swipe
                    if value.translation.width >= 50 {
                        //                            displayPost = false
                    }
                }
                .onEnded { value in
                    // Reset the offset after the drag ends
                    //                                    offset = .zero
                    
                    // Execute code when rightward swipe is detected
                    if value.translation.width > 50 {
                        print("Rightward swipe detected! Execute your code here.")
                    }
                }
        )
    }
}


