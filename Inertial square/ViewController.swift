//
//  ViewController.swift
//  Inertial square
//
//  Created by Николай Игнатов on 18.07.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    private lazy var squareView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var animator: UIDynamicAnimator?
    private var snapBehavior: UISnapBehavior?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupGestureRecognizers()
        setupAnimator()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(squareView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            squareView.widthAnchor.constraint(equalToConstant: 100),
            squareView.heightAnchor.constraint(equalToConstant: 100),
            squareView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            squareView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        view.layoutIfNeeded()
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupAnimator() {
        animator = UIDynamicAnimator(referenceView: view)
        
        let collisionBehavior = UICollisionBehavior(items: [squareView])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        let itemBehavior = UIDynamicItemBehavior(items: [squareView])
        itemBehavior.angularResistance = 2.0
        
        animator?.addBehavior(collisionBehavior)
        animator?.addBehavior(itemBehavior)
        
        snapBehavior = UISnapBehavior(item: squareView, snapTo: view.center)
        snapBehavior?.damping = 0.5
    }
    
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let tapLocation = gestureRecognizer.location(in: view)
        moveView(to: tapLocation)
    }
    
    private func moveView(to point: CGPoint) {
        guard let animator = animator, let snapBehavior = snapBehavior else {
            return
        }
        animator.removeBehavior(snapBehavior)
        
        snapBehavior.snapPoint = point
        
        animator.addBehavior(snapBehavior)
    }
}






