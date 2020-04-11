function check_dims(x::AR, y::AR)
    if length(x) != length(y)
        throw(DimensionMismatch("The vectors don't have the same length."))
    end
end

dict(kw...) = isempty(kw) ? nothing : Dict{Symbol,Any}(kw...)
