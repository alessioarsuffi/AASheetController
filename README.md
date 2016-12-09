# AASheetController

[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/AASheetController.svg?style=flat)](http://cocoapods.org/pods/AASheetController)
[![Version](https://img.shields.io/cocoapods/v/AASheetController.svg?style=flat)](http://cocoapods.org/pods/AASheetController)
[![License](https://img.shields.io/cocoapods/l/AASheetController.svg?style=flat)](http://cocoapods.org/pods/AASheetController)
[![Platform](https://img.shields.io/cocoapods/p/AASheetController.svg?style=flat)](http://cocoapods.org/pods/AASheetController)

## Screenshot

![Screenshot0][gif] &nbsp;&nbsp;

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
* iOS 9.3 +
* Xcode 8.0 +

## Installation

AASheetController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AASheetController"
```

# FAQ

*Frequently asked questions for AASheetController.* 

Contributions are welcome! Please submit a [pull request](https://github.com/alessioarsuffi/AASheetController/compare).

------------------------------------

#### Hide Cancel action?

````swift
...
let sheetController = AASheetController(barButtonItem: nil)
sheetController.showCancelButton = false
self.present(sheetController, animated: true, completion: nil)
...
````

#### Hide photo library *UICollectionView*?

````swift
...
let sheetController = AASheetController(barButtonItem: nil)
sheetController.showCollectionView = false
self.present(sheetController, animated: true, completion: nil)
...
````

#### Ipad *UIPopoverPresentationController*?

````swift
...
let sheetController = AASheetController(barButtonItem: aBarButtonItem)
self.present(sheetController, animated: true, completion: nil)
...
````

## Contributing

- If you **need help** or you'd like to **ask a general question**, open an issue.
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Author

Alessio Arsuffi, alessio.arsuffi@gmail.com

## License

AASheetController is available under the MIT license. See the LICENSE file for more info.


[gif]: http://i.giphy.com/jWelDzjTHmEVO.gif
