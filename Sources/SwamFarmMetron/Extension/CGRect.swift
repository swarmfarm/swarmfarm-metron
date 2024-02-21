import CoreGraphics

extension CGRect {

    // MARK: Convenience initializers

    init(size: CGSize) {
        self.init(origin: .zero, size: size)
    }

    init(center: CGPoint, size: CGSize) {
        self.init(origin: CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2), size: size)
    }

    init(origin: CGPoint, edges: CGFloat) {
        self.init(origin: origin, size: CGSize(edges: edges))
    }

    init(center: CGPoint, edges: CGFloat) {
        self.init(center: center, size: CGSize(edges: edges))
    }

    init(minX: CGFloat, minY: CGFloat, maxX: CGFloat, maxY: CGFloat) {
        self.init(origin: CGPoint(x: minX, y: minY), size: CGSize(width: maxX - minX, height: maxY - minY))
    }

    /// Initializes a `CGRect` of specified size, positioned such that
    /// the provided `origin` point will be in the specified `corner`.
    init(size: CGSize, origin: CGPoint, inCorner corner: Corner) {
        switch corner {
        case .minXminY: self.init(origin: origin, size: size)
        case .maxXminY: self.init(origin: CGPoint(x: origin.x - size.width, y: origin.y), size: size)
        case .minXmaxY: self.init(origin: CGPoint(x: origin.x, y: origin.y - size.height), size: size)
        case .maxXmaxY: self.init(origin: CGPoint(x: origin.x - size.width, y: origin.y - size.height), size: size)
        }
    }

    // MARK: Aspect fit / fill

    /// Initializes a `CGRect` that is scaled – preserving aspect ratio – to fill
    /// the entire rect specified at `inRect:`.
    init(aspectFillSize size: CGSize, inRect rect: CGRect) {
        let ratio = size / rect.size
        let smallestRatio = min(ratio.width, ratio.height)
        self.init(center: rect.center, size: size * (1.0 / smallestRatio))
    }

    /// Initializes a `CGRect` that is scaled – preserving aspect ratio – to fit
    /// exactly in the rect specified at `inRect:`.
    init(aspectFitSize size: CGSize, inRect rect: CGRect) {
        let ratio = size / rect.size
        let largestRatio = max(ratio.width, ratio.height)
        self.init(center: rect.center, size: size * (1.0 / largestRatio))
    }

    /// - returns: The value for the given edge
    /// (i.e. `minXEdge` will return this rect's `minX` value).
    func edge(_ edge: CGRectEdge) -> CGFloat {
        switch edge {
        case .minXEdge: return minX
        case .maxXEdge: return maxX
        case .minYEdge: return minY
        case .maxYEdge: return maxY
        }
    }

    /// - returns: The `CGPoint` coordinate for the given corner.
    func corner(_ corner: Corner) -> CGPoint {
        return CGPoint(x: edge(corner.xEdge), y: edge(corner.yEdge))
    }

    /// - returns: A `CGRect` with size scaled to the provided scale factor,
    /// preserving the center.
    func scaled(by scale: CGFloat) -> CGRect {
        return CGRect(center: center, size: size * scale)
    }

    /// - returns: A `CGRect` with size scaled to the provided scale factor,
    /// preserving the specified corner.
    func scaled(by scale: CGFloat, corner: Corner) -> CGRect {
        return CGRect(size: size * scale, origin: self.corner(corner), inCorner: corner)
    }

    /// - returns: The `LineSegment` representing the provided edge.
    func lineSegment(for edge: CGRectEdge) -> LineSegment {
        let corners = edge.corners
        return LineSegment(a: corner(corners.0), b: corner(corners.1))
    }
}


extension CGRect: Drawable {
    var path: CGPath? {
        return CGPath(rect: self, transform: nil)
    }
}

extension CGRect: Shape {
    var area: CGFloat {
        return size.area
    }

    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }

    var perimeter: CGFloat {
        return (2.0 * width) + (2.0 * height)
    }

    var boundingRect: CGRect { return self }
}

extension CGRect: PolygonType {
    var edgeCount: Int {
        return 4
    }
    var points: [CGPoint] {
        return CoordinateSystem.default.corners.map { self.corner($0) }
    }
    var lineSegments: [LineSegment] {
        return CoordinateSystem.default.edges.map { lineSegment(for: $0) }
    }
}
