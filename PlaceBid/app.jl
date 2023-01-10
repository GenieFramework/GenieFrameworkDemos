using GenieFramework
@genietools

@handlers begin
    @in idx = false

    @onchange idx begin
        @info "bid is placed"
        idx[] = false
    end
end

function ui()
    [
        card(
        [
            h2("Online Bidding 24x7 🌐", class="q-mx-auto")
            btn("place bid ⏳", color="red", @click("idx = true"),#= class="fixed-center"=#)
        ])
    ]
end

@page("/", ui)

Server.isrunning() || Server.up()