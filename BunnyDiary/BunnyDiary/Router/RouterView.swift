import SwiftUI
import SwiftData

struct RouterView: View {
    @State private var path: [Router] = []
    @State private var showHome = false
    @State private var justSaved: ThanksDiary? = nil

    var body: some View {
        NavigationStack(path: $path) {
            //  Splash 끝나면 Home을 루트로 교체(백버튼 없음)
            Group {
                if showHome {
                    HomeView(
                        onWrite: { path.append(.write) },
                        onReadList: { path.append(.list) }
                    )
                } else {
                    SplashView(duration: 1.6) {
                        showHome = true
                        path.removeAll() // HomeView를 루트로!!!!
                    }
                }
            }
            //MARK: 이제 가보자고
            .navigationDestination(for: Router.self) { route in
                switch route {
                case .splash:
                    SplashView()

                case .home:
                    HomeView(
                        onWrite: { path.append(.write) },
                        onReadList: { path.append(.list) }
                    )

                case .write:
                    WriteView { item in
                        justSaved = item
                        path.append(.save)
                    }
                    // 저장 완료 시 Save로 push, 카드에 넘길 item 보관
                    .navigationBarBackButtonHidden(true)
                    .toolbar { backToolbar }

                case .save:
                    SaveView {
                        if let item = justSaved {
                            path.append(.card(item))
                        }
                        // SaveView가 onFinished로 CardView로 이동
                    }
                    .navigationBarBackButtonHidden(true)

                case .card(let item):
                    CardView(item: item) {
                        path.removeAll()
                    }
                    // 홈 버튼은 항상 루트(Home)로 복귀하도록 하는 거 path.removeAll

                    .navigationBarBackButtonHidden(true)
                    .toolbar { backToolbar }

                case .list:
                    ListView()
                        .navigationBarBackButtonHidden(true)
                        .toolbar { backToolbar }
                }
            }
        }
    }

    // MARK: - 툴바! (커스텀 백버튼: 아이콘만 커스텀하게함)
    private var backToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                _ = path.popLast()
            } label: {
                HStack(spacing: 4) {
                    Image("Back")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .accessibilityLabel("뒤로")
                }
                .contentShape(Rectangle())
                .padding(.vertical, 6)
                .padding(.trailing, 4)
            }
            .tint(.primary)
        }
    }

    private var backToHomeToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                path = [.home]
            } label: {
                HStack(spacing: 6) {
                    Image("Back")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .accessibilityLabel("홈")
                    Text("홈")
                }
                .contentShape(Rectangle())
                .padding(.vertical, 6)
                .padding(.trailing, 4)
            }
            .tint(.primary)
        }
    }
}

#Preview {
    // 미리보기: SwiftData 컨테이너 연결
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ThanksDiary.self, configurations: config)

    // 샘플 데이터
    let sample = container.mainContext
    sample.insert(ThanksDiary(line1: "애플 아카데미", line2: "4기 화이팅", line3: "C5 화이팅", date: .now))
    sample.insert(ThanksDiary(line1: "날씨가 점점 시원해지고 있당", line2: "신난당", line3: "조아욥!", date: .now))

    return RouterView()
        .modelContainer(container)
}
