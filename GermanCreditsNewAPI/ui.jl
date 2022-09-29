heading("German Credits by Age")

row([ # big numbers row
  cell(class="st-module", [
    row([
      cell(class="st-br", [
        bignumber("Bad credits", :bad_credits_count, icon="format_list_numbered", color="negative")
      ])
      cell(class="st-br", [
        bignumber("Good credits", :good_credits_count, icon="format_list_numbered", color="positive")
      ])
      cell(class="st-br", [
        bignumber("Bad credits total amount", R"bad_credits_amount | numberformat", icon="euro_symbol", color="negative")
      ])
      cell(class="st-br", [
        bignumber("Good credits total amount", R"good_credits_amount | numberformat", icon="euro_symbol", color="positive")
      ])
    ])
  ])
]) # end big numbers row

row([ # age range slider
  cell([
    h4("Age interval filter")

    range(18:1:90, :age_range; label=true, labelalways=true,
          labelvalueleft=R"'Min age: ' + age_range.min",
          labelvalueright=R"'Max age: ' + age_range.max")
  ])
]) # end age range slider

row([
  cell(class="st-module", [
    h4("Credits data")
    table(:credit_data; pagination=:credit_data_pagination, style="height: 400px;")
  ])
  cell(class="st-module", [
    h4("Credits by age")
    plot(:good_bad_plot; layout=:good_bad_plot_layout, config = "{ displayLogo:false }")
  ])
])

row([
  cell(class="st-module", [
    h4("Credits by age, amount and duration")
    plot(:age_amount_duration_plot, layout=:age_amount_duration_plot_layout)
  ])
])