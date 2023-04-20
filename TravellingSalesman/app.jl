module App
include("tsp.jl")
using .TSP
using GenieFramework, PlotlyBase, Random
@genietools

function haversine_distance(lat1, lon1, lat2, lon2)
    R = 6371  # Earth's radius in kilometers
    dLat = (lat2 - lat1) * π / 180
    dLon = (lon2 - lon1) * π / 180
    a = sin(dLat / 2)^2 + cos(lat1 * π / 180) * cos(lat2 * π / 180) * sin(dLon / 2)^2
    c = 2 * atan(sqrt(a), sqrt(1 - a))
    return R * c
end

function distance_matrix(cities)
    n = length(cities)
    @show typeof(cities)
    dist_matrix = Matrix{Float64}(undef, n, n)
    for i in 1:n
        for j in 1:n
            if i == j
                dist_matrix[i, j] = 0
            else
                lat1, lon1 = cities[i]
                lat2, lon2 = cities[j]
                dist_matrix[i, j] = haversine_distance(lat1, lon1, lat2, lon2)
            end
        end
    end
    return dist_matrix
end

@app begin
    @in cities = [
        (51.5074, -0.1278),   # London
        (40.7128, -74.0060),  # New York
        (35.6895, 139.6917),  # Tokyo
        (-33.8688, 151.2093), # Sydney
        (37.7749, -122.4194), # San Francisco
        (19.4326, -99.1332)   # Mexico City
    ]
    @out D = zeros(6, 6)
    @out X = zeros(6, 6)
    @out mapData = [scattergeo()]
    @out mapLayout = PlotlyBase.Layout()
    @out mapConfig = PlotlyBase.PlotConfig()
    @onchange isready begin
        D = distance_matrix(cities)
        X = TSP.solve_tsp(D)
        connected_cities = [(cities[i], cities[j]) for i in 1:size(X, 1), j in 1:size(X, 2) if X[i, j] == 1.0]
        @show connected_cities
        # Create a trace for the cities with markers
        trace_cities = scattergeo(
            locationmode="ISO-3",
            lat=[city[1] for city in cities],
            lon=[city[2] for city in cities],
            mode="markers",
            marker=attr(size=10, color="blue")
        )
        # Create a trace for the line between the two selected cities
        trace_line = scattergeo(
            locationmode="ISO-3",
            lat=reduce(vcat, [city[1] for city_pair in connected_cities for city in city_pair]),
            lon=reduce(vcat, [city[2] for city_pair in connected_cities for city in city_pair]),
            mode="lines",
            line=attr(width=2, color="red")
        )
        mapData = [trace_cities, trace_line]
        @show X
    end
end

function ui()
    [
    h1("Travelling Salesman Problem")
    plot(:mapData, layout=:mapLayout, config=:mapConfig)
    ]
end

@page("/", ui)
Server.up(9000)
end
