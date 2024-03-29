using DataFrames, Flux, Dates
using BSON: @load
using SearchLightSQLite
using SearchLight: findone, SQLWhereExpression, Configuration, connect, save!
using GenieFramework
@genietools 
include("app/resources/houses/Houses.jl")
include("app/resources/predictions/Predictions.jl")
using .Houses, .Predictions

Configuration.load() |> connect
@load "bostonflux.bson" model

@handlers begin
    @out datatable = DataFrame(all(House))[:,2:end] |> x -> insertcols(x, 1, :id => 1:count(House)) |> DataTable
    @out predtable = DataTable()
    @out datatablepagination = DataTablePagination(rows_per_page=50)
    @in hid = 0 
    @out house = House()
    @out prediction = Prediction()

    @onchange hid begin
        house = findone(House, id=hid)
        # prediction = Prediction()
        prediction.house_id = house.id
        prediction.price = model([getfield(house, i) for i in 2:14])[1]
        @show prediction.price
        prediction.error = abs(prediction.price - house.MEDV)
        prediction.timestamp = string(now())
        save!(prediction)
        predtable = DataFrame(all(Prediction))[:,2:end] |> x -> insertcols(x, 1, :id => 1:count(Prediction))|> DataTable
    end
end

function ui()
[
        h2(class="q-mx-auto", style="margin:auto;display:block", "Boston house prices")
        row(
        [
                cell(class="st-module card", style="width:400px", [
                    h6("Predict house price")
                    textfield("House id", :hid)
                    bignumber("Real price", R"house.MEDV")
                    bignumber("Predicted price", R"prediction.price")
                    cell(class="", style="margin:auto;display:block")
                ])
                cell(class="st-module", [
                    h6("Prediction history")
                    GenieFramework.table(:predtable; dense=true, flat=true, style="height: 350px;", pagination=:datatablepagination)])
            ])
        row(
        [
                cell(class="st-module", [
                    h6("House data")
                    GenieFramework.table(:datatable; dense=true, flat=true, style="height: 350px;", pagination=:datatablepagination)])
            ]
        )
    ]
end

@page("/", ui)
Server.isrunning() || Server.up()
