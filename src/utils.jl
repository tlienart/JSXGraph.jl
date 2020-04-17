"""
$SIGNATURES

Internal function to check that two vectors have matching length.
"""
function check_dims(x::AR, y::AR)
    if length(x) != length(y)
        throw(DimensionMismatch("The vectors don't have the same length."))
    end
end

"""
$SIGNATURES

Internal function to unpack kwargs.
"""
dict(kw...) = isempty(kw) ? nothing : Dict{Symbol,Any}(kw...)
