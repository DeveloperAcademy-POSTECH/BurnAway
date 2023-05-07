//
//  TemporaryStorageView.swift
//  FireProjectSecond
//
//  Created by Kimjaekyeong on 2023/05/09.
//

import SwiftUI

struct TemporaryStorageView: View {
    
    let userDefaults = UserDefaults.standard
    struct AnswerText: Codable, Hashable {
        var Q1: String
        var Q2: String
        var Q3: String
        var Q4: String
        var date: String
        
        init(Q1: String, Q2: String, Q3: String, Q4: String, date: String) {
            self.Q1 = Q1
            self.Q2 = Q2
            self.Q3 = Q3
            self.Q4 = Q4
            self.date = Date().formatted(date: .numeric, time: .omitted)
        }
    }
    struct TemporaryText: Codable, Hashable {
        var Q1: String
        var Q2: String
        var Q3: String
        var Q4: String
        var date: String
        
        init(Q1: String, Q2: String, Q3: String, Q4: String, date: String) {
            self.Q1 = Q1
            self.Q2 = Q2
            self.Q3 = Q3
            self.Q4 = Q4
            self.date = Date().displayFormat
        }
    }
    
    @State var answerTexts1: String = ""
    @State var answerTexts2: String = ""
    @State var answerTexts3: String = ""
    @State var answerTexts4: String = ""
    @State var TemporaryDecoded: [TemporaryText] = []
    
    var body: some View {
        
        
        
        ScrollView(showsIndicators: false){
            VStack(spacing: 15){
                    ForEach(TemporaryDecoded.reversed(), id: \.self){ item in
                        NavigationLink {
                            HStack{
                                TabView{
                                    VStack{
                                        Text("1. 지금 어떤 생각이 당신을 여기로 오게 만들었나요?")
                                            .padding(10)
                                            .font(Font.custom("Bookk Myungjo", size: 15))
                                        Spacer()
                                        Text(item.Q1)
                                            .font(Font.custom("BBTreeC_B", size: 20))
                                        Spacer()
                                    } .background(Color.black)
                                        .navigationBarTitleDisplayMode(.inline)
                                        .colorScheme(.dark)
                                        .foregroundColor(.white)
                                        .toolbar {
                                            ToolbarItem(placement: .principal) {
                                                Text(item.date)
                                                    .font(Font.custom("Bookk Myungjo", size: 15))
                                            }
                                        }
                                    VStack{
                                        Text("2. 지금 그 생각에 당신은 어떻게 반응하고 있나요?")
                                            .padding(10)
                                            .font(Font.custom("Bookk Myungjo", size: 15))
                                        Spacer()
                                        Text(item.Q2)
                                            .font(Font.custom("BBTreeC_B", size: 20))
                                        Spacer()
                                    } .background(Color.black)
                                        .navigationBarTitleDisplayMode(.inline)
                                        .colorScheme(.dark)
                                        .foregroundColor(.white)
                                        .toolbar {
                                            ToolbarItem(placement: .principal) {
                                                Text(item.date)
                                                    .font(Font.custom("Bookk Myungjo", size: 15))
                                            }
                                        }
                                    VStack{
                                        Text("3. 지금 느끼고 있는 감정이 무엇이라고 생각하나요?")
                                            .padding(10)
                                            .font(Font.custom("Bookk Myungjo", size: 15))
                                        Spacer()
                                        Text(item.Q3)
                                            .font(Font.custom("BBTreeC_B", size: 20))
                                        Spacer()
                                    } .background(Color.black)
                                        .navigationBarTitleDisplayMode(.inline)
                                        .colorScheme(.dark)
                                        .foregroundColor(.white)
                                        .toolbar {
                                            ToolbarItem(placement: .principal) {
                                                Text(item.date)
                                                    .font(Font.custom("Bookk Myungjo", size: 15))
                                            }
                                        }
                                    VStack{
                                        Text("4. 지금의 감정은 당신을 그저 통과해 가려고 합니다.")
                                            .padding(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
                                            .font(Font.custom("Bookk Myungjo", size: 15))
                                        Text("이것을 흘려보내고 싶나요?")
                                            .padding(.init(top: 0, leading: 0, bottom: 10, trailing: 0))
                                            .font(Font.custom("Bookk Myungjo", size: 15))
                                        Spacer()
                                        Text(item.Q4)
                                            .font(Font.custom("BBTreeC_B", size: 20))
                                        Spacer()
                                    } .background(Color.black)
                                        .navigationBarTitleDisplayMode(.inline)
                                        .colorScheme(.dark)
                                        .foregroundColor(.white)
                                        .toolbar {
                                            ToolbarItem(placement: .principal) {
                                                Text(item.date)  .font(Font.custom("Bookk Myungjo", size: 15))
                                            }
                                        }
                                }.tabViewStyle(.page(indexDisplayMode: .always))
                                    .background(Color.black)
                                    .edgesIgnoringSafeArea(.all)
                                    .colorScheme(.dark)
                                    .foregroundColor(.white)
                            }
                        } label: {
                            GroupBox {
                                VStack{
                                    HStack{
                                        Text(item.Q1)
                                            .padding(.init(top: 10, leading: 15, bottom: 10, trailing: 0))
                                            .font(Font.custom("BBTreeC_B", size: 20))
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                        label: {
                            VStack{
                                HStack{
                                    Text(item.date)
                                        .font(Font.custom("Bookk Myungjo", size: 15))
                                        .padding(.init(top: 10, leading: 15, bottom: 10, trailing: 0))
                                    Spacer()
                                }
                                Spacer()
                            }
                        }.groupBoxStyle(CustomGroupBox())
                            
                        }
                    }.foregroundColor(.white)
                        .navigationTitle("")
                    Spacer()
                }
            .navigationTitle("")
            }
        .background(Color.black)
        .colorScheme(.dark)
        .foregroundColor(.white)
        .navigationTitle("")
        .onAppear {
            if let TemporaryData = userDefaults.object(forKey: "Temporary") as? Data {
                let decoder = JSONDecoder()
                do {
                    let Temporarydecoded = try decoder.decode([TemporaryText].self, from: TemporaryData)
                    self.TemporaryDecoded = Temporarydecoded
                    print("decoded: \(Temporarydecoded)")
                } catch {
                    print("Error decoding history data: \(error)")
                }
            }
        }
        .background(Color.black)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct TemporaryStorageView_Previews: PreviewProvider {
    static var previews: some View {
        TemporaryStorageView()
    }
}
