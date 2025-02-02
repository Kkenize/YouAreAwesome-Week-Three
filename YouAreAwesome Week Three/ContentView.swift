//
//  ContentView.swift
//  YouAreAwesome
//
//  Created by Zhejun Zhang on 2/1/25.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var imageName = ""
    @State private var imageRandomer = 0
    @State private var lastImageRandomer = -1
    @State private var messageString = ""
    @State private var messageRandomer = 0
    @State private var lastMessageRandomer = -1
    @State private var imageCount = 0
    @State private var messageCount = 0
    @State private var audioPlayer: AVAudioPlayer!
    @State private var soundName = ""
    @State private var soundRandomer = 0
    @State private var lastSoundRandomer = -1
    @State private var soundOn = true
    
    func playSound(soundName: String) {
        if audioPlayer != nil && audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("Can't find \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("\(error.localizedDescription)")
            return
        }
    }
    
    func generateRandomNumber(max: Int, lastValue: Int) -> Int {
        var returnValue = -1
        repeat {
            returnValue = Int.random(in: 0...max-1)
        } while lastValue == returnValue
        return returnValue
    }
    
    var body: some View {
        
        let messages = ["You are awesome!", "You are great!", "You are amazing!", "You are incredible!", "You are fantastic!", "You are perfect!", "You are the best!", "You are the GOAT!", "You are dazzling!"]
        let numberOfImages = 9
        
        VStack {
            
            Text(messageString)
                .bold()
                .font(.largeTitle)
                .foregroundStyle(.yellow)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .animation(.easeInOut(duration: 0.15), value: messageString)
                .frame(height: 100)
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .animation(.default, value: imageName)
                .shadow(radius: 50)
            
            Spacer()
            
            HStack {
                Text("Sound On:")
                Toggle("", isOn: $soundOn)
                    .labelsHidden()
                    .onChange(of: soundOn){
                        if audioPlayer != nil && audioPlayer.isPlaying {
                            audioPlayer.stop()
                        }
                    }
                
                Spacer()
                
                Button("Show Message") {
                    messageRandomer = generateRandomNumber(max: messages.count, lastValue: lastMessageRandomer)
                    messageString = messages[messageRandomer]
                    lastMessageRandomer = messageRandomer
                    
                    imageRandomer = generateRandomNumber(max: numberOfImages, lastValue: lastImageRandomer)
                    imageName = "image\(imageRandomer)"
                    lastImageRandomer = imageRandomer
                    
                    soundRandomer = generateRandomNumber(max: 5, lastValue: lastSoundRandomer)
                    soundName = "sound\(soundRandomer)"
                    lastSoundRandomer = soundRandomer
                    if soundOn {
                        playSound(soundName: soundName)
                    }
                    
                }
                .buttonStyle(.borderedProminent)
                .bold()
                .font(.title2)
            }
            .tint(.accentColor)
        }
        .padding()
    }
}


#Preview("Light Mode") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}
