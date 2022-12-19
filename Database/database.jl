using RDatasets, DataFrames, Flux, GenieFramework
using BSON: @save, @load

@load "bostonflux.bson" model x_test y_test

@show model(x_test)
SearchLight.Configuration.load() |> SearchLight.connect

SearchLight.Generator.newresource("house")
SearchLight.Migrations.init()
SearchLight.Migrations.last_up()
df = BostonHousing.dataframe
Houses.seed(df)
