mutable struct Slider <: Object
    name::String
    vals::Vector{Vector{<:Real}}
end

"""
    slider(name, vals; opts...)

Create a new slider, add it to the current board.

* name - name of the slider ex: `"slider1"`
* vals - position and values of the slider ex: `[[0,0],[3,0],[0,1.5,3]]`
          first element is `[xa, ya]` (position of minimum value point)
          second element is `[xb, yb]` (position of maximum value point)
          third element is `[va, v0, vb]` (min value, default value, max value)
"""
function slider(name, vals) #; opts...)
    @assert length(vals) == 3 "`slider`::expected three subarrays in `vals`."
    @assert length(vals[1]) == 2 && length(vals[2]) == 2 &&
            length(vals[3]) == 3 "`slider`::subvector dims should be 2,2,3."
    s = Slider(name, vals)
    return s
end
slider(name, a, b, v) = slider(name, [a, b, v])

# ---------------------------------------------------------------------------

val(s::Slider) = s.vals[3][2] # midvalue of last vector [va, v0, vb]

# ---------------------------------------------------------------------------

function str(s::Slider, b::Board)
    jss = js".create('slider', $(s.vals), {name:$(s.name),});"
    return "$(s.name)=" * b.name * jss.s
end
