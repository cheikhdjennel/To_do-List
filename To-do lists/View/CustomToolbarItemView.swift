//
//  ToolbarItemView.swift
//  To-do lists
//
//  Created by Cheikh on 10/10/2022.
//

import UIKit

class CustomToolbarItemView: UIStackView {

    let itemButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
       return btn
    }()
    
    let itemTitleLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.preferredFont(forTextStyle: .title2).withSize(14)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    func setup(imgName: String, itemTitle : String){
        self.addArrangedSubview(itemButton)
        self.addArrangedSubview(itemTitleLabel)
        itemTitleLabel.text = itemTitle
        let img = UIImage(named: imgName)
        itemButton.setBackgroundImage(img, for: .normal)
        layout()
    }
    
    func layout(){
        NSLayoutConstraint.activate([
            itemButton.widthAnchor.constraint(equalToConstant: 40),
            itemButton.heightAnchor.constraint(equalToConstant: 40),
            
            itemTitleLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
        
    }
    
    init(imgName: String, title : String) {
        super.init(frame: CGRect.zero)
        self.axis = .vertical
        self.spacing = 6.0
        self.distribution = .fill
        self.alignment = .center
        setup(imgName: imgName, itemTitle: title)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
