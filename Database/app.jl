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
        x = X_features[Int(idx%N+1),:]
        y = model(x)[1]
    end
end

function ui()
[
        card( style="width:1200px;margin-left:auto;margin-right:auto",
        [
                h2("Boston house prices", style="text-align:center")
                btn("Predict!", color="red", @click("idx=idx+1"), style="display:block;margin:auto")
                bignumber("Predicted price", R"y")
                bignumber("Feature vector", R"x")
            ])
    ]
end

@page("/", ui)
Server.isrunning() || Server.up()
