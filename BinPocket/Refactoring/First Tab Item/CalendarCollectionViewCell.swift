//
//  CalendarCollectionViewCell.swift
//  BinPocket
//
//  Created by 조성빈 on 5/17/24.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    private lazy var numberOfDay: UILabel = {
        let numberLabel = UILabel()
        numberLabel.text = "0"
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        return numberLabel
    }()
    
    private lazy var amountOfDay: UILabel = {
        let amountLabel = UILabel()
        amountLabel.text = "1,400,000"
        amountLabel.font = .systemFont(ofSize: 10, weight: .light)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        return amountLabel
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        stackView.addArrangedSubview(numberOfDay)
        stackView.addArrangedSubview(amountOfDay)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(days: String) {
        numberOfDay.text = days
        if days == "" {
            amountOfDay.text = ""
        }else {
            amountOfDay.text = "-"
        }
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
