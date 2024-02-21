import CoreGraphics

protocol Transformable {
    func applying(_ t: CGAffineTransform) -> Self
}

//  Native conformance
extension CGPoint: Transformable {
}

extension CGSize: Transformable {
}

extension CGRect: Transformable {
}


extension Transformable {

    /// Applies the given transform using the origin as anchor point.
    func applying(_ t: CGAffineTransform, anchorPoint: CGPoint) -> Self {
        let m = applying(CGAffineTransform(translationX: -anchorPoint.x, y: -anchorPoint.y))
        let mt = m.applying(t)
        return mt.applying(CGAffineTransform(translationX: anchorPoint.x, y: anchorPoint.y))
    }
    
}
