[
    heading("{{title}}")
    row([
        cell(class="col-md-12", [
          uploader(label="Upload Dataset", accpt=".csv", multiple=true, method="POST", url="http://localhost:8000/", field__name="csv_file",
          var"@uploaded"="handle_event('', 'updatefiles')")
        ])
    ])
    row([
    cell(class="st-module", [
      h6("File")
      Stipple.select(:selected_file; options=:upfiles)
    ])
    cell(class="st-module", [
      h6("Column")
      Stipple.select(:selected_column; options=:columns)
    ])
    ])
  row([
    cell(class="st-module", [
      h5("Histogram")
      plot(:irisplot)
    ])
    ])
] |> string
