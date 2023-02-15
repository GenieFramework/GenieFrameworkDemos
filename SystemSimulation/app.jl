using GenieFramework
using DifferentialEquations, ModelingToolkit
@genietools 

function define_ODE()
    @parameters t σ ρ β
    @variables x(t) y(t) z(t)
    D = Differential(t)

    eqs = [D(x) ~ σ * (y - x),
           D(y) ~ x * (ρ - z) - y,
           D(z) ~ x * y - β * z]
    @named sys = ODESystem(eqs)
    sys = structural_simplify(sys)
    u0 = [x => 1.0,
          y => 0.0,
          z => 0.0]
    p = [σ => 10.0,
         ρ => 28.0,
         β => 8 / 3]

    tspan = (0.0, 100.0)
    ODEProblem(sys, u0, tspan, p, jac = true)
end
    
prob = define_ODE()
integrator = DifferentialEquations.init(prob, Tsit5())

p = @task 1+1
schedule(p)

@handlers begin
    prob = define_ODE()
    p = @task 1+1
    schedule(p)
    @in t_step = 0.00
    @in t_end = 10
    @in start = false
    @out solplot = PlotData()
    u_x = []
    u_y = []
    @onchange start begin
        if istaskdone(p) == true || istaskstarted(p) == false
            p = @task begin
                @show p._state
                l = 1
                while integrator.sol.t[end] <= t_end
                    sleep(0.2)
                    solplot = PlotData(x = u_x, y = u_y, plot=StipplePlotly.Charts.PLOT_TYPE_LINE)
                    step!(integrator, t_step, true)
                    println(integrator.sol.t[end], ' ', l)
                    append!(u_x, [u[1] for u in integrator.sol.u[l:end]][:])
                    append!(u_y, [u[2] for u in integrator.sol.u[l:end]][:])
                    l = length(integrator.sol.u)
                end
                DifferentialEquations.reinit!(integrator)
                u_x = []
                u_y = []
            end
            println("aaa")
            println(p._state)
            schedule(p)
        end
    end
end

function ui()
[
        row([
            cell(class="st-module", textfield("End time", :t_end))
            cell(class="st-module", [
                h6("Time step")
                slider(0:0.1:1, :t_step ; label=true)
            ])
            button("Start!", @click("start = true"))
        ])
        row(plot(:solplot))
        # btn("End simulation", color = "primary", icon = "mail", @click("DifferentialEquations.reinit!(integrator)"))
    ]
end

@page("/", ui)
Server.isrunning() || Server.up()
