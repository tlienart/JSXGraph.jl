@testset "board" begin
    brd = board()
    @test startswith(brd.name, "brd_")
    @test brd isa J.Board
    @test brd.xlim == [-10.,10.]
    @test brd.ylim == [-10.,10.]
    @test !brd.axis
    @test !brd.showcopyright
    @test !brd.shownavigation

    brd = board("foo", xlim=[-2,2], ylim=[3,4], axis=true)
    @test brd.xlim == [-2,2]
    @test brd.ylim == [3,4]
    @test brd.axis

    @test brd.name == gcb().name
end
