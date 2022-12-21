using DataFrames, Flux, GenieFramework

SearchLight.Configuration.load() |> SearchLight.connect

SearchLight.Generator.newresource("house")
SearchLight.Migrations.init()
SearchLight.Migrations.last_up()
df = BostonHousing.dataframe
Houses.seed(df)
