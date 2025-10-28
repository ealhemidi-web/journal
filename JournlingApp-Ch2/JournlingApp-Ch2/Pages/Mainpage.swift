//
//  Untitled.swift
//  JournlingApp-Ch2
//
//  Created by Elham Alhemidi on 01/05/1447 AH.
//
import SwiftUI

// 2. هيكل البيانات (Data Model)
struct JournalEntry: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let content: String
    var isBookmarked: Bool
}

// 3. تصميم البطاقة الواحدة (Journal Card View)
struct JournalCardView: View {
    let entry: JournalEntry
    // لون التظليل (7F81FF) بدون hex
    let accentColor = Color(red: 160 / 255, green: 129 / 255, blue: 255 / 255)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(entry.title).font(.headline).foregroundColor(.white)
                Spacer()
                Image(systemName: entry.isBookmarked ? "bookmark" : "bookmark")
                    .foregroundColor(entry.isBookmarked ? accentColor : .gray)
                    .font(.title2)
            }
            Text(entry.date).font(.caption).foregroundColor(.gray)
            Text(entry.content)
                .font(.subheadline).foregroundColor(.white.opacity(0.8)).lineLimit(3)
        }
        .padding(18)
        .background(
            // **تطبيق تأثير الـ Glassmorphism على البطاقة**
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial) // خلفية شفافة
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5) // ظل خفيف
        )
        .padding(.horizontal)
    }
}

// 4. العرض الرئيسي (mainpage)
struct Mainpage: View {
    @State private var showCreationSheet: Bool = false
    @State private var journalEntries: [JournalEntry] = []
    @State private var currentSort: String = "Entry Date" // لتخزين خيار التصنيف الحالي
    
    // الألوان المخصصة
    let appBackgroundColor = Color(hex: "141420") ?? .black
    let journalAccentColor = Color(red: 127 / 255, green: 129 / 255, blue: 255 / 255) // 7F81FF

    func deleteEntry(entry: JournalEntry) {
        if let index = journalEntries.firstIndex(where: { $0.id == entry.id }) {
            journalEntries.remove(at: index)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                appBackgroundColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // شريط التنقل المخصص (Header)
                    HStack {
                        Text("Journal")
                            .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                        Spacer()
                        
                        HStack(spacing: 20) {
                            // **1. زر الفلتر الجديد (Menu)**
                            Menu {
                                Button("Sort by Entry Date") {
                                    currentSort = "Entry Date"
                                    // هنا يتم وضع كود تصنيف القائمة حسب التاريخ
                                }
                                Button("Sort by Bookmark") {
                                    currentSort = "Bookmark"
                                    // هنا يتم وضع كود تصنيف القائمة حسب الإشارة المرجعية
                                }
                            } label: {
                                // أيقونة التصنيف الحديثة (هرمية بثلاث خطوط)
                                Image(systemName: "line.3.horizontal.decrease")
                            }
                            
                            // 2. زر الإضافة
                            Button {
                                journalEntries.append(
                                    JournalEntry(
                                        title: "New Entry \(journalEntries.count + 1)",
                                        date: Date.now.formatted(date: .numeric, time: .omitted),
                                        content: "new journal",
                                        isBookmarked: Bool.random() // تجربة الإشارة المرجعية
                                    )
                                )
                                showCreationSheet = true // <--- فتح النافذة بعد الإضافة
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                        .font(.title2).foregroundColor(.white).padding(8)
                        // **تطبيق تأثير الـ Glassmorphism على الأزرار**
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial) // خلفية شفافة
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                        )
                    }
                    .padding(.horizontal).padding(.top, 10)

                    // منطق التبديل بين الشاشة الفارغة والقائمة
                    if journalEntries.isEmpty {
                        // شاشة فارغة (Empty State)
                        VStack(spacing: 12) {
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // قائمة اليوميات (List State)
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(journalEntries) { entry in
                                    JournalCardView(entry: entry)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button(role: .destructive) {
                                                deleteEntry(entry: entry)
                                            } label: {
                                                Label("Delete", systemImage: "trash.fill")
                                            }
                                            .tint(.red)
                                        }
                                }
                            }
                            .padding(.top, 15).padding(.bottom, 100)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    // شريط البحث في الأسفل
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                        Spacer()
                        Image(systemName: "mic.fill")
                    }
                    .padding()
                    // **تطبيق تأثير الـ Glassmorphism على شريط البحث**
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.ultraThinMaterial) // خلفية شفافة
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    )
                    .foregroundColor(.gray)
                    .padding(.horizontal).padding(.bottom, 20)
                    
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showCreationSheet) {
            NewJournal()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    Mainpage()
}
