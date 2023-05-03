module TSPUtils
export haversine_distance, distance_matrix, find_closest_point, get_travel_route

function haversine_distance(lat1, lon1, lat2, lon2)
    R = 6371  # Earth's radius in kilometers
    dLat = (lat2 - lat1) * π / 180
    dLon = (lon2 - lon1) * π / 180
    a = sin(dLat / 2)^2 + cos(lat1 * π / 180) * cos(lat2 * π / 180) * sin(dLon / 2)^2
    c = 2 * atan(sqrt(a), sqrt(1 - a))
    return R * c
end

function distance_matrix(points)
    n = length(points)
    @show typeof(points)
    dist_matrix = Matrix{Float64}(undef, n, n)
    for i in 1:n
        for j in 1:n
            if i == j
                dist_matrix[i, j] = 0
            else
                lat1, lon1 = points[i]
                lat2, lon2 = points[j]
                dist_matrix[i, j] = haversine_distance(lat1, lon1, lat2, lon2)
            end
        end
    end
    return dist_matrix
end
function find_closest_point(coord::Tuple{Float64,Float64}, points::Array{Tuple{Float64,Float64},1})
    lat1, lon1 = coord
    distances = [haversine_distance(lat1, lon1, lat2, lon2) for (lat2, lon2) in points]
    min_distance_index = argmin(distances)
    return points[min_distance_index], min_distance_index
end
# function get_travel_route(X::Matrix{Float64})
#     num_points = size(X, 1)
#     visited = Bool[]
#     route = Int[]
#
#     current_point = 1
#
#     while length(visited) < num_points
#         push!(visited, true)
#         push!(route, current_point)
#
#         found_next = false
#         for j in 1:num_points
#             if X[current_point, j] == 1 && !(j in route)
#                 current_point = j
#                 found_next = true
#                 break
#             end
#         end
#
#         if !found_next
#             break
#         end
#     end
#
#     return route
# end
# function get_travel_route(X::Matrix{Float64})
#     N = size(X, 1)
#     route = [1]  # Start at the first point
#     current_point = 1
#
#     while length(route) < N
#         for j in 1:size(X, 2)
#             if X[current_point, j] == 1
#                 if (j in route) && (length(route) != N - 1 || j != 1)
#                     continue  # Skip visited points unless returning to the starting point at the end of the route
#                 end
#                 push!(route, j)
#                 current_point = j
#                 break
#             end
#         end
#     end
#
#     return route
# end

function get_travel_route(X)
    N = size(X, 1)
    route = [1]
    current_point = 1

    while length(route) < N
        next_points = findall(X[current_point, :] .== 1)
        found_next_point = false
        for next_point in next_points
            if next_point ∉ route || (length(route) == N - 1 && next_point == 1)
                push!(route, next_point)
                current_point = next_point
                found_next_point = true
                break
            end
        end

        if !found_next_point
            # If no valid next point is found, the loop would be infinite
            # We break out of the loop and return an incomplete route
            break
        end
    end

    return route
end
end
