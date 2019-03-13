# 0.0.5

Fix types of elemIndex

# 0.0.4

Unify the module `t`s with the native `t`s uses to implement them.

# 0.0.3

Add a lot of new functions:
- Result.andThen
- List.elemIndex
- Option.toOption
- {StrStr,IntSet}.remove
- {StrStr,IntSet}.add
- {StrStr,IntSet}.set
- {StrStr,IntSet}.has
- {StrDict,IntDict}.merge

Add regex module to Bucklescript. The contract will probably change in future
versions because native regex uses an API that can't easily be made match.


Add pp functions for show derivers

Use individual mlis for each library - there are some minor differences we want to allow.

# 0.0.2

First release
