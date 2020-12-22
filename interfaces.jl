abstract type SomeDataBase end;

# DataBase methods 
ids( db :: SomeDataBase ) = Int[];
sites( db :: SomeDataBase, ids :: Vector{Int} ) = Vector{Float64}[];
function results( db :: SomeDataBase, ids :: Vector{Int}; include_nothing = true )
    Vector{Float64}[]
end

"Push a single `site` into `db`, set Evaluation result to nothing."
push_site!(db :: SomeDataBase, site :: Vector{Float64}, id :: Int = -1 ) = nothing; 

"Push multiple `sites` into `db`, set Evaluation results to nothing."
push_sites!(db :: SomeDataBase, sites :: Vector{Vector{Float64}}) = nothing

eval!( db :: SomeDataBase, f :: F where F<:Function, id :: Int; reevaluate = true ) = nothing;
