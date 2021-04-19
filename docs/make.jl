using Pkg
Pkg.activate(@__DIR__)
#%%
using GAIO
using Documenter

DocMeta.setdocmeta!(GAIO, :DocTestSetup, :(using GAIO); recursive=true)

makedocs(;
    modules=[Morbit],
    authors="Manuel Berkemeier",
    repo="https://github.com/manuelbb-upb/GAIO.jl/blob/{commit}{path}#{line}",
    sitename="GAIO.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://github.com/manuelbb-upb/GAIO.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="https://github.com/manuelbb-upb/GAIO.jl",
)
