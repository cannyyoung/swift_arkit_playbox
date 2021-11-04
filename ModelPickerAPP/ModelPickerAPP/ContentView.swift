//
//  ContentView.swift
//  ModelPickerAPP
//
//  Created by wl on 11/2/21.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    @State private var isPlacementEnabled = false
    @State private var selectedModel : String?
    @State private var modelConfirmedforPlacement: String?
    
    var models: [String] = ["fender_stratocaster", "teapot", "toy_biplane", "toy_robot_vintage"]
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(modelConfrimedforPlacement: $modelConfirmedforPlacement)
            if(isPlacementEnabled){
                PlacementButtonsView(isPlacementEnabled: $isPlacementEnabled, selectedModel:$selectedModel,modelConfirmedforPlacement: $modelConfirmedforPlacement)
            } else{
                ModelPickerView(isPlacementEnabled: $isPlacementEnabled,selectedModel: $selectedModel, models: self.models)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfrimedforPlacement: String?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        arView.session.run(config)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let modelName = self.modelConfrimedforPlacement{
            
            print("The Model placed : \(modelName)")
            
            let fileName = modelName + ".usdz"
            let modelEntity = try! ModelEntity.loadModel(named: fileName)
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.addChild(modelEntity)
            
            uiView.scene.addAnchor(anchorEntity)
            
            DispatchQueue.main.async {
                self.modelConfrimedforPlacement = nil
            }
        }
    }
    
}

struct PlacementButtonsView: View{
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: String?
    @Binding var modelConfirmedforPlacement: String?


    var body: some View{
        HStack {
            Button(action: {
                print("Cancel Button")
                self.isPlacementEnabled = false
                self.selectedModel = nil
            }) {
                Image(systemName: "xmark")
                        .frame(width:60, height:60)
                        .font(.title)
                        .background(Color.white.opacity(0.75))
                        .cornerRadius(30)
                        .padding(20)
            }
            Button(action: {
                print("Confirm Button")
                self.modelConfirmedforPlacement = self.selectedModel
                self.isPlacementEnabled = false
                self.selectedModel = nil
            }) {
                Image(systemName: "checkmark")
                        .frame(width:60, height:60)
                        .font(.title)
                        .background(Color.white.opacity(0.75))
                        .cornerRadius(30)
                        .padding(20)
            }
        }
    }
}
struct ModelPickerView: View{
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel : String?
    
    var models: [String]
    
    var body: some View{
       ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(0 ..< self.models.count){
                    index in
                    Button(action: {
                        print("Selected Model with name \(self.models[index])")
                        self.isPlacementEnabled = true
                        self.selectedModel = self.models[index]
                    }) {
                        Image(uiImage: UIImage(named: self.models[index])!).resizable().frame( height: 80).aspectRatio(1/1, contentMode: .fit)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                    }
                }
            }
            .padding(20)
            .background(Color.black.opacity(0.5))
    }
}
#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
