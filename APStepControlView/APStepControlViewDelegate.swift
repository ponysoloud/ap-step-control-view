//
//  APStepControlViewDelegate.swift
//  APStepControlView
//
//  Created by Александр Пономарев on 24.04.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

public protocol APStepControlViewDelegate: class {

    func stepsNavigationView(_ stepsNavigationView: APStepControlView, didChangeStepsCountFrom count: Int, to newCount: Int)

    func stepsNavigationView(_ stepsNavigationView: APStepControlView, shouldPopStepWithIndex index: Int) -> Bool

}

extension APStepControlViewDelegate {

    func stepsNavigationView(_ stepsNavigationView: APStepControlView, didChangeStepsCountFrom count: Int, to newCount: Int) { }
}
