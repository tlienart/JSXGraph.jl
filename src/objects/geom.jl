mutable struct Point{X<:FR,Y<:FR} <: Object
    x::X
    y::Y
    opts::Option{Dict{Symbol,Any}}
end

point(x::FR, y::FR; kw...) = Point(x, y, dict(kw...))
point(x::FR, y::FR, d::Dict{Symbol,Any}) = Point(x, y, d)

function str(p::Point, b::Board)
    xs, xss, xrp = strf(p.x, "FX")
    ys, yss, yrp = strf(p.y, "FY")
    opts = get_opts(p)
    jss = js".create('point', [$xss, $yss], $opts);"
    return xs * ys * b.name * replacefn(jss.s, xrp, yrp)
end
