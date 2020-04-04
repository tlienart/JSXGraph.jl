module JSXGraph

using JSExpr
using Random

export @jsf, val

export board, gcb
export slider
export functiongraph, plot

const JSX_ENV = Dict{Symbol,Any}(
    :CURRENT_BOARD => nothing,
    )

abstract type Object end

val = identity

# -----------------------------------------------

include("jsfun.jl")

include("board.jl")
include("objects/controllers.jl")
include("objects/curves.jl")

end # module
