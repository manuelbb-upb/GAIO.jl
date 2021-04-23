var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = GAIO ","category":"page"},{"location":"#GAIO","page":"Home","title":"GAIO","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This project was founded by the European Region Development Fund.","category":"page"},{"location":"","page":"Home","title":"Home","text":"<img src=\"https://www.efre.nrw.de/fileadmin/Logos/EU-Fo__rderhinweis__EFRE_/EFRE_Foerderhinweis_englisch_farbig.jpg\" width=\"45%\"/>","category":"page"},{"location":"","page":"Home","title":"Home","text":"<img src=\"https://www.efre.nrw.de/fileadmin/Logos/Programm_EFRE.NRW/Ziel2NRW_RGB_1809_jpg.jpg\" width=\"45%\"/>","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [GAIO]","category":"page"},{"location":"#GAIO.DepthFilterNodes","page":"Home","title":"GAIO.DepthFilterNodes","text":"DepthFilterNodes{T} <: PreOrderDFSSubIterator\n\nAn iterator based on PreOrderDFS that returns only nodes with a certain depth(s). Traversal starts at start_node but depth  is measured by depth( any_node ) and hence in relation to the  root of the tree (which possibly does not equal start_node) by default.\n\nA subtree is only visited for traversal if the depth of its respective parent is below the maximum value of desired return depths.\n\nInitialize via \n\ndfs_iterator = DepthFilterNodes( start_node, desired_depths :: Vector{Int} );\n\n\n\n\n\n","category":"type"},{"location":"#GAIO.Leaves","page":"Home","title":"GAIO.Leaves","text":"Leaves{T} <: PreOrderDFSSubIterator\n\nInitialize as per iter = Leaves( start_node ) iter is an iterator that returns the leaves of a subtree  starting at start_node.  It is based on a PreOrderDFS traversal.\n\n\n\n\n\n","category":"type"},{"location":"#GAIO.PreOrderDFS","page":"Home","title":"GAIO.PreOrderDFS","text":"PreOrderDFS{T}\n\tstart_node :: T\n\ttraverse_subtree_filter :: Union{Nothing, F where F<:Function};\nend\n\nAn iterator to perform a depth first traversal of the subtree that has  start_node as its root. PreOrder means that parent nodes are visited before their respective children. The field traverse_subtree_filter defaults to nothing. If a function is provided it should accept an argument of type T (a parent node) and return true if its children should be pushed to the stack for visiting.\n\n\n\n\n\n","category":"type"},{"location":"#GAIO.PreOrderDFSFiltered","page":"Home","title":"GAIO.PreOrderDFSFiltered","text":"PreOrderDFSFiltered{T} <: PreOrderDFSSubIterator\n\nAn iterator that is based on the PreOrderDFS iterator and allows for filtering out nodes that are returned. The most basic constructor is \n\niter = PreOrderDFSFiltered( \n\tstart_node :: T, \n\tfunc :: F where F <: Function )\n\nThe function func should take one argument of type T (a node)  and return true if it should be returned by iter.\n\n\n\n\n\n","category":"type"},{"location":"#GAIO.PreOrderDFSSubIterator","page":"Home","title":"GAIO.PreOrderDFSSubIterator","text":"An abstract super type for iterators that are based on the  PreOrderDFS iterator.\n\n\n\n\n\n","category":"type"},{"location":"#GAIO.:≺-Tuple{Vector{R} where R<:Real, Vector{R} where R<:Real}","page":"Home","title":"GAIO.:≺","text":"≺( X, Y )\n\nReturn true if vector X dominates Y, i.e. if all components of X not bigger than those of Y and if there is at least one component of X that is strictly smaller than the corresponding  Y component.\n\n\n\n\n\n","category":"method"},{"location":"#GAIO.add_sub_box!-Tuple{BoxNode, Vector{Float64}, Vector{Float64}}","page":"Home","title":"GAIO.add_sub_box!","text":"add_sub_box!( parent, sub_lb, sub_ub )\n\nAdd a new box node with variable boundaries sub_lb and sub_ub to parent.  Modifies sub_boxes field of parent and sets the parent reference  of the new box correctly.\n\n\n\n\n\n","category":"method"},{"location":"#GAIO.contains-Tuple{BoxNode, Vector{R} where R<:Real}","page":"Home","title":"GAIO.contains","text":"contains(box, point)\n\nReturn true if point lies in box.\n\n\n\n\n\n","category":"method"},{"location":"#GAIO.depth-Tuple{GAIO.Node}","page":"Home","title":"GAIO.depth","text":"depth(node)\n\nReturn depth of node in a tree. Root node is assigned depth 0, its children have depth 1 and so forth.\n\nThis default implementation goas up the tree starting at node as long  as there is a parent node. \n\nIt can be overwritten for custom Node/Tree types, e.g. when depth is  stored explicitly.\n\n\n\n\n\n","category":"method"},{"location":"#GAIO.eval!-Tuple{BoxNode, Function}","page":"Home","title":"GAIO.eval!","text":"Evaluate all sites referenced by field db_indices.\n\n\n\n\n\n","category":"method"},{"location":"#GAIO.init_box_tree","page":"Home","title":"GAIO.init_box_tree","text":"init_box_tree( lb, ub, db = nothing )\n\nInitialize the root node of a box Tree with variable boundaries lb and ub.  If db is a database then it is referenced in the node.\n\n\n\n\n\n","category":"function"},{"location":"#GAIO.push_site!","page":"Home","title":"GAIO.push_site!","text":"Push a single site into db, set Evaluation result to nothing.\n\n\n\n\n\n","category":"function"},{"location":"#GAIO.push_site!-2","page":"Home","title":"GAIO.push_site!","text":"Push a single site into db, set Evaluation result to nothing.\n\n\n\n\n\n","category":"function"},{"location":"#GAIO.push_sites!-Tuple{GAIO.DataBase, Vector{Vector{Float64}}}","page":"Home","title":"GAIO.push_sites!","text":"Push multiple sites into db, set Evaluation results to nothing.\n\n\n\n\n\n","category":"method"},{"location":"#GAIO.push_sites!-Tuple{GAIO.SomeDataBase, Vector{Vector{Float64}}}","page":"Home","title":"GAIO.push_sites!","text":"Push multiple sites into db, set Evaluation results to nothing.\n\n\n\n\n\n","category":"method"},{"location":"#GAIO.results-Tuple{BoxNode}","page":"Home","title":"GAIO.results","text":"Retrieve evaluation results indexed by db_indices from referenced DataBase db.\n\n\n\n\n\n","category":"method"},{"location":"#GAIO.sites-Tuple{BoxNode}","page":"Home","title":"GAIO.sites","text":"Retrieve sites indexed by db_indices from referenced DataBase db.\n\n\n\n\n\n","category":"method"},{"location":"#GAIO.subdivide!","page":"Home","title":"GAIO.subdivide!","text":"subdivide!(parent, divisor=2)\n\nRecursively subdivide node parent. parent is divided by divisor along each box dimension.\n\n\n\n\n\n","category":"function"},{"location":"#GAIO.subdivide!-Tuple{BoxNode, Union{Int64, Vector{Int64}}, Vector{Float64}, Vector{Float64}}","page":"Home","title":"GAIO.subdivide!","text":"Divide each of bns edges by divisor or the entries of divisor  and add sub boxes as children to the tree.\n\n\n\n\n\n","category":"method"}]
}