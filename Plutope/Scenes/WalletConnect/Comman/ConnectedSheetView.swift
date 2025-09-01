import SwiftUI

struct ConnectedSheetView: View {
    var title: String

    var body: some View {
        ZStack {
            VStack {
                Image("connected")

                Spacer()
            }

            VStack(spacing: 8) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 48, height: 4)
                    .background(Color(red: 0.02, green: 0.17, blue: 0.17).opacity(0.2))
                    .cornerRadius(100)
                    .padding(.top, 8)

                Text(title)
                    .foregroundColor(.gray)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.top, 168)

                Text("You can go back to your browser now")
                    .foregroundColor(Color(red: 0.47, green: 0.53, blue: 0.53))
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                Spacer()
            }
        }
    }
}

struct ContentView: View {
    @State private var isSheetPresented = false

    var body: some View {
        Button("Show Sheet") {
            isSheetPresented.toggle()
        }
        .sheet(isPresented: $isSheetPresented) {
            ConnectedSheetView(title: "")
        }
    }
}
