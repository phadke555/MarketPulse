//
//  ContentView.swift
//  clean_sentiment_updated
//
//  Created by Rohan Phadke on 6/7/23.
//

import SwiftUI
import Charts

struct ContentView: View {
    @State private var userInput: String = ""
    @State private var isShowingCompanyScreen: Bool = false
    @State private var recentInputs: [String] = []
    @State private var favoriteCompanies: [String] = []
    @State private var isStarFilled: Bool = false

    var body: some View {

            
        NavigationView {
            ZStack(){
                Color(UIColor(red: 0.749, green: 0.894, blue: 0.9, alpha: 1.0))
                    .ignoresSafeArea()
                
                VStack {
                    //                    Color(UIColor(red: 0.749, green: 0.894, blue: 0.9, alpha: 1.0))
                    HStack{
                        Text("Market Pulse")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Image(systemName: "newspaper")
                            .imageScale(.large)
                            .foregroundColor(.black)
                        
                    }
                    .padding()
                    Text("Stay up to date with the latest market trends and sentiments in the news")
                        .font(.headline)
                    //                        .fontWeight()
                        .multilineTextAlignment(.center)
                        .padding(3.0)
                        .padding(16.0)
                    
                    
                    
                    HStack {
                        TextField("Enter company name", text: $userInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        Image(systemName: isStarFilled ? "star" : "star.fill") // Use a filled star image when isStarFilled is true
                            .imageScale(.large)
                            .foregroundColor(.black)
                            .onTapGesture {
                                if isStarFilled {
                                    addToFavorites(userInput) // Add the companyName to favorites
                                } else {
                                    removeFavorites(userInput)
                                }
                                //                                addToFavorites(companyName)
                                isStarFilled.toggle() // Toggle the state of the star when pressed
                                
                                
                            }
                        
                        NavigationLink(destination: CompanyScreen(companyName: userInput.uppercased(), favorite: !isStarFilled), isActive: $isShowingCompanyScreen) {
                            Button(action: {
                                saveUserInput()
                                isShowingCompanyScreen = true
                            }) {
                                Text("Search")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            //                            .disabled(userInput.isEmpty)
                            //                            .padding(.bottom, 20) // Add padding if needed
                            
                        }
                        //                        Button(action: {
                        //                            saveUserInput()
                        //                            isShowingCompanyScreen = true
                        //                        }) {
                        //                            Text("Search")
                        //                                .font(.headline)
                        //                                .padding()
                        //                                .background(Color.gray)
                        //                                .foregroundColor(.white)
                        //                                .cornerRadius(10)
                        //                        }
                        .disabled(userInput.isEmpty)
                        .padding()
                    }
                    
                    
                    Divider()
                    VStack{
                        VStack{
                            Text("Favorites")
                                .font(.title2)
                                .padding()
                            HStack{
                                ForEach(favoriteCompanies, id: \.self) { input in
                                    Button(action: {
                                        userInput = input
                                        //                                    saveUserInput()
                                        isShowingCompanyScreen = true
                                    }) {
                                        HStack {
                                            Text(input.uppercased())
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding()
                                                .frame(maxWidth: .infinity)
                                        }
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing)
                                                .cornerRadius(10)
                                        )
                                        .padding()
                                    }
                                }
                            }
                            
                        }
                        //                    .padding()
                        //                    Divider()
                        
                        VStack() {
                            Color(UIColor(red: 0.749, green: 0.894, blue: 0.9, alpha: 1.0))
                            Text("Recent Searches")
                                .font(.title2)
                                .padding()
                            
                            ForEach(recentInputs, id: \.self) { input in
                                Button(action: {
                                    userInput = input
                                    saveUserInput()
                                    isShowingCompanyScreen = true
                                }) {
                                    VStack {
                                        Text(input.uppercased())
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                    }
                                    .background(Color.mint)
                                    //                                    LinearGradient(gradient: Gradient(colors: [Color.green, Color.cyan]), startPoint: .leading, endPoint: .trailing)
                                    //                                        .frame(width: 150.0, height: 30.0)
                                    .cornerRadius(10)
                                    
                                    //                                .padding(0.5)
                                }
                            }
                        }
                        .padding()
                    }
                    .padding()
                    //                .background(Color(UIColor(red: 0.749, green: 0.894, blue: 0.9, alpha: 1.0))) // Light blue background color
                    //                .edgesIgnoringSafeArea(.all)
                    //                .navigationBarTitleDisplayMode(.inline)
                    //                .navigationBarTitle("", displayMode: .inline)
                    //                .navigationBarItems(leading:
                    //                                        HStack {
                    //                    Spacer()
                    //                    Text("Market Pulse")
                    //                        .font(.title)
                    //                        .frame(maxWidth: .infinity, alignment: .leading)
                    //                },
                    //                                    trailing:
                    //                                        HStack() {
                    //                    Text(" ")
                    //                        .frame(maxWidth: .infinity, alignment: .trailing)
                    //                    Image(systemName: "newspaper")
                    //                        .resizable()
                    //                        .frame(width: 40, height: 40)
                    //                    //                        .padding(, 10)
                    //
                    //                }
                    //                )
                    
                    
                }
                //            .background(Color(UIColor(red: 0.749, green: 0.894, blue: 0.796, alpha: 1.0))) // Light blue background color
                //            .edgesIgnoringSafeArea(.all)
                
                //            .sheet(isPresented: $isShowingCompanyScreen) {
                //                CompanyScreen(companyName: userInput)
                //            }
                
                .onAppear {
                    loadRecentInputs()
                }
            }
        }


    }
    
