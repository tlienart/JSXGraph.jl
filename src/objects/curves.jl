mutable struct FunctionGraph
    f::JSFun
    a::Union{Nothing,<:Real}
    b::Union{Nothing,<:Real}
end

"""
    functiongraph(f; a, b)

* `f` - a function of a single parameter `x` ex: (x -> 3x)
* `a` - optionally set the minimum value of `x`
* `b` - optionall set the maximum value of `x`
"""
functiongraph(f; a=nothing, b=nothing) = FunctionGraph(f, a, b)
plot = functiongraph

function str(fg::FunctionGraph, b::Board=gcb())
    xmin = ifelse(isnothing(fg.a), b.xlim[1], fg.a)
    xmax = ifelse(isnothing(fg.b), b.xlim[2], fg.b)
    jss = js"create('functiongraph', [$(fg.f.s), $xmin, $xmax]);"
    return b.name * jss.s
end
