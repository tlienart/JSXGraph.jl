using JSXGraph

# FunctionGraph
begin
    b = board("brd", shownavigation=true, showscreenshot=true)
    slider("a", [[1,-1],[5,-1],[0,1.5,3]]) |> b
    @jsf foo(x) = val(a)*x^2
    functiongraph(foo, dash=2) |> b
    b
end

# ParametricCurve
begin
    brd = board("brd", xlim=[-1, 15], ylim=[-0.5, 2.5])
    @jsf f1(t) = t - sin(t)
    @jsf f2(t) = 1 - cos(t)
    slider("T", [[0,2.1],[3,2.1],[0,π,5π]]) |> brd
    @jsf fb() = val(T)
    @jsf pa() = f1(val(T))
    @jsf pb() = f2(val(T))
    plot(f1, f2; a=0, b=fb, dash=2) |> brd
    point(pa, pb, withlabel=false) |> brd
    brd
end

# DataPlot
begin
    brd = board("brd", xlim=[0, 1], ylim=[0, 1])
    x = rand(10)
    y = rand(10)
    plot(x, y) |> brd
    brd
end

# Point
begin
    brd = board("brd", xlim=[0,1], ylim=[0,1])
    point(0.5, 0.5, strokecolor="blue", fillcolor="blue", name="hello") |> brd
    slider("b", [[0.1,0.1],[0.6,0.1],[0,0.2,1]]) |> brd
    @jsf m() = val(b)
    point(0.7, m, strokecolor="blue") |> brd
    brd
end

# Scatter
begin
    brd = board("brd", xlim=[0,1], ylim=[0,1])
    scatter(rand(5), rand(5), strokecolor="blue", withlabel=false) |> brd
    brd
end

# Scatter + fun
begin
    brd = board("brd", xlim=[0,1], ylim=[0,1])
    slider("a", [[0.1,0.1],[0.6,0.1],[0,0.2,1]]) |> brd
    @jsf foo() = val(a)
    scatter(rand(5), foo, strokecolor="blue", withlabel=false) |> brd
    brd
end

# Lissajou
begin
    brd = board("brd", xlim=[-12, 12], ylim=[-10,10])
    slider("a", [[2,8],[6,8],[0,3,6]]) |> brd
    slider("b", [[2,7],[6,7],[0,2,6]]) |> brd
    slider("A", [[2,6],[6,6],[0,3,6]]) |> brd
    slider("B", [[2,5],[6,5],[0,3,6]]) |> brd
    slider("delta", [[2,4],[6,4],[0,0,π]], name="&delta;") |> brd
    @jsf f1(t) = val(A)*sin(val(a)*t+val(delta))
    @jsf f2(t) = val(B)*sin(val(b)*t)
    plot(f1, f2, a=0, b=2π, strokecolor="#aa2233", strokewidth=3) |> brd
    brd
end


var c = brd.create('curve',[
          function(t){return A.Value()*Math.sin(a.Value()*t+delta.Value());},
          function(t){return B.Value()*Math.sin(b.Value()*t);},
          0, 2*Math.PI],{strokeColor:'#aa2233',strokeWidth:3});
brd.unsuspendUpdate();
