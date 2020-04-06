@testset "Slider" begin
    s = slider("a", [0,0], [3,0], [0,1.5,3])
    @test s.name == "a"
    @test s.vals == [[0,0], [3,0], [0,1.5,3]]
end
