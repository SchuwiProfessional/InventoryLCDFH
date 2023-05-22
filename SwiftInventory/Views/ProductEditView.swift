//
//  ProductEditView.swift
//  SwiftInventory
//
//  Created by Alvaro  on 18/05/23.
//

import SwiftUI

enum Mode {
    case new
    case edit
}

enum Action {
    case delete
    case done
    case cancel
}

struct ProductEditView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @State var presentActionSheet = false
    
    @ObservedObject var viewModel = ProductViewModel()
    var mode: Mode = .new
    var completionHandler: ((Result<Action, Error>) -> Void)?
    
    var cancelButton: some View {
        Button(action: { self.handleCancelTapped() }) {
            Text("Cancelar")
        }
    }
    
    var saveButton: some View {
        Button(action: { self.handleDoneTapped() }) {
            Text(mode == .new ? "Hecho" : "Agregar")
        }
        .disabled(!viewModel.modified)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Producto")) {
                    TextField("Producto", text: $viewModel.product.product)
                }
                
                Section(header: Text("Marca del auto")) {
                    TextField("Marca", text: $viewModel.product.brand)
                }
                
                Section(header: Text("Cantidad del producto")) {
                    TextField("Cantidad", value: $viewModel.product.amount, formatter: NumberFormatter())
                }
                
                Section(header: Text("Precio del producto")) {
                    TextField("Precio", value: $viewModel.product.price, formatter: NumberFormatter())
                }
                
                Section(header: Text("Imagen del producto")) {
                    TextField("Imagen", text: $viewModel.product.image)
                }
                
                if mode == .edit {
                    Section {
                        Button("Eliminar producto") {  self.presentActionSheet.toggle() }
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle(mode == .new ? "Nuevo producto" : viewModel.product.product )
            .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
            .navigationBarItems(
            leading: cancelButton,
            trailing: saveButton
            )
            .actionSheet(isPresented: $presentActionSheet) {
                ActionSheet(title: Text("Estas seguro?"),
                buttons: [
                    .destructive(Text("Eliminar producto"),
                                 action: { self.handleDeleteTapped() }),
                    .cancel()
                ])
            }
        }
    }
    
    func handleCancelTapped() {
        self.dismiss()
    }
    
    func handleDoneTapped() {
        self.viewModel.handleDoneTapped()
        self.dismiss()
    }
    
    func handleDeleteTapped() {
        viewModel.handleDeleteTapped()
        self.dismiss()
        self.completionHandler?(.success(.delete))
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

}

struct ProductEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProductEditView()
    }
}
