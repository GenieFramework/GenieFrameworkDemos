module app

using GenieFramework

@genietools

@app ARModel begin
    @out grettings = "Welcome to GenieFramework App"
end

function app_jl_html()
    open("./app.jl.html") do f
        read(f, String)
    end
end

route("/") do
    model = ARModel |> init |> handlers
    page(model, app_jl_html()) |> html
end

up()

end