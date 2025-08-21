import SwiftUI
import SwiftData

/// 앱 내 라우팅 허브
/// Splash → Home → Write → Save(연출) → Card, + List
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
                    // SplashView는 duration과 onFinished를 지원(이전에 적용한 변경)
                    SplashView(duration: 1.6) {
                        showHome = true
                        path.removeAll() // Home을 루트로
                    }
                }
            }
            // 목적지 매핑
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
                    // 저장 완료 시 Save로 push, 카드에 넘길 item 보관
                    WriteView { item in
                        justSaved = item
                        path.append(.save)
                    }
                    .navigationBarBackButtonHidden(true)
                    .toolbar { backToolbar }

                case .save:
                    // SaveView가 자체 딜레이 후 onFinished로 카드로 이동
                    SaveView {
                        if let item = justSaved {
                            path.append(.card(item))
                        }
                    }
                    .navigationBarBackButtonHidden(true)

                case .card(let item):
                    CardView(item: item) {
                        // 홈 버튼은 항상 루트(Home)로 복귀 → 백버튼 없음
                        path.removeAll()
                    }
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

    // MARK: - Toolbars (커스텀 백버튼: 아이콘만 커스텀, 동작은 path 유지)
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
    // 미리보기: 인메모리 SwiftData 컨테이너 연결 (프리뷰에서 버튼 눌러도 안전)
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ThanksDiary.self, configurations: config)

    // 샘플 데이터(옵션)
    let ctx = container.mainContext
    ctx.insert(ThanksDiary(line1: "예시 1", line2: "아침 운동", line3: "커피 한 잔", date: .now))
    ctx.insert(ThanksDiary(line1: "예시 2", line2: "코드 정리", line3: "독서", date: .now.addingTimeInterval(-86400)))

    return RouterView()
        .modelContainer(container)
}
