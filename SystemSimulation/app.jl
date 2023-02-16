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


@handlers begin
    p = @task 1+1
    @in σ = 10
    @in ρ = 28.0
    @in β = 8 / 3
    @in t_step = 0.03
    @in t_end = 10
    @in start = false
    @out solplot = PlotData()
    u_x = []
    u_y = []
    @onchange start begin
        if !istaskstarted(p) || istaskdone(p) 
        p = @task begin
                    l = 1
                    while integrator.sol.t[end] <= t_end
                        sleep(t_step)
                        solplot = PlotData(x = u_x, y = u_y, plot=StipplePlotly.Charts.PLOT_TYPE_LINE)
                        integrator.p[1] = σ
                        integrator.p[2] = ρ
                        integrator.p[3] = β
                        step!(integrator, t_step, true)
                        append!(u_x, [u[1] for u in integrator.sol.u[l:end]][:])
                        append!(u_y, [u[2] for u in integrator.sol.u[l:end]][:])
                        l = length(integrator.sol.u)
                    end
                    DifferentialEquations.reinit!(integrator)
                    u_x = []
                    u_y = []
                end
        end
        schedule(p)
    end
end

function ui()
    [
     row([
          cell(class="st-module", textfield("End time", :t_end))
          cell(class="st-module", [
                                   h6("sigma")
                                   slider(1:2:20, :σ ; label=true)
                                  ])
          cell(class="st-module", [
                                   h6("rho")
                                   slider(10:2:40, :ρ ; label=true)
                                  ])
          cell(class="st-module", [
                                   h6("beta")
                                   slider(1:2:20, :β ; label=true)
                                  ])
          cell(class="st-module", [
                                   h6("Time step")
                                   slider(0:0.01:0.1, :t_step ; label=true)
                                  ])
           button("Start!", @click("start = !start"))
         ])
     row([
         cell(class="st-module", plot(:solplot))
         cell(class="st-module", "Lorenz equations")
    ])
    ]
end

@page("/", ui)
@page("/", "app.jl.html")
Server.isrunning() || Server.up()
