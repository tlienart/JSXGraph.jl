module JSXGraph

# Javascript
using JSExpr

# Display
import Blink

# Stdlib & simple things
using Random
using DocStringExtensions
import OrderedCollections: LittleDict

# -----------------------------------------------

# board etc
export board, gcb, (++)
# save
export save, str

# defining functions
export @jsf, @js_str
export val, valx, valy, setx, sety

# controllers
export slider, button

# objects
export functiongraph, parametriccurve, polarcurve, dataplot, plot
export point
export scatterplot, scatter

# -----------------------------------------------

abstract type Object end

Base.length(o::Object) = 1

# fallbacks overloaded by specific objects
val(x) = 1
valx(x) = 1
valy(y) = 1
setx(o, x) = 1
sety(o, y) = 1

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

include("display.jl")

end # module
