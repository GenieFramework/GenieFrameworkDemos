using GenieFramework, DataFrames, CSV
@genietools

Genie.config.cors_headers["Access-Control-Allow-Origin"]  =  "*"
Genie.config.cors_headers["Access-Control-Allow-Headers"] = "Content-Type"
Genie.config.cors_headers["Access-Control-Allow-Methods"] = "GET,POST,PUT,DELETE,OPTIONS"
Genie.config.cors_allowed_origins = ["*"]

# const FILE_PATH = "backend_upload"
const FILE_PATH = "upload"
mkpath(FILE_PATH)

# @out title = "CSV Analysis"
# @out files = readdir(FILE_PATH)
# @in selected_file = "iris.csv"
# @in selected_column = "petal.length"
# @out columns = ["petal.length", "petal.width", "sepal.length", "sepal.width", "variety"]
# @out datatable = DataTable()
# data = DataFrame()
# @out irisplot = PlotData()

# @handlers begin
#     @onchangeany isready, selected_file, selected_column begin
#         data = CSV.read(joinpath(FILE_PATH, selected_file), DataFrame)
#         columns = names(data)
#         datatable = DataTable(data)
#         if selected_column in names(data)
#             irisplot = PlotData(x=data[!, selected_column], plot=StipplePlotly.Charts.PLOT_TYPE_HISTOGRAM)
#         end
#     end
# end

route("/", method = POST) do
  files = Genie.Requests.filespayload()
  for f in files
      write(joinpath(FILE_PATH, f[2].name), f[2].data)
      @info "type of files $(typeof(files))"
      @info "f[name].name $(typeof(f[2].name))"
      push!(files, f[2].name)
  end
  if length(files) == 0
      @info "No file uploaded"
  end
  return "upload done"
end

route("/bye") do
  "Good bye!"
end                 # [GET] /bye => ()

@page("/", "ui.jl")
Server.isrunning() || Server.up()
