This folder contains the code used in the simulations for the Mundell-Fleming lecture.  It is based on the code used in  ["Sovereign debt crises and floating-rate bonds"](https://www.markaguiar.com/citation/FloatingRate) by Mark Aguiar, Manuel Amador and Ricardo Alves Monteiro (2023).  


## Running the code 

The code is in [Julia](https://julialang.org/downloads/).

To run the code, open a julia prompt at the root of this repository and type:

    julia> using Pkg 
    julia> Pkg.activate(".")
    julia> Pkg.instantiate()

The above will download the packages needed to run the code. 

The subfolder `scripts` contains the julia script used to generate the figures in the lecture

The subfolder `src` contains the main source code.

The subfolder `output` contains the figures generates by the scripts, as well as some the calculated moments. 

