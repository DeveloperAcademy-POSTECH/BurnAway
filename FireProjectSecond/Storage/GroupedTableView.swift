//
//  GroupedTableView.swift
//  FireProjectSecond
//
//  Created by Kimjaekyeong on 2023/05/09.
//

import SwiftUI
import LocalAuthentication

struct GroupedTableView: View {
    
    @State private var isUnlocked = false
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    isUnlocked = true
                    print("faceid success")
                } else {
                    // there was a problem
                    isUnlocked = false
                    print("faceid failed")
                }
            }
        } else {
            // no biometrics
        }
    }
    
    var body: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            HStack{
                if isUnlocked {
                    TabView {
                        ZStack{
                            TemporaryStorageView()
                        }
                        .foregroundColor(.white)
                        .tabItem {
                            Label("임시 저장", systemImage: "trash")
                        }
                        ZStack{
                            StorageView()
                        }
                        .foregroundColor(.white)
                        .tabItem {
                            Label("태운 기록", systemImage: "flame")
                        }
                    }
                    .foregroundColor(.white)
                } else {
                    
                }
            }
        }.colorScheme(.dark)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("기록")
                        .font(Font.custom("Bookk Myungjo", size: 15))
                        .foregroundColor(.white)
                }
            }.onAppear(perform: authenticate)
    }
}

struct CustomGroupBox : GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        
        ZStack {
            VStack(alignment: .leading) {
                configuration.label
                configuration.content
            }
            }  .frame(width: UIScreen.main.bounds.width,height: 130)
            .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct GroupedTableView_Previews: PreviewProvider {
    static var previews: some View {
        GroupedTableView()
        
    }
}
