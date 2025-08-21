//
//  ListView.swift
//  BunnyDiary
//
//  Created by 박민아 on 8/18/25.
//


import SwiftUI
import SwiftData

// MARK: - ListSectionView (감사일기 카드 컴포넌트)
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
            
            // UI 분기: if/else가 전체 리스트 영역을 차지해야 함
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image("Back")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showMonthPicker = true } label: {
                    Image("Picker")
                }
            }
        }
        .sheet(isPresented: $showMonthPicker) {
            VStack(spacing: 12) {
                Text("월 선택").font(.headline)

                HStack(spacing: 24) {
                    // Year wheel
                    Picker("년도", selection: $pickerYear) {
                        ForEach(2018...2032, id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 120)
                    .clipped()

                    // Month wheel
                    Picker("월", selection: $pickerMonth) {
                        ForEach(1...12, id: \.self) { m in
                            Text("\(m)월").tag(m)
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
                .buttonStyle(.borderedProminent)
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
// MARK: - 프리뷰
// ListView의 프리뷰를 위한 구조체입니다.
struct ListView_Previews: PreviewProvider {
    
    // 1. 모든 데이터 설정과 컨테이너를 이 변수 안에 묶습니다.
    private static var previewContainer: ModelContainer = {
        let container = try! ModelContainer(for: ThanksDiary.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        // 2. 뷰를 반환하기 전에, 데이터를 삽입하는 '명령'을 실행합니다.
        let sampleDiary1 = ThanksDiary(line1: "오늘의 감사", line2: "내 감사", line3: "내일의 감사", date: .now)
        let sampleDiary2 = ThanksDiary(line1: "어제는 맑음", line2: "오전 운동 완료", line3: "새벽예배 다녀왔다! 배움 완료", date: .now)
        let sampleDiary3 = ThanksDiary(line1: "지난 달의 감사", line2: "너무 좋았어", line3: "덕분에 행복했어", date: Calendar.current.date(byAdding: .month, value: -1, to: .now)!)
        
        container.mainContext.insert(sampleDiary1)
        container.mainContext.insert(sampleDiary2)
        container.mainContext.insert(sampleDiary3)
        
        // 3. 그리고 마지막으로 컨테이너를 반환합니다.
        return container
    }()
    
    static var previews: some View {
        // 4. `#Preview`에서는 완성된 변수만 사용합니다.
        // 이제 ViewBuilder는 뷰만 인식하게 되어 오류가 발생하지 않습니다.
        NavigationStack {
            ListView()
                .modelContainer(previewContainer)
        }
    }
}
