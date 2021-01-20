# GAIO.jl

GAIO in pure Julia 

There is no documentation yet.  
There is no proper project structure yet.  
But some functions have docstrings…

The "project module" is `BoxTrees` in `BoxTrees.jl`.
All other files (except the examples) are included there.

The main data structure is `Box` which subtypes `Node` so 
that some Graph methods are available ( mainly traversal, see `Trees.jl` ).

See the two example scripts `box_attractor_henon.jl` and `boxes_for_mo.jl`
for the subdivision algorithm.

### Notes

One idea for the future is to have an abstract box interface and have the actual implementation be a subtype of both `Node` and the abstract box type. 
This requires either multiple inheritance (not yet a Julia feature) or the use of `SimpleTraits.jl`.

