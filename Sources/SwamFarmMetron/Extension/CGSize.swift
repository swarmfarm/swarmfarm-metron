import CoreGraphics

extension CGSize {

    init(edges length: CGFloat) {
        self.init(width: length, height: length)
    }

    var area: CGFloat {
        return width * height
    }

    /// - returns: A `CGSize` with width and height swapped.
    var swapped: CGSize {
        return CGSize(width: height, height: width)
    }

    /// Limits the size to the given size.
    func clipped(to size: CGSize) -> CGSize {
        return CGSize(width: min(width, size.width),
            height: min(height, size.height))
    }
}

// MARK: Arithmetic

func *(lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
}
func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
}
func *(lhs: CGFloat, rhs: CGSize) -> CGSize {
    return CGSize(width: rhs.width * lhs, height: rhs.height * lhs)
}
func /(lhs: CGSize, rhs: CGSize) -> CGSize {
    return CGSize(width: lhs.width / rhs.width, height: lhs.height / rhs.height)
}
func /(lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
}
