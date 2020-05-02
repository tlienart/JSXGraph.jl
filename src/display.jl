"""
    standalone(b; full)

Internal function to return self-contained HTML with Javascript ready to be
displayed.
"""
function standalone(b::Board; full=false)
    s = ""
    if full
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
            """
    end
    s *= """<div id="jxgbox" class="jxgbox" style=\"$(b.style)\"></div>
         <script>$(str(b))</script>"""
    if full
        s *= """</body></html>"""
    end
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
        if isempty(b.functions)
            println(io, "Board $(b.name) (empty).")
        else
            println(io, "Board $(b.name) (no objects).")
        end
        return
    elseif isdefined(Main, :Atom) && Main.Atom.PlotPaneEnabled[]
        p = Blink.Page()
        Main.Atom.ploturl(Blink.localurl(p))
        wait(p)
        Blink.body!(p, standalone(b, full=true))
    else
        w = Blink.Window()
        Blink.body!(w, standalone(b, full=true))
    end
    return nothing
end
