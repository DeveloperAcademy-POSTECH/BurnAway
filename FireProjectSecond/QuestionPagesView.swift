//
//  QuestionPagesView.swift
//  FireProjectSecond
//
//  Created by Kimjaekyeong on 2023/05/07.
//

import SwiftUI
import Foundation


//MainView
struct QuestionPagesView: View {
    @EnvironmentObject var data : MyViewModel
    
    let font1 = UIFont(name: "GuideFont", size: 16)
    let font2 = UIFont(name: "AnswerFont", size: 16)
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
            self.date = Date().displayFormat
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
            //self.date = Date().formatted(date: .numeric, time: .omitted)
            self.date = Date().displayFormat
        }
    }
    @State var answerTexts1: String = ""
    @State var answerTexts2: String = ""
    @State var answerTexts3: String = ""
    @State var answerTexts4: String = ""
    @State var checkButton: Bool = false
    @State var backButton: Bool = false
    @State private var selectedTab = 0
    @Binding var onTap: Bool
    @Binding var tapPencilButton: Bool
    @Binding var lastAnswerText: String
    
    init(onTap: Binding<Bool> = .constant(false),
         tapPencilButton: Binding<Bool> = .constant(false),
         lastAnswerText:  Binding<String> = .constant("")
    ) {
        _onTap = onTap
        _tapPencilButton = tapPencilButton
        _lastAnswerText = lastAnswerText
    }
    
    var body: some View {
        let userDefaults = UserDefaults.standard
        
        GeometryReader { proxy  in
            VStack(alignment: .center){
                HStack{
                    Button {
                        let answerText = TemporaryText(Q1: answerTexts1, Q2: answerTexts2, Q3: answerTexts3, Q4: answerTexts4, date: Date().displayFormat)
                        var Temporary = [TemporaryText]()
                        
                        if let TemporaryData = userDefaults.object(forKey: "Temporary") as? Data {
                            let decoder = JSONDecoder()
                            do {
                                // 디코딩된 값은 decoded 변수에 저장됩니다.
                                let decoded = try decoder.decode([TemporaryText].self, from: TemporaryData)
                                Temporary = decoded
                                // 새로운 값을 history 배열에 추가합니다.
                                Temporary.append(answerText)
                                print("decoded: \(Temporary)")
                            } catch {
                                print("Error decoding history data: \(error)")
                            }
                        }
                        let encoder = JSONEncoder()
                        var encodedData: Data?
                        do {
                            if answerTexts1 == "" && answerTexts2 == "" && answerTexts3 == "" && answerTexts4 == "" {
                                print("noText")
                            } else {
                                encodedData = try encoder.encode(Temporary)}
                        } catch {
                            print("Error encoding history data: \(error)")
                        }
                        if let data = encodedData {
                            userDefaults.set(data, forKey: "Temporary")
                        } else {
                            print("Error encoding history data: encodedData is nil")
                        }
                        print("set \(Temporary)")
                        
                        backButton = true
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                            .padding(.init(top: 50, leading: 20, bottom: 0, trailing: 5))
                            .foregroundColor(.white)
                            
                    }.alert(isPresented:$backButton) {
                        Alert(
                            title: Text("이 페이지를 나가시겠어요?"),
                            message: Text("작성된 내용은 임시저장 됩니다"),
                            primaryButton: .default(Text("나가기").foregroundColor(.white)) {
                                tapPencilButton.toggle()
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            },
                            secondaryButton: .cancel(Text("취소"))
                        )
                    }
                    Spacer()
                    
                    //Storage Save Button
                    Button {
                        let answerText = AnswerText(Q1: answerTexts1, Q2: answerTexts2, Q3: answerTexts3, Q4: answerTexts4, date: Date().displayFormat)
                        var History = [AnswerText]()
                        
                        if let HistoryData = userDefaults.object(forKey: "History") as? Data {
                            let decoder = JSONDecoder()
                            do {
                                let decoded = try decoder.decode([AnswerText].self, from: HistoryData)
                                History = decoded
                                History.append(answerText)
                                print("decoded: \(decoded)")
                            } catch {
                                print("Error decoding history data: \(error)")
                            }
                        }
                        History.append(answerText)
                        let encoder = JSONEncoder()
                        var encodedData: Data?
                        do {
                            if answerTexts1 == "" && answerTexts2 == "" && answerTexts3 == "" && answerTexts4 == "" {
                                print("noText")
                            } else {
                                encodedData = try encoder.encode(History)}
                        } catch {
                            print("Error encoding history data: \(error)")
                        }
                        if let data = encodedData {
                            userDefaults.set(data, forKey: "History")
                        } else {
                            print("Error encoding history data: encodedData is nil")
                        }
                        print("set \(History)")
                        
                        data.crumplePages = false
                        checkButton = true
                    } label: {
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                          //  .frame(width: selectedTab == 3 ? 26 : 0)
                            .frame(width: 26)
                            .padding(.init(top: 50, leading: 0, bottom: 0, trailing: 20))
                            .foregroundColor(.white)
                            .opacity(selectedTab == 3 ? 0.8 : 0)
                            
                    }.alert(isPresented:$checkButton) {
                        Alert(
                            title: Text("모두 작성완료 하셨나요?"),
                            message: Text(""),
                            primaryButton: .default(Text("네").foregroundColor(.white)) {
                                //태우기 넘어가기 버튼
                                
                                SoundManager.instance.playSound(sounds: .paperCrumplingSound1)
                                onTap = true
                                tapPencilButton = false
                                data.crumplePages = true
                                lastAnswerText = answerTexts4
                                data.tapNext1 = false
                                data.tapNext2 = false
                                data.tapNext3 = false
                                answerTexts1 = ""
                                answerTexts2 = ""
                                answerTexts3 = ""
                                answerTexts4 = ""
                                HapticManager.instance.impact(style: .soft)
                               
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                
                                if data.crumplePages == true {
                                    print("crumplePages True")
                                }
                                else{ print("nothing")}
                            },
                            secondaryButton: .cancel(Text("아니요"))
                        )
                    }
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                HStack(alignment: .center) {
                             ForEach(0..<4) { index in
                                 Circle()
                                     .frame(width: 8, height: 8)
                                     .foregroundColor(index == selectedTab ? .white : .gray)
                             }
                         }
                HStack{
                    TabView(selection: $selectedTab) {
                        ZStack{
                            VStack{
                                Spacer()
                                Text("1. 지금 어떤 생각이 당신을 여기로 오게 만들었나요?")
                                    .font(Font.custom("Bookk Myungjo", size: 15))
                                    .foregroundColor(.white)
                                Spacer()
                                Image("noteImage")
                                    .resizable()
                                    .scaledToFit()
                                //   .frame(width: proxy.size.width - proxy.size.width/10, height: proxy.size.height - proxy.size.height/2.5)
                                    .edgesIgnoringSafeArea(.all)
                                Spacer()
                                Spacer()
                            }
                            TextEditor(text: $answerTexts1)
                                .font(Font.custom("BBTreeC_B", size: 25))
                                .frame(width: proxy.size.width - proxy.size.width/10, height: proxy.size.height - proxy.size.height/2)
                                .lineSpacing(0.3)
                                .background(Color.clear)
                                .scrollContentBackground(.hidden)
                                .frame(width: UIScreen.main.bounds.width)
                        }.tag(0)
                            .opacity(selectedTab  == 0 ? 1.0 : 0.3).animation(.easeIn(duration: 0.4))
                            
                        ZStack{
                            VStack{
                                Spacer()
                                Text("2. 지금 그 생각에 당신은 어떻게 반응하고 있나요?")
                                    .font(Font.custom("Bookk Myungjo", size: 15))
                                    .foregroundColor(.white)
                                Spacer()
                                Image("noteImage")
                                    .resizable()
                                    .scaledToFit()
                                //   .frame(width: proxy.size.width - proxy.size.width/10, height: proxy.size.height - proxy.size.height/2.5)
                                    .edgesIgnoringSafeArea(.all)
                                Spacer()
                                Spacer()
                            }
                            TextEditor(text: $answerTexts2)
                                .font(Font.custom("BBTreeC_B", size: 25))
                                .frame(width: proxy.size.width - proxy.size.width/10, height: proxy.size.height - proxy.size.height/2)
                                .lineSpacing(0.3)
                                .background(Color.clear)
                                .scrollContentBackground(.hidden)
                                .frame(width: UIScreen.main.bounds.width)
                        }.tag(1)
                            .opacity(selectedTab  == 1 ? 1.0 : 0.2).animation(.easeIn(duration: 0.4))
                        ZStack{
                            VStack{
                                Spacer()
                                Text("3. 지금 느끼고 있는 감정이 무엇이라고 생각하나요?")
                                    .font(Font.custom("Bookk Myungjo", size: 15))
                                    .foregroundColor(.white)
                                Spacer()
                                Image("noteImage")
                                    .resizable()
                                    .scaledToFit()
                                //   .frame(width: proxy.size.width - proxy.size.width/10, height: proxy.size.height - proxy.size.height/2.5)
                                    .edgesIgnoringSafeArea(.all)
                                Spacer()
                                Spacer()
                            }
                            TextEditor(text: $answerTexts3)
                                .font(Font.custom("BBTreeC_B", size: 25))
                                .frame(width: proxy.size.width - proxy.size.width/10, height: proxy.size.height - proxy.size.height/2)
                                .lineSpacing(0.3)
                                .background(Color.clear)
                                .scrollContentBackground(.hidden)
                                .frame(width: UIScreen.main.bounds.width)
                        }.tag(2)
                            .opacity(selectedTab  == 2 ? 1.0 : 0.2).animation(.easeIn(duration: 0.4))
                        ZStack{
                            VStack{
                                Spacer()
                                Text("4. 지금의 감정은 당신을 그저 통과해 가려고 합니다.")
                                    .font(Font.custom("Bookk Myungjo", size: 15))
                                    .foregroundColor(.white)
                                    .padding(.init(top: 0, leading: 0, bottom: 3, trailing: 0))
                                Text("이것을 흘려보내고 싶나요?")
                                    .font(Font.custom("Bookk Myungjo", size: 15))
                                    .foregroundColor(.white)
//                                Spacer()
                                Image("noteImage")
                                    .resizable()
                                    .scaledToFit()
                                //   .frame(width: proxy.size.width - proxy.size.width/10, height: proxy.size.height - proxy.size.height/2.5)
                                    .edgesIgnoringSafeArea(.all)
                                Spacer()
                                Spacer()
                            }
                            TextEditor(text: $answerTexts4)
                                .font(Font.custom("BBTreeC_B", size: 25))
                                .frame(width: proxy.size.width - proxy.size.width/10, height: proxy.size.height - proxy.size.height/2)
                                .lineSpacing(0.3)
                                .background(Color.clear)
                                .scrollContentBackground(.hidden)
                                .frame(width: UIScreen.main.bounds.width)
                        }.tag(3)
                            .opacity(selectedTab  == 3 ? 1.0 : 0.2).animation(.easeIn(duration: 0.4))
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                  
                        .opacity(0.7)
                }
            }
           
        }
        .edgesIgnoringSafeArea(.all)
        .hideKeyboardWhenTappedAround()
    }
    
}

extension Date {
    var displayFormat: String {
        self.formatted(
            .dateTime
                .year(.twoDigits)
                .month(.twoDigits)
                .day(.twoDigits)
        )
    }
}
extension View {
    func hideKeyboardWhenTappedAround() -> some View {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}


struct QuestionPagesView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(MyViewModel())
    }
}

