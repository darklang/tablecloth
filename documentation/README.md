# Documentation File

The documentation for tablecloth is in file `documentation.md`. The goal is to have a single file that can be used to generate documentation in both OCaml and ReasonML format.

Here is the general pattern for function documentation:

<pre lang="no-highlight"><code>## square

```ocaml
 val square : int -> int 
```

```reason
let square: int => int;
```

Description of function goes here. To mark inline code as OCaml,
follow it with {:.ocaml}; to mark it as ReasonML, follow it
with {:.reason}. (This is a convention from kramdown
https://kramdown.gettalong.org/) Example:

`square n`{:.ocaml} `square(n)`{:.reason} returns the square of `n`.

### Example

```ocaml
square 4 = 16
```

```reason
square(4) == 16
```</code></pre>
