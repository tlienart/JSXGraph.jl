mutable struct FunctionGraph <: Object
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

# ---------------------------------------------------------------------------

function str(fg::FunctionGraph, b::Board)
    xmin = ifelse(isnothing(fg.a), b.xlim[1], fg.a)
    xmax = ifelse(isnothing(fg.b), b.xlim[2], fg.b)
    fss = str(fg.f)
    jss = js".create('functiongraph', [function (x){return INSERT_FN(x)}, $xmin, $xmax]);"
    return fss * ";" * b.name * replace(jss.s, "INSERT_FN" => fg.f.fname)
end
