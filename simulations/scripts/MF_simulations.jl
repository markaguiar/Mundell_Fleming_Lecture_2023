# Simulations for IMF conference

# Getting the pacakages 
import Pkg
Pkg.activate(joinpath(@__DIR__, ".."))
Pkg.instantiate() 

using Revise
using LTBonds
using ThreadsX 
using Random 
using PrettyTables
using Plots
using LaTeXStrings
using Infiltrator
using DataFrames

SAVE_MOMENTS = true # set to true to save the moments to file. 
SAVE_FIGS = true 


benchmark_parameters =  let
    R = 1.01
    β = 0.9540232420
    β_ST=0.85
    γ = 2
    pref = Preferences(β = β, u = make_CRRA(ra = γ))
    prefST = Preferences(β = β_ST, u = make_CRRA(ra = γ))
    y = discretize(YProcess(n = 50, ρ = 0.948503, std = 0.027092, μ = 0.0, span = 3.0, tails = false))
    m = MTruncatedNormal(; std = 0.003, span = 2.0, quadN = 100)
    penalty = DefCosts(pen1 = -0.1881927550, pen2 = 0.2455843389, quadratic = true, reentry = 0.0385)
    η=0.05 #0.1
    (R = R, pref = pref, prefST=prefST, y = y, m = m, penalty = penalty, η=η, γ=γ)
end;



models = let
    R, pref,  prefST,  y, m, penalty, η = benchmark_parameters
   bondLT = Bond(n = 350, min = 0.0, max = 1.5, κ = 0.03, λ = 0.05)  
    bondST = Bond(n = 350, min = 0.0, max = 1.5, κ = R - 1, λ = 1.0)  
    

    egLT = generate_workspace(
        LTBondModel(
            y = y,
            m = m, 
            preferences = pref, 
            bond = bondLT, 
            def_costs = penalty, 
            R = R,
        )
    )

    egST = generate_workspace(
        LTBondModel(
            y = y,
            m = m, 
            preferences = prefST, 
            bond = bondST, 
            def_costs = penalty, 
            R = R,
        )
    )

    ckST = generate_workspace(
        CKLTBondModel(
            y = y,
            m = m, 
            preferences = prefST, 
            bond = bondST, 
            def_costs = penalty, 
            R = R,
            η = η
        )
    )


   (; egLT, egST, ckST) 
end;

rstar = 4 * log(benchmark_parameters.R)
rho0 = - 4 * log(benchmark_parameters.pref.β)
rho1 = - 4 * log(benchmark_parameters.prefST.β)

# compute models
@time for m ∈ models
    @time solve!(m; print_every = 200, max_iters = 5_000, err = 1e-7)
end

println("Simulations")

#simulations
big_T = 20_000 
big_N = 1_000

#generate shock path 
rng = Random.seed!(1234)
shocks, paths = create_shocks_paths(models.ckST, big_T, big_N; rng) # make sure to use a ck model to draw the sunspots

computed_moments = 
    map(
        (; models.egST, models.ckST, models.egLT)) do (m) 
        simulation!(paths, shocks, m; n = big_T, trim = 1000, trim_def = 20)
        out = moments(paths, m)
        (; out.mean_bp_y, out.mean_mv_y, out.mean_spread, out.std_spread, out.max_spread,  out.std_c_y, out.cor_tb_y, out.cor_r_y, out.cor_r_b_y, out.cor_r_tb, out.def_rate, out.run_share)
    end

#formats moments 
pretty_table(
    collect(map(m -> pairs(m), computed_moments)),
    row_names = collect(keys(computed_moments)), 
    formatters = (  ft_printf("%5.3f",[3,4,11]),ft_printf("%5.2f"),)
)

SAVE_MOMENTS && open(joinpath(@__DIR__,"..","output","moments.txt"), "w") do f
    pretty_table(f, 
        collect(map(m -> pairs(m), computed_moments)),
        row_names = collect(keys(computed_moments)), 
        formatters = ( ft_printf("%5.2f", [1, 2]), ft_printf("%5.3f"))
    )
end


#beta and gamma grids for autarky comparisons
betaGrid=LinRange(0.95,0.999,50)
gammaGrid=LinRange(0.5,20,50)
#dataframes to store results 
beta_df=DataFrame("Beta"=>betaGrid)
rho= -4*log.(betaGrid)
insertcols!(beta_df,2,:rho=>rho)
gamma_df=DataFrame("Gamma"=>gammaGrid)


@time do_beta_simulations!(beta_df, models, benchmark_parameters, shocks, paths, betaGrid)
sort!(beta_df,[:rho])
rho_threshold=beta_df.rho[findmin(x->abs(x-1), beta_df.egLT)[2]]
println("rho for EGLT= ", rho_threshold)
println("rho for ST= ", beta_df.rho[findmin([abs(x-y) for (x,y) in zip(beta_df.egST,beta_df.ckST)])[2]])

