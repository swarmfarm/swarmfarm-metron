import CoreGraphics

extension CGVector {

    /// - returns: A `CGPoint` with x: dx and y: dy.
    var point: CGPoint {
        return CGPoint(x: dx, y: dy)
    }

    var magnitude: CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
    var angle: Angle {
        return atan2(dy, dx)
    }

    init(angle: Angle, magnitude: CGFloat) {
        self.init(dx: magnitude * cos(angle), dy: magnitude * sin(angle))
    }

    var inversed: CGVector {
        return CGVector(dx: -dx, dy: -dy)
    }

    /// - returns: The `CGRectEdge` towards which this vector tends the most.
    var dominantEdge: CGRectEdge {
        return abs(dx) > abs(dy) ? (dx > 0.0 ? .maxXEdge : .minXEdge) : (dy > 0.0 ? .maxYEdge : .minYEdge)
    }

    /// - returns: The `Corner` towards which this vector tends the most.
    var dominantCorner: Corner {
        let xEdge: CGRectEdge = dx > 0 ? .maxXEdge : .minXEdge
        let yEdge: CGRectEdge = dy > 0 ? .maxYEdge : .minYEdge
        return Corner(x: xEdge, y: yEdge)
    }

    /// - returns: A `Line` drawn through the given point,
    /// following this vector.
    func line(through point: CGPoint) -> Line {
        return Line(a: point, b: point + self)
    }

    /// - returns: A `LineSegment` drawn from the given point,
    /// following this vector. The `LineSegment` length
    /// equals the vector magnitude.
    func lineSegment(from point: CGPoint) -> LineSegment {
        return LineSegment(a: point, b: point + self)
    }
}

// MARK: Arithmetic

func +(lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

func -(lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
}


func *(lhs: CGVector, rhs: CGFloat) -> CGVector {
    return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
}

func *(lhs: CGFloat, rhs: CGVector) -> CGVector {
    return CGVector(dx: rhs.dx * lhs, dy: rhs.dy * lhs)
}

func /(lhs: CGVector, rhs: CGFloat) -> CGVector {
    return CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
}

// MARK: Transform

extension CGVector: Transformable {
    func applying(_ t: CGAffineTransform) -> CGVector {
        return point.applying(t).vector
    }
}

extension CGAffineTransform {
    init(translation: CGVector) {
        self.init(translationX: translation.dx, y: translation.dy)
    }

    func translatedBy(vector: CGVector) -> CGAffineTransform {
        return translatedBy(x: vector.dx, y: vector.dy)
    }
}
