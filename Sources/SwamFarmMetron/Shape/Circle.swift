import CoreGraphics

/**
 *  A `Circle` represented by a center and a radius.
 */
struct Circle {

    /// The center of the circle.
    var center: CGPoint

    /// The radius of the circle, i.e. the distance
    /// from the center to the edge of the circle.
    var radius: CGFloat

    init(center: CGPoint, radius: CGFloat) {
        self.center = center
        self.radius = radius
    }
}

extension Circle {

    /// Initializes a `Circle` with radius equal to
    /// half of the provided diameter.
    init(center: CGPoint, diameter: CGFloat) {
        self.init(center: center, radius: diameter / 2.0)
    }

    /// Initializes a `Circle` that is aspect-fitted
    /// in the center of the provided rect.
    init(in rect: CGRect) {
        self.init(in: Square(in: rect))
    }

    /// Initializes a `Circle` that is fitted in the
    /// provided square.
    init(in square: Square) {
        self.init(center: square.center, diameter: square.edges)
    }

    /// The diamater, equal to 2 times the radius.
    var diameter: CGFloat {
        return radius * 2.0
    }

    /// The length of the enclosing boundary.
    var circumference: CGFloat {
        return diameter * .pi
    }

    /// - returns: The bounding square for this circle.
    var square: Square {
        return Square(origin: CGPoint(x: minX, y: minY), edges: diameter)
    }
}

extension Circle {

    /// - returns: An array of CGPoints along the perimeter of this circle.
    /// The circle is divided into `segments`, which can also be a non-integer number.
    /// The points are taken `startingAt` a specific angle and `rotating` in a 
    /// specific direction (`clockwise` by default), .
    func pointsAlongPerimeter(dividedInto segments: CGFloat, startingAt startingAngle: Angle = Angle(0), rotating: RotationDirection = .clockwise) -> [CGPoint] {
        guard segments > 0 else { return [] }
        let fullRotation = Angle.fullRotation(unit: .radians)
        let step = fullRotation / segments

        var offset: CGFloat = 0.0
        var points: [CGPoint] = []

        let steppingRunsClockwise = CoordinateSystem.default.circleRunsClockwise
        let shouldStepBackwards = steppingRunsClockwise != (rotating == .clockwise)

        while offset < fullRotation {
            let angle = shouldStepBackwards ? (startingAngle - Angle(offset)) : (startingAngle + Angle(offset))
            let vector = CGVector(angle: angle, magnitude: radius)
            let point = center + vector
            points.append(point)
            offset += step
        }

        return points
    }
}

// MARK: Drawable

extension Circle: Drawable {
    var path: CGPath? {
        return CGPath(ellipseIn: boundingRect, transform: nil)
    }
}

// MARK: Shape

extension Circle: Shape {

    var area: CGFloat {
        return radius * radius * .pi
    }

    var perimeter: CGFloat {
        return circumference
    }

    /// Extremities:
    var minX: CGFloat { return center.x - radius }
    var maxX: CGFloat { return center.x + radius }
    var minY: CGFloat { return center.y - radius }
    var maxY: CGFloat { return center.y + radius }

    /// Midpoints:
    var midX: CGFloat { return center.x }
    var midY: CGFloat { return center.y }

    var width: CGFloat { return diameter }
    var height: CGFloat { return diameter }

    /// The smallest rect in which the circle can be fitted.
    var boundingRect: CGRect {
        return CGRect(center: center, edges: diameter)
    }

    func contains(_ point: CGPoint) -> Bool {
        return center.distance(to: point) <= radius
    }
}

// MARK: Equatable / Comparable

extension Circle: Equatable {
    /// True if the radius is the same, regardless of center
    public static func ==(lhs: Circle, rhs: Circle) -> Bool {
        return lhs.radius == rhs.radius
    }
}

/// True if radius and center are the same
func ===(lhs: Circle, rhs: Circle) -> Bool {
    return lhs.radius == rhs.radius &&
        lhs.center == rhs.center
}

extension Circle: Comparable {
    public static func <(lhs: Circle, rhs: Circle) -> Bool {
        return lhs.radius < rhs.radius
    }
}

// MARK: CustomDebugStringConvertible

extension Circle: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Circle {center: \(center), radius: \(radius)}"
    }
}
