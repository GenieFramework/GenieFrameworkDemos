using GenieFramework
@genietools

using CSV, DataFrames, Dates, OrderedCollections

const data = CSV.File("german_credits.csv") |> DataFrame

function good_bad_credits_stats(data::DataFrame)
  @out good_credits_count = data[data.Good_Rating .== true, [:Good_Rating]] |> nrow
  @out bad_credits_count = data[data.Good_Rating .== false, [:Good_Rating]] |> nrow
  @out good_credits_amount = data[data.Good_Rating .== true, [:Amount]] |> Array |> sum
  @out bad_credits_amount = data[data.Good_Rating .== false, [:Amount]] |> Array |> sum

  (; good_credits_count, bad_credits_count, good_credits_amount, bad_credits_amount)
end

function credit_data_by_age_amount_duration(data::DataFrame; good_rating::Bool)
  data[data.Good_Rating .== good_rating, [:Age, :Amount, :Duration]]
end

function credit_data_by_age(data::DataFrame; good_rating::Bool)
  age_stats::LittleDict{Int,Int} = LittleDict()
  for x in 20:10:90
    age_stats[x] = data[(data.Age .∈ [x:x+10]) .& (data.Good_Rating .== good_rating), [:Good_Rating]] |> nrow
  end
  age_stats
end

@handlers begin
  @in age_range::RangeData{Int} = RangeData(18:90)
  @out credit_data = DataTable(data)
  @out credit_data_pagination = DataTablePagination(rows_per_page=100)
  @out age_slots = ["20-30", "30-40", "40-50", "50-60", "60-70", "70-80", "80-90"]
  @out good_bad_plot_layout = PlotLayout(barmode="group", showlegend = false)
  @out good_bad_plot = PlotData[]
  @out age_amount_duration_plot_layout = PlotLayout(showlegend = false)
  @out age_amount_duration_plot = PlotData[]

  @onchange age_range begin
    filtered_data = data[(age_range.range.start .<= data[!, :Age] .<= age_range.range.stop), :]

    good_credits_count, bad_credits_count, good_credits_amount, bad_credits_amount = good_bad_credits_stats(filtered_data)

    credit_data = DataTable(filtered_data)

    good_bad_plot = [
      PlotData(
        x = age_slots, y = collect(values(credit_data_by_age(filtered_data; good_rating = true))),
        name = "Good credits", plot = StipplePlotly.Charts.PLOT_TYPE_BAR, marker = PlotDataMarker(color = "#72C8A9")
      ),
      PlotData(
        x = age_slots, y = collect(values(credit_data_by_age(filtered_data; good_rating = false))),
        name = "Bad credits", plot = StipplePlotly.Charts.PLOT_TYPE_BAR, marker = PlotDataMarker(color = "#BD5631")
      )
    ]

    dgood = credit_data_by_age_amount_duration(filtered_data; good_rating = true)
    dbad = credit_data_by_age_amount_duration(filtered_data; good_rating = false)
    age_amount_duration_plot = [
      PlotData(
        x = dgood.Age, y = dgood.Amount, name = "Good credits", mode = "markers",
        marker = PlotDataMarker(size=18, opacity= 0.4, color = "#72C8A9", symbol="circle")
      ),
      PlotData(
        x = dbad.Age, y = dbad.Amount, name = "Bad credits", mode = "markers",
        marker = PlotDataMarker(size=18, opacity= 0.4, color = "#BD5631", symbol="cross")
      )
    ]
  end
end

@page("/", "ui.jl")

Server.isrunning() || Server.up()