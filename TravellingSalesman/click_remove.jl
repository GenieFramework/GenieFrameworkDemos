using Stipple, Stipple.ReactiveTools
using StippleUI
using StipplePlotly
using PlotlyBase
include("utils.jl")
include("tsp.jl")
using .TSPUtils
using .TSP

# format => [lat, lon]
cities = [
    (51.5074, -0.1278),   # London
    (40.7128, -74.0060),  # New York
    (35.6895, 139.6917),  # Tokyo
    (-33.8688, 151.2093), # Sydney
    (37.7749, -122.4194), # San Francisco
    (19.4326, -99.1332)   # Mexico point
]

# Define the two points to connect
point1 = 1 # London
point2 = 3 # Tokyo

# # Create a trace for the points with markers
trace_points = scattergeo(
    locationmode="ISO-3",
    lon=[point[2] for point in cities],
    lat=[point[1] for point in cities],
    mode="markers",
    marker=attr(size=10, color="blue")
)

# Create a trace for the line between the two selected points
trace_line = scattergeo(
    locationmode="ISO-3",
    lon=[cities[point1][2], cities[point2][2]],
    lat=[cities[point1][1], cities[point2][1]],
    mode="lines",
    line=attr(width=2, color="red")
)


# Create the layout
mylayout = PlotlyBase.Layout(
    title="Connecting two points",
    geo=attr(
        projection=attr(type="natural earth"),
        showland=true, showcountries=true,
        landcolor="#EAEAAE", countrycolor="#444444"
    )
)

myconfig = PlotlyBase.PlotConfig()

@app ARModel begin
    @out data = [trace_points, trace_line]
    @out appLayout = mylayout
    @out appConfig = myconfig
    @out points = [ (51.5074, -0.1278),   # London
    (40.7128, -74.0060),  # New York
    (35.6895, 139.6917),  # Tokyo
    (-33.8688, 151.2093), # Sydney
    (37.7749, -122.4194), # San Francisco
    (19.4326, -99.1332)   # Mexico point
]

    @mixin data::PlotlyEvents

    @onchange data_click begin
        println("plot clicked")
        @info data_click
        @show data_click["points"]

        lat = data_click["points"][1]["lat"]
        lon = data_click["points"][1]["lon"]

        closest, idx = TSPUtils.find_closest_point((lat,lon), points)
        if sum((closest .- (lat,lon)).^2) < 5
            deleteat!(points,idx)
            @info "Deleted $closest"
        else
            push!(points, (lat, lon))
        end

        @info typeof(lat)
        @info typeof(lon)

        D = TSPUtils.distance_matrix(points)
        X = TSP.solve_tsp(D)
        connected_points = [(points[i], points[j]) for i in 1:size(X, 1), j in 1:size(X, 2) if X[i, j] == 1.0]
        @show X, TSPUtils.get_travel_route(X)

        travel_route = TSPUtils.get_travel_route(X)
        route_idx = sortperm(travel_route)
        trace_points = scattergeo(
            locationmode="ISO-3",
            lon=[point[2] for point in points],
            lat=[point[1] for point in points],
            text=[string(i) for i in route_idx],
            # text=append(["1"],[string(c[2]) for c in connected_points]),
            textposition="bottom right",
            textfont=attr( family="Arial Black", size=18, color="blue"),
            mode="markers+text",
            marker=attr(size=10, color="blue")
        )

        trace_line = scattergeo(
            locationmode="ISO-3",
            # lat=reduce(vcat, [point[1] for point_pair in connected_points for point in point_pair]),
            # lon=reduce(vcat, [point[2] for point_pair in connected_points for point in point_pair]),
            lat = [points[i][1] for i in travel_route],
            lon = [points[i][2] for i in travel_route],
            mode="lines",
            line=attr(width=2, color="red")
        )

        model.data[] = [trace_points, trace_line]
    end

    model
end

@mounted ARModel watchplots()

UI = Ref{Any}()

UI[] = [
    h1("GenieFramework 🧞 TSP example 🚗")
    plot(:data, layout=:appLayout, config=:appConfig, syncevents=true)
]

ui() = UI[]

route("/") do
    global model
    model = ARModel |> init |> handlers
    @show model
    page(model, ui()) |> html
end

up()
