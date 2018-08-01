//
//  DetailViewController.swift
//  ObserverTesting
//
//  Created by Robin Malhotra on 30/07/18.
//  Copyright © 2018 Robin Malhotra. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    let zeDateFormatter = DateFormatter()
    var zeObserver: NSObjectProtocol?

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        zeDateFormatter.dateStyle = .none
        zeDateFormatter.timeStyle = .full

        //OPTION A
//        let x = NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.itsASelector), name: NSNotification.Name(rawValue: "something"), object: nil)

        //OPTION B

        self.zeObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "something"), object: nil, queue: .main) { [weak self] (_) in
            self?.itsASelector()
        }


        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        postNotification()
    }

    func postNotification() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) { [weak self] in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "something"), object: nil)
            self?.postNotification()
        }
    }

    @objc func itsASelector() {
        self.detailDescriptionLabel.text = "Selected at \(zeDateFormatter.string(from: Date()))"
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self.zeObserver)
    }

    deinit {
        print("deinited")
    }

}

