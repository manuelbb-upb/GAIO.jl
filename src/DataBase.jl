
mutable struct Evaluation 
    site :: Vector{Float64}
    result :: Union{Vector{Float64}, Nothing}

    Evaluation( site ) = new( site, nothing );
end

@with_kw struct DataBase <: SomeDataBase
	eval_dict :: Dict{ Int, Evaluation } = Dict{ Int, Evaluation }();
end

# DataBase methods 
ids( db :: DataBase ) = collect( keys( db.eval_dict ) );
sites( db :: DataBase, ids :: Vector{Int} ) = [ db.eval_dict[id].sites for id in ids ];
function results( db :: DataBase, ids :: Vector{Int}; include_nothing = true )
    all_results = [ db.eval_dict[id].result for id in ids ];
    if !include_nothing 
        deleteat!(all_results, isnothing.(all_results))
    end
    return all_results
end

"Push a single `site` into `db`, set Evaluation result to nothing."
function push_site!(db:: DataBase, site :: Vector{Float64}, id :: Int = -1 )
    if id < 0 
        max_id = let db_ids = ids(db);
            isempty(db_ids) ? 0 : maximum( db_ids )
        end;
        id = max_id + 1;
    end
    
    db.eval_dict[id] = Evaluation(site);
end

"Push multiple `sites` into `db`, set Evaluation results to nothing."
function push_sites!(db:: DataBase, sites :: Vector{Vector{Float64}})
    max_id = let db_ids = ids(db);
        isempty(db_ids) ? 0 : maximum( db_ids )
    end;
    new_ids = Vector{Int}(undef, length(sites) )
    for (site_ind, site) ∈ enumerate(sites)
        id = max_id + site_ind;
        new_ids[ site_ind ] = id;
        push_site!(db, site, id)
    end
    return new_ids
end 

function eval!( db :: DataBase, f :: F where F<:Function, id :: Int; reevaluate = true )
    if reevaluate || isnothing( db.eval_dict[id].result )
        db.eval_dict[id].result = f( db.eval_dict[id].site );
    end
    nothing
end
