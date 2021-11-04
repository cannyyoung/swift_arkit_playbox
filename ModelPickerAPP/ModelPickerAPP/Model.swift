//
//  Model.swift
//  ModelPickerAPP
//
//  Created by wl on 11/3/21.
//

import UIKit
import RealityKit
import Combine

class Model {
    var modelName:String
    var Image:UIImage
    var modelEntity: ModelEntity?
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String){
        self.modelName = modelName
        self.Image = UIImage(named: modelName)!
        let fileName = modelName + ".usdz"
        
        self.cancellable = ModelEntity.loadModelAsync(named: fileName).sink(receiveCompletion: {
            loadCompletion in
            //handling error
            print("unable to complete load model with name: \(self.modelName)")
        }, receiveValue: {
            modelEntity in
            self.modelEntity = modelEntity
            print("Completed loading model : \(self.modelName)")
        })
    }
}
