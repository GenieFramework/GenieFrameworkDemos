[
    heading("{{title}}")
    row([
        cell(class="col-md-12", [
            uploader(label="Upload Dataset", :auto__upload, :multiple, method="POST", url="http://localhost:8000/", field__name="csv_file")
        ])
    ])
    row([
    cell(class="st-module", [
      h6("File")
      Stipple.select(:selected_file; options=:files)
    ])
    cell(class="st-module", [
      h6("Column")
      Stipple.select(:selected_column; options=:columns)
    ])
    ])
  # row([
    # cell(class="st-module", [
      # h5("Iris data")
      # table(:datable; dense=true, flat=true, style="height: 350px;", pagination=:tablepagination)
    # ])
    # ])
  row([
    cell(class="st-module", [
      h5("Histogram")
      plot(:irisplot)
    ])
    ])
] |> string
