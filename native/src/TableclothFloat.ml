type t = float

type radians = t

let from_int = Base.Float.of_int

let from_string string =
  try Some (Base.Float.of_string string) with Invalid_argument _ -> None


let zero = 0.0

let one = 1.0

let nan = Base.Float.nan

let infinity = Base.Float.infinity

let negative_infinity = Base.Float.neg_infinity

let e = Base.Float.euler

let pi = Base.Float.pi

let epsilon = Base.Float.epsilon_float

let maximum_safe_integer = (2. ** 52.) -. 1.

let minimum_safe_integer = (-2. ** 52.) -. 1.

let largest_value = Base.Float.max_finite_value

let smallest_value = Base.Float.min_positive_normal_value

let add = ( +. )

let ( + ) = ( +. )

let subtract = ( -. )

let ( - ) = ( -. )

let multiply = ( *. )

let ( * ) = ( *. )

let divide n ~by = n /. by

let ( / ) = ( /. )

let power ~base ~exponent = base ** exponent

let ( ** ) = ( ** )

let negate = Base.Float.neg

let ( ~- ) = negate

let absolute = Base.Float.abs

let is_integer t = t = Base.Float.round t

let is_safe_integer t = is_integer t && t <= maximum_safe_integer

let clamp n ~lower ~upper =
  if upper < lower
  then
    raise
      (Invalid_argument
         ( "~lower:"
         ^ Base.Float.to_string lower
         ^ " must be less than or equal to ~upper:"
         ^ Base.Float.to_string upper ) )
  else if Base.Float.is_nan lower
          || Base.Float.is_nan upper
          || Base.Float.is_nan n
  then Base.Float.nan
  else max lower (min upper n)


let in_range n ~lower ~upper =
  if let open Base.Float in
     upper < lower
  then
    raise
      (Invalid_argument
         ( "~lower:"
         ^ Base.Float.to_string lower
         ^ " must be less than or equal to ~upper:"
         ^ Base.Float.to_string upper ) )
  else n >= lower && n < upper


let square_root = sqrt

let log n ~base =
  let open Base.Float in
  log10 n / log10 base


let is_nan = Base.Float.is_nan

let is_infinite = Base.Float.is_inf

let is_finite n = (not (is_infinite n)) && not (is_nan n)

let maximum x y = if is_nan x || is_nan y then nan else if y > x then y else x

let minimum x y = if is_nan x || is_nan y then nan else if y < x then y else x

let hypotenuse x y = square_root ((x * x) + (y * y))

let degrees n = n * (pi / 180.0)

external radians : float -> float = "%identity"

let turns n = n * 2. * pi

let cos = Base.Float.cos

let acos = Base.Float.acos

let sin = Base.Float.sin

let asin = Base.Float.asin

let tan = Base.Float.tan

let atan = Base.Float.atan

let atan2 ~y ~x = Base.Float.atan2 y x

type direction =
  [ `Zero
  | `AwayFromZero
  | `Up
  | `Down
  | `Closest of [ `Zero | `AwayFromZero | `Up | `Down | `ToEven ]
  ]

let round ?(direction = `Closest `Up) n =
  match direction with
  | (`Up | `Down | `Zero) as dir ->
      Base.Float.round n ~dir
  | `AwayFromZero ->
      if n < 0.
      then Base.Float.round n ~dir:`Down
      else Base.Float.round n ~dir:`Up
  | `Closest `Zero ->
      if n > 0.
      then Base.Float.round (n -. 0.5) ~dir:`Up
      else Base.Float.round (n +. 0.5) ~dir:`Down
  | `Closest `AwayFromZero ->
      if n > 0.
      then Base.Float.round (n +. 0.5) ~dir:`Down
      else Base.Float.round (n -. 0.5) ~dir:`Up
  | `Closest `Down ->
      Base.Float.round (n -. 0.5) ~dir:`Up
  | `Closest `Up ->
      Base.Float.round_nearest n
  | `Closest `ToEven ->
      Base.Float.round_nearest_half_to_even n


let floor = Base.Float.round_down

let ceiling = Base.Float.round_up

let truncate = Base.Float.round_towards_zero

let from_polar (r, theta) = (r * cos theta, r * sin theta)

let to_polar (x, y) = (hypotenuse x y, atan2 ~x ~y)

let to_int = Base.Float.iround_towards_zero

let to_string = Base.Float.to_string

let equal = ( = )

let compare = compare
