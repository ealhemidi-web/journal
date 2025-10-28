//
//  Untitled.swift
//  JournlingApp-Ch2
//
//  Created by Elham Alhemidi on 01/05/1447 AH.
//

import SwiftUI

// نموذج بيانات المدخل (Journal Entry Model)
struct JournalEntry: Identifiable {
    let id = UUID()
    var title: String
    var date: String
    var content: String
    var isBookmarked: Bool
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
    @State private var currentSort: String = "Entry Date"
    @State private var showCreationSheet: Bool = false
    
    // حالة تأكيد الحذف
    @State private var showDeleteAlert: Bool = false
    @State private var pendingOffsets: IndexSet? = nil
    @State private var pendingId: UUID? = nil
    
    // قائمة المدخلات الافتراضية - فارغة حتى يضيف المستخدم أول بطاقة
    @State private var entries: [JournalEntry] = []
    
    // دالة الحذف بالتمرير (Swipe-to-Delete) بعد التأكيد
    func deleteItems(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }
    
    // طلب الحذف عبر onDelete (من التحرير/السحب الافتراضي)
    private func requestDelete(offsets: IndexSet) {
        pendingOffsets = offsets
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
                            
                            //هنا زر الفرز
                            Menu {
                                Button("Sort by Bookmark") { currentSort = "Bookmark" }
                                Button("Sort by Entry Date") { currentSort = "Entry Date" }
                            }
                            label: {
                                Image(systemName: "line.3.horizontal.decrease")
                            }
                            
                            //هنا زر الاضافه
                            Button {
                                showCreationSheet = true
                            }
                            label: {
                                Image(systemName: "plus")
                            }
                        } //نهايه ال HStack
                        
                        //هنا حجم وشكل ولون المربع الي فيه الايقونات
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(15)
                        // **استخدام glassEffect مع تحديد شكل Capsule**
                        .glassEffect(cornerRadius: 0, isCapsule: true)
                    }
                    .padding(.horizontal).padding(.top, 10)
                    
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
                        // قائمة المدخلات القابلة للتمرير مع الحذف بالسحب
                        VStack(spacing: 0) {
                            List {
                                ForEach($entries) { $entry in
                                    // نحتاج الـ id هنا لإيجاد الفهرس عند الحذف من swipeActions
                                    let id = entry.id
                                    
                                    JournalCard(entry: $entry)
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
                            
                            // شريط البحث أسفل القائمة أيضاً
                            BottomSearchBar()
                                .padding(.vertical, 20)
                        }
                    }
                } // نهاية VStack
                
            }
            
            // تنبيه التأكيد (يشبه التصميم: عنوان + رسالة + زر إلغاء + زر حذف أحمر)
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
                    let newEntry = JournalEntry(
                        title: title,
                        date: Date().formatted(date: .numeric, time: .omitted),
                        content: content,
                        isBookmarked: false
                    )
                    entries.insert(newEntry, at: 0)
                }
                .presentationDetents([.fraction(1)]) // ملء الشاشة
                .presentationBackground(.clear)
            }
        }
    }
}

#Preview {
    Mainpage()
        .preferredColorScheme(.dark)
}
