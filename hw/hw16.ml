(* Homework 16 *)

type 'a set = 'a list 

val emptySet = nil : 'a set

fun isElem(_ : ''a,nil : ''a set) = false
  | isElem(x,y::ys) = if x = y then true else isElem(x,ys)

fun setAddElem(x : ''a,ys : ''a set) = if isElem(x,ys) then ys else x::ys

fun setUnion(nil : ''a set,ys : ''a set) = ys
  | setUnion(x::xs,ys) = setAddElem(x,setUnion(xs,ys))

fun setIntersection(nil : ''a set,ys : ''a set) = emptySet
  | setIntersection(x::xs,ys) = if isElem(x,ys) then x::setIntersection(xs,ys) else setIntersection(xs,ys)

fun setFilter(nil : 'a set,g) = emptySet
  | setFilter(x::xs,g) = if g(x) then x::setFilter(xs,g) else setFilter(xs,g)

fun isSubset(nil : ''a set,ys : ''a set) = true
  | isSubset(x::xs,ys) = isElem(x,ys) andalso isSubset(xs,ys)

fun areEqualSets(xs : ''a set,ys : ''a set) = isSubset(xs,ys) andalso isSubset(ys,xs)


fun intervalSet(m,n) : int set = if m > n then emptySet else m::intervalSet(m+1,n)

fun listMap(f,nil) = nil
  | listMap(f,x::xs) = f(x)::listMap(f,xs)

fun cartProd(nil : 'a set,ys : 'b set) : ('a * 'b) set = nil
  | cartProd(x::xs,ys) = listMap(fn y => (x,y),ys) @ cartProd(xs,ys)

fun powerSet(nil : 'a set) : 'a set set = [nil]
  | powerSet(x::xs) = let val p = powerSet(xs) in p @ listMap(fn y => x::y,p) end

fun setMap(g,nil : ''a set) : ''b set = nil
  | setMap(g,x::xs) = setAddElem(g(x),setMap(g,xs))



fun setRemoveElem(_,nil) = nil
  | setRemoveElem(a,b::bs) = if a = b then bs else b::setRemoveElem(a,bs)

fun flatten(nil) = nil
  | flatten(x::xs) = x @ flatten(xs)

fun perm([]) = [[]]
  | perm(bs) = flatten(listMap(fn b => listMap(fn p => b::p,perm(setRemoveElem(b,bs))),bs))


fun subsetsOfSize(_,0) = [[]]
  | subsetsOfSize([],_) = []
  | subsetsOfSize(b::bs,k) = listMap(fn cs => b::cs,subsetsOfSize(bs,k-1)) @ subsetsOfSize(bs,k)

(*** START HW 16 CODE ***)

fun isDHelper([], n, len) = n = len 
    | isDHelper([x], n, len) = not (x = n)
    | isDHelper(x::xs, n, len) = 
        if x = n then false else isDHelper(xs, n+1, len);

fun isDerangement(xs, len) = isDHelper(xs, 1, len);

fun len([]) = 0
    | len (x::xs) = 1 + len(xs);

fun isD(xs) = isDHelper(xs, 1, len(xs));

fun derangements(n) = 
    let val set = intervalSet(1,n)
        val perms = perm(set)
    in setFilter(perms,isD) end;

fun derangementRatio(n) = 
    let val set = intervalSet(1,n)
        val totals = perm(set)
        val numerator = derangements(n)
        val numTotals = len(totals)
        val numNumers = len(numerator)
        val frac = real(numNumers)/real(numTotals);
    in frac end;