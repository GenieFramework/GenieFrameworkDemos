using GenieFramework
using PlotlyBase

trace1 = scatter(Dict(
    :name => "",
    :x => ["2017-05-09 09:30:00", "2017-05-09 16:35:00"],
    :y => [0, 0],
    :marker => Dict(:color => "white")
))
trace2 = scatter(Dict(
    :name => "",
    :x => ["2017-05-09 10:00:00", "2017-05-09 11:22:00"],
    :y => [1, 1],
    :marker => Dict(:color => "white")
))
trace3 = scatter(Dict(
    :name => "",
    :x => ["2017-05-09 10:00:00", "2017-05-09 12:15:00"],
    :y => [2, 2],
    :marker => Dict(:color => "white")
))
trace4 = scatter(Dict(
    :name => "",
    :x => ["2017-05-09 11:15:00", "2017-05-09 12:49:00"],
    :y => [3, 3],
    :marker => Dict(:color => "white")
))
trace5 = scatter(Dict(
    :name => "",
    :x => ["2017-05-09 10:30:00", "2017-05-09 13:56:00"],
    :y => [4, 4],
    :marker => Dict(:color => "white")
))
trace6 = scatter(Dict(
    :name => "",
    :x => ["2017-05-09 11:45:00", "2017-05-09 15:11:00"],
    :y => [5, 5],
    :marker => Dict(:color => "white")
))
trace7 = scatter(Dict(
    :name => "",
    :x => ["2017-05-09 11:45:00", "2017-05-09 13:04:00"],
    :y => [6, 6],
    :marker => Dict(:color => "white")
))
trace8 = scatter(Dict(
    :name => "",
    :x => ["2017-05-09 12:15:00", "2017-05-09 13:30:00"],
    :y => [7, 7],
    :marker => Dict(:color => "white")
))
trace9 = scatter(Dict(
    :name => "",
    :x => ["2017-05-09 12:30:00", "2017-05-09 12:54:00"],
    :y => [8, 8],
    :marker => Dict(:color => "white")
))
trace10 = scatter(Dict(
    :name => "",
    :x => ["2017-05-09 12:45:00", "2017-05-09 17:55:00"],
    :y => [9, 9],
    :marker => Dict(:color => "white")
))
trace11 = scatter(Dict(
    :name => "",
    :x => ["2017-05-09 15:15:00", "2017-05-09 18:25:00"],
    :y => [10, 10],
    :marker => Dict(:color => "white")
))
trace12 = scatter(Dict(
    :name => "Boat_1",
    :x => ["2017-05-09 15:15:00", "2017-05-09 15:15:00"],
    :y => [0, 0],
    :marker => Dict(
        :size => 1,
        :color => "rgb(0, 0, 0)"
    ),
    :hoverinfo => "none",
    :showlegend => true
))
trace13 = scatter(Dict(
    :name => "Boat_2",
    :x => ["2017-05-09 15:15:00", "2017-05-09 15:15:00"],
    :y => [1, 1],
    :marker => Dict(
        :size => 1,
        :color => "rgb(139, 0, 0)"
    ),
    :hoverinfo => "none",
    :showlegend => true
))

