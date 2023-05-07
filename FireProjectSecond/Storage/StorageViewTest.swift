
//
//  GroupedTableView.swift
//  FireProjectSecond
//
//  Created by Kimjaekyeong on 2023/05/09.
//

import SwiftUI





struct StorageViewTest: View {
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
    
    struct StorageAnswerText: Codable, Hashable {
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
    
    @State var answerTexts1: String = ""
    @State var answerTexts2: String = ""
    @State var answerTexts3: String = ""
    @State var answerTexts4: String = ""
    @State var historyDecoded: [AnswerText] = []
    
    var body: some View {
        
        
        NavigationStack{
            ScrollView(showsIndicators: false){
                VStack{
                    Text("태운 기록")
                    Spacer()
                    VStack{
                      
                        
                        ForEach(historyDecoded.reversed(), id: \.self){ item in
                            
                            NavigationLink {
                                HStack{
                                    TabView {
                                        GroupBox {
                                            Text(item.Q1)
                                        } label: {
                                            Text("\(item.date)\n Q.1")
                                        }
                                    }
                                    TabView {
                                        GroupBox {
                                            Text(item.Q2)
                                        } label: {
                                            Text("\(item.date)\n Q.2")
                                        }
                                    }
                                    TabView {
                                        GroupBox {
                                            Text(item.Q3)
                                        } label: {
                                            Text("\(item.date)\n Q.3")
                                        }
                                    }
                                    TabView {
                                        GroupBox {
                                            Text(item.4)
                                        } label: {
                                            Text("\(item.date)\n Q.4")
                                        }
                                    }
                                } label: {
                                    GroupBox {
                                        Text(item.Q1)
                                    } label: {
                                        Text(item.date)
                                    }
                                }
                            }
                        }.foregroundColor(.white)
                        
                        Spacer()
                    }
                }}
            .background(Color.black)
            .colorScheme(.dark)
            .onAppear {
                print("happy")
                
                if let HistoryData = userDefaults.object(forKey: "History") as? Data {
                    let decoder = JSONDecoder()
                    do {
                        let decoded = try decoder.decode([AnswerText].self, from: HistoryData)
                        self.historyDecoded = decoded
                        print("decoded: \(decoded)")
                    } catch {
                        print("Error decoding history data: \(error)")
                    }
                }
            }
        }.background(Color.black)
            .colorScheme(.dark)
    }
}


struct StorageViewTest_Previews: PreviewProvider {
    static var previews: some View {
        StorageViewTest()
        
    }
}
