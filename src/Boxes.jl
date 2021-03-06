
@with_kw struct BoxNode <: Node
	lb :: Vector{Float64}
	ub :: Vector{Float64}
	subdivision_level :: Int64 = 0
	parent :: Union{BoxNode, Nothing} = nothing
	sub_boxes :: Vector{BoxNode} = []
    
    # Test point data
	database :: D where D<:SomeDataBase = DataBase()
    db_indices :: Vector{Int} = [];
    
end

# required Tree methods (see "Trees.jl")
children( bn :: BoxNode ) = bn.sub_boxes;
parent( bn :: BoxNode ) = bn.parent;
depth( bn :: BoxNode ) = bn.subdivision_level;

# utilities
lb( bn :: BoxNode ) = bn.lb; # use methods for `lb` & `ub` …
ub( bn :: BoxNode ) = bn.ub; # … in case we would rather want to store center & radius
n_vars( bn :: BoxNode ) = length( bn.lb );
width( bn :: BoxNode ) = ub(bn) .- lb(bn); # maybe raname?
center(bn :: BoxNode ) = lb(bn) .+ .5 .* width( bn );
edge_length( bn :: BoxNode, dim :: Int) = ub(bn)[dim] - lb(bn)[dim];

@doc """
    contains(box, point)

Return true if `point` lies in `box`.
"""
function contains( bn :: BoxNode, point :: Vector{R} where R<:Real)
    all( lb(bn) .<= point ) && all( point .<= ub(bn) )
end

function vertices( bn :: BoxNode )
    LB = lb(bn);
    UB = ub(bn);
    
    other_ind = combinations( eachindex(UB) )
    return [ [LB,];
        [ let v = copy(LB); v[ind] .= UB[ind]; v end for ind in other_ind ]                
    ]
end

function edges( bn :: BoxNode )
    verts = vertices( bn );
    return combinations( verts, 2 )
end

@doc "Retrieve sites indexed by `db_indices` from referenced DataBase `db`."
function sites( bn :: BoxNode )
    return sites( bn.database, bn.db_indices);
end

@doc "Retrieve evaluation results indexed by `db_indices` from referenced DataBase `db`."
function results( bn :: BoxNode; include_nothing = true )
    return results( bn.database, bn.db_indices; include_nothing);
end


"Evaluate all sites referenced by field `db_indices`."
function eval!( bn :: BoxNode, f :: F where F<:Function; reevaluate = true)
    for db_id in bn.db_indices
        eval!( bn.database, f, db_id; reevaluate );
    end
end

@doc """ 
    init_box_tree( lb, ub, db = nothing )

Initialize the root node of a box Tree with variable boundaries
`lb` and `ub`. 
If `db` is a database then it is referenced in the node.
""" 
function init_box_tree(
        lb :: Vector{R} where R<:Real, ub :: Vector{R} where R<:Real, 
        db :: Union{Nothing, DataBase} = nothing
    )
    box_tree = BoxNode(;
        lb = lb,
		ub = ub,
        database = isnothing(db) ? DataBase() : db,
    );
	return box_tree
end

@doc """ 
    add_sub_box!( parent, sub_lb, sub_ub )

Add a new box node with variable boundaries `sub_lb` and `sub_ub`
to parent. 
Modifies `sub_boxes` field of `parent` and sets the parent reference 
of the new box correctly.
"""
function add_sub_box!( 
        parent :: BoxNode, sub_lb :: Vector{Float64}, 
        sub_ub :: Vector{Float64} 
    )
	# check if boundaries of sub-box lay within parent box
	if all( lb(parent) .<= sub_lb ) && all( sub_ub .<= ub(parent) )
		push!( parent.sub_boxes,
			BoxNode(;
				lb = sub_lb,
				ub = sub_ub, 
				subdivision_level = parent.subdivision_level + 1,
				parent = parent,
				sub_boxes = BoxNode[],
                database = parent.database,
			)
		);
	else
		@error("Variable boundaries of subbox must not exceed parent boundaries.")
	end
end

# recursive subdivison function 
# usually not called directly by the user 
"Divide each of `bn`s edges by divisor or the entries of divisor 
and add sub boxes as children to the tree."
function subdivide!( 
        bn :: BoxNode, divisor :: Union{Int, Vector{Int}}, 
        LB :: Vector{Float64}, UB :: Vector{Float64};
    )
    
    # recursion starts with `LB` and `UB` empty
	var_level = length(LB) + 1; # recursion level 
    
    # divisor for this level 
    sub_divisor = isa( divisor, Int ) ? divisor : divisor[ var_level ]
    
    width = edge_length( bn, var_level );
	width_fraction = width / sub_divisor
	for s = 1 : sub_divisor
		sub_lb = [LB; lb( bn )[ var_level ] + (s-1) * width_fraction ]
		sub_ub = [UB; lb( bn )[ var_level ] + s * width_fraction ]
		if var_level == n_vars( bn )
			add_sub_box!( bn, sub_lb, sub_ub )
		else
			subdivide!( bn, divisor, sub_lb, sub_ub )
		end
	end
end

function subdivide!( 
        bn :: BoxNode;
        method = :cycle
    )
    if method == :cycle 
        divisor = fill(1, n_vars(bn) );
        divisor[ ( depth(bn) % n_vars(bn) + 1 ) ] = 2;
    else
        divisor = 2;
    end
    subdivide!( bn, divisor, Float64[], Float64[] );
end

@doc """
    subdivide!(parent, divisor=2)

Recursively subdivide node `parent`.
`parent` is divided by `divisor` along each box dimension.
"""
function subdivide!( parent :: BoxNode, divisor :: Union{Vector{Int}, Int} = 2)
	lb = Float64[];
	ub = Float64[];
	subdivide!( parent, divisor, lb, ub )
end

function generate_sites!( bn :: BoxNode; method ::Symbol = :edges_center, kwargs...  )
    generate_sites!(bn , Val(method); kwargs...)
end

function generate_sites!( bn :: BoxNode, ::Val{:edges_center}; num_edge_points = -1)
    if num_edge_points < 0
        num_edge_points = n_vars(bn)
    end

    # reset old database ids
    empty!(bn.db_indices);

    # get points for unit HyperCube (cached for future reference)
    unit_points = unit_sites_edges_center( n_vars(bn); num_edge_points = num_edge_points)
    
    scale_fn(p) = p .* width(bn) .+ lb(bn);
    new_points = scale_fn.(unit_points);
    
    db_indices = push_sites!( bn.database, new_points );
    push!(bn.db_indices,db_indices...);
    nothing;
end

@memoize function unit_sites_edges_center(n_vars ::Int; num_edge_points ::Int = -1)
    if num_edge_points < 0
        num_edge_points = n_vars
    end

    bn = init_box_tree( zeros(n_vars), ones(n_vars) );

    ℓ = collect( 1 : num_edge_points )
    steps = ( 2 .* ℓ .- 1 ) ./ (2*num_edge_points);

    # N * num_edges + 1
    box_edges = edges(bn)
    num_edges = length(edges(bn)) 
    num_new_points = num_edge_points * num_edges + 1;   

    # pre-allocate site array
    new_points = Vector{Vector{Float64}}(undef, num_new_points);

    new_points[end] = center(bn);

    counter = 1;
    for e ∈ box_edges
        v1, v2 = e;
        for λ ∈ steps 
            new_points[counter] = λ .* v1 .+ (1-λ) .* v2;
            counter += 1;
        end 
    end

    return new_points 
end
