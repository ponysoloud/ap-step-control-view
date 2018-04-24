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

    // MARK: - Private Properties

    private var steps: [APStepIndicator] = []
    private var size: CGSize

    // LongPress Behaviour properties
    private var beginPosition: CGFloat = 0.0
    private var lastIndexOffset: Int = 0
    private var stepsCountBeforeChanging: Int = 0

    public convenience init(sectionsCount: Int) {
        self.init(frame: CGRect.zero)

        for _ in 0..<sectionsCount {
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

    public enum StepIndicatorStateCircle {
        case regular
        case last
        case lastBorder
    }

    // MARK: - Public Methods

    public func setColor(_ color: UIColor, for state: StepIndicatorStateCircle) {
        var internalState: APStepIndicator.StateCircle

        switch state {
        case .regular:
            internalState = .regular
        case .last:
            internalState = .last
        case .lastBorder:
            internalState = .lastBorder
        }


        steps.forEach {
            $0.setColor(color, for: internalState)
        }
    }

    public func push() {
        let size = CGSize(width: self.size.height, height: self.size.height)
        let point = CGPoint(x: self.size.height * CGFloat(steps.count), y: 0.0)
        let rect = CGRect(origin: point, size: size)

        let step = APStepIndicator(frame: rect)
        addSubview(step)

        steps.last?.setState(.regular)
        steps.append(step)
        step.setState(.last)
    }

    public func pop() {
        guard let last = steps.popLast() else {
            return
        }

        let newLast = steps.last

        last.setState(.clear) {
            last.removeFromSuperview()

            newLast?.setState(.last)
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
                    guard let shouldPop = delegate?.stepsNavigationView(self, shouldPopStepWithIndex: steps.count - 1) else {

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

            delegate?.stepsNavigationView(self, didChangeStepsCountFrom: stepsCountBeforeChanging, to: steps.count)

            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        default:
            break
        }
    }
}

