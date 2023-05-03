module TwoOpt
export two_opt
using LinearAlgebra

function euclidean_distance(p1, p2)
    return sqrt(sum((p1 .- p2) .^ 2))
end

function calculate_total_distance(points, route)
    N = length(route)
    total_distance = euclidean_distance(points[route[N]], points[route[1]])
    for i in 1:N-1
        total_distance += euclidean_distance(points[route[i]], points[route[i+1]])
    end
    return total_distance
end

function two_opt_swap(route, i, k)
    new_route = copy(route)
    new_route[i:k] = reverse(route[i:k])
    return new_route
end

function two_opt(points, route)
    best_route = route
    best_distance = calculate_total_distance(points, route)

    improvement = true
    while improvement
        improvement = false
        for i in 2:length(route)-1  # Start at index 2 to keep the first point fixed
            for k in i+1:length(route)
                new_route = two_opt_swap(best_route, i, k)
                new_distance = calculate_total_distance(points, new_route)
                if new_distance < best_distance
                    best_distance = new_distance
                    best_route = new_route
                    improvement = true
                end
            end
        end
    end
    return best_route
end

end
