//
//  APStepIndicator.swift
//  APStepControlView
//
//  Created by Alexander Ponomarev on 24.04.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

/**
 Element of the ControlView.
 */
class APStepIndicator: UIView {

    /**
     Indicator Positions in ControlView
     */
    enum StackPosition {
        case peek
        case common
        case clear
    }

    class Circle: UIView {

        override init(frame: CGRect) {
            super.init(frame: frame)
            isOpaque = false
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        var radius: CGFloat = 0.0 {
            didSet {
                setNeedsDisplay()
            }
        }

        var color: UIColor = .clear {
            didSet {
                setNeedsDisplay()
            }
        }

        override func draw(_ rect: CGRect) {
            let context = UIGraphicsGetCurrentContext()

            let center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)

            context?.move(to: center)

            // Draw fill circle
            let fillSize = CGSize(width: radius * 2, height: radius * 2)
            let fillOrigin = CGPoint(x: center.x - radius, y: center.y - radius)
            let fillRect = CGRect(origin: fillOrigin, size: fillSize)

            context?.setFillColor(color.cgColor)
            context?.fillEllipse(in: fillRect)
        }
    }

    private var smallCircle: Circle?
    private var borderCircle: Circle?

    private var state: StackPosition = .clear

    // MARK: - Private colors properties

    private var commonCircleColor: UIColor = .red {
        didSet {
            if state == .common {
                smallCircle?.color = commonCircleColor
            }
        }
    }
    private var peekCircleColor: UIColor = .darkGray {
        didSet {
            if state == .peek {
                smallCircle?.color = peekCircleColor
            }
        }
    }
    private var peekBorderColor: UIColor = .gray {
        didSet {
            if state == .peek {
                borderCircle?.color = peekBorderColor
            }
        }
    }

    // MARK: - Internal Indicator configuration methods

    enum ColorStyle {
        case peek(circle: UIColor, border: UIColor)
        case common(circle: UIColor)
    }

    func setColorStyle(_ colorStyle: ColorStyle) {
        switch colorStyle {
        case let .peek(circle: circleColor, border: borderColor):
            peekCircleColor = circleColor
            peekBorderColor = borderColor
        case let .common(circle: circleColor):
            commonCircleColor = circleColor
        }
    }

    func setState(_ newState: StackPosition, completion: @escaping () -> Void = {}) {
        switch state {
        case .peek:
            switch newState {
            case .common:
                animateBorderDisappearing {
                    self.borderCircle?.removeFromSuperview()
                    self.borderCircle = nil

                    self.smallCircle?.color = self.commonCircleColor

                    completion()
                }
            case .clear:
                let group = DispatchGroup()

                group.enter()
                animateSmallDisappearing {
                    self.smallCircle?.removeFromSuperview()
                    self.smallCircle = nil

                    group.leave()
                }

                group.enter()
                animateBorderDisappearing {
                    self.borderCircle?.removeFromSuperview()
                    self.borderCircle = nil

                    group.leave()
                }

                group.notify(queue: .main, execute: completion)

            case .peek:
                break
            }
        case .common:
            switch newState {
            case .peek:
                borderCircle?.removeFromSuperview()

                let side = min(frame.width, frame.height)

                borderCircle = Circle(frame: self.bounds)
                borderCircle!.radius = side / 2
                borderCircle!.color = self.peekBorderColor
                insertSubview(borderCircle!, belowSubview: smallCircle!)

                smallCircle!.color = self.peekCircleColor

                animateBorderAppearing(completion: completion)

            case .clear:
                animateSmallDisappearing {
                    self.smallCircle?.removeFromSuperview()
                    self.smallCircle = nil

                    completion()
                }
            case .common:
                break
            }
        case .clear:
            switch newState {
            case .peek:
                smallCircle?.removeFromSuperview()
                borderCircle?.removeFromSuperview()

                let side = min(frame.width, frame.height)
                let mainRadius = (side / 2) * 0.6

                borderCircle = Circle(frame: self.bounds)
                borderCircle!.radius = side / 2
                borderCircle!.color = self.peekBorderColor
                addSubview(borderCircle!)

                smallCircle = Circle(frame: self.bounds)
                smallCircle!.radius = mainRadius
                smallCircle!.color = self.peekCircleColor
                addSubview(smallCircle!)

                animateSmallCircleAppearing()
                animateBorderAppearing(completion: completion)

            case .common:
                smallCircle?.removeFromSuperview()
                borderCircle?.removeFromSuperview()

                let side = min(frame.width, frame.height)
                let mainRadius = (side / 2) * 0.6

                borderCircle = nil

                smallCircle = Circle(frame: self.bounds)
                smallCircle!.radius = mainRadius
                smallCircle!.color = self.commonCircleColor
                addSubview(smallCircle!)

                animateSmallCircleAppearing(completion: completion)

            case .clear:
                break
            }
        }

        state = newState
    }
}

extension APStepIndicator {

    // MARK: - Private Indicator animation methods

    private func animateSmallCircleAppearing(completion: @escaping () -> Void = {}) {
        smallCircle?.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)

        UIView.animate(withDuration: 0.07, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.smallCircle?.transform = CGAffineTransform.identity
        }, completion: { _ in
            completion()
        })
    }

    private func animateBorderAppearing(completion: @escaping () -> Void = {}) {
        borderCircle?.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)

        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.borderCircle?.transform = CGAffineTransform.identity
        }, completion: { _ in
            completion()
        })
    }

    private func animateBorderDisappearing(completion: @escaping () -> Void = {}) {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            self.borderCircle?.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        }, completion: { _ in
            completion()
        })
    }

    private func animateSmallDisappearing(completion: @escaping () -> Void = {}) {
        UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
            self.smallCircle?.transform = CGAffineTransform.identity.scaledBy(x: 0.05, y: 0.05)
        }, completion: { _ in
            completion()
        })
    }
}

