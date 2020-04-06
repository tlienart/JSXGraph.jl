@testset "Curve 1" begin
    b = board("brd", axis=true)
    slider("a", [2,-5],[7,-5],[-5,1,5]) |> b
    slider("b", [2,-6],[7,-6],[-5,0,5]) |> b
    slider("c", [2,-7],[7,-7],[-5,0,5]) |> b

    @jsf f(x) = val(a)*x^2 + val(b)*sin(x) + val(c)

    plot(f) |> b

    write(
        joinpath(dirname(dirname(pathof(JSXGraph))), "sandbox", "index.html"),
        """
        <!DOCTYPE html>
        <html>
        <head>
          <script src="jsxgraphcore.js"></script>
          <link rel="stylesheet" href="jsxgraph.css" />
          <title>JSXGraph playground</title>
        </head>
        <div id="jxgbox" class="jxgbox" style="width:500px; height:500px"></div>
        <script>$(String(take!(b.io)))</script>
        </html>
        """)
end

element ...

b = board(name; options)
add(b, el1, el2, ...)
str(b)
