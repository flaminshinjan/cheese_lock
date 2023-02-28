//
//  ContentView.swift
//  cheese_lock
//
//  Created by Shinjan Patra on 27/02/23.
//
import SwiftUI

struct ContentView: View {
    let dotsPerRow = 3
    let dotCount = 9
    let dotSize: CGFloat = 16
    @State private var showError = false
    @Binding var selectedRowIndex: Int
    
    
    @State private var selectedDots: [Int] = []
    
    private func verifyPattern(_ pattern: [Int]) -> Bool {
        return pattern == [2, 1, 0, 3, 4, 5, 8, 7, 6]
    }
    
    var body: some View {
        ZStack{
            
            VStack {
                Text("Unlock the App")
                    .font(.title.bold())
                
                Text("Pattern does not match!")
                    .font(.body)
                    .foregroundColor(.red)
                    .opacity(showError ? 1 : 0)
                    .padding(.top, 4)
                
                
                GeometryReader { geometry in
                    ZStack {
                        Path { path in
                            for index in selectedDots.indices {
                                let position = selectedDots[index]
                                let column = position % dotsPerRow
                                let row = position / dotsPerRow
                                let x = geometry.size.width / CGFloat(dotsPerRow + 1) * CGFloat(column + 1)
                                let y = geometry.size.height / CGFloat(dotsPerRow + 1) * CGFloat(row + 1)
                                
                                if (y < geometry.size.height / 2 + 104) {
                                    if index == 0 {
                                        path.move(to: CGPoint(x: x, y: y))
                                    } else {
                                        path.addLine(to: CGPoint(x: x, y: y))
                                    }
                                }
                            }
                        }
                        .stroke(.blue, lineWidth: 8)
                        ForEach(0..<dotCount, id: \.self) { index in
                            let column = index % dotsPerRow
                            let row = index / dotsPerRow
                            let x = geometry.size.width / CGFloat(dotsPerRow + 1) * CGFloat(column + 1)
                            let y = geometry.size.height / CGFloat(dotsPerRow + 1) * CGFloat(row + 1)
                            Circle()
                                .foregroundColor(.black.opacity(0.9))
                                .frame(width: dotSize, height: dotSize)
                                .position(x: x, y: y)
                                .tag(index)
                        }
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .padding([.horizontal])
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let location = (x: value.location.x, y: value.location.y)
                        var column: Int  {
                            let col = Int((location.x / (dotSize * 5)).rounded(.towardZero)) - 1
                            if (col < 0) {
                                return 0
                            } else if (col > 2) {
                                return 2
                            }
                            return col;
                        }
                        var row: Int {
                            let row = Int((location.y / (dotSize * 5)).rounded(.towardZero)) - 1
                            if (row < 0) {
                                return 0
                            } else if (row > 2) {
                                return 2
                            }
                            return row;
                        }
                        let index = row * dotsPerRow + column;
                        print((row: row, column: column, index: index))
                        if (!selectedDots.contains(index) ) {
                            selectedDots.append(index)
                        }
                        print(selectedDots)
                    }
                    .onEnded { value in
                        // Verify pattern
                        if verifyPattern(selectedDots) {
                            withAnimation {
                                selectedRowIndex = 1
                            }
                            
                        } else {
                            withAnimation {
                                showError = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                withAnimation {
                                    showError = false
                                }
                            })
                        }
                        // Reset pattern
                        selectedDots.removeAll()
                    })
            }
        }
        
    }

}

struct LockView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedRowIndex: .constant(0))
    }
}
   

