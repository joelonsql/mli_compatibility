# mli_compatibility
Extract and normalize function signatures from .mli file

### Building
Run `dune build`. The generated executable will then be in `./_build/default/mli_analyser.exe`.

### Usage

    cd [the dit source dir] && ./for_each_commit.sh

This will checkout all git commits,
starting from the oldest,
and run `./_build/default/mli_analyser.exe` for each git commit,
and write all function signatures to `/tmp/sig.csv`.

Install Signatures table and View_Changes view:

    `psql -f signatures.sql`
    `psql -f view_changes.sql`
