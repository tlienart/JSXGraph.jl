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
