"""
    Board

Parent element which encapsulates all objects (sliders, points, curves, ...).
"""
mutable struct Board
    name::String
    objects::Vector{Object}
    # --- key board options ---
    xlim::Vector{<:Real}
    ylim::Vector{<:Real}
    axis::Bool
    showcopyright::Bool
    shownavigation::Bool
    style::String
    # --- other board options --- jsxgraph.org/docs/symbols/JXG.Board.html
    opts::Option{Dict{Symbol,Any}}
end
function Board(name, obj;
               xlim=[-10,10], ylim=[-10,10], axis=false,
               showcopyright=false, shownavigation=false,
               style="width:300px; height:300px;", kw...)
    d = dict(kw...)
    b = Board(name, obj, xlim, ylim, axis,
              showcopyright, shownavigation,
              style, d)
    if !isnothing(d) && :boundingbox ∈ keys(d)
        bb = d[:boundingbox]
        @assert length(bb) == 4 "Bounding box must have 4 elements."
        b.xlim = bb[1,3]
        b.ylim = bb[4,2]
    end
    return b
end

"""
    board(name="brd"+randstring(3); opts...)

Create a new board.

* `name` - name of the board (generated by default)

## Keyword
* `xlim::Vector` - x axis limits default: `[-10,10]`
* `ylim::Vector` - y axis limits default: `[-10,10]`
* `axis::Bool` - whether to show the axis ex: false
* `showcopyright::Bool` - whether to show JSX's copyright ex: true
* `shownavigation::Bool` - whether to show a navigation tool on the board ex:
                            true
* `style::String` - the CSS style of the div containing the board ex:
                     `"width:300px; height:300px;"`

You can also use any of the keywords from https://jsxgraph.org/docs/symbols/JXG.Board.html.
"""
board(name="brd_"*randstring(3); kw...) = Board(name, Object[]; kw...)

# ---------------------------------------------------------------------------

get_opts(b::Board) = (
    boundingbox = [b.xlim[1], b.ylim[2], b.xlim[2], b.ylim[1]],
    axis = b.axis,
    showcopyright = b.showcopyright,
    shownavigation = b.shownavigation,
    (isnothing(b.opts) ? () : (;b.opts...))...
    )

"""
    obj |> board
    (obj1, obj2, ...) |> board
    [obj1, obj2, ...] |> board

Add object(s) to board `board`.
"""
(b::Board)(o) = length(o) > 1 ? append!(b.objects, o) : push!(b.objects, o)

"""
    board ++ obj

Same as `obj |> board`.
"""
++(b::Board, obj) = b(obj)

# ---------------------------------------------------------------------------

const PREAMBLE =
    "function val(x){return x.Value();};" *
    prod("function $f(x){return Math.$f(x);};"
         for f in (:abs, :acos, :acosh, :asin, :asinh,
                   :atan, :atanh, :ceil, :cos, :cosh, :exp,
                   :expm1, :floor, :hypot, :log, :log1p, :log10,
                   :log2, :max, :min, :round, :sign, :sin, :sinh,
                   :sqrt, :tan, :tanh, :trunc)) *
    "function rand(){return Math.random();};" *
    "const π=Math.PI;const ℯ=Math.E;const pi=Math.PI;"

function str(b::Board)
    io = IOBuffer()
    print(io, PREAMBLE)
    opts = get_opts(b)
    jss = js"JXG.JSXGraph.initBoard('jxgbox',$opts);"
    print(io, "$(b.name)=" * jss.s)
    for o in b.objects
        print(io, str(o, b))
    end
    return String(take!(io))
end

"""
    save(b, fpath)

Save a board as a javascript file that can be plugged in a HTML file with the
libraries.
"""
function save(b::Board, fpath::AbstractString)
    fpath = splitext(fpath)[1] * ".js"
    write(fpath, str(b))
    return nothing
end

# ---------------------------------------------------------------------------

"""
    standalone(b)

Internal function to return self-contained HTML with Javascript ready to be
displayed.
"""
function standalone(b::Board)
    s = """
        <!DOCTYPE html>
        <html>
        <head>
          <script>
          $(read(joinpath(dirname(pathof(JSXGraph)), "libs", "jsxgraphcore.js"),String))
          </script>
          <style>
          $(read(joinpath(dirname(pathof(JSXGraph)), "libs", "jsxgraph.css"),String))
          </style>
        </head>
        <body>
          <div id="jxgbox" class="jxgbox" style=\"$(b.style)\"></div>
        <script>
          $(str(b))
        </script>
        </body>
        </html>
        """
    return s
end

# NOTE: Juno/Atom does not allow interactive Javascript so obliged to go via
# a Blink window. Not ideal but ok.
#
# For IJulia, should manage to do it like
# https://github.com/queryverse/VegaLite.jl/blob/2208264fe0bfd38f563f26035dd00a0153bd0c61/src/rendering/render.jl#L74
# however this is black magic, I haven't  worked out how to  do it.

function Base.show(io::IO, b::Board)
    if isempty(b.objects)
        println(io, "Board $(b.name) (empty).")
        return
    elseif isdefined(Main, :Atom) && Main.Atom.PlotPaneEnabled[]
        p = Blink.Page()
        Main.Atom.ploturl(Blink.localurl(p))
        wait(p)
        Blink.body!(p, standalone(b))
    else
        w = Blink.Window()
        Blink.body!(w, standalone(b))
    end
    return nothing
end
