//
//  Untitled.swift
//  JournlingApp-Ch2
//
//  Created by Elham Alhemidi on 01/05/1447 AH.
//

import SwiftUI

// نموذج بيانات المدخل (Journal Entry Model)
struct JournalEntry: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var date: String          // نص لعرض التاريخ
    var content: String
    var isBookmarked: Bool
    var createdAt: Date       // تاريخ فعلي للفرز
    // ملاحظة: نترك Equatable مُولّد تلقائياً ليأخذ جميع الحقول بعين الاعتبار.
}

// ==========================================================
// 2. واجهة عرض البطاقة (JournalCard)
// ==========================================================

struct JournalCard: View {
    // Binding لتعديل حالة البوك مارك من القائمة الرئيسية
    @Binding var entry: JournalEntry
    
    // لون البنفسجي المستخدم في التطبيق
    private let accentPurple = Color(red: 127 / 255, green: 129 / 255, blue: 255 / 255)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(entry.title)
                    // حجم أكبر من الحالي ولكن ليس كبيراً جداً
                    .font(.title2) // أكبر من .headline وأصغر من .title
                    .fontWeight(.bold)
                    // لون العنوان بنفس درجة البنفسجي المستخدمة في البوكمارك
                    .foregroundColor(accentPurple)
                
                Spacer()
                
                // زر البوك مارك التفاعلي
                Button {
                    entry.isBookmarked.toggle()
                } label: {
                    Image(systemName: entry.isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(entry.isBookmarked ? accentPurple : Color.gray)
                        .font(.title3)
                }
            }
            
            Text(entry.date)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(entry.content)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(3)
        }
        .padding(20)
        .glassEffect()
        .padding(.horizontal, 2)
    }
}

// شريط البحث المعاد استخدامه أسفل الصفحة
private struct BottomSearchBar: View {
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            Text("Search")
            Spacer()
            Image(systemName: "mic.fill")
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .frame(height: 48)
        .glassEffect()
        .foregroundColor(.gray)
        .padding(.horizontal)
    }
}

// ==========================================================
// 4. واجهة عرض الصفحة الرئيسية (Mainpage) - الكود المحدث
// ==========================================================

struct Mainpage: View {
    @State private var currentSort: String = "Entry Date" // "Entry Date" أو "Bookmark"
    @State private var showCreationSheet: Bool = false
    
    // حالة تأكيد الحذف
    @State private var showDeleteAlert: Bool = false
    @State private var pendingOffsets: IndexSet? = nil
    @State private var pendingId: UUID? = nil
    
    // قائمة المدخلات الافتراضية - فارغة حتى يضيف المستخدم أول بطاقة
    @State private var entries: [JournalEntry] = []
    
    // فهرس العناصر المعروضة حالياً (للدعم الصحيح للـ binding مع التصفية)
    private var indicesToShow: [Int] {
        // اختر الفهارس حسب التصفية، ثم رتّبها بالأحدث أولاً
        let filteredIndices: [Int]
        if currentSort == "Bookmark" {
            filteredIndices = entries.indices.filter { entries[$0].isBookmarked }
        } else {
            filteredIndices = Array(entries.indices)
        }
        // الترتيب: الأحدث أولاً دائماً لعرض جميل
        return filteredIndices.sorted { entries[$0].createdAt > entries[$1].createdAt }
    }
    
    // دالة ترتيب العناصر بحسب الاختيار الحالي (تستخدم عند الإضافة/الحذف لثبات الترتيب العام)
    private func sortEntries() {
        switch currentSort {
        case "Bookmark":
            // لا نغير entries نفسها بالتصفية، فقط نحافظ على ترتيب منطقي داخلياً إن رغبت
            entries.sort { lhs, rhs in
                if lhs.createdAt != rhs.createdAt {
                    return lhs.createdAt > rhs.createdAt
                } else {
                    // إن تساوى التاريخ، ضع المفضلة قبل غيرها
                    return lhs.isBookmarked && !rhs.isBookmarked
                }
            }
        default:
            // الأحدث أولاً
            entries.sort { $0.createdAt > $1.createdAt }
        }
    }
    
    // دالة الحذف بالتمرير (Swipe-to-Delete) بعد التأكيد
    func deleteItems(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }
    
    // طلب الحذف عبر onDelete (من التحرير/السحب الافتراضي) مع تحويل الفهارس من المعروض إلى الأصل
    private func requestDelete(offsets displayedOffsets: IndexSet) {
        // حوّل الفهارس الظاهرة إلى فهارس حقيقية في entries
        let mapped = IndexSet(displayedOffsets.map { indicesToShow[$0] })
        pendingOffsets = mapped
        pendingId = nil
        showDeleteAlert = true
    }
    
    // طلب الحذف من زر swipeActions (نحتفظ بالمعرف)
    private func requestDelete(id: UUID) {
        pendingId = id
        pendingOffsets = nil
        showDeleteAlert = true
    }
    
