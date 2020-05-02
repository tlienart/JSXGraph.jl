# Scatter
# begin
#     brd = board("brd", xlim=[0,1], ylim=[0,1])
#     scatter(rand(5), rand(5), strokecolor="blue", withlabel=false) |> brd
#     brd
# end

# Scatter + fun
# begin
#     brd = board("brd", xlim=[0,1], ylim=[0,1])
#     slider("a", [[0.1,0.1],[0.6,0.1],[0,0.2,1]]) |> brd
#     @jsf foo() = val(a)
#     scatter(rand(5), foo, strokecolor="blue", withlabel=false) |> brd
#     brd
# end
