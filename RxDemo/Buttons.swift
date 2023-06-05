//
//  Buttons.swift
//  RxDemo
//
//  Created by admin on 04/06/23.
//

import UIKit

class CustomButton: UIButton {
    var tapButton: ( () -> Void )?
    init(textButton: String, color: UIColor) {
        super.init(frame: .zero)
        frame = .zero
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(textButton, for: .normal)
        backgroundColor = color
        layer.cornerRadius = 10
        titleColor(for: .highlighted)
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func didTapButton() {
        self.tapButton?()
    }
}
