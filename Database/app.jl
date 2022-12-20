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
y = Vector(data[:, end])
N = length(y)

@handlers begin
    @in idx = 0  
    @out x = []
    @out y = 0
    @onchange idx begin
        x = X_features[Int(idx%N+1),:]
        y = model(x) 
    end
end

function ui()
    [
        h5("Predict house price")
        row(btn("Predict!", color="red", icon="mail", type="a", @click("idx=idx+1")))
        bignumber(label="Predicted price", value=:y)
    ]
end

@page("/", ui)
Server.isrunning() || Server.up()
