push!(LOAD_PATH,"../src/")
using Documenter, BFloat

makedocs(
    sitename = "BFloat.jl",
    modules  = [BFloat],
    doctest  = false
)

deploydocs(
    repo = "github.com/adknudson/BFloat.jl.git",
    versions = ["stable" => "v^", "v#.#", "dev" => "master"]
)
