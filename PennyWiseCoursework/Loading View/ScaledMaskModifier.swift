import SwiftUI

struct ScaledMaskModifier<Mask: View>: ViewModifier {
     
    var mask: Mask
    var progress: CGFloat
     
    func body(content: Content) -> some View {
        content
            .mask(GeometryReader(content: { geometry in
                self.mask.frame(width: self.calculateSize(geometry: geometry) * self.progress,
                                height: self.calculateSize(geometry: geometry) * self.progress,
                                alignment: .center)
            }))
    }
     
    func calculateSize(geometry: GeometryProxy) -> CGFloat {
        if geometry.size.width > geometry.size.height {
            return geometry.size.width
        }
        return geometry.size.height
    }
 
}
