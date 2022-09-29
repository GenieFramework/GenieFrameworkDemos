heading("{{title}}")

row([
  cell(class="st-module", [
    h6("Number of clusters")
    slider(1:1:20, :no_of_clusters; label=true)
  ])
  cell(class="st-module", [
    h6("Number of iterations")
    slider(10:10:200, :no_of_iterations; label=true)
  ])

  cell(class="st-module", [
    h6("X feature")
    Stipple.select(:xfeature; options=:features)
  ])

  cell(class="st-module", [
    h6("Y feature")
    Stipple.select(:yfeature; options=:features)
  ])
])

row([
  cell(class="st-module", [
    h5("Species clusters")
    plot(:irisplot)
  ])

  cell(class="st-module", [
    h5("k-means clusters")
    plot(:clusterplot)
  ])
])

row([
  cell(class="st-module", [
    h5("Iris data")
    table(:datatable; dense=true, flat=true, style="height: 350px;", pagination=:datatablepagination)
  ])
])