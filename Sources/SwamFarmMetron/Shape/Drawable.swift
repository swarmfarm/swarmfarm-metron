import CoreGraphics

/**
 *  Any figure from which a path can be derived
 *  that can then be drawn.
 */
protocol Drawable {
    var path: CGPath? { get }
}
