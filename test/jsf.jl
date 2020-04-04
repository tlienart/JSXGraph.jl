@testset "JSFun-1" begin
    @jsf bar(x) = 5x+4
    @test bar(5) == 5*5+4
    @test J.str(bar) == "function bar(x){return ((5*x)+4)}"
    # Show
    io = IOBuffer()
    Base.show(io, bar)
    @test String(take!(io)) == "JSFun: bar\n"
    #
    @jsf function foo(x)
        x^2+2
    end
    @test foo(3) == 3^2+2
    @test J.str(foo) == "function foo(x){return (Math.pow(x,2)+2)}"
end
