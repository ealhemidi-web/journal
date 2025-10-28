//
//  Untitled.swift
//  JournlingApp-Ch2
//
//  Created by Elham Alhemidi on 01/05/1447 AH.
//
import SwiftUI


struct Mainpage: View {
    @State private var currentSort: String = "Entry Date"
    @State private var showCreationSheet: Bool = false
    
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
                    Spacer()
                    
                    // شريط البحث
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
                    .padding(.horizontal).padding(.bottom, 20)
                }
                    
                    
                    }
                    
                //هنا لما نضغط عالزر الخاص بالاضافه يفتح لي صفحه ال new journal
                //ورابط بين الصفحتين
                .sheet(isPresented: $showCreationSheet) {
                    NewJournal()
                        .presentationDetents([.fraction(10)])
                    //ال fraction هنا هو مسافه التاب الخاصه بالنيو جورنال وين توصل بالصفحه
                        .presentationBackground(.clear)
                 }
               }
             }
           }
#Preview {
    Mainpage()
        .preferredColorScheme(.dark)
}
