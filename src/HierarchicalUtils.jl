module HierarchicalUtils

abstract type NodeType end
struct LeafNode <: NodeType end
struct InnerNode <: NodeType end
struct SingletonNode <: NodeType end

NodeType(::Type{T}) where T = @error "Define NodeType(::Type{$T}) to be either LeafNode(), SingletonNode() or InnerNode()"
NodeType(x::T) where T = NodeType(T)

isleaf(n) = isleaf(NodeType(n), n)
isleaf(::LeafNode, _) = true
isleaf(::SingletonNode, _) = false
isleaf(::InnerNode, n) = nchildren(n) == 0

childrenfields(::Type{T}) where T = @error "Define childrenfields(::$T) to be the iterable over fields of the structure pointing to the children"
childrenfields(::T) where T = childrenfields(T)

childsort(x) = x
function childsort(x::NamedTuple{T}) where T
    ks = tuple(sort(collect(T))...)
    NamedTuple{ks}(x[k] for k in ks)
end

children(n) = children(NodeType(n), n)
children(::LeafNode, _) = ()
children(_, ::T) where T = @error "Define children(n::$T) to return NamedTuple or Tuple of children"

children_sorted(n) = childsort(children(n))

printchildren(n) = children(n)
printchildren_sorted(n) = childsort(printchildren(n))

# noderepr(::T) where T = @error "Define noderepr(x) for type $T of x for hierarchical printing, empty string is possible"
noderepr(x) = repr(x)

nchildren(n) = nchildren(NodeType(n), n)
nchildren(::LeafNode, n) = 0
nchildren(::SingletonNode, n) = 1
nchildren(::InnerNode, n) = length(children(n))

export NodeType, LeafNode, SingletonNode, InnerNode
export childrenfields, children, nchildren
export noderepr, printchildren

include("statistics.jl")
export nnodes, nleafs

include("traversal_encoding.jl")
export encode_traversal, walk, list_traversal

include("printing.jl")
export printtree

include("iterators.jl")
export NodeIterator, LeafIterator, TypeIterator, PredicateIterator, ZipIterator, MultiIterator

include("maps.jl")
export treemap, treemap!, leafmap, leafmap!

end # module
