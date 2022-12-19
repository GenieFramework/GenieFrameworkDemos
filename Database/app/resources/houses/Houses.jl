module Houses

import SearchLight: AbstractModel, DbId, save!
import Base: @kwdef
using CSV, DataFrames

export House

@kwdef mutable struct House <: AbstractModel
    id::DbId = DbId()
    CRIM::Float64 = 0.0
    ZN::Float64 = 0.0
    INDUS::Float64 = 0.0
    CHAS::Float64 = 0.0
    NOX::Float64 = 0.0
    RM::Float64 = 0.0
    AGE::Float64 = 0.0
    DIS::Float64 = 0.0
    RAD::Float64 = 0.0
    TAX::Float64 = 0.0
    PTRATIO::Float64 = 0.0
    B::Float64 = 0.0
    LSTAT::Float64 = 0.0
    MEDV::Float64 = 0.0
end

function seed(df)
    for row in eachrow(df)
        House(
            CRIM = row.CRIM,
            ZN = row.ZN,
            INDUS = row.INDUS,
            CHAS = row.CHAS,
            NOX = row.NOX,
            RM = row.RM,
            AGE = row.AGE,
            DIS = row.DIS,
            RAD = row.RAD,
            TAX = row.TAX,
            PTRATIO = row.PTRATIO,
            B = row.B,
            LSTAT = row.LSTAT,
            MEDV = row.MEDV,
        ) |> save!
    end
end

end
