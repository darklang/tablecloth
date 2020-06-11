(** Comparator provide a way for custom data structures to be used with {!Map}s and {!Set}s 

    Say we have a module [Book] which we want to be able to create a {!Set} of

    {[
      module Book = struct
        type t = {
          isbn: string;
          title: string;
        }

        let compare bookA bookB =
          String.compare bookA.isbn bookb.isbn
      end
    ]}

    First we need to make our module conform to the {!S} signature.

    This can be done by using the {!Make} functor.

    {[
      module Book = struct
        type t = {
          isbn: string;
          title: string;
        }

        let compare bookA bookB =
          String.compare bookA.isbn bookb.isbn
        
        include Comparator.Make(struct 
          type nonrec t = t

          let compare = compare
        end)
      end
    ]}

    Now we can create a Set of books

    {[
      Set.fromList (module Book) [
        { isbn="9788460767923"; title="Moby Dick or The Whale" }
      ]
    ]}
*)

module type T = sig
  (** T represents the input for the {!Make} functor *)

  type nonrec t

  val compare : t -> t -> int
end

type ('a, 'identity) t

(** This just is an alias for {!t}  *)
type ('a, 'identity) comparator = ('a, 'identity) t

module type S = sig
  (** The output type of {!Make}.  *)

  type t

  type identity

  val comparator : (t, identity) comparator
end

(** A type alias that is useful typing functions which accept first class modules like {!Map.empty} or {!Set.fromArray} *)
type ('a, 'identity) s =
  (module S with type identity = 'identity and type t = 'a)

(** Create a new comparator by providing a module which satisifies {!T}.

    {2 Examples}

    {[
      module Book = struct
        module T = struct
          type t = {
            isbn: string;
            title: string;
          }
          let compare bookA bookB =
            String.compare bookA.isbn bookB.isbn
        end

        include T
        include Comparator.Make(T)
      end

      let books = Set.empty (module Book)
    ]}
*)
module Make : functor (M : T) -> S with type t := M.t