    func addToFavorites(_ company: String) {
        if !favoriteCompanies.contains(company) {
            favoriteCompanies.append(company)
            print(favoriteCompanies)
        }
    }
    
    func removeFavorites(_ company: String) {
        if let index = favoriteCompanies.firstIndex(of: company) {
            favoriteCompanies.remove(at: index)
        }
    }
    
    func saveUserInput() {
        // Check if the input already exists in the recentInputs array
        if let existingIndex = recentInputs.firstIndex(of: userInput) {
            // Remove the existing entry to avoid duplication
            recentInputs.remove(at: existingIndex)
        }
        
        // Insert the new input at the beginning of the array
        recentInputs.insert(userInput, at: 0)
//        recentInputs.insert(userInput, at: 0)
        if recentInputs.count > 3 {
            recentInputs.removeLast()
        }

        UserDefaults.standard.set(recentInputs, forKey: "RecentInputs")
    }

    func loadRecentInputs() {
        if let inputs = UserDefaults.standard.array(forKey: "RecentInputs") as? [String] {
            recentInputs = inputs
        }
    }
}

// Rest of the code remains the same...



struct CompanyScreen: View {
    let companyName: String
    let favorite: Bool
    @State private var sentiment: String = ""
    @State private var topHeadline: String = ""
    @State private var otherHeadline1: String = ""
    @State private var otherHeadline2: String = ""
    @State private var isShowingSummary1: Bool = false
    @State private var isShowingSummary2: Bool = false
    @State private var isShowingSummary3: Bool = false
    @State private var summary1: String = ""
    @State private var summary2: String = ""
    @State private var summary3: String = ""
    @State private var isLoading: Bool = false
    @State private var isShowingBarChart: Bool = false
//    @State private var additionalData1: String = ""
//    @State private var additionalData2: String = ""
//    @State private var additionalData3: String = ""

    @State private var barChartData: [ToyShape] =  [
//        .init(type: "Positive", count: 6),
//        .init(type: "Negative", count: 3),
//        .init(type: "Neutral", count: 5)
    ]
    @State private var isStarFilled: Bool = false

