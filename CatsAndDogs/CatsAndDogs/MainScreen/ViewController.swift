//
//  ViewController.swift
//  CatsAndDogs
//
//  Created by Svetlana Safonova on 15.11.2021.
//

import UIKit
import SnapKit
import Combine

struct CatsFact: Codable {
    let fact: String
    let length: Int
    init() {
        fact = ""
        length = 0
    }
}

struct DogsResponse: Codable {
    let message: String
    let status: String
    init() {
        message = ""
        status = ""
    }
}

class ViewController: UIViewController {
    
    enum Constants {
        static let zero = 0
        static let one = 1
        static let cats = "Cats"
        static let dogs = "Dogs"
        static let reset = "Reset"
        static let content = "Content"
        static let borderWidth: CGFloat = 1
        static let contentViewRadius: CGFloat = 10
        static let buttonCornerRadius: CGFloat = 20
        static let buttonTitle = "more"
        static let catUrl = "https://catfact.ninja/fact"
        static let dogUrl = "https://dog.ceo/api/breeds/image/random"
    }

    // MARK: - Properties
    
    private var cancellable: AnyCancellable?
    private var loadImageCancellable: AnyCancellable?
    private var catsCount = Constants.zero
    private var dogsCount = Constants.zero
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: Constants.cats, at: Constants.zero, animated: true)
        segmentedControl.insertSegment(withTitle: Constants.dogs, at: Constants.one, animated: true)
        segmentedControl.selectedSegmentIndex = Constants.zero
        segmentedControl.addTarget(self, action: #selector(setScreen), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var resetBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: Constants.reset,
                                     style: .plain,
                                     target: self,
                                     action: #selector(reset))
        button.tintColor = .systemBlue
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = Constants.content
        label.numberOfLines = Constants.zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.contentViewRadius
        view.layer.borderWidth = Constants.borderWidth
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.buttonTitle, for: .normal)
        button.backgroundColor = UIColor().getMoreButtonColor()
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
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
            make.trailing.leading.equalToSuperview().inset(5)
        }
        contentView.snp.makeConstraints { make in
            make.height.equalTo(204.37)
            make.top.equalTo(segmentedControl.snp.bottom).offset(41)
            make.leading.equalToSuperview().inset(19)
            make.trailing.equalToSuperview().inset(18)
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
        navBarAppearance.backgroundColor = UIColor().getNavBarColor()
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func catsRequest() {
        guard let url = URL(string: Constants.catUrl) else {
            return
        }
        
        self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CatsFact.self, decoder: JSONDecoder())
            .replaceError(with: CatsFact())
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
            }) { [weak self] catsFact in
                self?.label.text = catsFact.fact
            }
    }
    
    private func dogsRequest() {
        guard let url = URL(string: Constants.dogUrl) else {
            return
        }
        
        self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: DogsResponse.self, decoder: JSONDecoder())
            .replaceError(with: DogsResponse())
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { completion in

            }) { [weak self] dogsResponse in
                guard let url = URL(string: dogsResponse.message) else {
                    return
                }
                self?.loadImageCancellable = URLSession.shared.dataTaskPublisher(for: url)
                    .map { UIImage(data: $0.data) }
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { completion in
                        
                    }) { [weak self] result in
                        guard let image = result else {
                            return
                        }
                        self?.imageView.image = image
                    }
            }
    }
    // MARK: - Actions
    
    @objc private func setScreen() {
        if segmentedControl.selectedSegmentIndex == Constants.zero {
            imageView.isHidden = true
            label.isHidden = false
        } else {
            imageView.isHidden = false
            label.isHidden = true
        }
    }
    
    @objc private func moreButtonTapped() {
        if segmentedControl.selectedSegmentIndex == Constants.zero {
            catsRequest()
            catsCount += Constants.one
        } else {
            dogsRequest()
            dogsCount += Constants.one
        }
        scoreLabel.text = "Score: \(catsCount) cats and \(dogsCount) dogs"
    }
    
    @objc private func reset() {
        catsCount = Constants.zero
        dogsCount = Constants.zero
        scoreLabel.text = "Score: \(catsCount) cats and \(dogsCount) dogs"
    }
}


extension UIColor {
    func getMoreButtonColor() -> UIColor {
        UIColor(red: 255/255, green: 155/255, blue: 138/255, alpha: 1)
    }
    
    func getNavBarColor() -> UIColor {
        UIColor(displayP3Red: 249/255, green: 249/255, blue: 249/255, alpha: 0.94)
    }
}
