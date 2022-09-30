using Genie.Server
using Stipple
using Stipple.ModelStorage.Sessions
using StippleUI
using StipplePlotly
using Faker

using GenieAutoReload
GenieAutoReload.autoreload(pwd())

@reactive mutable struct HelloPie <: ReactiveModel
  number_of_slices::R{Int} = 3
  piechart::R{PlotData} = PlotData(; values = [], labels = [], plot = "pie")
end

function handlers(model::HelloPie)
  onany(model.isready, model.number_of_slices) do (_...)
    model.piechart[] = PlotData(
      values = rand(1:100, model.number_of_slices[]),
      labels = [Faker.first_name() for _ in 1:model.number_of_slices[]],
      plot = "pie"
    )
  end

  model
end

function ui(model::HelloPie)
  page(
    model,
    [
      heading("Hello pie!")

      row([
        cell(class="st-module", [
          h6("Number of slices")
          slider(1:1:20, :number_of_slices; label=true)
        ])
      ])

      row([
        cell(class="st-module", [
          h5("Pie chart")
          plot(:piechart)
        ])
      ])
    ],
    append = [
      Genie.Assets.channels_support()
      GenieAutoReload.assets()
    ]
  )
end

route("/") do
  HelloPie |> init |> handlers |> ui |> html
end

Server.isrunning() || Server.up()