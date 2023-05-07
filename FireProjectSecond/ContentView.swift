//
//  ContentView.swift
//  FireProjectSecond
//
//  Created by Kimjaekyeong on 2023/05/07.
//

import SwiftUI
import Lottie
import Combine

@MainActor class MyViewModel : ObservableObject {
    @Published var tapNext1: Bool = false
    @Published var tapNext2: Bool = false
    @Published var tapNext3: Bool = false
    @Published var crumplePages: Bool = false
    @Published var Finale: Bool = false
    @Published var finaleMessege: Bool = false
    //    @Published var answerTexts4: Binding<String> = $answerTexts4
    
    // ChangeFlameColor
    var functionCaller = PassthroughSubject<String, Never>()
    var shouldUpdateView = true
}

struct ContentView: View {
    
    @StateObject var data = MyViewModel()
    
    @State var mainControlerZStack: CGFloat = 1
    @State var mainScreenZStack: CGFloat = 0
    @State var onTap: Bool = false
    @State var tapPencilButton: Bool = false
    @State var lastAnswerText: String = ""
    @State var isHistoryLinkActive: Bool = false
    
    
    var body: some View {
        NavigationView{
            ZStack {
               
                Color.black.ignoresSafeArea()
                FireScreenView()
                    .zIndex(Double(onTap == true ? 2 : 1))
                    .ignoresSafeArea()
                    .onTapGesture{
                        if data.crumplePages == false {
                            onTap.toggle()
                        }
                    }
                //                ThrowFireScreenView(Finale: $Finale)
                //                    .zIndex(Double(Finale == true ? 4 : -1))
                
                MainControler(onTap: $onTap, tapPencilButton: $tapPencilButton, isHistoryLinkActive: $isHistoryLinkActive)
                    .zIndex(Double(onTap == true ? 1 : 2))
                    .opacity(0.8)
                    .onTapGesture{
                        if data.crumplePages == false {
                            onTap.toggle()
                        }
                    }
                QuestionPagesView(onTap: $onTap, tapPencilButton: $tapPencilButton, lastAnswerText: $lastAnswerText)
                    .zIndex(Double(tapPencilButton == true ? 3 : 0))
                
                CrumplePageView(text: $lastAnswerText)
                    .zIndex(Double(data.crumplePages == true ? 3 : 0))
               
              
            }
            .hideKeyboardWhenTappedAround()
           
        }.environmentObject(data)
            .background(Color.black)
            .ignoresSafeArea()
            
       
    }
    
}



class HapticManager {
    
    static let instance = HapticManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

