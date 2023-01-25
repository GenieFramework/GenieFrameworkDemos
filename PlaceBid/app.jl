using GenieFramework
@genietools

@in idx = false
@onbutton idx begin
    @info "bid is placed"
end

function ui()
    [
        card([
            h1("Online Bidding 24x7 🌐", class="q-mx-auto")
            h3("Select a range for your bet", [
                slider(1:5:100)
            ])
            btn("place bid ⏳", color="red", @click("idx = true"))
        ])
    ]
end

@page("/", ui)

Server.isrunning() || Server.up()