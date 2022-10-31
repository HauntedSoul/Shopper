//
//  ProductListView.swift
//  Shopper
//
//  Created by Vitor Dinis on 10/10/2022.
//

import SwiftUI

struct ProductListView: View {
    
    @EnvironmentObject var cart: Cart
    
    @StateObject var viewModel: ProductListViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.viewTitle())
                    .font(.system(size: 26))
                    .bold()
                    .foregroundColor(.black)
                Spacer()
                Button {
                    // TODO: Open cart
                } label: {
                    Image(systemName: cart.isEmpty ? "cart" : "cart.fill")
                        .resizable()
                        .tint(.blue)
                        .frame(width: 30, height: 30)
                        .overlay {
                            if cart.count > 0 {
                                VStack {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "\(cart.count).circle.fill")
                                            .tint(.blue)
                                    }
                                    Spacer()
                                }
                                .padding(.trailing, -12)
                                .padding(.top, -8)
                            }
                        }
                }
            }
            .padding(.horizontal)
            
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .tint(.blue)
                        .scaleEffect(3)
                        .onTapGesture {
                            viewModel.refreshProductList()
                        }
                    Spacer()
                }
            } else {
                if viewModel.productList.isEmpty {
                    VStack {
                        Spacer()
                        Button("Refresh") {
                            viewModel.refreshProductList()
                        }
                        .font(.system(size: 32))
                        .bold()
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(viewModel.productList, id: \.self.id) { product in
                                ProductCellView(product: product)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 32)
                    }
                    .frame(maxHeight: .infinity)
                }
            }
        }
        .onAppear {
            viewModel.productListOnAppear()
        }
        .background {
            Color.white
                .ignoresSafeArea()
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(viewModel: ProductListViewModel(category: "smartphones"))
            .environmentObject(Cart.testObject())
    }
}

struct ProductCellView: View {
    
    @EnvironmentObject var cart: Cart
    
    let product: Product
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                AsyncImage(url: URL(string: product.thumbnail)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 60, height: 60)
                
                VStack(alignment: .leading) {
                    Text(product.title)
                        .foregroundColor(.black)
                    Text("Stock: \(product.stock)")
                        .foregroundColor(.black)
                }
                Spacer()
                Image(systemName: "plus.circle")
                    .resizable()
                    .foregroundColor(.blue)
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        cart.addToCart(product: product)
                    }
            }
            .padding(.vertical)
            SeparatorView()
        }
    }
}
