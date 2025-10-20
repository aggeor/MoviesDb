import SwiftUI

struct MainView: View {
    
    // 2 columns grid
    private let adaptiveColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // ViewModel
    @StateObject var mainViewModel: MainViewModel = MainViewModel()
    
    // Search text
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // MARK: Header with title and search
                VStack(spacing: 12) {
                    
                    TextField("Search movies...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .onSubmit {
                            Task {
                                await mainViewModel.search(searchText)
                            }
                        }
                        .overlay(
                                HStack {
                                    Spacer()
                                    if !searchText.isEmpty {
                                        Button(action: {
                                            searchText = ""
                                            if mainViewModel.title != "Popular Movies"{
                                                Task {
                                                    await mainViewModel.search(nil) // reset to popular movies
                                                }
                                            }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.trailing, 24)
                                    }
                                }
                            )

                    Text(mainViewModel.title)
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)

                }
                .padding(.vertical, 12)
                .background(Color.black)
                
                if mainViewModel.movies.count != 0{
                    // MARK: Movies ScrollView
                    ScrollView {
                            LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                                ForEach(mainViewModel.movies, id: \.id) { movie in
                                    MovieCard(movie: movie)
                                    .onAppear {
                                        Task {
                                            await mainViewModel.fetchNextIfNeeded(currentMovie: movie)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                    }
                    .background(Color.black.edgesIgnoringSafeArea(.all))
                } else{
                    VStack(spacing: 0){
                        Text("No movies found")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.black)
                }
            }
            .navigationBarHidden(true)
            .task {
                await mainViewModel.search(nil)
            }
        }
    }
}
