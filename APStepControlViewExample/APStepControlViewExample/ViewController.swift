//
//  ViewController.swift
//  APStepControlViewExample
//
//  Created by Александр Пономарев on 25.04.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import UIKit
import APStepControlView

class ViewController: UIViewController, APStepControlViewDelegate {

    var stepControl: APStepControlView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize
        stepControl = APStepControlView(stepsCount: 3)
        stepControl.delegate = self

        view.addSubview(stepControl)

        // Set color for regular state of steps
        stepControl.commonIndicatorColorStyle.circle = .black
        stepControl.peekIndicatorColorStyle.borderColor = .lightGray

        // Add constraints - fix height, vertical and horizontal position. Width is free for increasing and decreasing
        stepControl.translatesAutoresizingMaskIntoConstraints = false
        stepControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 250.0).isActive = true
        stepControl.heightAnchor.constraint(equalToConstant: 40.0).isActive = true

        // View position can be fix with center
        //stepControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // View can be fixing with left or right anchors
        stepControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 70.0).isActive = true


        // Add push Button
        let pushRect = CGRect(x: 200, y: 400, width: 70, height: 40)
        let pushButton = UIButton(frame: pushRect)
        pushButton.setTitle("Push", for: .normal)
        pushButton.setTitleColor(.black, for: .normal)
        pushButton.addTarget(self, action: #selector(push(_:)), for: .touchUpInside)

        view.addSubview(pushButton)

        // Add pop Button
        let popRect = CGRect(x: 200, y: 500, width: 70, height: 40)
        let popButton = UIButton(frame: popRect)
        popButton.setTitle("Pop", for: .normal)
        popButton.setTitleColor(.black, for: .normal)
        popButton.addTarget(self, action: #selector(pop(_:)), for: .touchUpInside)

        view.addSubview(popButton)
    }

    @objc
    func push(_ sender: Any) {
        stepControl.push()
    }

    @objc
    func pop(_ sender: Any) {
        stepControl.pop()
    }

    // Implementing APStepControlViewDelegate

    func apStepControlView(_ apStepControlView: APStepControlView, shouldPopStepWithIndex index: Int) -> Bool {
        return index > 0 // Count of steps in control view is always greater 0. Notice: pop() method of Control View don't ask for a delegate.
    }

    func apStepControlView(_ apStepControlView: APStepControlView, didChangeStepsCountFrom count: Int, to newCount: Int) {
        print("Number of steps changed from \(count) to \(newCount)")
    }
}