    // تنفيذ الحذف بعد التأكيد
    private func confirmDelete() {
        if let offsets = pendingOffsets {
            deleteItems(at: offsets)
            pendingOffsets = nil
        } else if let id = pendingId, let idx = entries.firstIndex(where: { $0.id == id }) {
            entries.remove(at: idx)
            pendingId = nil
        }
        withAnimation(.easeInOut) {
            sortEntries()
        }
    }
   
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                (Color(hex: "141420") ?? .black)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // شريط العنوان (Header)
                    HStack {
                        // Title: Journal
                        Text("Journal")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        
                        // الأزرار العلوية (الفرز والإضافة)
                        HStack(spacing: 30) {
                            
                            // زر الفرز/التصفية
                            Menu {
                                Button {
                                    withAnimation(.easeInOut) { currentSort = "Bookmark" }
                                } label: {
                                    Label("Sort by Bookmark", systemImage: currentSort == "Bookmark" ? "checkmark" : "")
                                }
                                Button {
                                    withAnimation(.easeInOut) { currentSort = "Entry Date" }
                                } label: {
                                    Label("Sort by Entry Date", systemImage: currentSort == "Entry Date" ? "checkmark" : "")
                                }
                            }
                            label: {
                                Image(systemName: "line.3.horizontal.decrease")
                            }
                            
                            // زر الإضافة
                            Button {
                                showCreationSheet = true
                            }
                            label: {
                                Image(systemName: "plus")
                            }
                        } // نهاية HStack
                        
                        // مظهر أيقونات الهيدر
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(15)
                        .glassEffect(cornerRadius: 0, isCapsule: true)
                    }
                    .padding(.horizontal).padding(.top, 10)
                    .onChange(of: currentSort) { _, _ in
                        withAnimation(.easeInOut) { sortEntries() }
                    }
                    
                    // حالة لا توجد أي مدخلات إطلاقاً
                    if entries.isEmpty {
                        // شاشة فارغة مطابقة لواجهة EmptyState (المحتوى في المنتصف والبحث في الأسفل)
                        let accentTextColor = Color(red: 127 / 255, green: 129 / 255, blue: 255 / 255)
                        
                        VStack(spacing: 0) {
                            // المحتوى الأوسط
                            VStack(spacing: 12) {
                                Image("book icon 2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 151.39, height: 97.32)
                                    .foregroundStyle(.tint)
                                
                                Text("Begin Your Journal")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(accentTextColor)
                                
                                Text("Craft your personal diary, tap the plus icon to begin")
                                    .font(.system(size: 18, weight: .light))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 280, height: 50)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            // شريط البحث في الأسفل
                            BottomSearchBar()
                                .padding(.bottom, 20)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    } else {
                        // حساب إن كانت التصفية (Bookmark) أدت لعدم وجود نتائج
                        let noResultsWithFilter = indicesToShow.isEmpty && currentSort == "Bookmark"
                        
                        VStack(spacing: 0) {
                            if noResultsWithFilter {
                                // لا توجد مذكرات مفضلة
                                VStack(spacing: 12) {
                                    Image(systemName: "bookmark.slash")
                                        .font(.system(size: 44))
                                        .foregroundColor(.gray)
                                    Text("No bookmarked journals")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    Text("Mark some journals as bookmarked to see them here.")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                // قائمة المدخلات القابلة للتمرير مع الحذف بالسحب
                                List {
                                    ForEach(indicesToShow, id: \.self) { index in
                                        let id = entries[index].id
                                        JournalCard(entry: $entries[index])
                                            .listRowSeparator(.hidden)
                                            .listRowBackground(Color.clear)
                                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                                Button(role: .destructive) {
                                                    requestDelete(id: id)
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            }
                                    }
                                    // بدلاً من الحذف الفوري، نعرض تأكيد
                                    .onDelete(perform: requestDelete)
                                }
                                .listStyle(.plain)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                            }
                            
                            // شريط البحث أسفل القائمة أو أسفل حالة عدم وجود نتائج
                            BottomSearchBar()
                                .padding(.vertical, 20)
                        }
                    }
                } // نهاية VStack
                
            }
            
            // تنبيه التأكيد
            .alert("Delete Journal?", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {
                    pendingOffsets = nil
                    pendingId = nil
                }
                Button("Delete", role: .destructive) {
                    confirmDelete()
                }
            } message: {
                Text("Are you sure you want to delete this journal?")
            }
            
            // ربط صفحة الإضافة بالبيانات الديناميكية عبر onSave
            .sheet(isPresented: $showCreationSheet) {
                NewJournal { title, content in
                    let now = Date()
                    let newEntry = JournalEntry(
                        title: title,
                        date: now.formatted(date: .numeric, time: .omitted),
                        content: content,
                        isBookmarked: false,
                        createdAt: now
                    )
                    entries.insert(newEntry, at: 0)
                    withAnimation(.easeInOut) { sortEntries() }
                }
                .presentationDetents([.fraction(1)]) // ملء الشاشة
                .presentationBackground(.clear)
            }
            .onAppear {
                sortEntries()
            }
            .onChange(of: entries) { _, _ in
                // حافظ على الترتيب بعد أي تعديل (مثل تغيير حالة البوك مارك)
                withAnimation(.easeInOut) { sortEntries() }
            }
        }
    }
}

#Preview {
    Mainpage()
        .preferredColorScheme(.dark)
}
