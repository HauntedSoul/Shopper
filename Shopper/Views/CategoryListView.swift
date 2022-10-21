//
//  CategoryListView.swift
//  Shopper
//
//  Created by Vitor Dinis on 21/10/2022.
//

import SwiftUI

struct CategoryListView: View {
    
    @EnvironmentObject var cart: Cart
    
    @StateObject var viewModel = CategoryListViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Categories")
                        .font(.system(size: 26))
                        .bold()
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
                                viewModel.refreshCategoryList()
                            }
                        Spacer()
                    }
                } else {
                    if viewModel.categoryList.isEmpty {
                        VStack {
                            Spacer()
                            Button("Refresh") {
                                viewModel.refreshCategoryList()
                            }
                            .font(.system(size: 32))
                            .bold()
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(viewModel.categoryList, id: \.self) { category in
                                    CategoryCellView(categoryName: category, viewModel: viewModel)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 32)
                        }
                        .frame(maxHeight: .infinity)
                    }
                }
            }
        }
        .onAppear {
            viewModel.categoryListOnAppear()
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
            .environmentObject(Cart())
    }
}

struct CategoryCellView: View {
    
    let categoryName: String
    let viewModel: CategoryListViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text(categoryName.categoryFormatted)
                .font(.system(size: 32))
                .padding()
            SeparatorView()
        }
    }
}

struct SeparatorView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.gray)
            .opacity(0.3)
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }
}
