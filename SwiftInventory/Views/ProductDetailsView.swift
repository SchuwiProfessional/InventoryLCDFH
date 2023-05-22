//
//  ProductDetailsView.swift
//  SwiftInventory
//
//  Created by Alvaro  on 18/05/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetailsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var presentEditProductSheet = false
    
    var product: Product
    
    private func editButton(action: @escaping () -> Void) -> some View {
        Button(action: { action() }) {
            Text("Editar")
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Producto")) {
                Text(product.product)
            }
            
            Section(header: Text("Marca de auto")) {
                Text(product.brand)
            }
            
            Section(header: Text("Cantidad")) {
                Text("\(product.amount)")
            }
            
            Section(header: Text("Precio")) {
                Text("S/. \(product.price)")
            }
            
            Section(header: Text("Imagen")) {
                AnimatedImage(url: URL(string: product.image)!).resizable().frame(width: 300, height: 300)
            }
        }
        .navigationBarTitle(product.product)
        .navigationBarItems(trailing: editButton {
            self.presentEditProductSheet.toggle()
        })
        .onAppear() {
            print("BookDetailsView.onAppear() for \(self.product.product)")
        }
        .onDisappear() {
            print("BookDetailsView.onDisappear()")
        }
        .sheet(isPresented: self.$presentEditProductSheet) {
            ProductEditView(viewModel: ProductViewModel(product: product), mode: .edit) { result in
                if case .success(let action) = result, action == .delete {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct ProductDetailsView_Previews: PreviewProvider { 
    static var previews: some View {
        let product = Product(product: "Producto", brand: "Marca", amount: 36, price: 235, image: "photo1")
        
        return NavigationView {
            ProductDetailsView(product: product)
        }
    }
}
