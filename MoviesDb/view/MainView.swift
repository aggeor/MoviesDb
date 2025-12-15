import SwiftUI

struct MainView: View {
    // 2 columns grid
    private let adaptiveColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    @StateObject var mainViewModel: MainViewModel = MainViewModel()

    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerView
                if mainViewModel.isLoading {
                    loadingView
                } else if mainViewModel.movies.isEmpty {
                    emptyView
                } else {
                    moviesView
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                searchText = mainViewModel.lastSearchText ?? ""
            }
            .task {
                if mainViewModel.movies.isEmpty {
                    await mainViewModel.search(nil)
                }
            }
        }
    }
    
    var headerView: some View {
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
                                Task {
                                    await mainViewModel.search(nil)
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 24)
                        }
                    }
                )
            
            HStack {
                Text(mainViewModel.title)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    Task {
                        await mainViewModel.search(searchText.isEmpty ? nil : searchText)
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .foregroundColor(.white)
                        .opacity(mainViewModel.isLoading ? 0.5 : 1)
                }
                .disabled(mainViewModel.isLoading)
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
        .background(Color.black)
    }
    
    var loadingView: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
        }
    }
    
    var emptyView: some View {
        VStack(spacing: 0) {
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
    
    var moviesView: some View {
        ScrollView {
            LazyVGrid(columns: adaptiveColumns, spacing: 16) {
                ForEach(mainViewModel.movies, id: \.id) { movie in
                    NavigationLink(destination: MovieDetailView(movieID: movie.id)) {
                        MovieCard(movie: movie)
                            .onAppear {
                                Task {
                                    await mainViewModel.fetchNextIfNeeded(currentMovie: movie)
                                }
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
