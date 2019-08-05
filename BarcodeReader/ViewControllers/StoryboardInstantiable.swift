//
//  StoryboardInstantiable.swift
//  BarcodeReader
//
//  Created by 橋本 龍 on 2019/08/05.
//  Copyright © 2019 Ryoh Hashimoto. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable where Self: UIViewController {

    static var instantiableStoryboard: UIStoryboard { get }
    static var storyboardIdentifier: String? { get }

}

extension StoryboardInstantiable {

    static var instantiableStoryboard: UIStoryboard {
        let className = String(describing: self)
        return UIStoryboard(name: className, bundle: nil)
    }

    static var storyboardIdentifier: String? {
        return nil
    }

    static func instantiate() -> Self {
        if let identifier = storyboardIdentifier {
            return instantiableStoryboard.instantiateViewController(withIdentifier: identifier) as! Self
        } else {
            return instantiableStoryboard.instantiateInitialViewController() as! Self
        }
    }

}
