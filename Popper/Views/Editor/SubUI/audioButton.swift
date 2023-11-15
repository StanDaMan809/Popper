//
//  audioButton.swift
//  Popper
//
//  Created by Stanley Grullon on 11/14/23.
//

import SwiftUI
import AVFAudio
import AVFoundation

struct audioButton: View {
    
    @ObservedObject var sharedEditNotifier: SharedEditState
    var recordButton: UIButton!
    @State private var isRecording = false
    @State var recordingSession: AVAudioSession!
    @State var audioRecorder: AVAudioRecorder!
    @State var audioURL: URL?
    @State private var recordingTimer: Timer?
    
    
    var body: some View {
            VStack {
                if let _ = audioURL {
                    AudioPlayerView(sharedEditNotifier: sharedEditNotifier, audioURL: $audioURL)
                } else {
                    Button(action: {
                        if isRecording {
                            stopRecording()
                        } else {
                            startRecording()
                            startRecordingTimer()
                        }
                    }) {
                        Image(systemName: "mic.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .foregroundStyle(isRecording ? Color.red : Color.black)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .onAppear(perform: setupRecorder)
        }

        func setupRecorder() {
            let audioSession = AVAudioSession.sharedInstance()

            do {
                try audioSession.setCategory(.playAndRecord, mode: .default)
                try audioSession.setActive(true)

                let basePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let audioURL = basePath.appendingPathComponent("audioRecording.wav")

                let settings: [String: Any] = [
                    AVFormatIDKey: kAudioFormatLinearPCM,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
                    AVEncoderBitRateKey: 320000,
                    AVNumberOfChannelsKey: 2,
                    AVSampleRateKey: 44100.0
                ]

                audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
                
                audioRecorder.prepareToRecord()
            } catch {
                print("Error setting up audio recording: \(error.localizedDescription)")
            }
        }

        func startRecording() {
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                audioRecorder.record()
                isRecording = true
            } catch {
                print("Error starting audio recording: \(error.localizedDescription)")
            }
        }

        func stopRecording() {
            audioRecorder.stop()
            isRecording = false
            audioURL = audioRecorder.url
            
            
        }
    
    func startRecordingTimer() {
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            stopRecording()
        }
    }
}

struct AudioPlayerView: View {
    @ObservedObject var sharedEditNotifier: SharedEditState
    @Binding var audioURL: URL?
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        HStack(alignment: .center) {
            
            Button(action: {
                audioURL = nil
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundStyle(Color.black)
                    .frame(width: 25, height: 25)
                    .padding()
            }
            
            Button(action: {
                do {
                    if let audioURL = audioURL {
                        audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                        audioPlayer?.play()
                    }
                } catch {
                    print("Error playing audio: \(error.localizedDescription)")
                }
            }) {
                Image(systemName: "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundStyle(Color.black)
                    .frame(width: 50, height: 50)
                    .padding()
            }
            
            Button(action: {
                if let audioURL = audioURL {
                    sharedEditNotifier.selectedElement?.element.soundOnClick = audioURL
                    sharedEditNotifier.editorDisplayed = .none
                }
            }) {
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundStyle(Color.black)
                    .frame(width: 25, height: 25)
                    .padding()
            }
            
        }
        .background(Color.clear)
    }
}
