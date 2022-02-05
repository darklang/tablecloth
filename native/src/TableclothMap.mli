(** *)

(** A [Map] represents a unique mapping from keys to values.

    [Map] is an immutable data structure which means operations like {!Map.add} and {!Map.remove} do not modify the data structure, but return a new map with the desired changes.

    Since maps of [int]s and [string]s are so common the specialized {!Map.Int} and {!Map.String} modules are available, which offer a convenient way to construct new maps.

    Custom data types can be used with maps as long as the module satisfies the {!Comparator.S} interface.

    {[
      module Point = struct
        type t = int * int
        let compare = Tuple2.compare ~f:Int.compare ~g:Int.compare
        include Comparator.Make(struct
          type nonrec t = t
          let compare = compare
        end)
      end

      type animal = 
        | Cow
        | Pig
        | Alpacca

      let point_to_animal : animal Map.Of(Point).t = 
        Map.from_list (module Point) [((0, 0), Alpacca); ((3, 4), Cow); ((6, 7), Pig)]
    ]}

    See the {!Comparator} module for a more details.
*)

type ('key, +'value, 'id) t = ('key, 'value, 'id) Base.Map.t

(** This functor lets you describe the type of Maps a little more concisely.

    {[
      let string_to_int : int Map.Of(String).t =
        Map.from_list (module String) [("Apple", 2); ("Pear", 0)]
    ]}

    Is the same as

    {[
      let string_to_int : (string, int, String.identity) Map.t =
        Map.from_list (module String) [("Apple", 2); ("Pear", 0)]
    ]}
*)
module Of (M : TableclothComparator.S) : sig
  type nonrec 'value t = (M.t, 'value, M.identity) t
end

(** {1 Create}

    You can create sets of modules types which conform to the {!Comparator.S} signature by using {!empty}, {!singleton}, {!from_list} or {!from_array}.

    Specialised versions of the {!empty}, {!singleton}, {!from_list} and {!from_array} functions available in the {!Set.Int} and {!Set.String} sub-modules.
*)

