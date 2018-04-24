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

        stepControl = APStepControlView(sectionsCount: 3)
        stepControl.delegate = self

        view.addSubview(stepControl)

        stepControl.translatesAutoresizingMaskIntoConstraints = false
        //stepControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30.0).isActive = true
        stepControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.0).isActive = true
        stepControl.heightAnchor.constraint(equalToConstant: 40.0).isActive = true


        let pushRect = CGRect(x: 40, y: 200, width: 70, height: 40)
        let pushButton = UIButton(frame: pushRect)
        pushButton.setTitle("Push", for: .normal)
        pushButton.setTitleColor(.black, for: .normal)
        pushButton.addTarget(self, action: #selector(push(_:)), for: .touchUpInside)

        view.addSubview(pushButton)


        let popRect = CGRect(x: 40, y: 250, width: 70, height: 40)
        let popButton = UIButton(frame: popRect)
        popButton.setTitle("Pop", for: .normal)
        popButton.setTitleColor(.black, for: .normal)
        popButton.addTarget(self, action: #selector(pop(_:)), for: .touchUpInside)

        view.addSubview(popButton)
    }

    func stepsNavigationView(_ stepsNavigationView: APStepControlView, shouldPopStepWithIndex index: Int) -> Bool {
        return index > 0
    }

    func stepsNavigationView(_ stepsNavigationView: APStepControlView, didChangeStepsCountFrom count: Int, to newCount: Int) {
        print("Number of steps changed from \(count) to \(newCount)")
    }

    @objc
    func push(_ sender: Any) {
        stepControl.push()
    }

    @objc
    func pop(_ sender: Any) {
        stepControl.pop()
    }

}

