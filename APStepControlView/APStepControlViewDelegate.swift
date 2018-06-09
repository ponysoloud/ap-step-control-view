//
//  APStepControlViewDelegate.swift
//  APStepControlView
//
//  Created by Александр Пономарев on 24.04.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

public protocol APStepControlViewDelegate: AnyObject {

    /**
     Notify about changing steps count in list when long press ends.

     - parameters:
        - apStepControlView: The APStepControlView object
        - count: Count of step before long press
        - newCount: Count of step after long press
    */
    func apStepControlView(_ apStepControlView: APStepControlView, didChangeStepsCountFrom count: Int, to newCount: Int)

    /**
     Ask to pop object during long press interaction with index.

     - parameters:
        - apStepControlView: The APStepControlView object
        - index: Index of the element to pop in the list (from zero)
    */
    func apStepControlView(_ apStepControlView: APStepControlView, shouldPopStepWithIndex index: Int) -> Bool

}

public extension APStepControlViewDelegate {

    func apStepControlView(_ apStepControlView: APStepControlView, didChangeStepsCountFrom count: Int, to newCount: Int) { }
}
