using MLDatasets: BostonHousing
using SearchLight
using SearchLightSQLite

# edit db/connection.yml
SearchLight.Configuration.load() |> SearchLight.connect

#SearchLight.Generator.newresource("house")
#SearchLight.Generator.newresource("prediction")
# edit migration for House
# edit Houses.jl with struct and seed function
SearchLight.Migrations.init()
#SearchLight.Migrations.last_up()
SearchLight.Migrations.all_up!!()
include("app/resources/houses/Houses.jl")
df = BostonHousing().dataframe
Houses.seed(df)
