@testset "misc" begin
    @test J.val(nothing) == 1
    @test J.val(2) == 1
    @test J.Option{Int} == Union{Nothing,Int}
end
