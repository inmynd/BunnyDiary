//
//  ListView.swift
//  BunnyDiary
//
//  Created by 박민아 on 8/18/25.
//


import SwiftUI
import SwiftData

// MARK: - ListSectionView (감사일기 하나당 보이는 거)
struct ListSectionView: View {
    let diary: ThanksDiary
    
    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyy년 M월 d일 a h시 m분"
        return f
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if !diary.line1.isEmpty { row(diary.line1) }
            if !diary.line2.isEmpty { row(diary.line2) }
            if !diary.line3.isEmpty { row(diary.line3) }
            
            Text(ListSectionView.formatter.string(from: diary.date))
                .font(.Bunny21)
                .foregroundStyle(.gray)
                .padding(.top, 6)
        }
        .padding(16)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func row(_ text: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Image("Carrot")
            Text(text).font(.Bunny30)  // ← 텍스트 추가
        }
    }
}

// MARK: - ListView
struct ListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \ThanksDiary.date, order: .reverse)
    private var allDiaries: [ThanksDiary]
    
    // selectedMonth를 Date 타입으로 변경
    @State private var selectedMonth: Date = Calendar.current.startOfDay(for: .now)
    @State private var showMonthPicker = false
    @State private var pickerYear: Int = Calendar.current.component(.year, from: .now)
    @State private var pickerMonth: Int = Calendar.current.component(.month, from: .now)
    
    private var monthDiaries: [ThanksDiary] {
        let cal = Calendar.current
        return allDiaries.filter {
            cal.isDate($0.date, equalTo: selectedMonth, toGranularity: .month)
        }
    }
    
    private func deleteDiaries(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(monthDiaries[index])
            }
        }
        try? modelContext.save()
    }

    var body: some View {
        VStack {
            // 헤더 부분
            HStack {
                Button(action: {
                    if let newMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) {
                        selectedMonth = newMonth
                    }
                }) {
                    Image("Left")
                        .foregroundColor(.black)
                        .padding()
                }
                
                Text(selectedMonth.formatted(.dateTime.year().month().locale(Locale(identifier: "ko_KR"))))
                    .font(.Bunny30)
                    .frame(minWidth: 80)
                    .padding()
                
                Button(action: {
                    if let newMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) {
                        selectedMonth = newMonth
                    }
                }) {
                    Image("Right")
                        .foregroundColor(.black)
                        .padding()
                }
            }
            
            // if/else가 전체 리스트 영역을 차지해야 해서 있는지 없는지 상태값 보이게 하는 것
            if monthDiaries.isEmpty {
                Spacer()
                VStack {
                    Image("OohBunny")
                    Text("작성된 세줄감사가 없어요 🥲")
                        .font(.Bunny30)
                }
                Spacer()
            } else {
                List {
                    ForEach(monthDiaries) { diary in
                        Section {
                            ListSectionView(diary: diary)
                                .listRowInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
                                .listRowSeparator(.hidden)
                        }
                    }
                    .onDelete(perform: deleteDiaries)
                }
                .listSectionSpacing(20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showMonthPicker = true } label: {
                    Image("Picker")
                }
            }
        }
        .sheet(isPresented: $showMonthPicker) {
            VStack(spacing: 12) {
                Text("감사일기 월 선택").font(.Bunny30)

                HStack(spacing: 24) {
                    // Year wheel
                    Picker("년도", selection: $pickerYear) {
                        ForEach(2018...2025, id: \.self) { year in
                            Text(String(year)).tag(year)
                                .font(.Bunny30)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 120)
                    .clipped()

                    // Month wheel
                    Picker("월", selection: $pickerMonth) {
                        ForEach(1...12, id: \.self) { m in
                            Text("\(m)월").tag(m)
                                .font(.Bunny30)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 120)
                    .clipped()
                }
                .padding(.vertical)

                Button("완료") {
                    var comps = DateComponents()
                    comps.year = pickerYear
                    comps.month = pickerMonth
                    if let d = Calendar.current.date(from: comps) {
                        selectedMonth = d
                    }
                    showMonthPicker = false
                }
                .font(.Bunny30)
                .buttonStyle(.plain)
            }
            .padding()
            .presentationDetents([.medium])
        }
        .onAppear {
            pickerYear = Calendar.current.component(.year, from: selectedMonth)
            pickerMonth = Calendar.current.component(.month, from: selectedMonth)
        }
    }
}
// MARK: - Preview
struct ListView_Previews: PreviewProvider {
    
    // 모든 데이터 설정과 컨테이너를 여기로
    private static var previewContainer: ModelContainer = {
        let container = try! ModelContainer(for: ThanksDiary.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        // 뷰를 반환하기 전에, 데이터를 삽입하는 명령 !!!!
        let sampleDiary1 = ThanksDiary(line1: "안녕하세용", line2: "땡스버니 리트라이~", line3: "화이팅팅", date: .now)
        let sampleDiary2 = ThanksDiary(line1: "날씨 조음", line2: "오운완~", line3: "마싯는 샤인머스켓 케이크와 아빠 생신", date: .now)

        container.mainContext.insert(sampleDiary1)
        container.mainContext.insert(sampleDiary2)

        
        // 마지막에는 컨테이너 반환
        return container
    }()
    
    static var previews: some View {
        // #Preview에서는 완성된 변수만 사용해야된다이이이잉!!!!!!
        NavigationStack {
            ListView()
                .modelContainer(previewContainer)
        }
    }
}
