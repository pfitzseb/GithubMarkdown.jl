using GithubMarkdown
using Test

cd(@__DIR__) do
@testset "GithubMarkdown.jl" begin
    @testset "in-memory" begin
        ioin = IOBuffer("foo")
        ioout = IOBuffer()
        expectedout = "<p>foo</p>\n"
        rendergfm(ioout, ioin)
        @test String(take!(ioout)) == expectedout
    end

    @testset "html" begin
        io = IOBuffer()
        rendergfm(io, "test1.md"; format = "html")
        @test String(take!(io)) == read("test1.html", String)

        rendergfm("testout.html", joinpath(@__DIR__, "test1.md"); format = "html")
        @test read("testout.html", String) == read("test1.html", String)
    end

    @testset "latex" begin
        io = IOBuffer()
        rendergfm(io, "test1.md"; format = "latex")
        @test String(take!(io)) == read("test1.tex", String)
    end

    @testset "html input" begin
        io = IOBuffer()
        rendergfm(io, "malicious.md", extensions = [])
        @test String(take!(io)) == "<script>console.log(\"this is bad.\")</script>\n<p>asd</p>\n"
        rendergfm(io, "malicious.md")
        @test String(take!(io)) == "&lt;script>console.log(\"this is bad.\")&lt;/script>\n<p>asd</p>\n"
        rendergfm(io, "malicious.md", removehtml = true)
        @test String(take!(io)) == "<!-- raw HTML omitted -->\n<!-- raw HTML omitted -->\n"
    end

    @testset "error handling" begin
        @test_throws ErrorException rendergfm("dontwriteme", "idontexist.md")
        @test !isfile("dontwriteme")
        @test_throws ArgumentError rendergfm("dontwriteme", "test1.md"; format = "nahhh")
        @test !isfile("dontwriteme")
        @test_throws ArgumentError rendergfm("dontwriteme", "test1.md"; extensions = ["nope"])
        @test !isfile("dontwriteme")
    end
end
end
