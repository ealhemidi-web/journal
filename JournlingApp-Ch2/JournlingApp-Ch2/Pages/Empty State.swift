//
//  Empty State.swift
//  JournlingApp-Ch2
//
//  Created by Elham Alhemidi on 30/04/1447 AH.
//
import SwiftUI

struct EmptyState: View {
    var body: some View {
        let buttonBackgroundColor = Color(hex: "343440") ?? .gray
        let accentTextColor = Color(red: 150 / 255, green: 139 / 255, blue: 255 / 255)
        
        NavigationStack {
            ZStack (alignment: .top) {
                (Color(hex: "141420") ?? .black)
                    .ignoresSafeArea()
                
                VStack(spacing: 190) {
                    
                    // شريط التنقل المخصص (Header)
                    HStack {
                        // Title: Journal
                        Text("Journal")
                            .font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                        Spacer()
                        
                        // الأزرار العلوية (القائمة والإضافة)
                        HStack(spacing: 20) {
                            Image(systemName: "line.horizontal.3")
                            Image(systemName: "plus")
                                .buttonStyle(GlassButtonStyle())
                        }
                        .font(.title2).foregroundColor(.white).padding(8)
                        .background(buttonBackgroundColor)
                        .clipShape(Capsule()) // أزرار بيضاوية كما في الصورة
                    }
                    
                    
                    
                    VStack(spacing: 12)
                    {
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
                            .frame(width:280, height:50)
                    }
                    
                    
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                        Spacer()
                        Image(systemName: "mic.fill")
                    }
                    .padding()
                    // **تطبيق تأثير الـ Glassmorphism على شريط البحث**
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(.ultraThinMaterial) // خلفية شفافة
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    )
                    .foregroundColor(.gray)

                    .padding(.top,100)
                    //هذه البادينق تستعمل عشان تخلي مسافه بينها وبين الي فوقها
                }
                    
                    
                    .padding()
                    

                }
            }
        }
    }
#Preview {
    EmptyState()
}