    var body: some View {
        ZStack() {
            Color(UIColor(red: 0.749, green: 0.894, blue: 0.9, alpha: 1.0))
                .ignoresSafeArea()
        VStack {

            HStack{
                Text(companyName)
                    .font(.title)
                    .multilineTextAlignment(.center)
//                    .padding()
                if favorite{
                    Image(systemName: "star.fill")
                        .imageScale(.large)
                        .foregroundColor(.black)
                } else{
                    Image(systemName: "star")
                        .imageScale(.large)
                        .foregroundColor(.black)
                }
//                Image(systemName: isStarFilled ? "star.fill" : "star") // Use a filled star image when isStarFilled is true
//                            .imageScale(.large)
//                            .foregroundColor(.black)
//                            .onTapGesture {
////                                addToFavorites(companyName)
//                             isStarFilled.toggle() // Toggle the state of the star when pressed

//                                       }
                
            }
            
            Button(action: {
                makeAPIRequest()
            }) {
                Text("Refresh")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            Divider()
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
            }
            Button(action: {
                isShowingBarChart = true
            }) {
                Text("Sentiment: \(sentiment)")
                    .font(.body)
                    .padding()
            }
            .sheet(isPresented: $isShowingBarChart) {
                BarChart(data: barChartData)
            }
            .opacity(sentiment.isEmpty ? 0 : 1) // Hide the button if sentiment is empty
            Button(action: {
                isShowingSummary1 = true
            }) {
                Text("Top Headline: \(topHeadline)")
                    .font(.body)
                    .padding()
            }
            .sheet(isPresented: $isShowingSummary1) {
                SummaryView(articleTitle: topHeadline, summary: $summary1)
            }
            .opacity(topHeadline.isEmpty ? 0 : 1) // Hide the button if topHeadline is empty
            
            Button(action: {
                isShowingSummary2 = true
            }) {
                Text("Other Headline: \(otherHeadline1)")
                    .font(.body)
                    .padding()
            }
            .sheet(isPresented: $isShowingSummary2) {
                SummaryView(articleTitle: otherHeadline1, summary: $summary2)
            }
            .opacity(otherHeadline1.isEmpty ? 0 : 1) // Hide the button if otherHeadline1 is empty
            Button(action: {
                isShowingSummary3 = true
            }) {
                Text("Other Headline: \(otherHeadline2)")
                    .font(.body)
                    .padding()
            }
            .sheet(isPresented: $isShowingSummary3) {
                SummaryView(articleTitle: otherHeadline2, summary: $summary3)
            }
            .opacity(otherHeadline2.isEmpty ? 0 : 1) // Hide the button if otherHeadline2 is empty
            
//            if sentiment.isEmpty && topHeadline.isEmpty && otherHeadline1.isEmpty && otherHeadline2.isEmpty {
//                Text("No data available")
//                    .font(.title3)
//                    .padding()
//            }
        }
    }
        .padding()
        .background(Color(UIColor(red: 0.749, green: 0.894, blue: 0.9, alpha: 1.0)))
    }
    

    func makeAPIRequest() {
        isLoading = true

        // Perform the API request here
        // Replace this with your own API endpoint and JSON serialization code
        let url = URL(string: "https://rohanphadke-newssentiment.hf.space/run/predict")!
        let jsonData = try! JSONSerialization.data(withJSONObject: ["data": [companyName]])

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                isLoading = false // Stop the loading indicator
            }

            guard let data = data else {
                print("Error: No data")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let responseDict = json as? [String: Any],
                   let responseData = responseDict["data"] as? [String] {
                    DispatchQueue.main.async {
                        if responseData.count >= 4 {
                            sentiment = responseData[0]
                            topHeadline = responseData[1]
                            otherHeadline1 = responseData[2]
                            otherHeadline2 = responseData[3]
                            summary1 = responseData[4]
                            summary2 = responseData[5]
                            summary3 = responseData[6]
                            let additionalData1 = responseData[7]
                            print(additionalData1)
                            let additionalData2 = responseData[8]
                            print(additionalData2)
                            let additionalData3 = responseData[9]
                            print(additionalData3)

                            barChartData = [
                                .init(type: "Positive", count: Double(additionalData1) ?? 0.0),
                                .init(type: "Neutral", count: Double(additionalData2) ?? 0.0),
                                .init(type: "Negative", count: Double(additionalData3) ?? 0.0)
                            ]
                        }
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }.resume()
    }
}

struct SummaryView: View {
    let articleTitle: String
    @Binding var summary: String

    var body: some View {
        ZStack(){
            Color(UIColor(red: 0.749, green: 0.894, blue: 0.9, alpha: 1.0))
                .ignoresSafeArea()
            VStack {
                Text(articleTitle)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                Text(summary)
                    .font(.body)
                    .padding()
                
                
                
//                Button(action: {
//                    // Code to dismiss the summary view
//                }) {
//                    Text("Dismiss")
//                        .font(.headline)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
                .padding()
            }
            .padding()
            .background(Color(UIColor(red: 0.749, green: 0.894, blue: 0.9, alpha: 1.0)))
        }
    }

}

struct ToyShape: Identifiable {
    var type: String
    var count: Double
    var id = UUID()
}

struct BarChart: View {
    var data: [ToyShape]
    
    init(data: [ToyShape]) {
        self.data = data
    }
    
    var body: some View {
        Chart {
            ForEach(data) { shape in
                BarMark(
                    x: .value("Shape Type", shape.type),
                    y: .value("Total Count", shape.count)
                )
                .foregroundStyle(.mint)
            }

        }
        .chartYAxis {AxisMarks(position: .leading)
        }

    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
