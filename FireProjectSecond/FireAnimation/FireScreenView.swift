
import SwiftUI
import AVKit
import Lottie
// ChangeFlameColor
import Combine

struct LottieView: UIViewRepresentable {
    
    @EnvironmentObject var data : MyViewModel
    @State var name : String
    @State var loopMode: LottieLoopMode
    // ChangeFlameColor
    @State private var animationView: LottieAnimationView
    
    enum Mode {
        case aurora, throwPaper
    }
    @State var mode: Mode = .aurora
    
    init(jsonName: String = "", loopMode : LottieLoopMode = .loop, mode: Mode = .aurora){
        self.name = jsonName
        self.loopMode = loopMode
        // ChangeFlameColor
        self.animationView = LottieAnimationView()
        self.mode = mode
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        // ChangeFlameColor
        let view = UIView(frame: .zero)
        // animationView = LottieAnimationView()
        // let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(name, bundle: Bundle.main)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        // switch mode {
        // case .aurora:
        //     self.animationView = animationView
        // case .throwPaper:
        //     self.throwAnimationView = animationView
        // }
        return view
    }
    
    private func modifyAnimationView(mode: Mode) {
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //        if let animationView = uiView.subviews.first as? LottieAnimationView {
        //            if data.Finale {
        //                animationView.stop()
        //                animationView.animation = LottieAnimation.named("comp3", bundle: Bundle.main)
        //                animationView.loopMode = .playOnce
        //                print("@Log Lottie update comp3")
        //                animationView.play(completion: { _ in
        //                    animationView.animation = LottieAnimation.named("comp1", bundle: Bundle.main)
        //                    animationView.loopMode = .loop
        //                    animationView.play()
        //                    print("@Log Lottie uptate comp1")
        //                })
        //            } else {
        //                animationView.loopMode = .loop
        //                animationView.play()
        //            }
        //        } else {
        //            let animationView = LottieAnimationView()
        //            let animation = LottieAnimation.named(name, bundle: Bundle.main)
        //            animationView.animation = animation
        //            animationView.contentMode = .scaleAspectFit
        //            animationView.backgroundBehavior = .pauseAndRestore
        //            animationView.translatesAutoresizingMaskIntoConstraints = false
        //            uiView.addSubview(animationView)
        //            NSLayoutConstraint.activate([
        //                animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor),
        //                animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor)
        //            ])
        ////            if data.Finale {
        ////                animationView.stop()
        ////                animationView.animation = LottieAnimation.named("comp3", bundle: Bundle.main)
        ////                animationView.loopMode = .playOnce
        ////                animationView.play(completion: { _ in
        ////                    animationView.animation = LottieAnimation.named("comp1", bundle: Bundle.main)
        ////                    animationView.loopMode = .loop
        ////                    animationView.play()
        ////                })
        ////            } else {
        ////                animationView.loopMode = .loop
        ////                animationView.play()
        ////            }
        //        }
        
        guard data.shouldUpdateView else {
            data.shouldUpdateView = false
            return
        }
        
        context.coordinator.tieFunctionCaller(data: data)
        context.coordinator.animationView = animationView
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parentLottieView: LottieView
        var animationView: LottieAnimationView? = nil
        
        private var cancellable: AnyCancellable?
        
        init(_ parentLottieView: LottieView) {
            self.parentLottieView = parentLottieView
            super.init()
        }
        
        @MainActor func tieFunctionCaller(data: MyViewModel) {
            cancellable = data.functionCaller.sink(receiveValue: { jsonName in
                print(jsonName)
                if self.parentLottieView.mode == .aurora {
                    self.animationView?.stop()
                    self.animationView?.animation = LottieAnimation.named(jsonName, bundle: Bundle.main)
                    self.animationView?.play()
                }
            })
        }
    }
}

class LottieViewData: ObservableObject {
    
}

class SoundManager: ObservableObject {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    enum soundOption: String {
        case fireSound = "fireSound"
        case paperCrumplingSound1 = "paperCrumplingSound1"
        case paperCrumplingSound2 = "paperCrumplingSound2"
        case paperCrumplingSound3 = "paperCrumplingSound3"
        case paperCrumplingSound4 = "paperCrumplingSound4"
        case writingSound = "writingSound"
    }
    
    func stopSound() {
        player?.stop()
    }
    func playSound(sounds: soundOption) {
        guard let url = Bundle.main.url(forResource: sounds.rawValue, withExtension: ".mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("재생하는데 오류가 생겼습니다. 오류코드 \(error.localizedDescription)")
        }
    }
    
}
class BGSoundManager: ObservableObject {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    enum soundOption: String {
        case fireSound = "fireSound"
        case paperCrumplingSound1 = "paperCrumplingSound1"
        case paperCrumplingSound2 = "paperCrumplingSound2"
        case paperCrumplingSound3 = "paperCrumplingSound3"
        case paperCrumplingSound4 = "paperCrumplingSound4"
        case writingSound = "writingSound"
    }
    
