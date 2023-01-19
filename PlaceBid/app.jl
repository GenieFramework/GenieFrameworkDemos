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
            h1("Online Bidding 24x7 🌐", class="q-mx-auto")
            h3("Select a range for your bet", [
                slider(1:5:100)
            ])
            btn("place bid ⏳", color="red", class="float-right", @click("idx = true"))
        ])
    ]
end

@page("/", ui)

Server.isrunning() || Server.up()