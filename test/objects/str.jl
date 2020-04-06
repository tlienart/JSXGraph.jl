@testset "controllers" begin
    b = board("brd")
    slider("a", [0,0], [3,0], [0, 1.5, 3]) |> b
    s = String(take!(b.io))
    @test endswith(s, """a = brd.create('slider', [[0.0,0.0],[3.0,0.0],[0.0,1.5,3.0]], (name = "a",));""")
end
