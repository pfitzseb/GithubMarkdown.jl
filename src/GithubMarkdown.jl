module GithubMarkdown

using gfm_jll

export rendergfm

const EXTENSIONS = [
    "footnotes",
    "table",
    "strikethrough",
    "autolink",
    "tagfilter",
    "tasklist"
]

const FORMATS = [
    "html",
    "xml",
    "man",
    "commonmark",
    "plaintext",
    "latex"
]

"""
    rendergfm(output::IO, input::IO; documenter = false, format="html", removehtml = false, extensions=EXTENSIONS)
    rendergfm(output::IO, input::AbstractString; documenter = false, format="html", removehtml = false, extensions=EXTENSIONS)
    rendergfm(output::AbstractString, input::AbstractString; documenter = false, format="html", removehtml = false, extensions=EXTENSIONS)

Render the markdown document `input` to `output`, following the cmark-gfm spec.

- `documenter`: Wraps the output in a Documenter `@raw`-block of the specified format.
- `format`: Can be one of `html`, `xml`, `man`, `commonmark`, `plaintext`, `latex`.
- `removehtml`: Removes all literal HTML input and potentially dangerous links if `true`. `false`
  by default. The `tagfilter` extension (enabled by default) will remove most malicious raw HTML.
  It's recommended to sanitize the resulting HTML when `removehtml == false`.
- `extensions`: An array of extensions to use. Valid extensions are `footnotes`, `table`,
  `strikethrough`, `autolink`, `tagfilter`, `tasklist`. All of those are enabled by default.

Spec: https://github.github.com/gfm/
"""
function rendergfm end

"""
    rendergfm(input::AbstractString; documenter = false, format="html", removehtml = false, extensions=EXTENSIONS)::String

Render the `input` string and return the resulting HTML as a string.
"""
function rendergfm(input::AbstractString; kwargs...)
    out = IOBuffer()
    rendergfm(out, IOBuffer(input); kwargs...)
    return String(take!(out))
end

function rendergfm(output::AbstractString, input::AbstractString; kwargs...)
    io = IOBuffer()
    rendergfm(io, input; kwargs...)

    open(output, "w") do input
        write(input, seekstart(io))
    end

    return nothing
end

function rendergfm(output::IO, input::AbstractString; kwargs...)
    isfile(input) || throw(ErrorException("File not found."))

    open(input) do input
        rendergfm(output, input; kwargs...)
    end

    return nothing
end

function rendergfm(output::IO, input::IO; documenter = false, format="html", removehtml = false, extensions=EXTENSIONS)
    if !(format in FORMATS)
        throw(ArgumentError("""
            Invalid format `$(format)`.
            Only $(join(map(s -> string('`', s, '`'), FORMATS), ", ")) are supported.
        """))
    end

    for ext in extensions
        if !(ext in EXTENSIONS)
            throw(ArgumentError("""
                Invalid extension `$(ext)`.
                Only $(join(map(s -> string('`', s, '`'), EXTENSIONS), ", ")) are supported.
            """))
        end
    end

    flags = String["-t", format, "--width", "100"]

    !removehtml && push!(flags, "--unsafe")

    for ext in extensions
        push!(flags, "-e")
        push!(flags, ext)
    end

    documenter && println(output, "````````````@raw ", format)
    p = pipeline(input, `$(gfm_jll.gfm()) $(flags)`)
    print(output, read(p, String))
    documenter && println(output, "\n````````````")

    return nothing
end

end # module