mylayout = PlotlyBase.Layout(Dict(
    :title => "Gantt Chart",
    :width => 900,
    :xaxis => Dict(
        :type => "date",
        :showgrid => true,
        :zeroline => false,
        :rangeselector => Dict(:buttons => [
            Dict(
                :step => "day",
                :count => 7,
                :label => "1w",
                :stepmode => "backward"
            ),
            Dict(
                :step => "month",
                :count => 1,
                :label => "1m",
                :stepmode => "backward"
            ),
            Dict(
                :step => "month",
                :count => 6,
                :label => "6m",
                :stepmode => "backward"
            ),
            Dict(
                :step => "year",
                :count => 1,
                :label => "YTD",
                :stepmode => "todate"
            ),
            Dict(
                :step => "year",
                :count => 1,
                :label => "1y",
                :stepmode => "backward"
            ),
            Dict(:step => "all")
        ])
    ),
    :yaxis => Dict(
        :range => [-1, 12],
        :showgrid => true,
        :ticktext => ["Turbine 2", "Turbine 4", "Turbine 10", "Turbine 11", "Turbine 20", "Turbine 27", "Turbine 16", "Turbine 23", "Turbine 15", "Turbine 6", "Turbine 12"],
        :tickvals => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        :zeroline => false,
        :autorange => false
    ),
    :height => 600,
    :shapes => [
        Dict(
            :x0 => "2017-05-09 09:30:00",
            :x1 => "2017-05-09 16:35:00",
            :y0 => -0.4,
            :y1 => 0.4,
            :line => Dict(:width => 0),
            :type => "rect",
            :xref => "x",
            :yref => "y",
            :opacity => 1,
            :fillcolor => "rgb(0, 0, 0)"
        ),
        Dict(
            :x0 => "2017-05-09 10:00:00",
            :x1 => "2017-05-09 11:22:00",
            :y0 => 0.6,
            :y1 => 1.4,
            :line => Dict(:width => 0),
            :type => "rect",
            :xref => "x",
            :yref => "y",
            :opacity => 1,
            :fillcolor => "rgb(139, 0, 0)"
        ),
        Dict(
            :x0 => "2017-05-09 10:00:00",
            :x1 => "2017-05-09 12:15:00",
            :y0 => 1.6,
            :y1 => 2.4,
            :line => Dict(:width => 0),
            :type => "rect",
            :xref => "x",
            :yref => "y",
            :opacity => 1,
            :fillcolor => "rgb(0, 0, 0)"
        ),
        Dict(
            :x0 => "2017-05-09 11:15:00",
            :x1 => "2017-05-09 12:49:00",
            :y0 => 2.6,
            :y1 => 3.4,
            :line => Dict(:width => 0),
            :type => "rect",
            :xref => "x",
            :yref => "y",
            :opacity => 1,
            :fillcolor => "rgb(0, 0, 0)"
        ),
        Dict(
            :x0 => "2017-05-09 10:30:00",
            :x1 => "2017-05-09 13:56:00",
            :y0 => 3.6,
            :y1 => 4.4,
            :line => Dict(:width => 0),
            :type => "rect",
            :xref => "x",
            :yref => "y",
            :opacity => 1,
            :fillcolor => "rgb(139, 0, 0)"
        ),
        Dict(
            :x0 => "2017-05-09 11:45:00",
            :x1 => "2017-05-09 15:11:00",
            :y0 => 4.6,
            :y1 => 5.4,
            :line => Dict(:width => 0),
            :type => "rect",
            :xref => "x",
            :yref => "y",
            :opacity => 1,
            :fillcolor => "rgb(139, 0, 0)"
        ),
        Dict(
            :x0 => "2017-05-09 11:45:00",
            :x1 => "2017-05-09 13:04:00",
            :y0 => 5.6,
            :y1 => 6.4,
            :line => Dict(:width => 0),
            :type => "rect",
            :xref => "x",
            :yref => "y",
            :opacity => 1,
            :fillcolor => "rgb(0, 0, 0)"
        ),
        Dict(
            :x0 => "2017-05-09 12:15:00",
            :x1 => "2017-05-09 13:30:00",
            :y0 => 6.6,
            :y1 => 7.4,
            :line => Dict(:width => 0),
            :type => "rect",
            :xref => "x",
            :yref => "y",
            :opacity => 1,
            :fillcolor => "rgb(0, 0, 0)"
        ),
        Dict(
            :x0 => "2017-05-09 12:30:00",
            :x1 => "2017-05-09 12:54:00",
            :y0 => 7.6,
            :y1 => 8.4,
            :line => Dict(:width => 0),
            :type => "rect",
            :xref => "x",
            :yref => "y",
            :opacity => 1,
            :fillcolor => "rgb(139, 0, 0)"
        ),
        Dict(
            :x0 => "2017-05-09 12:45:00",
            :x1 => "2017-05-09 17:55:00",
            :y0 => 8.6,
            :y1 => 9.4,
            :line => Dict(:width => 0),
            :type => "rect",
            :xref => "x",
            :yref => "y",
            :opacity => 1,
            :fillcolor => "rgb(0, 0, 0)"
        ),
        Dict(
            :x0 => "2017-05-09 15:15:00",
            :x1 => "2017-05-09 18:25:00",
            :y0 => 9.6,
            :y1 => 10.4,
            :line => Dict(:width => 0),
            :type => "rect",
            :xref => "x",
            :yref => "y",
            :opacity => 1,
            :fillcolor => "rgb(0, 0, 0)"
        )
    ],
    :hovermode => "closest",
    :showlegend => true
))

myconfig = PlotlyBase.PlotConfig()

@app begin
    @out appData = [trace1, trace2, trace3, trace4, trace5, trace6, trace7, trace8, trace9, trace10, trace11, trace12, trace13]
    @out appLayout = mylayout
    @out appConfig = myconfig
end

function ui()
    [
        h1("StipplePlotly 🧞 Timeline example 📊")
        plot(:appData, layout=:appLayout, config=:appConfig)
    ]
end

@page("/", ui)

up()