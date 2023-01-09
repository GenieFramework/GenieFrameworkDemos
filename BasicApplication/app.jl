using GenieFramework
@genietools

d₁ = PlotData(
    x = [1, 2, 3],
    y = [4, 1, 2],
    plot = StipplePlotly.Charts.PLOT_TYPE_BAR,
    name = "Barcelona")
    
d₂ = PlotData(
    x = [1, 2, 3],
    y = [2, 4, 5],
    plot = StipplePlotly.Charts.PLOT_TYPE_BAR,
    name = "London")

@handlers begin
    @in data = [d₁, d₂]
    @in layout = PlotLayout()
end

function ui()
    [
        h1("GenieFramework 🧞 Data Vizualization 📊")
        plot(:data, layout=:layout)
    ]
end

@page("/", ui)

Server.isrunning() || Server.up()