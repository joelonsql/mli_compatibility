#!/bin/bash                                                                                                                                                                                                                                    

COMMITS=$(git log --oneline | cut -d " " -f 1)

rm /tmp/sig.csv

for COMMIT in $COMMITS
do
    git checkout $COMMIT
    
    find . -name '*.mli' -exec './_build/default/mli_analyser.exe' '{}' "`git remote get-url origin`" "`git log -1 --format=%H`" "`git log -1 --format=%cd`" ';' >> /tmp/sig.csv
                                                                                                                                                                                                                                
done

git checkout master