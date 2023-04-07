//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit

extension Maker {

    // MARK: High priority

    /// Installs constant width for current instance.
    ///
    /// - parameter width: The width for instance.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func width(_ width: Number) -> Self {
        let handler = { [unowned self] in
            self.newRect.setValue(width.value, for: .width)
        }
        handlers.append((.high, handler))
        widthParameter = ValueParameter(value: width.value)
        return self
    }

    /// Creates width relation relatively another view = Aspect ratio.
    ///
    /// Use this method when you want that your view's width equals to another view's height with some multiplier, for example.
    ///
    /// - note: You can not use this method with other relations except for `nui_width` and `nui_height`.
    ///
    /// - parameter relationView:   The view on which you set relation.
    /// - parameter multiplier:     The multiplier for views relation. Default multiplier value: 1.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func width(to relationView: RelationView<SizeRelation>, multiplier: Number = 1.0) -> Self {
        let element = relationView.element
        let relationType = relationView.relationType

        let handler = { [unowned self] in
            if element != self.element {
                let width = self.relationSize(element: element, for: relationType) * multiplier.value
                self.newRect.setValue(width, for: .width)
            }
            else {
                if let parameter = self.heightParameter {
                    self.newRect.setValue(parameter.value * multiplier.value, for: .width)
                }
                else if let parameter = self.heightToParameter {
                    let width = self.relationSize(element: parameter.element, for: parameter.relationType) * (parameter.value * multiplier.value)
                    self.newRect.setValue(width, for: .width)
                }
                else {
                    guard let topParameter = self.topParameter, let bottomParameter = self.bottomParameter else {
                        return
                    }

                    let topViewY = self.convertedValue(for: topParameter.relationType, with: topParameter.element) + topParameter.value
                    let bottomViewY = self.convertedValue(for: bottomParameter.relationType, with: bottomParameter.element) - bottomParameter.value

                    self.newRect.setValue((bottomViewY - topViewY) * multiplier.value, for: .width)
                }
            }
        }
        handlers.append((.high, handler))
        widthToParameter = SideParameter(element: element, value: multiplier.value, relationType: relationType)
        return self

    }

    /// Installs constant height for current view.
    ///
    /// - parameter height: The height for view.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func height(_ height: Number) -> Self {
        let handler = { [unowned self] in
            self.newRect.setValue(height.value, for: .height)
        }
        handlers.append((.high, handler))
        heightParameter = ValueParameter(value: height.value)
        return self
    }

    /// Creates height relation relatively another view = Aspect ratio.
    ///
    /// Use this method when you want that your view's height equals to another view's width with some multiplier, for example.
    ///
    /// - note: You can not use this method with other relations except for `nui_width` and `nui_height`.
    ///
    /// - parameter relationView:   The view on which you set relation.
    /// - parameter multiplier:     The multiplier for views relation. Default multiplier value: 1.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func height(to relationView: RelationView<SizeRelation>, multiplier: Number = 1.0) -> Self {
        let element = relationView.element
        let relationType = relationView.relationType

        let handler = { [unowned self] in
            if element != self.element {
                let height = self.relationSize(element: element, for: relationType) * multiplier.value
                self.newRect.setValue(height, for: .height)
            }
            else {
                if let parameter = self.widthParameter {
                    self.newRect.setValue(parameter.value * multiplier.value, for: .height)
                }
                else if let parameter = self.widthToParameter {
                    let height = self.relationSize(element: parameter.element, for: parameter.relationType) * (parameter.value * multiplier.value)
                    self.newRect.setValue(height, for: .height)
                }
                else {
                    guard let leftParameter = self.leftParameter, let rightParameter = self.rightParameter else {
                        return
                    }

                    let leftViewX = self.convertedValue(for: leftParameter.relationType, with: leftParameter.element) + leftParameter.value
                    let rightViewX = self.convertedValue(for: rightParameter.relationType, with: rightParameter.element) - rightParameter.value

                    self.newRect.setValue((rightViewX - leftViewX) * multiplier.value, for: .height)
                }
            }
        }
        handlers.append((.high, handler))
        heightToParameter = SideParameter(element: element, value: multiplier.value, relationType: relationType)
        return self
    }

    /// Installs constant width and height at the same time.
    ///
    /// - parameter width:  The width for instance.
    /// - parameter height: The height for instance.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func size(width: Number, height: Number) -> Self {
        return self.width(width).height(height)
    }

    /// Installs constant width and height at the same time.
    ///
    /// - parameter size:  The size for instance.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func size(_ size: CGSize) -> Self {
        return self.size(width: size.width, height: size.height)
    }
    
    /// Resizes the current view so it just encloses its subviews.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func sizeToFit() -> Maker {
        view.sizeToFit()
        setHighPriorityValue(view.bounds.width, for: .width)
        setHighPriorityValue(view.bounds.height, for: .height)
        return self
    }

    /// Calculates the size that best fits the specified size.
    ///
    /// ```
    ///     maker.sizeThatFits(size: CGSize(width: cell.frame.width, height: cell.frame.height)
    /// ```
    /// - parameter size: The size for best-fitting.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func sizeThatFits(size: CGSize) -> Maker {
        let fitSize = view.sizeThatFits(size)
        let width = min(size.width, fitSize.width)
        let height = min(size.height, fitSize.height)
        setHighPriorityValue(width, for: .width)
        setHighPriorityValue(height, for: .height)
        return self
    }

    /// Resizes and moves the receiver view so it just encloses its subviews only for height.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func heightToFit() -> Maker {
        return heightThatFits(maxHeight: CGFloat.greatestFiniteMagnitude)
    }

    /// Calculates the height that best fits the specified size.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func heightThatFits(maxHeight: Number) -> Maker {
        let handler = { [unowned self] in
            let fitWidth: CGFloat

            if let parameter = self.widthParameter {
                fitWidth = parameter.value
            }
            else if let parameter = self.widthToParameter {
                fitWidth = self.relationSize(view: parameter.view, for: parameter.relationType) * parameter.value
            }
            else if let leftParameter = self.leftParameter, let rightParameter = self.rightParameter {
                let leftViewX = self.convertedValue(for: leftParameter.relationType, with: leftParameter.view) + leftParameter.value
                let rightViewX = self.convertedValue(for: rightParameter.relationType, with: rightParameter.view) - rightParameter.value

                fitWidth = rightViewX - leftViewX
            }
            else {
                fitWidth = .greatestFiniteMagnitude
            }

            let fitSize = self.view.sizeThatFits(CGSize(width: fitWidth, height: .greatestFiniteMagnitude))
            self.newRect.setValue(min(maxHeight.value, fitSize.height), for: .height)
        }
        handlers.append((.high, handler))
        return self
    }

    /// Resizes and moves the receiver view so it just encloses its subviews only for width.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func widthToFit() -> Maker {
        return widthThatFits(maxWidth: CGFloat.greatestFiniteMagnitude)
    }

    /// Calculates the width that best fits the specified size.
    ///
    /// - returns: `Maker` instance for chaining relations.
    @discardableResult public func widthThatFits(maxWidth: Number) -> Maker {
        let handler = { [unowned self] in
            let fitHeight: CGFloat

            if let parameter = self.heightParameter {
                fitHeight = parameter.value
            }
            else if let parameter = self.heightToParameter {
                fitHeight = self.relationSize(view: parameter.view, for: parameter.relationType) * parameter.value
            }
            else if let topParameter = self.topParameter, let bottomParameter = self.bottomParameter {
                let topViewY = self.convertedValue(for: topParameter.relationType, with: topParameter.view) + topParameter.value
                let bottomViewY = self.convertedValue(for: bottomParameter.relationType, with: bottomParameter.view) - bottomParameter.value

                fitHeight = bottomViewY - topViewY
            }
            else {
                fitHeight = .greatestFiniteMagnitude
            }

            let fitSize = self.view.sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: fitHeight))
            self.newRect.setValue(min(maxWidth.value, fitSize.width), for: .width)
        }

        handlers.append((.high, handler))
        return self
    }
}
