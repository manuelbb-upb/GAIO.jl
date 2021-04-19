
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://manuelbb-upb.github.io/GAIO.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://manuelbb-upb.github.io/GAIO.jl/dev)
[![Build Status](https://github.com/manuelbb-upb/Morbit.jl/workflows/CI/badge.svg)](https://github.com/manuelbb-upb/GAIO.jl/actions)
[![Coverage](https://codecov.io/gh/manuelbb-upb/Morbit.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/manuelbb-upb/GAIO.jl)

# GAIO.jl

GAIO in pure Julia 

There is no documentation yet.  
There is no proper project structure yet.  
But some functions have docstrings…

The main data structure is `BoxNode` which subtypes `Node` so 
that some Graph methods are available ( mainly traversal, see `Trees.jl` ).

See the two example scripts `box_attractor_henon.jl` and `boxes_for_mo.jl`
for the subdivision algorithm.
**The examples have to be re-done so that they actually use the Tree structure.**

### Notes

One idea for the future is to have an abstract box interface and have the actual implementation be a subtype of both `Node` and the abstract box type. 
This requires either multiple inheritance (not yet a Julia feature) or the use of `SimpleTraits.jl`.
