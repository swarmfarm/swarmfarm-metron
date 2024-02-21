import CoreGraphics

// MARK: Triangle Helpers

/// A Vertex is a meeting point of two lines forming an angle.
public typealias Vertex = CGPoint

/// A Triplet is an (a, b, c) representation of
/// three related values of a specific type.
struct Triplet<T> {
    var a: T
    var b: T
    var c: T

    init(a: T, b: T, c: T) {
        self.a = a
        self.b = b
        self.c = c
    }

    init?(_ array: [T]) {
        guard array.count == 3 else { return nil }
        self.a = array[0]
        self.b = array[1]
        self.c = array[2]
    }

    var asArray: [T] {
        return [a, b, c]
    }
}

extension Triplet where T: Summable {
    var sum: T {
        return a + b + c
    }
}

// MARK: Triangle

/**
 *  A `Triangle` is a shape with three straight sides and three angles.
 *  It is defined by its three vertices, the points where the sides
 *  meet.
 */
struct Triangle {
    var vertices: Triplet<Vertex>

    init(_ verticesTriplet: Triplet<Vertex>) {
        self.vertices = verticesTriplet
    }

    init(a: Vertex, b: Vertex, c: Vertex) {
        self.vertices = Triplet<Vertex>(a: a, b: b, c: c)
    }
}


extension Triangle {

    var vertexA: Vertex {
        return vertices.a
    }
    var vertexB: Vertex {
        return vertices.b
    }
    var vertexC: Vertex {
        return vertices.c
    }
}

extension Triangle {

    /// Side A is opposite `vertexA`.
    var sideA: LineSegment {
        return LineSegment(a: vertices.b, b: vertices.c)
    }
    /// Side B is opposite `vertexB`.
    var sideB: LineSegment {
        return LineSegment(a: vertices.c, b: vertices.a)
    }
    /// Side C is opposite `vertexC`.
    var sideC: LineSegment {
        return LineSegment(a: vertices.a, b: vertices.b)
    }

    /// All sides as `Triplet`.
    var sides: Triplet<LineSegment> {
        return Triplet(a: sideA, b: sideB, c: sideC)
    }
}

extension Triangle {

    /// Angle A is the angle at vertex A,
    /// from side C to side B.
    var angleA: Angle {
        return angles.a
    }

    /// Angle B is the angle at vertex B,
    /// from side A to side C.
    var angleB: Angle {
        return angles.b
    }

    /// Angle C is the angle at vertex C,
    /// from side B to side A.
    var angleC: Angle {
        return angles.c
    }

    /// All angles as `Triplet`. These are calculated together
    /// to guarantee the angles are not inversed (negative or reflex).
    var angles: Triplet<Angle> {
        let a = vertexA.angle(previous: vertexC, next: vertexB)
        let b = vertexB.angle(previous: vertexA, next: vertexC)
        let c = vertexC.angle(previous: vertexB, next: vertexA)

        if a.value < 0 || b.value < 0 || c.value < 0 {
            return Triplet(a: a.inversed, b: b.inversed, c: c.inversed)
        }
        return Triplet(a: a, b: b, c: c)
    }
}

extension Triangle {

    /// An angle bisector divides the angle into two angles with equal measures.
    /// `angleBisectorA` bisects `angleA`.
    var angleBisectorA: LineSegment {
        return LineSegment(a: vertices.a, b: vertices.b).rotatedAroundA(0.5 * angleA)
    }

    /// An angle bisector divides the angle into two angles with equal measures.
    /// `angleBisectorB` bisects `angleB`.
    var angleBisectorB: LineSegment {
        return LineSegment(a: vertices.b, b: vertices.c).rotatedAroundA(0.5 * angleB)
    }

    /// An angle bisector divides the angle into two angles with equal measures.
    /// `angleBisectorC` bisects `angleC`.
    var angleBisectorC: LineSegment {
        return LineSegment(a: vertices.c, b: vertices.a).rotatedAroundA(0.5 * angleC)
    }

    /// All angle bisectors as `Triplet`.
    var angleBisectors: Triplet<LineSegment> {
        return Triplet(a: angleBisectorA, b: angleBisectorB, c: angleBisectorC)
    }
}

extension Triangle {

    /// An altitude of a triangle is a straight line through a vertex 
    /// and perpendicular to the opposite side.
    /// `altitudeA` goes perpendicular from `sideA` to `vertexA`.
    var altitudeA: LineSegment {
        let line = sideA.line.perpendicular(through: vertexA)
        return line.segment(between: line.intersection(with: sideA)!, and: vertexA)!
    }

    /// An altitude of a triangle is a straight line through a vertex
    /// and perpendicular to the opposite side.
    /// `altitudeB` goes perpendicular from `sideB` to `vertexB`.
    var altitudeB: LineSegment {
        let line = sideB.line.perpendicular(through: vertexB)
        return line.segment(between: line.intersection(with: sideB)!, and: vertexB)!
    }

    /// An altitude of a triangle is a straight line through a vertex
    /// and perpendicular to the opposite side.
    /// `altitudeC` goes perpendicular from `sideC` to `vertexC`.
    var altitudeC: LineSegment {
        let line = sideC.line.perpendicular(through: vertexC)
        return line.segment(between: line.intersection(with: sideC)!, and: vertexC)!
    }

    /// All altitudes as `Triplet`.
    var altitudes: Triplet<LineSegment> {
        return Triplet(a: altitudeA, b: altitudeB, c: altitudeC)
    }
}

