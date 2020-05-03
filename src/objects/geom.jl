mutable struct Point{X<:FR,Y<:FR} <: Object
    x::X
    y::Y
    opts::Option{LittleDict{Symbol,Any}}
end

point(x::FR, y::FR; kw...) = Point(x, y, dict(;kw...))
point(x::FR, y::FR, d::LittleDict{Symbol,Any}) = Point(x, y, d)

function str(p::Point, b::Board)
    xs, xss, xrp = strf(p.x, "FX", b)
    ys, yss, yrp = strf(p.y, "FY", b)
    opts = get_opts(p)
    jss = js".create('point', [$xss, $yss], $opts);"
    return xs * ys * b.name * replacefn(jss.s, xrp, yrp)
end

mutable struct Segment <: Object
    a::String
    b::String
    opts::Option{LittleDict{Symbol,Any}}
end

segment(a::String, b::String; kw...) = Segment(a, b, dict(;kw...))
segment(a::String, b::String, d::LittleDict{Symbol,Any}) = Segment(a, b, d)

function str(s::Segment, b::Board)
    opts = get_opts(s)
    sa, sb = s.a, s.b
    jss = js".create('segment', [$sa, $sb], $opts);"
    arp = "INSERT_$(sa)_$(sb)" => opts.name
    return b.name * replacefn(jss.s, arp)
end