val empty :
  ('key, 'identity) TableclothComparator.s -> ('key, 'value, 'identity) t
(** A map with nothing in it.

    Often used as an intial value for functions like {!Array.fold}.

    {2 Examples}

    {[
      Array.fold
        [|"Pear"; "Orange"; "Grapefruit"|]
        ~initial:(Map.empty (module Int))
        ~f:(fun length_to_fruit fruit ->
          Map.add length_to_fruit ~key:(String.length fruit) ~value:fruit
        )
      |> Map.to_array
      = [|(4, "Pear"); (6, "Orange"); (10, "Grapefruit")|]
    ]}

    In this particular case you might want to use {!Array.group_by}
*)

val singleton :
     ('key, 'identity) TableclothComparator.s
  -> key:'key
  -> value:'value
  -> ('key, 'value, 'identity) t
(** Create a map from a key and value.

    {2 Examples}

    {[Map.singleton (module Int) ~key:1 ~value:"Ant" |> Map.to_list = [(1, "Ant")]]}
*)

val from_array :
     ('key, 'identity) TableclothComparator.s
  -> ('key * 'value) array
  -> ('key, 'value, 'identity) t
(** Create a map from an {!Array} of key-value tuples. *)

val from_list :
     ('key, 'identity) TableclothComparator.s
  -> ('key * 'value) list
  -> ('key, 'value, 'identity) t
(** Create a map of a {!List} of key-value tuples. *)

(** {1 Basic operations} *)

val add :
  ('key, 'value, 'id) t -> key:'key -> value:'value -> ('key, 'value, 'id) t
(** Adds a new entry to a map. If [key] is allready present, its previous value is replaced with [value].

    {2 Examples}

    {[
      Map.add
        (Map.Int.from_list [(1, "Ant"); (2, "Bat")])
        ~key:3
        ~value:"Cat"
      |> Map.to_list = [(1, "Ant"); (2, "Bat"); (3, "Cat")]
    ]}

    {[Map.add (Map.Int.from_list [(1, "Ant"); (2, "Bat")]) ~key:2 ~value:"Bug" |> Map.to_list = [(1, "Ant"); (2, "Bug")]]}
*)

val ( .?{}<- ) :
  ('key, 'value, 'id) t -> 'key -> 'value -> ('key, 'value, 'id) t
(** The {{: https://caml.inria.fr/pub/docs/manual-ocaml/indexops.html } index operator} version of {!add}

    {b Note} Currently this is only supported by the OCaml syntax.

    {2 Examples}

    {[
      let index_to_animal = Map.Int.from_list [(1, "Ant");(2, "Bat");(3, "Cat")] in
      let index_to_animal = numbers.Map.?{4} <- "Dog" in
      index_to_animal.Map.?{4} = Some "Dog"
    ]}
 *)

val remove : ('key, 'value, 'id) t -> 'key -> ('key, 'value, 'id) t
(** Removes a key-value pair from a map based on they provided key.

    {2 Examples}

    {[
      let animal_populations = Map.String.from_list [
        ("Elephant", 3_156);
        ("Mosquito", 56_123_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ] in
      Map.remove animal_populations "Mosquito" |> Map.to_list = [
        ("Elephant", 3_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ]
    ]}
*)

val get : ('key, 'value, 'id) t -> 'key -> 'value option
(** Get the value associated with a key. If the key is not present in the map, returns [None].

    {2 Examples}

    let animal_populations = Map.String.from_list [
      ("Elephant", 3_156);
      ("Mosquito", 56_123_156);
      ("Rhino", 3);
      ("Shrew", 56_423);
    ] in
    Map.get animal_populations "Shrew" = Some 56_423;
*)

val ( .?{} ) : ('key, 'value, _) t -> 'key -> 'value option
(** The {{: https://caml.inria.fr/pub/docs/manual-ocaml/indexops.html } index operator} version of {!Map.get}

    {b Note} Currently this is only supported by the OCaml syntax.

    {2 Examples}

    {[
      let index_to_animal = Map.Int.from_list [(1, "Ant");(2, "Bat");(3, "Cat")] in
      index_to_animal.Map.?{3} = Some "Cat"
    ]}
 *)

val update :
     ('key, 'value, 'id) t
  -> key:'key
  -> f:('value option -> 'value option)
  -> ('key, 'value, 'id) t
(** Update the value for a specific key using [f]. If [key] is not present in the map [f] will be called with [None].

    {2 Examples}

    {[
      let animal_populations = Map.String.from_list [
        ("Elephant", 3_156);
        ("Mosquito", 56_123_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ] in

      Map.update animal_populations ~key:"Hedgehog" ~f:(fun population ->
        match population with
        | None -> Some 1
        | Some count -> Some (count + 1)
      )
      |> Map.to_list = [
        ("Elephant", 3_156);
        ("Hedgehog", 1);
        ("Mosquito", 56_123_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ]
    ]}
*)

(** {1 Query} *)

val is_empty : (_, _, _) t -> bool
(** Determine if a map is empty. *)

val length : (_, _, _) t -> int
(** Returns the number of key-value pairs present in the map.

    {2 Examples}

    {[
      Map.Int.from_list [(1, "Hornet"); (3, "Marmot")]
      |> Map.length = 2
    ]}
*)

val any : (_, 'value, _) t -> f:('value -> bool) -> bool
(** Determine if [f] returns [true] for [any] values in a map. *)

val all : (_, 'value, _) t -> f:('value -> bool) -> bool
(** Determine if [f] returns [true] for [all] values in a map. *)

val find :
     ('key, 'value, _) t
  -> f:(key:'key -> value:'value -> bool)
  -> ('key * 'value) option
(** Returns, as an {!Option} the first key-value pair for which [f] evaluates to [true].

    If [f] doesn't return [true] for any of the elements [find] will return [None].

    Searches starting from the smallest {b key}

    {2 Examples}

    {[
      Map.String.from_list [
        ("Elephant", 3_156);
        ("Mosquito", 56_123_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ]
      |> Map.find ~f:(fun ~key ~value -> value > 10_000)
        = Some ("Mosquito", 56_123_156)
    ]}
*)

val includes : ('key, _, _) t -> 'key -> bool
(** Determine if a map includes [key].  *)

val minimum : ('key, _, _) t -> 'key option
(** Returns, as an {!Option}, the smallest {b key } in the map.

    Returns [None] if the map is empty.

    {2 Examples}

    {[
      Map.Int.from_list [(8, "Pigeon"); (1, "Hornet"); (3, "Marmot")]
      |> Map.minimum = Some 1
    ]}
*)

val maximum : ('key, _, _) t -> 'key option
(** Returns the largest {b key } in the map.

    Returns [None] if the map is empty.

    {2 Examples}

    {[
      Map.Int.from_list [(8, "Pigeon"); (1, "Hornet"); (3, "Marmot")]
      |> Map.maximum = Some 8
    ]}
*)

val extent : ('key, _, _) t -> ('key * 'key) option
(** Returns, as an {!Option}, a {!Tuple} of the [(minimum, maximum)] {b key}s in the map.

    Returns [None] if the map is empty.

    {2 Examples}

    {[
      Map.Int.from_list [(8, "Pigeon"); (1, "Hornet"); (3, "Marmot")]
      |> Map.extent = Some (1, 8)
    ]}
*)

(** {1 Combine} *)

val merge :
     ('key, 'v1, 'id) t
  -> ('key, 'v2, 'id) t
  -> f:('key -> 'v1 option -> 'v2 option -> 'v3 option)
  -> ('key, 'v3, 'id) t
(** Combine two maps.

    You provide a function [f] which is provided the key and the optional
    value from each map and needs to account for the three possibilities:

    - Only the 'left' map includes a value for the key.
    - Both maps contain a value for the key.
    - Only the 'right' map includes a value for the key.

    You then traverse all the keys, building up whatever you want.

    {2 Examples}

    {[
      let animal_to_population =
        Map.String.from_list [
          ("Elephant", 3_156);
          ("Shrew", 56_423);
        ]
      in
      let animal_to_population_growth_rate = Map.String.from_list [
        ("Elephant", 0.88);
        ("Squirrel", 1.2);
        ("Python", 4.0);
      ] in

      Map.merge
        animal_to_population
        animal_to_population_growth_rate
        ~f:(fun _animal population growth ->
          match (Option.both population growth) with
          | Some (population, growth) ->
              Some Float.((from_int population) * growth)
          | None -> None
        )
      |> Map.to_list
        = [("Elephant", 2777.28)]
    ]}
*)

(** {1 Transform} *)

val map : ('key, 'value, 'id) t -> f:('value -> 'b) -> ('key, 'b, 'id) t
(** Apply a function to all values in a dictionary.

    {2 Examples}

    {[
      Map.String.from_list [
        ("Elephant", 3_156);
        ("Shrew", 56_423);
      ]
      |> Map.map ~f:Int.to_string
      |> Map.to_list
        = [
        ("Elephant", "3156");
        ("Shrew", "56423");
      ]
    ]}
*)

val map_with_index :
  ('key, 'value, 'id) t -> f:('key -> 'value -> 'b) -> ('key, 'b, 'id) t
(** Like {!map} but [f] is also called with each values corresponding key. *)

val filter :
  ('key, 'value, 'id) t -> f:('value -> bool) -> ('key, 'value, 'id) t
(** Keep elements that [f] returns [true] for.

    {2 Examples}

    {[
      Map.String.from_list [
        ("Elephant", 3_156);
        ("Shrew", 56_423);
      ]
      |> Map.filter ~f:(fun population -> population > 10_000)
      |> Map.to_list
        = [
        ("Shrew", 56423);
      ]
    ]}
*)

val partition :
     ('key, 'value, 'id) t
  -> f:(key:'key -> value:'value -> bool)
  -> ('key, 'value, 'id) t * ('key, 'value, 'id) t
(** Divide a map into two, the first map will contain the key-value pairs that [f] returns [true] for, pairs that [f] returns [false] for will end up in the second.

    {2 Examples}

    {[
      let (endangered, not_endangered) = Map.String.from_list [
        ("Elephant", 3_156);
        ("Mosquito", 56_123_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ]
      |> Map.partition ~f:(fun ~key:_  -> fun ~value:population  -> population < 10000)
      in

      Map.to_list endangered = [
        ("Elephant", 3_156);
        ("Rhino", 3);
      ];

      Map.to_list not_endangered = [
        ("Mosquito", 56_123_156);
        ("Shrew", 56_423);
      ];
    ]}
*)

val fold :
     ('key, 'value, _) t
  -> initial:'a
  -> f:('a -> key:'key -> value:'value -> 'a)
  -> 'a
(** Like {!Array.fold} but [f] is also called with both the [key] and [value]. *)

(** {1 Iterate} *)

val for_each : (_, 'value, _) t -> f:('value -> unit) -> unit
(** Runs a function [f] against each {b value} in the map. *)

val for_each_with_index :
  ('key, 'value, _) t -> f:(key:'key -> value:'value -> unit) -> unit
(** Like {!Map.for_each} except [~f] is also called with the corresponding key. *)

(** {1 Convert} *)

val keys : ('key, _, _) t -> 'key list
(** Get a {!List} of all of the keys in a map.

    {2 Examples}

    {[
      Map.String.from_list [
        ("Elephant", 3_156);
        ("Mosquito", 56_123_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ]
      |> Map.keys = [
        "Elephant";
        "Mosquito";
        "Rhino";
        "Shrew";
      ]
    ]}
*)

val values : (_, 'value, _) t -> 'value list
(** Get a {!List} of all of the values in a map.

    {2 Examples}

    {[
      Map.String.from_list [
        ("Elephant", 3_156);
        ("Mosquito", 56_123_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ]
      |> Map.values = [
        3_156;
        56_123_156;
        3;
        56_423;
      ]
    ]}
*)

val to_array : ('key, 'value, _) t -> ('key * 'value) array
(** Get an {!Array} of all of the key-value pairs in a map. *)

val to_list : ('key, 'value, _) t -> ('key * 'value) list
(** Get a {!List} of all of the key-value pairs in a map. *)

(** Construct a Map which can be keyed by any data type using the polymorphic [compare] function. *)
module Poly : sig
  type identity

  type nonrec ('key, 'value) t = ('key, 'value, identity) t

  val empty : unit -> ('key, 'value) t
  (** A map with nothing in it. *)

  val singleton : key:'key -> value:'value -> ('key, 'value) t
  (** Create a map from a key and value.

      {2 Examples}

      {[Map.Poly.singleton ~key:false ~value:1 |> Map.to_list = [(false, 1)]]}
  *)

  val from_array : ('key * 'value) array -> ('key, 'value) t
  (** Create a map from an {!Array} of key-value tuples. *)

  val from_list : ('key * 'value) list -> ('key, 'value) t
  (** Create a map from a {!List} of key-value tuples. *)
end

(** Construct a Map with {!Int}s for keys. *)
module Int : sig
  type nonrec 'value t = 'value Of(TableclothInt).t

  val empty : 'value t
  (** A map with nothing in it. *)

  val singleton : key:int -> value:'value -> 'value t
  (** Create a map from a key and value.

      {2 Examples}

      {[Map.Int.singleton ~key:1 ~value:"Ant" |> Map.to_list = [(1, "Ant")]]}
  *)

  val from_array : (int * 'value) array -> 'value t
  (** Create a map from an {!Array} of key-value tuples. *)

  val from_list : (int * 'value) list -> 'value t
  (** Create a map of a {!List} of key-value tuples. *)
end

(** Construct a Map with {!String}s for keys. *)
module String : sig
  type nonrec 'value t = 'value Of(TableclothString).t

  val empty : 'value t
  (** A map with nothing in it. *)

  val singleton : key:string -> value:'value -> 'value t
  (** Create a map from a key and value.

      {2 Examples}

      {[Map.String.singleton ~key:"Ant" ~value:1 |> Map.to_list = [("Ant", 1)]]}
  *)

  val from_array : (string * 'value) array -> 'value t
  (** Create a map from an {!Array} of key-value tuples. *)

  val from_list : (string * 'value) list -> 'value t
  (** Create a map from a {!List} of key-value tuples. *)
end
