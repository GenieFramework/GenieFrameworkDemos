using Faker
using GenieFramework
@genietools

@handlers begin
  @in number_of_slices = 3
  @out piechart = PlotData(; values = [], labels = [], plot = "pie")
  @onchangeany isready, number_of_slices begin
    piechart = PlotData(
      values = rand(1:100, number_of_slices),
      labels = [Faker.first_name() for _ in 1:number_of_slices],
      plot = "pie"
    )
  end
end

@page("/", "ui.jl")

Server.isrunning() || Server.up()