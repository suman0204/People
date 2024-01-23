//
//  Rx+UIImagePickerController.swift
//  SeSACTalk
//
//  Created by 홍수만 on 2024/01/22.
//

//import Foundation
//#if os(iOS)
//    
//    import RxSwift
//    import RxCocoa
//    import UIKit
//
//    extension Reactive where Base: UIImagePickerController {
//
//        /**
//         Reactive wrapper for `delegate` message.
//         */
//        public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey : AnyObject]> {
//            return delegate
//                .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
//                .map({ (a) in
//                    return try castOrThrow(Dictionary<UIImagePickerController.InfoKey, AnyObject>.self, a[1])
//                })
//        }
//
//        /**
//         Reactive wrapper for `delegate` message.
//         */
//        public var didCancel: Observable<()> {
//            return delegate
//                .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
//                .map {_ in () }
//        }
//        
//    }
//    
//#endif
//
//private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
//    guard let returnValue = object as? T else {
//        throw RxCocoaError.castingError(object: object, targetType: resultType)
//    }
//
//    return returnValue
//}

//import UIKit
//import RxSwift
//import RxCocoa
//
//class ImagePickerDelegateProxy: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate>, DelegateProxyType, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    init(imagePicker: UIImagePickerController) {
//        super.init(parentObject: imagePicker, delegateProxy: ImagePickerDelegateProxy.self)
//    }
//
//    static func registerKnownImplementations() {
//        self.register { ImagePickerDelegateProxy(imagePicker: $0) }
//    }
//
//    static func currentDelegate(for object: UIImagePickerController) -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
//        return object.delegate
//    }
//
//    static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, to object: UIImagePickerController) {
//        object.delegate = delegate
//    }
//}
//
//extension Reactive where Base: UIImagePickerController {
//
//    var didFinishPickingMediaWithInfo: ControlEvent<[UIImagePickerController.InfoKey: Any]> {
//        let source = ImagePickerDelegateProxy.proxy(for: base)
//            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
//            .map { parameters in
//                return try castOrThrow([UIImagePickerController.InfoKey: Any].self, parameters[1])
//            }
//        return ControlEvent(events: source)
//    }
//
//    var didCancel: ControlEvent<Void> {
//        let source = ImagePickerDelegateProxy.proxy(for: base)
//            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
//            .map { _ in }
//        return ControlEvent(events: source)
//    }
//}
//
//private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
//    guard let returnValue = object as? T else {
//        throw RxCocoaError.castingError(object: object, targetType: resultType)
//    }
//    return returnValue
//}
