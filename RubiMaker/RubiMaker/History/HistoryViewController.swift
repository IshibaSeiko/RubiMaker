//
//  HistoryViewController.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/12.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit

final class HistoryViewController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet private weak var historyTableView: UITableView!

    // MARK: Property
    var inputFromTextViewController: InputFromTextViewController!

    // MARK: LayoutProperties
    private var modalViewHeight: CGFloat {
        return view.frame.height - view.safeAreaInsets.top
    }
    private var maxDistance: CGFloat {
        return modalViewHeight - fullPositionConstant
    }
    private var fullPositionConstant: CGFloat {
        return view.safeAreaInsets.top
    }
    private var halfPositionConstant: CGFloat {
        return maxDistance * 0.7
    }
    private var tipPositionConstant: CGFloat {
        return maxDistance
    }
    private var halfPositionFractionValue: CGFloat {
        return tipToHalfDistance / maxDistance
    }
    private var tipToHalfDistance: CGFloat {
        return maxDistance - halfPositionConstant
    }
    private var halfToFullDistance: CGFloat {
        return maxDistance - tipToHalfDistance
    }

    //MARK: for animator
    private var modalAnimator = UIViewPropertyAnimator()
    private var modalAnimatorProgress: CGFloat = 0.0 {
        didSet {
            print("modal progress \(modalAnimatorProgress)")
        }
    }

    private var remainigToHalfDistance: CGFloat = 0.0
    private var isRunningToHalf = false
    private var currentMode: DrawerPositionType = .half
    private var modalViewBottomConstraint = NSLayoutConstraint()

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        inputFromTextViewController = InputFromTextViewController.instance()
        addChild(inputFromTextViewController)

        self.addChild(inputFromTextViewController)
        self.view.addSubview(inputFromTextViewController.view)
        (inputFromTextViewController).didMove(toParent: self)

        setupModalLayout()

        let pan =
        UIPanGestureRecognizer(target: self,
                             action: #selector(handle(_:)))
        inputFromTextViewController.view.addGestureRecognizer(pan)
    }
}

extension HistoryViewController {
    private func setupModalLayout() {
        guard let modalView = inputFromTextViewController.view else { return }
        modalView.translatesAutoresizingMaskIntoConstraints = false

        modalViewBottomConstraint = modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                      constant: halfPositionConstant)

        modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        modalViewBottomConstraint.isActive = true
        modalView.heightAnchor.constraint(equalToConstant: modalViewHeight).isActive = true
        view.layoutIfNeeded()
    }

    @objc private func handle(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            beganInteractionAnimator()
            activeAnimator()
        case .changed:
            let translation = panGesture.translation(in: inputFromTextViewController.view)
            switch currentMode {
            case .tip:
                modalAnimator.fractionComplete = -translation.y / maxDistance + modalAnimatorProgress
            case .full:
                modalAnimator.fractionComplete = translation.y / maxDistance + modalAnimatorProgress
            case .half: fatalError()
            }
        case .ended:
            // 終了アニメーションを実行
            let velocity = panGesture.velocity(in: inputFromTextViewController.view)
            continueInteractionAnimator(velocity: velocity)
        default: break
        }
    }

    private func beganInteractionAnimator() {

        if !modalAnimator.isRunning {
            // animatorが実行中ではない(ポーズ状態）
            if currentMode == .half {
                // halfならtipに変更する
                currentMode = .tip
                // 制約をリセット
                modalViewBottomConstraint.constant = tipPositionConstant
                view.layoutIfNeeded()
                modalAnimatorProgress = halfPositionFractionValue
            } else {
                modalAnimatorProgress = 0.0
            }
            // プロパティを更新
            generateAnimator()

        } else if isRunningToHalf {
            modalAnimator.pauseAnimation()
            isRunningToHalf.toggle()

            let currentConstantPoint: CGFloat
            switch currentMode {
            case .tip:
                currentConstantPoint = tipToHalfDistance - remainigToHalfDistance * (1 - modalAnimator.fractionComplete)
                modalViewBottomConstraint.constant = tipPositionConstant
            case .full:
                currentConstantPoint = (halfToFullDistance - remainigToHalfDistance) + remainigToHalfDistance * modalAnimator.fractionComplete
                modalViewBottomConstraint.constant = fullPositionConstant
            case .half: fatalError()
            }

            modalAnimatorProgress = currentConstantPoint / maxDistance
            stopModalAnimator()

            // プロパティを更新
            generateAnimator()
        } else {
            modalAnimator.pauseAnimation()

            modalAnimatorProgress = modalAnimator.isReversed ? 1 - modalAnimator.fractionComplete : modalAnimator.fractionComplete
            if modalAnimator.isReversed {
                modalAnimator.isReversed.toggle()
            }
        }
    }

    private func generateAnimator(duration: TimeInterval = 1.0) {
        if modalAnimator.state == .active {
            stopModalAnimator()
        }

        modalAnimator = generateModalAnimator(duration: duration)
    }

    private func generateModalAnimator(duration: TimeInterval) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1.0) {[weak self] in
            // アニメーション開始
            guard let self = self else { return }
            switch self.currentMode {
            case .tip:
                self.modalViewBottomConstraint.constant = self.fullPositionConstant
            case .full:
                self.modalViewBottomConstraint.constant = self.tipPositionConstant
            case .half: fatalError()
            }
            self.view.layoutIfNeeded()
        }
        animator.addCompletion {[weak self] position in
            guard let self = self else { return }
            // アニメーション終了
            switch self.currentMode {
            case .tip:
                if position == .start {
                    self.modalViewBottomConstraint.constant = self.tipPositionConstant
                    self.currentMode = .tip
                } else if position == .end {
                    self.modalViewBottomConstraint.constant = self.fullPositionConstant
                    self.currentMode = .full
                }
            case .full:
                if position == .start {
                    self.modalViewBottomConstraint.constant = self.fullPositionConstant
                    self.currentMode = .full
                } else if position == .end {
                    self.modalViewBottomConstraint.constant = self.tipPositionConstant
                    self.currentMode = .tip
                }
            case .half: fatalError()
            }
            self.view.layoutIfNeeded()
        }
        return animator
    }

    private func activeAnimator() {
        modalAnimator.startAnimation()
        modalAnimator.pauseAnimation()
    }

    private func stopModalAnimator() {
        modalAnimator.stopAnimation(false)
        modalAnimator.finishAnimation(at: .current)
    }

    private func continueInteractionAnimator(velocity: CGPoint) {
        let fractionComplete = modalAnimator.fractionComplete
        if currentMode.isBeginningArea(fractionPoint: fractionComplete,
                                       velocity: velocity,
                                       halfAreaBorderPoint: halfPositionFractionValue) {
            begginingAreaContinueInteractionAnimator(velocity: velocity)

        } else if currentMode.isEndArea(fractionPoint: fractionComplete,
                                        velocity: velocity,
                                        halfAreaBorderPoint: halfPositionFractionValue) {

            endAreaContinueInteractionAnimator(velocity: velocity)
        } else {
            halfAreaContinueInteractionAnimator(velocity: velocity)
        }
    }

    private func calculateContinueAnimatorParams(remainingDistance: CGFloat, velocity: CGPoint) -> (timingParameters: UITimingCurveProvider?, durationFactor: CGFloat) {
        if remainingDistance == 0 {
            return (nil, 0)
        }
        let relativeVelocity = abs(velocity.y) / remainingDistance
        let timingParameters = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: CGVector(dx: relativeVelocity, dy: relativeVelocity))
        let newDuration = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters).duration
        let durationFactor = CGFloat(newDuration/modalAnimator.duration)
        return (timingParameters, durationFactor)
    }

    private func begginingAreaContinueInteractionAnimator(velocity: CGPoint) {
        let remainingFraction = 1 - modalAnimator.fractionComplete
        let remainingDistance = maxDistance * remainingFraction
        modalAnimator.isReversed = true
        let continueAnimatorParams = calculateContinueAnimatorParams(remainingDistance: remainingDistance, velocity: velocity)
        continueAnimator(parameters: continueAnimatorParams.timingParameters, durationFactor: continueAnimatorParams.durationFactor)
    }

    private func endAreaContinueInteractionAnimator(velocity: CGPoint) {
        let remainingFraction = 1 - modalAnimator.fractionComplete
        let remainingDistance = maxDistance * remainingFraction
        let continueAnimatorParams = calculateContinueAnimatorParams(remainingDistance: remainingDistance, velocity: velocity)
        let timingParameters = continueAnimatorParams.timingParameters
        let durationFactor = continueAnimatorParams.durationFactor
        modalAnimator.continueAnimation(withTimingParameters: timingParameters,
                                        durationFactor: durationFactor)
    }

    private func halfAreaContinueInteractionAnimator(velocity: CGPoint) {
        modalAnimator.pauseAnimation()
        let toHalfDistance = currentMode == .tip ? tipToHalfDistance : halfToFullDistance
        remainigToHalfDistance = toHalfDistance - (maxDistance * modalAnimator.fractionComplete)

        stopModalAnimator()
        modalAnimator.addAnimations {
            self.modalViewBottomConstraint.constant = self.halfPositionConstant
            self.view.layoutIfNeeded()
        }
        modalAnimator.addCompletion {[weak self] position in
            guard let self = self else { return }
            self.isRunningToHalf = false
            switch position {
            case .end:
                self.currentMode = .half
                self.modalViewBottomConstraint.constant = self.halfPositionConstant
            case .start, .current: ()
            @unknown default:
                ()
            }
            self.view.layoutIfNeeded()
        }
        isRunningToHalf = true

        activeAnimator()
        let continueAnimatorParams = calculateContinueAnimatorParams(remainingDistance: remainigToHalfDistance, velocity: velocity)
        continueAnimator(parameters: continueAnimatorParams.timingParameters, durationFactor: continueAnimatorParams.durationFactor)
    }

    private func continueAnimator(parameters: UITimingCurveProvider?, durationFactor: CGFloat) {
        modalAnimator.continueAnimation(withTimingParameters: parameters, durationFactor: durationFactor)
    }
}


