module type Sig = sig
  (** user-defined record type *)
  type 'a t

  (** objective function value type *)
  type fv

  (** paramter type *)
  type prm

  (** user-defined paramter record type *)
  type prms = prm t

  (** objective function type *)
  type f = prms -> fv

  (** internal state *)
  type state

  (** stopping criterion function type *)
  type stop = state -> bool

  (** [iter s] returns the number of iterations for optimisation state [s] *)
  val iter : state -> int

  (** [prms s] returns the optimisation parameters of state [s] *)
  val prms : state -> prms

  (** [f s] returns the objective function of state [s] *)
  val f : state -> f

  (** [f s] returns the objective function value of state [s] *)
  val fv : state -> float

  (** [init ~prms0 ~f ()] returns an initialises optimisation state for initial parmaters [prms0] and objective function [f] *)
  val init : prms0:prms -> f:f -> unit -> state

  (** [stop s] is the default stopping criterion, which prints out the iteration and objective function value at each optimisation iteration and terminates when the objective function value goes below 1E-4 *)
  val stop : state -> bool

  (** [min ?(stop=stop) ~lr s] minimises f for optimisation state [s] using vanilla gradient descent. Once the stopping criterion is reached (i.e. [stop s] returns [true]), the [min] returns the optimised state. *)
  val min : ?stop:stop -> lr:Lr.t -> state -> state

  (** [max ?(stop=stop) ?(beta=0.9) ~lr s] is similar to [min] but maximises f. *)
  val max : ?stop:stop -> lr:Lr.t -> state -> state
end
