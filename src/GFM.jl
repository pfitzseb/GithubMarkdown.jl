module GFM

export rendergfm

const libpath = normpath(joinpath(@__DIR__, "..", "deps", "usr", "lib"))
const binary_path = normpath(joinpath(@__DIR__, "..", "deps", "usr", "bin", "cmark-gfm"))

@static if Sys.iswindows()
    const execenv = ("PATH" => string(libpath, ";", Sys.BINDIR))
elseif Sys.isapple()
    const execenv = ("DYLD_LIBRARY_PATH" => libpath)
else
    const execenv = ("LD_LIBRARY_PATH" => libpath)
end

# Load in `deps.jl`, complaining if it does not exist
const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")
if !isfile(depsjl_path)
    error("LibFoo not installed properly, run Pkg.build(\"LibFoo\"), restart Julia and try again")
end
include(depsjl_path)

# Module initialization function
function __init__()
    # Always check your dependencies from `deps.jl`
    check_deps()
end

"""
    rendergfm(fileout::AbstractString, file::AbstractString; documenter = false, format="html")
    rendergfm(io, file::AbstractString; documenter = false, format="html")

Render the markdown document `file` to `fileout` or `io`, following the cmark-gfm spec.

- `documenter`: Wraps the output in a Documenter `@raw`-block of the specified format.
- `format`: Can be one of `html`, `xml`, `man`, `commonmark`, `plaintext`, `latex`.

Spec: https://github.github.com/gfm/
"""
function rendergfm(fileout::AbstractString, file::AbstractString; kwargs...)
    io = IOBuffer()
    rendergfm(io, file; kwargs...)

    open(fileout, "w") do file
        write(file, seekstart(io))
    end

    return fileout
end

function rendergfm(io, file::AbstractString; documenter = false, format="html")
    isfile(file) || throw(ErrorException("File not found."))

    if !(format in ["html", "xml", "man", "commonmark", "plaintext", "latex"])
        throw(ArgumentError("""
            Invalid format `$(format)`.
            Only `html`, `xml`, `man`, `commonmark`, `plaintext`, `latex` are supported.
        """))
    end

    withenv(execenv) do
        documenter && println(io, "````````````@raw ", format)
        print(io, read(`$(binary_path) $(file) -t $(format) --width 100 -e footnotes -e table -e strikethrough -e tasklist`, String))
        documenter && println(io, "\n````````````")
    end

    return nothing
end

end # module
