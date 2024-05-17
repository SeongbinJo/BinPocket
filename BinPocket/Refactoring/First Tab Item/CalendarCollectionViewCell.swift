//
//  CalendarCollectionViewCell.swift
//  BinPocket
//
//  Created by 조성빈 on 5/17/24.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    let dayOfWeek: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    private lazy var numberOfDay: UILabel = {
        let numberLabel = UILabel()
        numberLabel.text = "asdf"
        return numberLabel
    }()
    
    private lazy var amountOfDay: UILabel = {
        let amountLabel = UILabel()
        amountLabel.text = "20,000"
        amountLabel.font = .systemFont(ofSize: 10, weight: .light)
        return amountLabel
    }()
    
    private lazy var cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.backgroundColor = .red
        stackView.spacing = 0
        stackView.addArrangedSubview(numberOfDay)
        stackView.addArrangedSubview(amountOfDay)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cellStackView)
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
//            cellStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(string: String, string2: String) {
        numberOfDay.text = string
        amountOfDay.text = string2
    }
}
