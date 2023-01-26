using GenieFramework, DataFrames, CSV
@genietools

@uploadheaders

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

@page("/", "ui.jl")
@uploadhandler("/", "upload")

Server.isrunning() || Server.up()
