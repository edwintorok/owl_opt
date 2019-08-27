# Owl Opt 

Owl Opt is a gradient-based optimisation library that works well with Owl's automatic differentiation library. Using Owl Opt's ppx deriver, users can define their own record of optimization parameters without having to worry too much about book keeping. This greatly facilitates fast prototyping. 

Owl Opt currently provides several popular optimization methods (e.g. Adam, Rmsprop, Lbfgs). With the exception of LBFGS (built ontop of [L-BFGS-ocaml](https://github.com/Chris00/L-BFGS-ocaml)), all methods now support both single and double precision.

## Installation
```sh
$ dune build @install
$ dune install
```

## Examples 

The following code fragement solves a standard linear regression problem: find paramters `a` and `b` that minimises the l2 loss `sqrt((y - (a*x + b))^2)`. 
The optimisation is carried out using Adam with hyperparameters `beta1=0.99` and `beta2=0.999`.

```ocaml
module Prms = struct
   type 'a t = {a: 'a; b: 'a} [@@deriving prms]
end

(* make an Adam optimisation module for the parameter definition Prms *)
module O = Owl_opt.D.Adam.Make (Prms)

(* define the objective function *)
let f prms = Owl.Algodiff.D.Maths.(l2norm' (y - ((prms.a *@ x) + prms.b))) 

(* define initial parameters *)
let prms0 = {a = Owl.Algodiff.D.Mat.gaussian 5 5; b = Owl.Algodiff.D.gaussian 5 1} 

(* initialise an optimisation session *)
let s0 = O.init ~beta1:0.99 ~beta2:0.999 ~prms0 ~f () 

(* define stopping criteria: stop when function value is smaller than 1E-4 *)
let stop s = O.(fv s) < 1E-4

(* minimise objective function f *)
let s = O.min ~stop f

(* final objective function value *)
let c = O.fv s

(* final prms *)
let prms = O.prms s
```

See `examples/test_adam.ml` for more details:
```sh
$ dune exec examples/test_adam.exe
step: 7670 | loss: 0.003270402
final loss: 0.000704
```
 
