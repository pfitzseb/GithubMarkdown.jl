# GithubMarkdown.jl

[![Build Status](https://travis-ci.com/pfitzseb/GithubMarkdown.jl.svg?branch=master)](https://travis-ci.com/pfitzseb/GithubMarkdown.jl)
[![Codecov](https://codecov.io/gh/pfitzseb/GithubMarkdown.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/pfitzseb/GithubMarkdown.jl)

Render a markdown file (conforming to the [gfm spec](https://github.github.com/gfm/)) to an `IOBuffer` or directly to a file.


```
rendergfm(fileout::AbstractString, file::AbstractString; documenter = false, format="html")
rendergfm(io, file::AbstractString; documenter = false, format="html")
```

Render the markdown document `file` to `fileout` or `io`, following the cmark-gfm spec.

- `documenter`: Wraps the output in a Documenter `@raw`-block of the specified format.
- `format`: Can be one of `html`, `xml`, `man`, `commonmark`, `plaintext`, `latex`.

You can also use `rendergfm` to work with strings directly:

```
julia> "a **b** c `def` [g](https://julialang.org)" |> rendergfm
"<p>a <strong>b</strong> c <code>def</code> <a href=\"https://julialang.org\">g</a></p>\n"
```
