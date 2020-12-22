module BoxTrees

using Parameters: @with_kw
using Memoize: @memoize

export Box, generate_sites!, eval!, subdivide!, init_box_tree,
    results, sites, contains;
export children, parent, Leaves;
export ≺, point_not_dominated_by_box;


include("Trees.jl");
include("HyperCube.jl");

include("interfaces.jl");

# implementation of the `SomeDataBase` interface
include("DataBase.jl");

include("Boxes.jl");
include("mo_utils.jl")

end