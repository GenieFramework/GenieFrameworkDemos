using GenieFramework, DataFrames, CSV
@genietools

# @uploadheaders
Genie.config.cors_headers["Access-Control-Allow-Origin"]  =  "*"
Genie.config.cors_headers["Access-Control-Allow-Headers"] = "Content-Type"
Genie.config.cors_headers["Access-Control-Allow-Methods"] = "GET,POST,PUT,DELETE,OPTIONS"
Genie.config.cors_allowed_origins = ["*"]

const FILE_PATH = "upload"
mkpath(FILE_PATH)

@vars begin
    title = "Limited Bandwidth Demo"
    selected_file = "iris.csv"
    selected_column = "petal.length"
    upfiles = readdir(FILE_PATH)
    columns = ["petal.length", "petal.width", "sepal.length", "sepal.width", "variety"]
    irisplot = PlotData()
    files_dirty = false
end

@onchange isready, selected_file, selected_column, upfiles begin
    filepath = joinpath(FILE_PATH, selected_file)
    isfile(filepath) || return
    data = CSV.read(filepath, DataFrame)
    columns = names(data)
    if selected_column in names(data)
        irisplot = PlotData(x=data[!, selected_column], plot=StipplePlotly.Charts.PLOT_TYPE_HISTOGRAM)
    end
end

@event updatefiles begin
    upfiles = readdir(FILE_PATH)
end

# function ui()
#     [
#         row([
#             cell(class="col-md-12", [
#                 uploader(label="Upload Dataset", accept=".csv", multiple=true, method="POST", url="http://localhost:8000/", field__name="csv_file",
#                     var"@uploaded"="handle_event('', 'updatefiles')")
#             ])
#         ]),
#         row([
#             cell(class="st-module", [
#                 h6("File")
#                 Stipple.select(:selected_file; options=:upfiles)
#             ])
#             cell(class="st-module", [
#                 h6("Column")
#                 Stipple.select(:selected_column; options=:columns)
#             ])
#         ]),
#         row([
#             cell(class="st-module", [
#                 h5("Histogram")
#                 plot(:irisplot)
#             ])
#         ])
#     ]
# end


@page("/", "ui.jl")

# @uploadhandler("/", "dirpath")

route("/", method = POST) do
    @show "Processing upload..."
    files = Genie.Requests.filespayload()
    for f in files
        write(joinpath(FILE_PATH, f[2].name), f[2].data)
    end
    if length(files) == 0
        @info "No file uploaded"
    end

    return "Upload finished"
end

Server.isrunning() || Server.up()
