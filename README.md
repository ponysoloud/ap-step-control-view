# APStepControlView

[![Version](https://img.shields.io/cocoapods/v/APStepControlView.svg?style=flat)](https://cocoapods.org/pods/APStepControlView)
[![License](https://img.shields.io/cocoapods/l/APStepControlView.svg?style=flat)](https://cocoapods.org/pods/APStepControlView)
[![Platform](https://img.shields.io/cocoapods/p/APStepControlView.svg?style=flat)](https://cocoapods.org/pods/APStepControlView)
[![Swift](https://img.shields.io/badge/swift-4.0-lightgrey.svg?style=flat)](https://cocoapods.org/pods/APStepControlView)

`APStepControlView` is beautiful control element that provides to user easy and lovely way to decrease count of elements in list. It may be useful to manipulate with `Navigation controller` hierarchy.

<img src="https://github.com/ponysoloud/ap-step-control-view/blob/master/Demonstration.gif" width="450">

## Requirements

- iOS 10.0+
- Xcode 9

## Installation

You can use [CocoaPods](http://cocoapods.org/) to install `APStepControlView` by adding it to your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!

target 'MyApp' do
    pod 'APStepControlView'
end
```

## Usage

#### Initialization

```swift
import APStepControlView
```

`APStepControlView` have one initializer to set initial count of steps.

```swift
let stepControlView = APStepControlView(sectionsCount: 5)
```

Also, `APStepControlView` is a `UIView` and can be initialized like it.

```swift
let rect = CGRect(x: 40, y: 200, width: 200, height: 40)
let stepControlView = APStepControlView(frame: rect)
```

#### APStepControlViewDelegate

You can implement `APStepControlViewDelegate` to be notified about actions with `APStepControlView` and control behaviour

```swift
class StepControlViewDelegateImpl: APStepControlViewDelegate {
  func stepControlView(_ stepControlView: APStepControlView, didChangeStepsCountFrom count: Int, to newCount: Int) {
    print("Number of steps changed from \(count) to \(newCount)")
  }
  
  func stepControlView(_ stepControlView: APStepControlView, shouldPopStepWithIndex index: Int) -> Bool {
    return index > 0 // In an array, at least one element
  }
}
```

```swift
let stepControlViewDelegateImpl = StepControlViewDelegateImpl()

stepControlView.delegate = stepControlViewDelegateImpl
```

#### Customizing

Steps indicators colors are customizable. It's set for states separately.

![Illustration](https://github.com/ponysoloud/ap-step-control-view/blob/master/ColorStatesIllustration.png?raw=true)

```swift
stepControl.setColor(.black, for: .regular)
```

If you don't need to take user touch control and want to manipulate it with forced `pow()` and `pop()`, just set `isUserInteractionEnabled = false`.

#### AutoLayout

You can position and resize view through `frame`, `center` and other properties or use constraints. If you use constraints, you shouldn't strongly fix width. It allows to autoresize view on pushing and poping steps, increase size of view correctly on tap.





