(** A [Map] represents a unique mapping from keys to values.  *)

type 'value t = 'value Belt.Map.String.t

(** {1 Create} *)

val empty : 'value t
(** A map with nothing in it.

    Often used as an intial value for functions like {!Array.fold}

    {2 Examples}

    {[
      Array.fold
        [|"Pear", "Orange", "Grapefruit"|]
        ~initial:(Map.String.empty)
        ~f:(fun lengthToFruit fruit ->
          Map.String.add lengthToFruit (String.length fruit) fruit
        )
      |> Map.String.toArray
      = [|(4, "Pear"); (6, "Orange"), (10, "Grapefruit")|]
    ]}

    In this particular case you might want to use {!Array.groupBy}
*)

val singleton :
  key:string
  -> value:'value
  -> 'value t
(** Create a map from a key and value

    {2 Examples}

    {[Map.String.singleton  ~key:1 ~value:"Ant" |> Map.String.toList = [(1, "Ant")]]}
*)

val fromArray :
  (string * 'value) array
  -> 'value t
(** Create a map from an {!Array} of key-value tuples *)

val from_array :
  (string * 'value) array
  -> 'value t

val fromList :
  (string * 'value) list
  -> 'value t
(** Create a map of a {!List} of key-value tuples *)

val from_list :
  (string * 'value) list
  -> 'value t

(** {1 Basic operations} *)

val add :
  'value t -> key:string -> value:'value -> 'value t
(** Adds a new entry to a map. If [key] is allready present, its previous value is replaced with [value].

    {2 Examples}

    {[
      Map.String.add
        (Map.String.fromList [(1, "Ant"); (2, "Bat")])
        ~key:3
        ~value:"Cat"
      |> Map.String.toList = [(1, "Ant"); (2, "Bat"); (3, "Cat")]
    ]}

    {[Map.String.add (Map.String.fromList [(1, "Ant"); (2, "Bat")]) ~key:2 ~value:"Bug" |> Map.String.toList = [(1, "Ant"); (2, "Bug")]]}
*)

val ( .?{}<- ) :
  'value t -> string -> 'value -> 'value t
(** The {{: https://caml.inria.fr/pub/docs/manual-ocaml/indexops.html } index operator} version of {!add}

    {b Note} Currently this is only supported by the OCaml syntax.

    {2 Examples}

    {[
      let indexToAnimal = Map.String.fromList [(1, "Ant");(2, "Bat");(3, "Cat")] in
      let indexToAnimal = numbers.Map.String.?{4} <- "Dog" in
      indexToAnimal.Map.String.?{4} = Some "Dog"
    ]}
 *)

val remove : 'value t -> string -> 'value t
(** Removes a key-value pair from a map based on they provided key.

    {2 Examples}
    {[
      let animalPopulations = Map.String.String.fromList [
        ("Elephant", 3_156);
        ("Mosquito", 56_123_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ] in
      Map.String.remove animalPopulations "Mosquito" |> Map.String.toList = [
        ("Elephant", 3_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ]
    ]}
*)

val get : 'value t -> string -> 'value option
(** Get the value associated with a key. If the key is not present in the map, returns [None].

    {2 Examples}

    let animalPopulations = Map.String.String.fromList [
      ("Elephant", 3_156);
      ("Mosquito", 56_123_156);
      ("Rhino", 3);
      ("Shrew", 56_423);
    ] in
    Map.String.get animalPopulations "Shrew" = Some 56_423;
*)

val ( .?{} ) : 'value t -> string -> 'value option
(** The {{: https://caml.inria.fr/pub/docs/manual-ocaml/indexops.html } index operator} version of {!Map.String.get}

    {b Note} Currently this is only supported by the OCaml syntax.

    {2 Examples}

    {[
      let indexToAnimal = Map.String.fromList [(1, "Ant");(2, "Bat");(3, "Cat")] in
      indexToAnimal.Map.String.?{3} = Some "Cat"
    ]}
 *)

val update :
     'value t
  -> key:string
  -> f:('value option -> 'value option)
  -> 'value t
(** Update the value for a specific key using [f]. If [key] is not present in the map [f] will be called with [None].

    {2 Examples}

    {[
      let animalPopulations = Map.String.String.fromList [
        ("Elephant", 3_156);
        ("Mosquito", 56_123_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ] in

      Map.String.update animalPopulations ~key:"Hedgehog" ~f:(fun population ->
        match population with
        | None -> Some 1
        | Some count -> Some (count + 1)
      )
      |> Map.String.toList = [
        ("Elephant", 3_156);
        ("Hedgehog", 1);
        ("Mosquito", 56_123_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ]
    ]}
*)

(** {1 Query} *)

val isEmpty : _ t -> bool
(** Determine if a map is empty. *)

val is_empty : _ t -> bool

val length : 'value t -> int
(** Returns the number of key-value pairs present in the map.

    {2 Examples}

    {[
      Map.String.fromList [(1, "Hornet"); (3, "Marmot")]
      |> Map.String.length = 2
    ]}
*)

val any : 'value t -> f:('value -> bool) -> bool
(** Determine if [f] returns [true] for [any] values in a map. *)

val all : 'value t -> f:('value -> bool) -> bool
(** Determine if [f] returns [true] for [all] values in a map. *)

val find :
     'value t
  -> f:(key:string -> value:'value -> bool)
  -> (string * 'value) option
(** Returns, as an {!Option} the first key-value pair for which [f] evaluates to true.

    If [f] doesn't return [true] for any of the elements [find] will return [None].

    Searches starting from the smallest {b key}

    {2 Examples}

    {[
      Map.String.String.fromList [
        ("Elephant", 3_156);
        ("Mosquito", 56_123_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ]
      |> Map.String.find ~f:(fun ~key ~value -> value > 10_000)
        = Some ("Mosquito", 56_123_156)
    ]}
*)

val includes : 'value t -> string -> bool
(** Determine if a map includes [key].  *)

val minimum : 'value t -> string option
(** Returns, as an {!Option}, the smallest {b key } in the map.

    Returns [None] if the map is empty.

    {2 Examples}

    {[
      Map.String.fromList [(8, "Pigeon"); (1, "Hornet"); (3, "Marmot")]
      |> Map.String.minimum = Some 1
    ]}
*)

val maximum : 'value t -> string option
(** Returns the largest {b key} in the map.

    Returns [None] if the map is empty.

    {2 Examples}

    {[
      Map.String.fromList [(8, "Pigeon"); (1, "Hornet"); (3, "Marmot")]
      |> Map.String.maximum = Some 8
    ]}
*)

val extent : 'value t -> (string * string) option
(** Returns, as an {!Option}, a {!Tuple} of the [(minimum, maximum)] {b key}s in the map.

    Returns [None] if the map is empty.

    {2 Examples}

    {[
      Map.String.fromList [(8, "Pigeon"); (1, "Hornet"); (3, "Marmot")]
      |> Map.String.extent = Some (1, 8)
    ]}
*)

(** {1 Combine} *)

val merge :
     'v1 t
  -> 'v2 t
  -> f:(string -> 'v1 option -> 'v2 option -> 'v3 option)
  -> 'v3 t
(** Combine two maps.

    You provide a function [f] which is provided the key and the optional
    value from each map and needs to account for the three possibilities:

    1. Only the 'left' map includes a value for the key.
    2. Both maps contain a value for the key.
    3. Only the 'right' map includes a value for the key.

    You then traverse all the keys, building up whatever you want.

    {2 Examples}

    {[
      let animalToPopulation =
        Map.String.String.fromList [
          ("Elephant", 3_156);
          ("Shrew", 56_423);
        ]
      in
      let animalToPopulationGrowthRate = Map.String.String.fromList [
        ("Elephant", 0.88);
        ("Squirrel", 1.2);
        ("Python", 4.0);
      ] in

      Map.String.merge
        animalToPopulation
        animalToPopulationGrowthRate
        ~f:(fun _animal population growth ->
          match (Option.both population growth) with
          | Some (population, growth) ->
              Some Float.((ofInt population) * growth)
          | None -> None
        )
      |> Map.String.toList
        = [("Elephant", 2777.28)]
    ]}
*)

(** {1 Transform} *)

val map : 'value t -> f:('value -> 'b) -> 'b t
(** Apply a function to all values in a dictionary.

    {2 Examples}

    {[
      Map.String.String.fromList [
        ("Elephant", 3_156);
        ("Shrew", 56_423);
      ]
      |> Map.String.map ~f:Int.toString
      |> Map.String.toList
        = [
        ("Elephant", "3156");
        ("Shrew", "56423");
      ]
    ]}
*)

val mapWithIndex :
  'value t -> f:(string -> 'value -> 'b) -> 'b t
(** Like {!map} but [f] is also called with each values corresponding key *)

val map_with_index :
  'value t -> f:(string -> 'value -> 'b) -> 'b t

val filter :
  'value t -> f:('value -> bool) -> 'value t
(** Keep elements that [f] returns [true] for.

    {2 Examples}

    {[
      Map.String.String.fromList [
        ("Elephant", 3_156);
        ("Shrew", 56_423);
      ]
      |> Map.String.map ~f:(fun population -> population > 10_000)
      |> Map.String.toList
        = [
        ("Shrew", "56423");
      ]
    ]}
*)

val partition :
     'value t
  -> f:(key:string -> value:'value -> bool)
  -> 'value t * 'value t
(** Divide a map into two, the first map will contain the key-value pairs that [f] returns [true] for, pairs that [f] returns [false] for will end up in the second.

    {2 Examples}

    {[
      let (endangered, notEndangered) = Map.String.String.fromList [
        ("Elephant", 3_156);
        ("Mosquito", 56_123_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ]
      |> Map.String.partition ~f:(fun population -> population < 10_000)
      in

      Map.String.toList endangered = [
        ("Elephant", 3_156);
        ("Rhino", 3);
      ];

      Map.String.toList notEndangered = [
        ("Mosquito", 56_123_156);
        ("Shrew", 56_423);
      ];
    ]}
*)

val fold :
     'value t
  -> initial:'a
  -> f:('a -> key:string -> value:'value -> 'a)
  -> 'a
(** Like {!Array.fold} but [f] is also called with both the [key] and [value] *)

(** {1 Iterate} *)

val forEach : 'value t -> f:('value -> unit) -> unit
(** Runs a function [f] against each {b value} in the map. *)

val for_each : 'value t -> f:('value -> unit) -> unit

val forEachWithIndex :
  'value t -> f:(key:string -> value:'value -> unit) -> unit
(** Like {!Map.String.forEach} except [~f] is also called with the corresponding key *)

val for_each_with_index :
  'value t -> f:(key:string -> value:'value -> unit) -> unit

(** {1 Convert} *)

val keys : string t -> string list
(** Get a {!List} of all of the keys in a map.

    {2 Examples}

    {[
      Map.String.String.fromList [
        ("Elephant", 3_156);
        ("Mosquito", 56_123_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ]
      |> Map.String.keys = [
        "Elephant";
        "Mosquito";
        "Rhino";
        "Shrew";
      ]
    ]}
*)

val values : 'value t -> 'value list
(** Get a {!List} of all of the values in a map.

    {2 Examples}

    {[
      Map.String.String.fromList [
        ("Elephant", 3_156);
        ("Mosquito", 56_123_156);
        ("Rhino", 3);
        ("Shrew", 56_423);
      ]
      |> Map.String.values = [
        3_156;
        56_123_156;
        3;
        56_423;
      ]
    ]}
*)

val toArray : 'value t -> (string * 'value) array
(** Get an {!Array} of all of the key-value pairs in a map. *)

val to_array : 'value t -> (string * 'value) array

val toList : 'value t -> (string * 'value) list
(** Get a {!List} of all of the key-value pairs in a map. *)

val to_list : 'value t -> (string * 'value) list

