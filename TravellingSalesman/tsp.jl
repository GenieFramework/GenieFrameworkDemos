"""
Solution for the travelling salesman problem using JuMP.
Source: https://github.com/mtanneau/tutorial_jump
"""
module TSP
export solve_tsp

using Random
using Printf
using Test
using DelimitedFiles

using JuMP
using MathOptInterface
const MOI = MathOptInterface

using GLPK

function all_subsets(x::Vector{T}) where {T}
    res = Vector{T}[[]]  # Vector of vectors
    for elem in x, j in eachindex(res)
        push!(res, [res[j]; elem])
    end
    return res
end

"""
    solve_tsp(D, optimizer)

Compute a shortest TSP tour given the distance matrix `D`.
"""
function solve_tsp(D)
    # Number of cities
    N = size(D, 1)
    N == size(D, 2) || throw(DimensionMismatch())                     # sanity check: `D` is square
    N <= 16 || error("N cannot be larger than 16 for memory safety")  # sanity check: `N` is not too large

    # Instantiate a model
    mip = Model(GLPK.Optimizer)

    # I. Create arc variables
    @variable(mip, X[1:N, 1:N], Bin)

    # II. Set objective
    @objective(mip, Min, sum(X .* D)) # sum(D[i,j] * X[i,j] for i=1:N, j=1:N)

    # III. Add constraints to the model

    # III.1 
    # No city can be its own follower in the tour
    for k in 1:N
        @constraint(mip, X[k, k] == 0.0)
    end

    # III.2
    # Each city has one predecessor and one successor
    for i in 1:N
        @constraint(mip, sum(X[i, j] for j in 1:N) == 1.0)
        @constraint(mip, sum(X[j, i] for j in 1:N) == 1.0)
    end

    # III.3
    # We only want a cycle of length N
    tours = all_subsets([1:N;])
    for st in tours
        T = length(st)
        # Sub-tour elimination constraints
        if 2 ≤ T ≤ N - 1
            @constraint(mip, sum(X[st[k], st[k+1]] for k = 1:T-1) + X[st[T], st[1]] ≤ T - 1)
            @constraint(mip, sum(X[st[k+1], st[k]] for k = 1:T-1) + X[st[1], st[T]] ≤ T - 1)
        end
    end

    # Solve MIP model
    optimize!(mip)

    println("Optimal tour length is ", objective_value(mip))

    # Return solution
    return value.(X)
end

end
