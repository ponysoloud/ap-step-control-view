//
//  APStepControlView.swift
//  APStepControlView
//
//  Created by Александр Пономарев on 24.04.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

public class APStepControlView: UIView {

    // MARK: - Public Properties

    public weak var delegate: APStepControlViewDelegate?

    public var stepsCount: Int {
        return steps.count
    }

    /**
     Defines color scheme of the Common Element in ControlView.
     */
    public struct CommonColorStyle {
        public var circle: UIColor
    }

    /**
     Defines color scheme of the Peek Element in ControlView.
     */
    public struct PeekColorStyle {
        public var circle: UIColor
        public var borderColor: UIColor
    }

    /**
     Color style of the Common Indicators (all elements in ControlView excepting last).

     Use it to configure elements shapes colors.
     */
    public var commonIndicatorColorStyle = CommonColorStyle(circle: .red) {
        didSet {
            reloadSteps()
        }
    }

    /**
     Color style of the Peek Indicator (last element in ControlView).

     Use it to configure elements shapes colors.
     */
    public var peekIndicatorColorStyle = PeekColorStyle(circle: .darkGray, borderColor: .gray) {
        didSet {
            reloadSteps()
        }
    }

    // MARK: - Private Properties
    private var steps: [APStepIndicator] = []
    private var size: CGSize

    // LongPress Behaviour properties
    private var beginPosition: CGFloat = 0.0
    private var lastIndexOffset: Int = 0
    private var stepsCountBeforeChanging: Int = 0

    public convenience init(stepsCount: Int) {
        self.init(frame: CGRect.zero)

        for _ in 0..<stepsCount {
            push()
        }

        applyLongPressGestureRecognizer()
    }

    override public init(frame: CGRect) {
        self.size = frame.size

        super.init(frame: frame)

        applyLongPressGestureRecognizer()
    }

    required public init?(coder aDecoder: NSCoder) {
        self.size = CGSize.zero

        super.init(coder: aDecoder)

        applyLongPressGestureRecognizer()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        invalidateIntrinsicContentSize()
    }

    override public var bounds: CGRect {
        willSet {
            if newValue.height != bounds.height {
                self.size = newValue.size
                reloadSteps()
            }
        }
    }

    override public var intrinsicContentSize: CGSize {
        let width = bounds.height * CGFloat(steps.count)
        return CGSize(width: width, height: bounds.height)
    }
}

extension APStepControlView {

    /**
     Add element to the end of steps list.

     It doesn't call delegates methods.
    */
    public func push() {
        let size = CGSize(width: self.size.height, height: self.size.height)
        let point = CGPoint(x: self.size.height * CGFloat(steps.count), y: 0.0)
        let rect = CGRect(origin: point, size: size)

        let step = APStepIndicator(frame: rect)
        addSubview(step)

        steps.last?.setState(.common)
        steps.last?.setColorStyle(.common(circle: commonIndicatorColorStyle.circle))

        steps.append(step)
        step.setState(.peek)
        step.setColorStyle(.peek(circle: peekIndicatorColorStyle.circle, border: peekIndicatorColorStyle.borderColor))
    }

    /**
     Forced remove element from the end of steps list.

     If list is empty, it does nothing.

     It doesn't call delegates methods and ignore shouldPopStep function.
    */
    public func pop() {
        guard let last = steps.popLast() else {
            return
        }

        let newLast = steps.last

        last.setState(.clear) {
            last.removeFromSuperview()

            newLast?.setState(.peek)
        }
    }

    // MARK: - Private Methods

    private func reloadSteps() {
        let count = steps.count

        steps.forEach {
            $0.removeFromSuperview()
        }
        steps.removeAll()

        for _ in 0..<count {
            push()
        }
    }

    private func applyLongPressGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        gestureRecognizer.minimumPressDuration = 0.01

        addGestureRecognizer(gestureRecognizer)
    }

    @objc
    private func handleLongPress(gesture : UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            beginPosition = gesture.location(in: self).x

            stepsCountBeforeChanging = steps.count

            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity.scaledBy(x: 1.05, y: 1.05)
            })
        case .changed:
            let offset = gesture.location(in: self).x - beginPosition
            let indexOffset = Int((offset / self.size.height).rounded())

            guard offset < 0, indexOffset != lastIndexOffset else {
                return
            }

            if abs(indexOffset) > abs(lastIndexOffset) {
                // move left
                if steps.count > 0 {
                    guard let shouldPop = delegate?.apStepControlView(self, shouldPopStepWithIndex: steps.count - 1) else {

                        self.pop()

                        lastIndexOffset = indexOffset
                        break
                    }

                    if shouldPop {
                        self.pop()
                    }
                }
            } else {
                // move right
                if steps.count < stepsCountBeforeChanging {
                    self.push()
                }
            }

            lastIndexOffset = indexOffset

        case .ended, .cancelled:

            delegate?.apStepControlView(self, didChangeStepsCountFrom: stepsCountBeforeChanging, to: steps.count)

            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        default:
            break
        }
    }
}

