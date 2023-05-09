using GenieFramework
@genietools

@out data = PlotData(
    locations= ["FRA", "DEU", "RUS", "ESP"],
    plot = StipplePlotly.Charts.PLOT_TYPE_SCATTERGEO,
    mode = "markers",
    marker = PlotDataMarker(
        size = [20, 30, 15, 10],
        color = [10.0, 20.0, 40.0, 50.0],
        cmin = 0.0,
        cmax = 50.0,
        colorscale = "Greens",
        colorbar = ColorBar(title_text = "Some rate", ticksuffix = "%", showticksuffix = "last"),
        line = PlotlyLine(color = "black")
    ),
    name = "Europe Data")

@out layout = PlotLayout(
        plot_bgcolor = "#333",
        title = PlotLayoutTitle(text="Europe Plot", font=Font(24)),
        geo = PlotLayoutGeo(scope = "europe", resolution="50")
    )

@out config = PlotConfig()

function ui()
    p("plot")
    plot(:data, layout=:layout, config=:config)
end

@page("/", ui)

Server.isrunning() || Server.up()