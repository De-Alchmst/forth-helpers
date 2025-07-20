here value seed

\ random number
\ https://en.wikipedia.org/wiki/Linear_congruential_generator
: RND ( -- n )
  \ Musl values
  6364136223846793005 seed * 1+ \ natural overflow as modulus (Musl on 64-bit,
  dup to seed ;                 \ but should still be good enough on 32/16-bit)

\ random number within range
: RANDOM ( n -- 0..n-1 ) rnd swap mod abs ;

