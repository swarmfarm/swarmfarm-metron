import CoreGraphics

/**
 *  An edge is an outside limit of an area.
 *  The point where two edges meet is a corner.
 */
protocol EdgeType {
    associatedtype CornerType

    var corners: (CornerType, CornerType) { get }

    var axis: Axis { get }
}