    func stopSound() {
        player?.stop()
    }
    func playSound(sounds: soundOption) {
        guard let url = Bundle.main.url(forResource: sounds.rawValue, withExtension: ".mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("재생하는데 오류가 생겼습니다. 오류코드 \(error.localizedDescription)")
        }
    }
    
}



struct FireScreenView: View {
    @EnvironmentObject var data : MyViewModel
    
    // ChangeFlameColor
    let auroraFlameList = ["comp1", "pink1", "purple1", "blue1", "green1", ]
    let throwPaperList = ["comp3", "pink2", "purple2", "blue2", "green2", ]
    
    @State private var currentColorIndex = 0 {
        didSet {
            UserDefaults.standard.set(currentColorIndex, forKey: "FLAME_COLOR_INDEX")
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.black.ignoresSafeArea()
            
            ZStack {
                if data.Finale == true {
                    // ChangeFlameColor
                    LottieView(jsonName: "\(throwPaperList[currentColorIndex]).mov.lottie", loopMode: .playOnce)
                    
                    
                } else {
                    LottieView(jsonName: "\(auroraFlameList[currentColorIndex]).mov.lottie", loopMode: .loop)
                    
                }
                VStack(spacing: 1){
                    VStack(alignment: .center, spacing: 15) {
                        Text("이제 일상으로 돌아가셔도 됩니다.")
                            .font(Font.custom("Bookk Myungjo", size: 15))
                        Text("이 불은 언제나 여기서 기다리고 있을겁니다.")
                            .font(Font.custom("Bookk Myungjo", size: 15))
                        Text("언제든 다시 돌아오세요.")
                            .font(Font.custom("Bookk Myungjo", size: 15))
                        
                    }.frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.height/7)
                        .background(.ultraThinMaterial.opacity(0.2), in: IndividualCorner(corners: [.topLeft, .topRight], radius:  20))
                    VStack(alignment: .center) {
                        Button {
                            data.finaleMessege = false
                        } label: {
                            Text("확인")
                                .font(Font.custom("Bookk Myungjo", size: 15))
                                .padding(30)
                                
                                .frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.height/18)
                                .background(.ultraThinMaterial.opacity(0.2), in: IndividualCorner(corners: [.bottomLeft, .bottomRight], radius:  20))
                              
                        }}
                }
              //  .padding(.init(top: 40, leading: 60, bottom: 20, trailing: 60))
               
                
                .foregroundColor(.white)
                .opacity(data.finaleMessege == true ? 1 : 0).animation(.easeIn(duration: 1.4))
//                .offset(y: data.finaleMessege == true ? -200 : 600).animation(.easeIn(duration: 2.0))
                .offset(y: -180)
            }
            .edgesIgnoringSafeArea(.all)
            
            .onAppear {
                BGSoundManager.instance.playSound(sounds: .fireSound)
                currentColorIndex = UserDefaults.standard.integer(forKey: "FLAME_COLOR_INDEX")
                data.functionCaller.send("\(auroraFlameList[currentColorIndex]).mov.lottie")
                print("onAppear: currentColorIndex: ", currentColorIndex)
            }
            .onDisappear {
                BGSoundManager.instance.stopSound()
            }
            .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local).onEnded({ value in
                print(value.translation, currentColorIndex)
                switch(value.translation.width, value.translation.height) {
                case (...0, -30...30):
                    print("left swipe // 다음 색상")
                    guard currentColorIndex >= 0 else {
                        return
                    }
                    
                    if currentColorIndex == auroraFlameList.count - 1 {
                        currentColorIndex = 0
                    } else {
                        currentColorIndex += 1
                    }
                    data.functionCaller.send("\(auroraFlameList[currentColorIndex]).mov.lottie")
                    
                case (0..., -30...30):
                    print("right swipe // 이전 색상")
                    guard currentColorIndex <= auroraFlameList.count - 1 else {
                        return
                    }
                    
                    if currentColorIndex == 0 {
                        currentColorIndex = auroraFlameList.count - 1
                    } else {
                        currentColorIndex -= 1
                    }
                    data.functionCaller.send("\(auroraFlameList[currentColorIndex]).mov.lottie")
                    
                case (-100...100, ...0):  print("up swipe")
                case (-100...100, 0...):  print("down swipe")
                default:  print("no clue")
                }
            }))
        }
//        .alert(isPresented:$data.finaleMessege){
//            withAnimation(.easeIn(duration: 4.0)){
//                Alert(title: Text("고생하셨습니다"),message: Text("이제 일상으로 돌아가셔도 됩니다.\n이 불은 언제나 여기서 기다리고 있을겁니다.\n언제든 다시 돌아오세요."),dismissButton: .cancel(Text("확인")))
//            }
//        }
       
           
        
    }
}





struct FireScreenView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        FireScreenView().environmentObject(MyViewModel())
        
    }
    
}

