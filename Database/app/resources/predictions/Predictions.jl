module Predictions

import SearchLight: AbstractModel, DbId, save!
import Base: @kwdef
using Dates

export Prediction

@kwdef mutable struct Prediction <: AbstractModel
    id::DbId = DbId()
    price::Float64 = 0.0
    error::Float64 = 0.0
    timestamp::String = ""
end

end
