heading("Hello pie!")

row([
  cell(class="st-module", [
    h6("Number of slices")
    slider(1:1:20, :number_of_slices; label=true)
  ])
])

row([
  cell(class="st-module", [
    h5("Pie chart")
    plot(:piechart)
  ])
])