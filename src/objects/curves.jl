#=
- curve http://jsxgraph.org/docs/symbols/Curve.html
- datacurve ? (via curve)
=#

mutable struct FunctionGraph <: Object
    f::JSFun
    a::Union{Nothing,<:Real}
    b::Union{Nothing,<:Real}
    # --- other board options --- jsxgraph.org/docs/symbols/Functiongraph.html
    opts::Option{LittleDict{Symbol,Any}}
end

"""
    functiongraph(f; a, b)

* `f` - a function of a single parameter `x` ex: (x -> 3x)
* `a` - optionally set the minimum value of `x`
* `b` - optionall set the maximum value of `x`
"""
function functiongraph(f::JSFun; a=nothing, b=nothing, kw...)
    return FunctionGraph(f, a, b, dict(;kw...))
end

# ---------------------------------------------------------------------------

function str(fg::FunctionGraph, b::Board)
    xmin = ifelse(isnothing(fg.a), b.xlim[1], fg.a)
    xmax = ifelse(isnothing(fg.b), b.xlim[2], fg.b)
    opts = get_opts(fg)
    fs, fss, frp = strf(fg.f, "FN", b)
    jss = js".create('functiongraph', [$fss, $xmin, $xmax], $opts);"
    return fs * b.name * replacefn(jss.s, frp)
end

# ===========================================================================

abstract type Curve{X,Y,A,B} <: Object end

mutable struct ParametricCurve{X<:FR,Y<:FR,A<:FR,B<:FR} <: Curve{X,Y,A,B}
    x::X
    y::Y
    a::A
    b::B
    # -- opts -- jsxgraph.org/docs/symbols/Curve.html
    opts::Option{LittleDict{Symbol,Any}}
end
function parametriccurve(f::FR, g::FR; a::Option{FR}=nothing,
                         b::Option{FR}=nothing, kw...)
    isnothing(a) && (a = -10)
    isnothing(b) && (b = 10)
    return ParametricCurve(f, g, a, b, dict(;kw...))
end
pcurve = parametriccurve

mutable struct DataPlot{X<:AR,Y<:AFR} <: Curve{X,Y,Nothing,Nothing}
    x::X
    y::Y
    # -- opts -- jsxgraph.org/docs/symbols/Curve.html
    opts::Option{LittleDict{Symbol,Any}}
end
dataplot(x::AR, y::JSFun; kw...) = DataPlot(x, y, dict(;kw...))
dataplot(x::AR, y::AR; kw...) = (check_dims(x, y); DataPlot(x, y, dict(;kw...)))

# ---------------------------------------------------------------------------

function str(pc::ParametricCurve, b::Board)
    isnothing(pc.a) && (pc.a = -10)
    isnothing(pc.b) && (pc.b = xmax)
    xs, xss, xrp = strf(pc.x, "FX", b)
    ys, yss, yrp = strf(pc.y, "FY", b)
    as, ass, arp = strf(pc.a, "FA", b)
    bs, bss, brp = strf(pc.b, "FB", b)
    opts = get_opts(pc)
    jss = js".create('curve', [$xss, $yss, $ass, $bss], $opts);"
    return xs * ys * as * bs * b.name * replacefn(jss.s, xrp, yrp, arp, brp)
end

function str(dp::DataPlot, b::Board)
    opts = get_opts(dp)
    jss = js".create('curve', [$(dp.x), $(dp.y)], $opts);"
    return b.name * jss.s
end

# ===========================================================================

plot(f::JSFun; kw...) = functiongraph(f; kw...)
plot(f::FR, g::FR; kw...) = parametriccurve(f, g; kw...)
plot(x::AR, y::AFR; kw...) = dataplot(x, y; kw...)


# # {curveType: 'polar'}
# mutable struct PolarCurve{R<:Function,O<:AFR,A<:FR,B<:FR} <: Curve{R,O,A,B}
#     r::R
#     offset::O
#     a::A
#     b::B
# end
