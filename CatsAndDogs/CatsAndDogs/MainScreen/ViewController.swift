//
//  ViewController.swift
//  CatsAndDogs
//
//  Created by Svetlana Safonova on 15.11.2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Cats", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Dogs", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(setScreen), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var resetBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Reset",
                                     style: .plain,
                                     target: nil,
                                     action: nil)
        button.tintColor = .systemBlue
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Content"
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("more", for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 155/255, blue: 138/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Score: 0 cats and 0 dogs"
        return label
    }()
    
    // MARK: - Instance Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        makeConstraints()
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        view.addSubview(contentView)
        view.addSubview(segmentedControl)
        view.addSubview(button)
        view.addSubview(scoreLabel)
    }
    
    private func makeConstraints() {
        segmentedControl.snp.makeConstraints { make in
            make.width.equalTo(196)
            make.height.equalTo(32)
            make.top.equalToSuperview().offset(27)
            make.centerX.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.width.equalTo(338)
            make.height.equalTo(204.37)
            make.top.equalTo(segmentedControl.snp.bottom).offset(41)
            make.centerX.equalToSuperview()
        }
        button.snp.makeConstraints { make in
            make.width.equalTo(144)
            make.height.equalTo(40)
            make.top.equalTo(contentView.snp.bottom).offset(12.63)
            make.centerX.equalToSuperview()
        }
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom)
                .offset(19)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Cats and dogs"
        navigationItem.rightBarButtonItem = resetBarButtonItem
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black]
        navBarAppearance.backgroundColor = UIColor(displayP3Red: 249/255, green: 249/255, blue: 249/255, alpha: 0.94)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    // MARK: - Actions
    
    @objc private func setScreen() {
        if segmentedControl.selectedSegmentIndex == 0 {
            imageView.isHidden = true
            label.isHidden = false
        } else {
            imageView.isHidden = false
            label.isHidden = true
        }
    }

}

