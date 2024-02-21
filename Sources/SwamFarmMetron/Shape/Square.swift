import CoreGraphics

/**
 *  A `Square` is a rectangle with edges of equal length.
 */
struct Square {
    var origin: CGPoint
    var edges: CGFloat

    init(origin: CGPoint, edges: CGFloat) {
        self.origin = origin
        self.edges = edges
    }
}


extension Square {
    /// Initializes a `Square` that is aspect-fitted in
    /// the center of the provided rect.
    init(in rect: CGRect) {
        let square = CGRect(aspectFitSize: CGSize(edges: min(rect.width, rect.height)), inRect: rect)
        self.init(origin: square.origin, edges: square.width)
    }

    /// - returns: The `CGRect` representing this square.
    var rect: CGRect {
        return CGRect(origin: origin, edges: edges)
    }
}


extension Square: Drawable {
    var path: CGPath? {
        return rect.path
    }
}

extension Square: Shape {

    var area: CGFloat {
        return rect.area
    }

    var perimeter: CGFloat {
        return rect.perimeter
    }

    var center: CGPoint {
        return rect.center
    }

    /// Extremities:
    var minX: CGFloat { return origin.x }
    var maxX: CGFloat { return origin.x + edges }
    var minY: CGFloat { return origin.y }
    var maxY: CGFloat { return origin.y + edges }

    /// Midpoints:
    var midX: CGFloat { return center.x }
    var midY: CGFloat { return center.y }

    var width: CGFloat { return edges }
    var height: CGFloat { return edges }

    var boundingRect: CGRect { return rect }

    func contains(_ point: CGPoint) -> Bool {
        return rect.contains(point)
    }
}

extension Square: PolygonType {
    var edgeCount: Int {
        return 4
    }
    var points: [CGPoint] {
        let rect = self.rect
        return CoordinateSystem.default.corners.map { rect.corner($0) }
    }
    var lineSegments: [LineSegment] {
        return rect.lineSegments
    }
}

// MARK: CustomDebugStringConvertible

extension Square: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Square {origin: \(origin), edges: \(edges)}"
    }
}
