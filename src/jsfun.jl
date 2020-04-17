mutable struct JSFun
    f::Function
    s::JSString
    fname::Symbol
end
(jsf::JSFun)(x...) = jsf.f(x...)

"""
    @jsf

Make a function usable on a board. The function can still be used as a normal
Julia function.
"""
macro jsf(ex)
    if !(ex isa Expr) || ex.head ∉ (:function, :(=))
        error("@jsf only works with function definitions.")
    end
    fname = ex.args[1].args[1]
    ex.head = :function
    jsf = JSFun(identity, eval(:(@js($ex))), fname)
    ex.args[1].args[1] = Symbol("__jsf_$(fname)__")
    jsf.f = eval(ex)
    return esc(:($fname = $jsf))
end

function Base.show(io::IO, jsf::JSFun)
    println(io, "JSFun: $(jsf.fname)")
    return nothing
end

# ---------------------------------------------------------------------------

"""
$SIGNATURES

Internal function to recover the javascript corresponding to a JSFun.
"""
function str(jsf::JSFun)
    rs = replace(jsf.s.s, r"\^\((.*?,.*?)\)" => s"Math.pow(\1)")
    return rs * ";"
end

"""
$SIGNATURES

Internal function to get separate strings corresponding to a JSFun to
facilitate the use of functions in plots etc.
"""
function strf(f::JSFun, n::String="FN")
    fn   = String(f.fname)
    jsfn = JSString(fn)
    jsn  = JSString("INSERT_$n")
    fs   = str(f)
    fss  = js"function(t){return $jsn(t);}"
    return fs, fss, "INSERT_$n" => fn
end

function strf(x::Real, ::String="")
    fss = JSString("$x")
    return "", fss, nothing
end

replacefn(s::String, ::Nothing) = s
replacefn(s::String, p::Pair) = replace(s, p)

function replacefn(s::String, ps...)
    for p in ps
        s = replacefn(s, p)
    end
    return s
end
