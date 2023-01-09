using DataFrames, Flux, Dates
using BSON: @load
using SearchLightSQLite
using SearchLight: find, SQLWhereExpression, Configuration, connect, save!
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
    @in id = 0 
    @out house = House()
    @out prediction = Prediction()

    @onchange id begin
        house = find(House, SQLWhereExpression("id == ?", id))[1]
        prediction = Prediction()
        # prediction.id = SearchLight.DbId(id)
        prediction.price = model([getfield(house, i) for i in 2:14])[1]
        prediction.error = abs(prediction.price - house.MEDV)
        prediction.timestamp = string(now())
        @show prediction
        save!(prediction)
        predtable = DataFrame(all(Prediction))[:,2:end] |> x -> insertcols(x, 1, :id => 1:count(Prediction))|> DataTable
    end
end

function ui()
[
        h2(class="q-mx-auto", "Boston house prices")
        row(
        [
                cell(class="st-module card", style="width:400px", [
                    textfield("House id", :id)
                    bignumber("Real price", R"house.MEDV")
                    bignumber("Predicted price", R"prediction.price")
                ])
                cell(class="st-module", GenieFramework.table(:predtable; dense=true, flat=true, style="height: 350px;", pagination=:datatablepagination))
            ])
        row(
        [
                cell(class="st-module", GenieFramework.table(:datatable; dense=true, flat=true, style="height: 350px;", pagination=:datatablepagination))

            ]
        )
    ]
end

@page("/", ui)
Server.isrunning() || Server.up()
