//
//  APStepIndicator.swift
//  APStepControlView
//
//  Created by Александр Пономарев on 24.04.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

class APStepIndicator: UIView {

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

    enum State {
        case last
        case regular
        case clear
    }

    enum StateCircle {
        case regular
        case last
        case lastBorder
    }

    private var state: State = .clear

    private var regularColor: UIColor = .red {
        didSet {
            if state == .regular {
                smallCircle?.color = regularColor
            }
        }
    }
    private var lastColor: UIColor = .darkGray {
        didSet {
            if state == .last {
                smallCircle?.color = lastColor
            }
        }
    }
    private var lastBorderColor: UIColor = .gray {
        didSet {
            if state == .last {
                borderCircle?.color = lastBorderColor
            }
        }
    }

    func setColor(_ color: UIColor, for state: StateCircle) {
        switch state {
        case .regular:
            regularColor = color
        case .last:
            lastColor = color
        case .lastBorder:
            lastBorderColor = color
        }
    }

    func setState(_ newState: State, completion: @escaping () -> Void = {}) {
        switch state {
        case .last:
            switch newState {
            case .regular:
                animateBorderDisappearing {
                    self.borderCircle?.removeFromSuperview()
                    self.borderCircle = nil

                    self.smallCircle?.color = self.regularColor

                    completion()
                }
            case .clear:
                animateSmallDisappearing {
                    self.smallCircle?.removeFromSuperview()
                    self.smallCircle = nil
                }

                animateBorderDisappearing {
                    self.borderCircle?.removeFromSuperview()
                    self.borderCircle = nil

                    completion()
                }

            default:
                break
            }
        case .regular:
            switch newState {
            case .last:
                borderCircle?.removeFromSuperview()

                let side = min(frame.width, frame.height)

                borderCircle = Circle(frame: self.bounds)
                borderCircle!.radius = side / 2
                borderCircle!.color = self.lastBorderColor
                insertSubview(borderCircle!, belowSubview: smallCircle!)

                smallCircle!.color = self.lastColor

                animateBorderAppearing(completion: completion)

            case .clear:
                animateSmallDisappearing {
                    self.smallCircle?.removeFromSuperview()
                    self.smallCircle = nil

                    completion()
                }
            default:
                break
            }
        case .clear:
            switch newState {
            case .last:
                smallCircle?.removeFromSuperview()
                borderCircle?.removeFromSuperview()

                let side = min(frame.width, frame.height)
                let mainRadius = (side / 2) * 0.6

                borderCircle = Circle(frame: self.bounds)
                borderCircle!.radius = side / 2
                borderCircle!.color = self.lastBorderColor
                addSubview(borderCircle!)

                smallCircle = Circle(frame: self.bounds)
                smallCircle!.radius = mainRadius
                smallCircle!.color = self.lastColor
                addSubview(smallCircle!)

                animateSmallCircleAppearing()
                animateBorderAppearing(completion: completion)

            case .regular:
                smallCircle?.removeFromSuperview()
                borderCircle?.removeFromSuperview()

                let side = min(frame.width, frame.height)
                let mainRadius = (side / 2) * 0.6

                borderCircle = nil

                smallCircle = Circle(frame: self.bounds)
                smallCircle!.radius = mainRadius
                smallCircle!.color = self.regularColor
                addSubview(smallCircle!)

                animateSmallCircleAppearing(completion: completion)

            default:
                break
            }
        }

        state = newState
    }
}

extension APStepIndicator {

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

