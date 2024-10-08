\ These words don't have any sanity checks and will crash the system
\ (or break other stuff) if you try to go under 0 elements or give it
\ index over the max.
\ I feel indifer to what should happen, so I'm keeping them like this.
\ If you with them to handle it differently, you are encuraged to edit
\ them as much as you like

\ Words can be easily modified to use items of different size.
\ The base list% is usable for any type of data.


begin-structure list%
  field: list-len
  field: list-ptr
end-structure

: new-list64 ( n -- a ) \ len
  \ list
  list% allocate throw
 
  \ contents
  2dup list-len !
  swap cells allocate throw
  over list-ptr !
;

: new-list64-fill ( n* -- a ) \ list of values ended by length
  dup new-list64              \ example: 14 6 42 3 new-list64-fill

  swap
  dup 0<> if
    0 swap 1- do \ start from the end, so that the order is preserved
      \ n* list-ptr
      swap
      over list-ptr @ i cells + !
    -1 +loop
  else
    drop
  then
;

: list64-resize { n a -- } \ delta list64
  a list-ptr dup @
  a list-len dup @ n + 
  \ ptr-adr ptr len-adr new-len

  dup rot !
  cells resize throw
   
  swap !
;

: list64-remove { n a -- } \ index (starting at 0!) list64
  \ if remove the last, use normal resize
  n a list-len 1- = if
    -1 a list64-resize
    exit
  then

  a list-ptr @ n cells + \ position of remove
  a list-len @ n 1- - \ number of items left

  \ shift all values comming after
  0 do
    dup i 1+ cells + @
    over i cells + !
  loop
  drop
  \ resize anyways
  \ probably could be all written better,
  \ but I want it to be single and readable word
  -1 a list64-resize
;

: list64-append ( n a -- )
  1 over list64-resize
  dup list-len @ 1- cells
  swap list-ptr @ + ! 
;

: list64-insert { v n a -- } \ value index (still 0 based) list64

  \ give to regular append if inserting at the end
  n a list-len @ = if
    v a list64-append
    exit
  then

  1 a list64-resize
  a list-ptr @ n cells + \ position of append
  a list-len @ n - 1- \ number of items after insertion

  \ shift everything one further
  1 swap do
    dup i 1- cells + @
    over i cells + !
  -1 +loop

  v swap !
;

\ remove last and return it's value
: list64-pop ( a -- n )
  dup list-ptr @
  over list-len @ 1- cells + @
  -1 rot list64-resize
;

\ remove first and return it's value
: list64-shift ( a -- n )
  dup list-ptr @ @
  0 rot list64-remove
;
