# Bumpkin

A ruby implementation of bumpkin.

## Usage

1. `gem build bumpkin.gemspec`
2. `gem install bumpkin-0.0.1.gem`
3. `bumpkin ../factorial.bk`

You can also execute arbitrary strings of bumpkin with `-e`:

    bumpkin -e "print[-[5 4]]"
    
and dump the intermediate and final ASTs with `--dump-tree`:

    bumpkin -e "print[-[5 4]]" --dump-tree

or 

    bumpkin --dump-tree ../factorial.bk
