module App
using GenieFramework
using PlotlyBase
@genietools
include("utils.jl")
include("tsp.jl")
include("two_opt.jl")
using .TSPUtils
using .TSP
using .TwoOpt

function draw_map(points, travel_route)
    route_idx = sortperm(travel_route)
    @show travel_route
    @show route_idx
    trace_points = scattergeo(
        locationmode="ISO-3",
        lon=[point[2] for point in points],
        lat=[point[1] for point in points],
        text=[string(i) for i in route_idx],
        # text=append(["1"],[string(c[2]) for c in connected_points]),
        textposition="bottom right",
        textfont=attr(family="Arial Black", size=18, color="blue"),
        mode="markers+text",
        marker=attr(size=10, color="blue"),
        name="Point"
    )

    trace_line = scattergeo(
        locationmode="ISO-3",
        lat=[points[i][1] for i in travel_route],
        lon=[points[i][2] for i in travel_route],
        mode="lines",
        line=attr(width=2, color="red"),
        name="Route"
    )

    trace_return = scattergeo(
        locationmode="ISO-3",
        lat=[points[1][1], points[travel_route[end]][1]],
        lon=[points[1][2], points[travel_route[end]][2]],
        mode="lines",
        line=attr(width=2, color="green"),
        name="Return"
    )

    return [trace_points, trace_line, trace_return]
end
cities = [
    (51.5074, -0.1278),   # London
    (40.7128, -74.0060),  # New York
    (35.6895, 139.6917),  # Tokyo
    (-33.8688, 151.2093), # Sydney
    (37.7749, -122.4194), # San Francisco
    (19.4326, -99.1332)   # Mexico City
]

init_map = draw_map(cities, [1, 2, 3, 4, 5, 6])


# Create the layout
mylayout = PlotlyBase.Layout(
    geo=attr(
        projection=attr(type="natural earth"),
        showland=true, showcountries=true,
        landcolor="#EAEAAE", countrycolor="#444444"
    ),
    margin=attr(l=20, r=20, t=20, b=20),
    width=800, height=800,
)

myconfig = PlotlyBase.PlotConfig()

@app ARModel begin
    @out data = init_map
    @out appLayout = PlotlyBase.Layout(
        geo=attr(
            projection=attr(type="natural earth"),
            showland=true, showcountries=true,
            landcolor="#EAEAAE", countrycolor="#444444"
        ),
        margin=attr(l=20, r=20, t=20, b=20),
        autosize=true
    )

    @out appConfig = myconfig
    @private points = deepcopy(cities)
    @in reset = false
    @out max_reached = false
    @out loading = false
    @mixin data::PlotlyEvents

    @onchange data_click begin
        loading = true
        println("plot clicked")
        @info data_click
        selector = haskey(data_click, "points") ? "points" : "cursor"
        @show data_click[selector]

        max_reached = length(points) >= 8 ? true : false
        if haskey(data_click, "points")
            lat = data_click["points"][1]["lat"]
            lon = data_click["points"][1]["lon"]
        else
            lat = data_click["cursor"]["lat"]
            lon = data_click["cursor"]["lon"]
        end

        closest, idx = TSPUtils.find_closest_point((lat, lon), points)
        if sum((closest .- (lat, lon)) .^ 2) < 5
            length(points) > 1 && deleteat!(points, idx)
            @info "Deleted $closest"
        else
            push!(points, (lat, lon))
        end

        @info typeof(lat)
        @info typeof(lon)

        travel_route = []
        if !max_reached
            D = TSPUtils.distance_matrix(points)
            X = TSP.solve_tsp(D)
            @show D
            connected_points = [(points[i], points[j]) for i in 1:size(X, 1), j in 1:size(X, 2) if X[i, j] == 1.0]
            @show X

            travel_route = TSPUtils.get_travel_route(X)
            # push!(travel_route, 1)

        else
            initial_route = collect(1:length(points))
            travel_route = two_opt(points, initial_route)
        end
        route_idx = sortperm(travel_route)
        data = draw_map(points, travel_route)
        @show points
        loading = false
    end

    @onchange reset begin
        points = deepcopy(cities)
        data = init_map
    end

end

@mounted ARModel watchplots()

function app_jl_html()
    open("./app.jl.html") do f
        read(f, String)
    end
end

route("/") do
    model = ARModel |> init |> handlers
    page(model, app_jl_html()) |> html
end


up()
end