// MARK: Classification

extension Triangle {

    //  By lengths of sides

    /// True if all sides are equal.
    var isEquilateral: Bool {
        let sides = self.sides
        let (a, b, c) = (sides.a.length, sides.b.length, sides.c.length)
        return a == b &&
            a == c
    }

    /// True iff two sides are equal.
    var isIsosceles: Bool {
        let sides = self.sides
        let (a, b, c) = (sides.a.length, sides.b.length, sides.c.length)
        return (a == b && a != c) ||
            (a == c && a != b) ||
            (b == c && a != b)
    }

    /// True if all sides are different.
    var isScalene: Bool {
        let sides = self.sides
        let (a, b, c) = (sides.a.length, sides.b.length, sides.c.length)
        return a != b && a != c && b != c
    }

    //  By internal angles

    /// True if one angle is exactly 90°.
    var isRight: Bool {
        return angles.asArray.first { round($0.degrees) == 90.0 } != nil
    }
    /// True of no angle is 90°.
    var isOblique: Bool {
        return !isRight
    }

    /// True if all angles are less than 90°.
    var isAcute: Bool {
        return angles.asArray.reduce(true, { return $0 && $1.degrees < 90.0 })
    }
    /// True if one angle is more than 90°.
    var isObtuse: Bool {
        return !isAcute
    }
}

extension Triangle {

    /// The intersection of the lines drawn from each 
    /// vertex to the midpoint of the other side.
    var centroid: CGPoint {
        return CGPoint(x: (vertexA.x + vertexB.x + vertexC.x) / 3.0,
            y: (vertexA.y + vertexB.y + vertexC.y) / 3.0)
    }

    /// The interscetion of each side's perpendicular bisector
    /// (a perpendicular line drawn from the midpoint of a side).
    var circumcenter: CGPoint {
        let perpendicularBisectorA = sideA.line.perpendicular(through: sideA.midpoint)
        let perpendicularBisectorB = sideB.line.perpendicular(through: sideB.midpoint)
        return perpendicularBisectorA.intersection(with: perpendicularBisectorB)!
    }

    /// The intersection of each angle's bisector
    /// (An angle bisector divides the angle into two angles with equal measures).
    var incenter: CGPoint {
        return angleBisectorA.intersection(with: angleBisectorB)!
    }

    /// The intersection of each side's altitude
    /// (a line drawn at right angle to a side and going through the opposite vertex).
    var orthocenter: CGPoint {
        return altitudeA.intersection(with: altitudeB)!
    }
}

// MARK: Polygon

extension Triangle: PolygonType {

    var edgeCount: Int {
        return 3
    }

    var points: [CGPoint] {
        return vertices.asArray
    }

    var lineSegments: [LineSegment] {
        return sides.asArray
    }
}

extension Triangle: Drawable {

    var path: CGPath? {
        let path = CGMutablePath()
        path.move(to: vertices.a)
        path.addLine(to: vertices.b)
        path.addLine(to: vertices.c)

        path.closeSubpath()
        return path.copy()
    }
}

extension Triangle: Shape {

    var area: CGFloat {
        //  Heron's Formula
        let s = perimeter / 2.0
        return sqrt(s * (s - sideA.length) * (s - sideB.length) * (s - sideC.length))
    }

    var perimeter: CGFloat {
        return lineSegments.reduce(CGFloat(0.0), { $0 + $1.length })
    }

    /// This returns the most common of triangle centers, the centroid.
    var center: CGPoint {
        return centroid
    }

    /// Extremities:
    var minX: CGFloat {
        return vertices.asArray.reduce(CGFloat.greatestFiniteMagnitude, { current, point -> CGFloat in
            return min(current, point.x)
        })
    }
    var maxX: CGFloat {
        return vertices.asArray.reduce(-CGFloat.greatestFiniteMagnitude, { current, point -> CGFloat in
            return max(current, point.x)
        })
    }
    var minY: CGFloat {
        return vertices.asArray.reduce(CGFloat.greatestFiniteMagnitude, { current, point -> CGFloat in
            return min(current, point.y)
        })
    }
    var maxY: CGFloat {
        return vertices.asArray.reduce(-CGFloat.greatestFiniteMagnitude, { current, point -> CGFloat in
            return max(current, point.y)
        })
    }

    /// Midpoints:
    var midX: CGFloat {
        let minX = self.minX
        return minX + ((maxX - minX) / 2.0)
    }
    var midY: CGFloat {
        let minY = self.minY
        return minY + ((maxY - minY) / 2.0)
    }

    var width: CGFloat { return maxX - minX }
    var height: CGFloat { return maxY - minY }

    var boundingRect: CGRect {
        return CGRect(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }

    func contains(_ point: CGPoint) -> Bool {
        let planeDirection: (Vertex, Vertex) -> CGFloat = { v1, v2 in
            let plane = (v1.x - point.x) * (v2.y - point.y) - (v2.x - point.x) * (v1.y - point.y)
            return abs(plane) / plane
        }
        let dirAB = planeDirection(vertices.a, vertices.b)
        let dirBC = planeDirection(vertices.b, vertices.c)
        let dirCA = planeDirection(vertices.c, vertices.a)

        return dirAB == dirBC && dirBC == dirCA
    }
}


// MARK: CustomDebugStringConvertible

extension Triangle: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Triangle {a: \(vertexA), b: \(vertexB), c: \(vertexC)}"
    }
}

extension Triplet: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Triplet {a: \(a), b: \(b), c: \(c)}"
    }
}
