
import SwiftUI

// ----------------------------------------------------
// 1. تعريف مُعدِّل Glass Effect لتسهيل القراءة
// ----------------------------------------------------
struct GlassEffect: ViewModifier {
    // تحديد شكل الخلفية (افتراضياً: مستطيل بزوايا دائرية 30)
    let shape: AnyShape
    
    init(cornerRadius: CGFloat, isCapsule: Bool = false) {
        if isCapsule {
            self.shape = AnyShape(Capsule())
        } else {
            self.shape = AnyShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                shape
                    .fill(.ultraThinMaterial) // التأثير الزجاجي الفعلي
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
            )
    }
}

// دالة تسهيلية لاستدعاء المُعدّل بسهولة
extension View {
    func glassEffect(cornerRadius: CGFloat = 30, isCapsule: Bool = false) -> some View {
        self.modifier(GlassEffect(cornerRadius: cornerRadius, isCapsule: isCapsule))
    }
}

struct EmptyState: View {
    @State private var currentSort: String = "Entry Date"
    @State private var showCreationSheet: Bool = false
    
    var body: some View {
        let accentTextColor = Color(red: 127 / 255, green: 129 / 255, blue: 255 / 255) // تم تصحيح اللون ليتطابق
        
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
                    
                    
                    
                    // المنطقة الوسطى: Empty State
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
            .navigationBarHidden(true)
            .preferredColorScheme(.dark)
            //هنا تعطي مظهر الدارك موود

    }
    }
    }

#Preview {
    EmptyState()
}
