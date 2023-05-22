//
//  MainControler.swift
//  FireProjectSecond
//
//  Created by Kimjaekyeong on 2023/05/07.
//

import SwiftUI

struct MainController: View {
    @EnvironmentObject var data: MyViewModel
    @Binding var onTap: Bool
    @Binding var tapPencilButton: Bool
    @Binding var isHistoryLinkActive: Bool 
    @State var showHistoryAlert: Bool = false

    var body: some View {
        VStack {
            HStack {
                NavigationLink(
                    destination: GroupedTableView(),
                    isActive: $isHistoryLinkActive,
                    label: {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .scaledToFit()
                            .frame(width: onTap ? 0 : 40, height: tapPencilButton ? 0 : 40)
                            .padding(.init(top: -10, leading: 20, bottom: 0, trailing: 20))
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 2)
                            .onTapGesture {
                                showHistoryAlert.toggle()
                            }
                    })
                .navigationTitle("")
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    tapPencilButton.toggle()
                    data.crumplePages = false
                    data.tapNext1 = false
                    data.tapNext2 = false
                    data.tapNext3 = false
                    print(data.tapNext1.description)
                }, label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: onTap ? 0 : 40, height: tapPencilButton ? 0 : 40)
                        .padding(20)
                        .padding(.bottom, 30)
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 2)
                })
            }
        }
        .alert(isPresented: $showHistoryAlert, content: {
            Alert(
                title: Text("기록 페이지로 이동합니다"),
                message: Text("흘려보낸 감정을 다시 마주할 준비가 되셨나요?"),
                primaryButton: .default(Text("네")) {
                    isHistoryLinkActive = true
                },
                secondaryButton: .cancel(Text("아니요"))
            )
        })
    }
}

struct MainControler_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(MyViewModel())
    }
}
