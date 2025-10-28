//
//  Untitled.swift
//  JournlingApp-Ch2
//
//  Created by Elham Alhemidi on 04/05/1447 AH.
//

import SwiftUI

// 2. Create Journal View
struct NewJournal: View {
    
    // لإغلاق الشاشة عند الضغط على زر X أو Done
    @Environment(\.dismiss) var dismiss
    
    // خصائص إدخال البيانات
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var showingAlert = false
    
    // الألوان المخصصة (نفس الألوان المستخدمة في الصفحة الرئيسية)
    let appBackgroundColor = Color(hex: "141420") ?? .black
    let journalAccentColor = Color(red: 127 / 255, green: 129 / 255, blue: 255 / 255)
    
    // التاريخ الافتراضي لليوم
    let currentDate = Date.now.formatted(date: .numeric, time: .omitted)
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // الخلفية الداكنة
            appBackgroundColor.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                
                // شريط التنقل المخصص (Header)
                HStack {
                    // زر الإلغاء (X)
                    Button {
                        showingAlert = true //  لحفظ الشاشة أو إغلاقها
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2) .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // زر الحفظ (Done)
                    Button {
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(journalAccentColor) // لون التظليل على زر Done
                            )
                    }
                }
                .padding(.horizontal)
                .padding(.top,5)
                
                // 1. حقل العنوان
                TextField("Title", text: $title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // 2. التاريخ
                Text(currentDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // 3. محرر اليومية (Text Editor) مع Placeholder
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $content)
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(maxHeight: .infinity)
                        .scrollContentBackground(.hidden) // إزالة خلفية TextEditor الافتراضية
                        .background(appBackgroundColor) // تعيين خلفية شفافة/سوداء
                    
                    if content.isEmpty {
                        Text("Type your Journal...")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.top, 6)      // لضبط مكان النص داخل TextEditor
                            .padding(.leading,2)  // مسافة بسيطة من الحافة اليسرى
                            .allowsHitTesting(false) // حتى لا يمنع الكتابة في TextEditor
                    }
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 20)
        }
        .alert("Discard Changes?", isPresented: $showingAlert) {
                    // زر "Discard" (يهمل التغييرات ويغلق الشاشة)
                    Button("Discard", role: .destructive) {
                        dismiss() // يقوم بإغلاق الـ Sheet
                    }
                    // زر "Cancel" (يلغي الإغلاق ويعود للشاشة)
                    Button("Cancel", role: .cancel) {
                        // لا يقوم بأي شيء، فقط يغلق التنبيه
                    }
                } message: {
                    Text("Are you sure you want to discard your unsaved changes?")
                }
                
        
        .background(appBackgroundColor)
    }
}

#Preview {
    NewJournal()
        .preferredColorScheme(.dark)
}
