//
//  CrumplePageView.swift
//  FireProjectSecond
//
//  Created by Kimjaekyeong on 2023/05/10.
//
import UIKit
import SwiftUI

struct CrumplePageView: View {
    @EnvironmentObject var data : MyViewModel
    @EnvironmentObject var sound : SoundManager
    
    //drag
    @State private var isDragging = false
    @State var offset: CGSize = .zero
    @State var isOnDraw: Bool = false
    @Binding var text: String
    
    
    
    var body: some View {
        
        ZStack{
            Color.clear
                
            Image("crumplePage1")
                .resizable()
                .scaledToFit()
                .frame(width: data.tapNext1 == true ? 0 : UIScreen.main.bounds.width - 4)
                .offset(x: 2, y: 30)
                .zIndex(3)
               
            
            Image("crumplePage2")
                .resizable()
                .scaledToFit()
                .frame(width: data.tapNext2 == true ? 0 : UIScreen.main.bounds.width/1.6)
                .offset(x: 2, y: 150)
                .zIndex(2)
                .opacity(data.tapNext1 == true ? 1.0 : 0.0)
            Image("crumplePage3")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width/3)
                .offset(x: 2, y: 200)
                .offset(offset)
                .scaleEffect(getScaleAmount())
                .opacity( offset.height < -200 ? 0 : 1)
                .zIndex(1)
                .gesture(
                    DragGesture()
                        .onEnded{ value in
                            data.tapNext3.toggle()
                            data.Finale = true
                            closeFinale()
                            withAnimation(.spring()){
                                offset = CGSize(width: 0, height: -201)
                                print("Finale.\(data.Finale)")
                            }
                        }
                )
            
            Text("이제 종이를 위로 스와이프해서 \n불로 던져 넣으세요.")
                .font(Font.custom("Bookk Myungjo", size: 20))
                .foregroundColor(.white)
                .offset(y: -300)
                .opacity(data.tapNext3 == true ? 1 : 0)
            //
            
            ZStack(alignment: .leading){
                VStack(alignment: .leading){
                    Text(text)
                        .font(Font.custom("BBTreeC_B", size: 25))
                        .frame(width: data.tapNext1 == true ? 0 : UIScreen.main.bounds.width - 42)
                        .offset(x: 0 ,y:-170)
                        .lineSpacing(0.3)
                        .background(Color.clear)
                }
            } .zIndex(4)
               
        }
        
       
        .onTapGesture {
            if data.tapNext1 == false {
                
                
                SoundManager.instance.playSound(sounds: .paperCrumplingSound2)
                data.tapNext1.toggle()
                offset = .zero
                HapticManager.instance.impact(style: .soft)
                
            } else if data.tapNext1 == true && data.tapNext2 == false {
                SoundManager.instance.playSound(sounds: .paperCrumplingSound3)
                data.tapNext2.toggle()
                data.tapNext3.toggle()
                HapticManager.instance.impact(style: .soft)
            } else if data.tapNext2 == true {
            }
            
        }
        
    }
    func getScaleAmount() -> CGFloat {
        let max = UIScreen.main.bounds.height / 3
        let currentAmount = abs(offset.height)
        let percentage = currentAmount / max
        return 1.0 - min(percentage, 0.5)
    }
    func closeFinale() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            data.Finale = false
            data.crumplePages = false
            data.finaleMessege = true
            print("Finale.\(data.Finale)")
        }
    }
    
}
struct CrumplePageView_Previews: PreviewProvider {
    static var previews: some View {
        CrumplePageView(text: .constant("edsacdasdasdfsadfdsafsdfae")).environmentObject(MyViewModel()).environmentObject(SoundManager())
    }
}
