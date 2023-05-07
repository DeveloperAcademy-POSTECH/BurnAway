//
//  SwiftUIView.swift
//  FireProjectSecond
//
//  Created by Kimjaekyeong on 2023/05/16.
//
import SwiftUI

struct CustomTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedTab) {
                Text("Tab 1").tag(0)
                Text("Tab 2").tag(1)
                Text("Tab 3").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            Spacer()
            
            if selectedTab == 0 {
                Text("Content 1")
            } else if selectedTab == 1 {
                Text("Content 2")
            } else if selectedTab == 2 {
                Text("Content 3")
            }
            
            Spacer()
        }
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
    }
}
