module JSXGraph

# Javascript
using JSExpr

# Display
import Blink

# Stdlib & simple things
using Random
using DocStringExtensions

# -----------------------------------------------

# board etc
export board, gcb

# defining functions
export @jsf, val

# controllers
export slider

# objects
export functiongraph, parametriccurve, dataplot, plot
export point
export scatterplot, scatter

# -----------------------------------------------

abstract type Object end

# fallbacks overloaded by specific objects
val(x) = 1

function get_opts(x::Object)
    isnothing(x.opts) && return JSString("{}")
    return (;x.opts...)
end

# -----------------------------------------------

include("jsfun.jl")

# -----------------------------------------------

const Option{T} = Union{<:T,Nothing} where T

const FR = Union{JSFun,Real}
const AR = AbstractArray{<:Real}
const AFR = Union{AR,FR}

# -----------------------------------------------

include("utils.jl")

include("board.jl")
include("objects/controllers.jl")
include("objects/curves.jl")
include("objects/geom.jl")
include("objects/extras.jl")

end # module
