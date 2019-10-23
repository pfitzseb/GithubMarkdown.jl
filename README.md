# GFM.jl

[![Build Status](https://travis-ci.com/pfitzseb/GFM.jl.svg?branch=master)](https://travis-ci.com/pfitzseb/GFM.jl)
[![Codecov](https://codecov.io/gh/pfitzseb/GFM.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/pfitzseb/GFM.jl)

Render a markdown file (conforming to the [gfm spec](https://github.github.com/gfm/)) to an `IOBuffer` or directly to a file.

---

```
    rendergfm(fileout::AbstractString, file::AbstractString; documenter = false, format="html")
    rendergfm(io, file::AbstractString; documenter = false, format="html")
```

Render the markdown document `file` to `fileout` or `io`, following the cmark-gfm spec.

- `documenter`: Wraps the output in a Documenter `@raw`-block of the specified format.
- `format`: Can be one of `html`, `xml`, `man`, `commonmark`, `plaintext`, `latex`.

Spec: https://github.github.com/gfm/
