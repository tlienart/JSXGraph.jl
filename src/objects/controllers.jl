mutable struct Slider
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
    s = Slider(name, vals)
    return s
end

function str(s::Slider, b::Board=gcb())
    jss = js".create('slider', $(s.vals), (name = $(s.name),))"
    return "$(s.name) = " * b.name * jss.s
end
