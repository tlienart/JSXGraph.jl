@testset "JSFun-1" begin
    @jsf bar(x) = 5x+4
    @test bar isa J.JSFun
    @test bar.name == :bar
    @test bar(5) == 5*5+4
    @test J.str(bar) == "function bar(x){return ((5*x)+4)};"

    @jsf function foo(x)
        x^2+2
    end
    @test foo(3) == 3^2+2
    @test J.str(foo) == "function foo(x){return (Math.pow(x,2)+2)};"

    # Show
    io = IOBuffer()
    Base.show(io, bar)
    @test String(take!(io)) == "JSFun: bar\n"
end

@testset "strf" begin
    @jsf foo(x) = 5x+π
    fs, fss, p = J.strf(foo, "FA")
    @test fs == "function foo(x){return ((5*x)+π)};"
    @test fss isa J.JSExpr.JSString
    @test fss.s == "function(t){return INSERT_FA(t);}"
    @test p == ("INSERT_FA" => "foo")
    @test replace(fss.s, p) == "function(t){return foo(t);}"

    @test J.strf(2) == ("", J.JSExpr.JSString("2"), nothing)
end

@testset "replacefn" begin
    @jsf foo(x) = 5x+3
    fs, fss, p = J.strf(foo, "FA")
    jss = js".create('functiongraph', [$fss, 0, 1])"
    @test J.replacefn(jss.s, p) ==
        ".create('functiongraph', [function(t){return foo(t);}, 0, 1])"
    @jsf bar(x) = x^2
    gs, gss, p2 = J.strf(bar, "FB")
    jss = js".create('functiongraph', [$fss, $gss, 0, 1])"
    @test J.replacefn(jss.s, p, p2) ==
        ".create('functiongraph', [function(t){return foo(t);}, function(t){return bar(t);}, 0, 1])"
end

@testset "isdef" begin
    b = board("b")
    b ++ (@jsf foo(x) = 5x)
    # it's already defined
    @test str(foo, b) == ""
    # it will be on the board
    @test occursin("function foo(x){return (5*x)};", str(b, preamble=false))
end
