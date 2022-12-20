using DataFrames, Flux
using BSON: @load
using SearchLight, SearchLightSQLite
using GenieFramework
include("app/resources/houses/Houses.jl")
using .Houses
@genietools 

SearchLight.Configuration.load() |> SearchLight.connect
data = DataFrame(all(House))

@load "bostonflux.bson" model
X_features = Matrix(data[:,2:end-1])
N = size(X_features, 1)

@handlers begin
    @in idx = 1 
    @out x = X_features[1, :]
    @out y = 0.0
    @onchange idx begin
        x = X_features[Int(idx),:]
        y = model(x)[1]
    end
end

function ui()
    [
        h5("Predict house price")
        row(btn("Predict!", color="red", @click("idx=idx+1")))
        bignumber("Predicted price", R"y")
    ]
end

@page("/", ui)
Server.isrunning() || Server.up()
