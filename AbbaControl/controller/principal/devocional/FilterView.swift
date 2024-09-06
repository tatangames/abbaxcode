//
//  FilterView.swift
//  AbbaControl
//
//  Created by Jonathan  Moran on 19/3/24.
//

import UIKit

class FilterView: UIView {
    
    var buttonPressedHandler: ((Int) -> Void)?
    
    var dataSource: [String] = [] {
           didSet {
               renderUI()
           }
       }
    
    //*********************************
    
    var selectedButtonIndex: Int? {
          didSet {
              highlightButtonAtIndex(selectedButtonIndex)
          }
      }
      
    
    private func highlightButtonAtIndex(_ index: Int?) {
        guard let index = index else { return }
        
        var mitema = false
        
        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
            mitema = true
        }
           
           for (currentIndex, buttonView) in stackView.arrangedSubviews.enumerated() {
               if currentIndex == index {
                   
                   buttonView.backgroundColor = .gray
                   if let label = buttonView.subviews.first as? UILabel {
                       label.textColor = .white
                   }
               } else {
                   
                   if(mitema){
                       buttonView.backgroundColor = .white
                       if let label = buttonView.subviews.first as? UILabel {
                           label.textColor = .black
                       }
                   }else{
                       buttonView.backgroundColor = .black
                       if let label = buttonView.subviews.first as? UILabel {
                           label.textColor = .white
                       }
                   }
                  
               }
           }
       }
    
    
    //*******************************
    
   
    
    
    
    
    var buttonBackgroundColor: UIColor = .black {
          didSet {
              updateButtonBackgroundColor()
          }
      }
    
    var buttonTextColor: UIColor = .black {
          didSet {
              updateButtonTextColor()
          }
      }
       
       lazy var scrollView: UIScrollView = {
           let scrollView = UIScrollView()
           scrollView.showsHorizontalScrollIndicator = false
           return scrollView
       }()
       
       lazy var stackView: UIStackView = {
           let stackView = UIStackView()
           stackView.axis = .horizontal
           stackView.spacing = 8
           stackView.distribution = .fill
           return stackView
       }()
       
       
       required override init(frame: CGRect){
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder: NSCoder){
           super.init(coder: coder)
           commonInit()
       }
       
       private func commonInit(){
           scrollView.translatesAutoresizingMaskIntoConstraints = false
           stackView.translatesAutoresizingMaskIntoConstraints = false
           self.addSubview(scrollView)
           scrollView.addSubview(stackView)
           
           NSLayoutConstraint.activate([
               scrollView.topAnchor.constraint(equalTo: self.topAnchor),
               scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
               scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
               scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
               
               stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
               stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
               stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
               stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
               stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor) // Set the height of stackView same as scrollView
           ])
       }
       
       
       private func renderUI(){
           for (index, item) in dataSource.enumerated() {
               stackView.addArrangedSubview(createTokenView(index: index, item: item))
           }
           // Update contentSize of scrollView after adding subviews
           scrollView.contentSize = stackView.bounds.size
       }
       
       
    private func createTokenView(index: Int, item: String) -> UIView {
         let view = UIView()
         let textLabel = UILabel()
         textLabel.text = item
         textLabel.textColor = .white
         textLabel.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(textLabel)
        
        // Añadir espaciado entre el texto y los bordes del botón
        let margin: CGFloat = 6.0 // Espaciado de margen
           NSLayoutConstraint.activate([
               textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: margin),
               textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
               textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin),
               textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin)
           ])
           
          
         
        /* NSLayoutConstraint.activate([
             textLabel.topAnchor.constraint(equalTo: view.topAnchor),
             textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
         ])*/
        
        // Agregar borde al botón
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 8
                
        // Agregar gesto de tap al botón
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        view.addGestureRecognizer(tapGesture)
         view.isUserInteractionEnabled = true
           
           // Asignar el índice del botón al tag para identificarlo más tarde
           view.tag = index
         
         return view
     }
     
     // Public method to update button background color
     func updateButtonBackgroundColor() {
         for case let buttonView as UIView in stackView.arrangedSubviews {
             buttonView.backgroundColor = buttonBackgroundColor
           
         }
     }
    
    private func updateButtonTextColor() {
            for case let buttonView as UIView in stackView.arrangedSubviews {
                if let label = buttonView.subviews.first as? UILabel {
                    label.textColor = buttonTextColor
                }
            }
        }
    
    @objc private func buttonTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        buttonPressedHandler?(view.tag) // Llamar al closure con el índice del botón
        
        
        /*for case let buttonView as UIView in stackView.arrangedSubviews {
            buttonView.backgroundColor = buttonView == view ? .gray : .white
        }*/
   
        let instanciaTema = TemaController()
        if( instanciaTema.conocerTemaActual() == 1){
           
            // Cambiar el color de fondo y de texto del botón tocado a gris y de los demás a blanco
            for case let buttonView as UIView in stackView.arrangedSubviews {
                if buttonView == view {
                    buttonView.backgroundColor = .gray
                    if let label = buttonView.subviews.first as? UILabel {
                        label.textColor = .white
                    }
                } else {
                    buttonView.backgroundColor = .white
                    if let label = buttonView.subviews.first as? UILabel {
                        label.textColor = .black
                    }
                }
            }
            
        }else{
                        
            // Cambiar el color de fondo y de texto del botón tocado a gris y de los demás a blanco
            for case let buttonView as UIView in stackView.arrangedSubviews {
                if buttonView == view {
                    buttonView.backgroundColor = .gray
                    if let label = buttonView.subviews.first as? UILabel {
                        label.textColor = .white
                    }
                } else {
                    buttonView.backgroundColor = .black
                    if let label = buttonView.subviews.first as? UILabel {
                        label.textColor = .white
                    }
                }
            }
        }
    }

}
