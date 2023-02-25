#!/bin/zsh

curl -O https://infolibras-pf.deboramalaquias.repl.co/Gloss%C3%A1rioTEC.html
grep -o 'https://www.youtube.com/[^"]\+' Gloss%C3%A1rioTEC.html > videos.txt
grep 'label' Gloss%C3%A1rioTEC.html | awk -F'[<>]' '{print $3}' | sed 's/^ *//;s/ *$//' > termos.txt

# https://stackoverflow.com/questions/53975551/how-to-load-zsh-mapfile-in-zsh

zmodload zsh/mapfile
termos=("${(f@)mapfile[termos.txt]}")
videos=("${(f@)mapfile[videos.txt]}")

mkdir -p docs/termos
for ((i=1; i <= $#termos; i++)); do
    termo="${termos[i]}"
    video="${videos[i]}"

    # https://unix.stackexchange.com/questions/614299/how-to-split-a-string-by-character-in-bash-zsh
    partes_video=("${(@s:/:)videos[1]}")
    video_id="${video[-1]}"

    slug_termo=$(slugify "${termo}")
    if [[ ${termo} = "C#" ]]; then
        slug_termo="c-sharp"
    elif [[ ${termo} = "C++" ]]; then
        slug_termo="cpp"
    fi

    print -r -- "- [${termo}](termos/${slug_termo})" >> docs/index.md
    cat << FIM > docs/termos/"${slug_termo}".md
# ${termo}

<iframe 
    width="560" 
    height="315" 
    src="${video}" 
    title="YouTube video player" 
    frameborder="0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
    allowfullscreen>
</iframe>

FIM

done
