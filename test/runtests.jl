using GFM
using Test

@testset "GFM.jl" begin
    @testset "html" begin
        io = IOBuffer()
        rendergfm(io, joinpath(@__DIR__, "test1.md"); format = "html")
        @test String(take!(io)) == read("test1.html", String)

        rendergfm("testout.html", joinpath(@__DIR__, "test1.md"); format = "html")
        @test read("testout.html", String) == read("test1.html", String)
    end

    @testset "latex" begin
        io = IOBuffer()
        rendergfm(io, joinpath(@__DIR__, "test1.md"); format = "latex")
        @test String(take!(io)) == read("test1.tex", String)
    end

    @testset "error handling" begin
        @test_throws ErrorException rendergfm("dontwriteme", "idontexist.md")
        @test !isfile("dontwriteme")
        @test_throws ArgumentError rendergfm("dontwriteme", joinpath(@__DIR__, "test1.md"); format = "nahhh")
        @test !isfile("dontwriteme")
    end
end
