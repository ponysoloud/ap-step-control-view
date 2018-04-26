//
//  APStepControlViewDelegate.swift
//  APStepControlView
//
//  Created by Александр Пономарев on 24.04.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

public protocol APStepControlViewDelegate: class {

    /**
     Notify about changing steps count in list when long press ending.

     - parameters:
        - apStepControlView: The APStepControlView object
        - count: Count of step before last editing
        - newCount: Count of step after last editing
    */
    func apStepControlView(_ apStepControlView: APStepControlView, didChangeStepsCountFrom count: Int, to newCount: Int)

    /**
     Ask to pop object with index.

     - parameters:
        - apStepControlView: The APStepControlView object
        - index: Index of the popping element in the list (from zero)
    */
    func apStepControlView(_ apStepControlView: APStepControlView, shouldPopStepWithIndex index: Int) -> Bool

}

extension APStepControlViewDelegate {

    func apStepControlView(_ apStepControlView: APStepControlView, didChangeStepsCountFrom count: Int, to newCount: Int) { }
}
