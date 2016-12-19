//
//  RSAlertAction.swift
//  RSAlertController
//
//  Created by Alessio Arsuffi on 07/12/2016.
//  Copyright © 2016 Alessio Arsuffi. All rights reserved.
//

import UIKit

@objc public enum AASheetActionStyle : Int {
    
    case `default`
    case destructive
    case cancel
    
    func color() -> UIColor {
        switch self {
        case .default, .cancel:
            return .appleBlue
        case .destructive:
            return .red
        }
    }
}

public class AASheetAction: UIButton {
    
    fileprivate var action: (() -> Void)?
    
    public var actionStyle : AASheetActionStyle
    
    var separator = UIImageView()
    
    @objc init() {
        self.actionStyle = .cancel
        super.init(frame: CGRect.zero)
    }
    
    override public var isHighlighted: Bool {
        didSet {
            switch isHighlighted {
            case true:
                backgroundColor = UIColor.black.withAlphaComponent(0.1)
            case false:
                backgroundColor = .white
            }
        }
    }
    
    @objc public convenience init(title: String?, style: AASheetActionStyle, action: (() -> Void)? = nil) {
        self.init()
        
        self.action = action
        self.addTarget(self, action: #selector(AASheetAction.tapped(_:)), for: .touchUpInside)
        
        self.actionStyle = style
        self.setTitle(title, for: UIControlState())
        self.setTitleColor(style.color(), for: UIControlState())
        self.titleLabel?.font = style == .cancel ? UIFont.systemFont(ofSize: 20, weight: UIFontWeightSemibold) : UIFont.systemFont(ofSize: 20)
        
        self.addSeparator()
        
        clipsToBounds = true
    }
    
    @objc required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapped(_ sender: AASheetActionStyle) {
        self.action?()
    }
    
    @objc fileprivate func addSeparator(){
        separator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        self.addSubview(separator)
        
        // Autolayout separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 0).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: 0).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}

extension UIColor {
    
    /// Default apple blue color
    @objc static var appleBlue: UIColor {
        return UIColor(red: 14/255, green: 122/255, blue: 254/255, alpha: 1.0)
    }
}
