module JSXGraph

using JSExpr
using Random

export @jsf, val

export board, gcb
export slider
export functiongraph, plot

# -----------------------------------------------

abstract type Object end

val(x) = 1 # should be overloaded by specific objects

# -----------------------------------------------

include("jsfun.jl")

include("board.jl")
include("objects/controllers.jl")
include("objects/curves.jl")

end # module
