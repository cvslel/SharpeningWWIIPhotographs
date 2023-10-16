//
//  ViewController.swift
//  SharpeningWWIIPhotographs
//
//  Created by Cenker Soyak on 13.10.2023.
//

import UIKit
import SnapKit
import Lottie

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var animationView = LottieAnimationView()
    var imageView = UIImageView()
    var animator: UIViewPropertyAnimator!
    var animationPaused = false

    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
    }
  
    
    func createUI(){
        view.backgroundColor = .white
        
        imageView.image = UIImage(systemName: "questionmark")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 1
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(300)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gesture)
        animationView = .init(name: "loading")
        animationView.isHidden = true
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
        }
        
        let startButton = UIButton()
        startButton.setTitle("Start Animation", for: .normal)
        startButton.backgroundColor = .black
        startButton.layer.cornerRadius = 10
        startButton.configuration = .plain()
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)
        startButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(100)
            make.left.equalTo(imageView.snp.left)
            make.height.equalTo(80)
        }
        
        let stopButton = UIButton()
        stopButton.setTitle("Stop Animation", for: .normal)
        stopButton.backgroundColor = .black
        stopButton.layer.cornerRadius = 10
        stopButton.configuration = .plain()
        view.addSubview(stopButton)
        stopButton.addTarget(self, action: #selector(stopAnimation), for: .touchUpInside)
        stopButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(100)
            make.left.equalTo(imageView.snp.right).offset(-120)
            make.height.equalTo(80)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        animator = UIViewPropertyAnimator(duration: 10, curve: .easeInOut){
            blurView.alpha = 0.2
            DispatchQueue.main.asyncAfter(deadline: .now() + 10){
                self.animationView.stop()
            }
        }
        dismiss(animated: true)
    }
    @objc func selectImage(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    @objc func startAnimation(){
        animationView.isHidden = false
        animationView.loopMode = .loop
        animationView.play()
        if animator == nil{
            let blur = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blur)
            blurView.frame = imageView.bounds
            imageView.addSubview(blurView)
            animator = UIViewPropertyAnimator(duration: 10, curve: .easeInOut){
                blurView.alpha = 0.2
                }
        } else {
            animator.startAnimation()
        }
    }
    @objc func stopAnimation(){
        animator.pauseAnimation()
        animationView.stop()
    }
}
