import CoreGraphics

extension Comparable {
    /// - returns: Value clipped to the provided minimum (first argument)
    /// and maximum (second argument).
    /// - note: no check is made whether the provided minimum is lower than
    /// the provided maximum.
    func clipped(_ minValue: Self, _ maxValue: Self) -> Self {
        return max(minValue, min(self, maxValue))
    }

    /// - returns: true if the value is between the 
    /// provided lower and upper limits.
    func between(lower: Self, upper: Self) -> Bool {
        return self >= min(lower, upper) &&
        self <= max(lower, upper)
    }
}

/// Represents entities that can logically be summed.
/// (For example, angles).
protocol Summable {
    static func +(lhs: Self, rhs: Self) -> Self
}
