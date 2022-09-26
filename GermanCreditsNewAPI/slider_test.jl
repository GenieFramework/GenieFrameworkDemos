using GenieFramework
@genietools

@reactive! mutable struct Test <: ReactiveModel
  # range_data::R{RangeData{Int}} = RangeData(18:80)
  # range_data::R{RangeData{Int}} = R(RangeData{Int}(18:80))
  range_data = R(RangeData{Int}(18:80))
end

function handlers(model)
  on(model.range_data) do val
    @show val
  end

  model
end

function ui(model)
  page(model, [
    heading("German Credits by Age")
    range(18:1:90,
              :range_data;
              label=true,
              labelalways=true,
              labelvalueleft=Symbol("'Min age: ' + range_data.min"),
              labelvalueright=Symbol("'Max age: ' + range_data.max"))
  ])
end

route("/") do
  Test |> init |> handlers |> ui |> html
end