@time do_gamma_simulations!(gamma_df, models, benchmark_parameters, shocks, paths, gammaGrid)
sort!(gamma_df,[:Gamma])
gamma_threshold =gamma_df.Gamma[findmin(x->abs(x-1), gamma_df.egLT)[2]]
println("gamma for EGLT= ", gamma_threshold)
println("gamma for ST= ", gamma_df.Gamma[findmin([abs(x-y) for (x,y) in zip(gamma_df.egST,gamma_df.ckST)])[2]])


#frontier grids for autarky comparisons
betaGrid_coarse=LinRange(0.95,0.975,20)
gammaGrid_coarse=LinRange(0.5,15,50)
frontier = Array{Float64}(undef,length(betaGrid_coarse),length(gammaGrid_coarse))   
thresh= Array{Int64}(undef,length(betaGrid_coarse))

@time do_frontier_simulations!(frontier, thresh,models.egLT, shocks, paths, betaGrid_coarse,gammaGrid_coarse)


#beta and gamma grid for LoLR comparisons
norun_betaGrid=LinRange(0.8,0.999,50)
norun_gammaGrid=LinRange(0.5,20,50)

norun_beta_df=DataFrame("Beta"=>norun_betaGrid)
rho2= -4*log.(norun_betaGrid)
insertcols!(norun_beta_df,2,:rho=>rho2)
norun_gamma_df=DataFrame("Gamma"=>norun_gammaGrid);


@time norun_welfare_beta!(norun_beta_df, models,benchmark_parameters, shocks, paths, norun_betaGrid)
sort!(norun_beta_df,[:rho])
norun_rho_threshold=norun_beta_df.rho[findmin(x->abs(x-1), norun_beta_df.Lambda)[2]]
println("rho for no run= ", norun_rho_threshold)

@time norun_welfare_gamma!(norun_gamma_df, models,benchmark_parameters, shocks, paths, norun_gammaGrid)
sort!(norun_gamma_df,[:Gamma])
norun_gamma_threshold=norun_gamma_df.Gamma[findmin(x->abs(x-1), norun_gamma_df.Lambda)[2]]
println("gamma for no run= ", norun_gamma_threshold)


#frontier grids for LoLR comparisons
norun_betaGrid_coarse=LinRange(0.95,0.99,20)
norun_gammaGrid_coarse=LinRange(0.5,10,50)
norun_frontier = Array{Float64}(undef,length(norun_betaGrid_coarse),length(norun_gammaGrid_coarse)) 
norun_thresh= Array{Int64}(undef,length(norun_betaGrid_coarse))

@time norun_do_frontier_simulations!(norun_frontier, norun_thresh,models, shocks, paths, norun_betaGrid_coarse,norun_gammaGrid_coarse)


# Plots

#Figure 13
plt=plot(-4*log.(betaGrid_coarse),[gammaGrid_coarse[i] for i in thresh],color=:black,lw=3,legend=false;fill=(0,:grey80,0.5))
plot!(-4*log.(betaGrid_coarse),[gammaGrid_coarse[i] for i in thresh],color=:black,lw=3,legend=false;fill=(15,:red,0.5))
xlabel!("Household Discount Rate: " * L"\rho")
ylabel!("Household Risk Aversion: " * L"\gamma")
annotate!(-4*log(benchmark_parameters.pref.β),benchmark_parameters.γ, text(L"\cdot",50))
annotate!(-4*log(benchmark_parameters.pref.β)+.002,benchmark_parameters.γ+.25, text("G",14))
annotate!(0.12,10, text("Prefers Autarky",14,))
annotate!(0.16,4, text("Prefers Debt",14,))
annotate!(0.108,4.25, text(L"\cdot",50,))
annotate!(0.11,4.5, text("B",14,))
annotate!(0.12,2.5, text(L"\cdot",50,))
annotate!(0.122,2.75, text("A",14,))

SAVE_FIGS && savefig(plt, joinpath(@__DIR__, "..","output", "Figure13.pdf"))
SAVE_FIGS && savefig(plt, joinpath(@__DIR__, "..","output", "Figure13.eps"))

#Figure 14
plt=plot(-4*log.(norun_betaGrid_coarse),[norun_gammaGrid_coarse[i] for i in norun_thresh],color=:black,lw=3,legend=false;fill=(0,:grey80,0.5))
plot!(-4*log.(norun_betaGrid_coarse),[norun_gammaGrid_coarse[i] for i in norun_thresh],color=:black,lw=3,legend=false;fill=(10,:red,0.5))
xlabel!("Household Discount Rate: " * L"\rho")
ylabel!("Household Risk Aversion: " * L"\gamma")
annotate!(0.08,5, text("Prefers Runs",14,))
annotate!(0.16,3, text("Prefers LoLR",14,))

SAVE_FIGS && savefig(plt, joinpath(@__DIR__, "..","output", "Figure14.pdf"))
SAVE_FIGS && savefig(plt, joinpath(@__DIR__, "..","output", "Figure14.eps"))



