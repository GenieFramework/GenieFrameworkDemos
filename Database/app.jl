using RDatasets, DataFrames, Flux, Random
using MLDatasets: BostonHousing
using BSON: @save, @load

@load "bostonflux.bson" model x_test y_test

@show model(x_test)
