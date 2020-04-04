mutable struct JSFun
    f::Function
    s::JSString
    fname::Symbol
end
(jsf::JSFun)(x...) = jsf.f(x...)

function str(jsf::JSFun)
    rs = replace(jsf.s.s, r"\^\((.*?,.*?)\)" => s"Math.pow(\1)")
    return rs
end

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
