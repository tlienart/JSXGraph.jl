"""
$SIGNATURES

Internal function to check that two vectors have matching length.
"""
function check_dims(vec1, vec2)
    if length(vec1) != length(vec2)
        throw(DimensionMismatch("The vectors don't have the same length."))
    end
end

"""
$SIGNATURES

Internal function to unpack kwargs.
"""
dict(;kw...) = isempty(kw) ? nothing : LittleDict{Symbol,Any}(kw)
