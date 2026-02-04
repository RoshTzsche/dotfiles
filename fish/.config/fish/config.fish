source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
function IA_Mode
    if not contains /opt/miniforge/bin $PATH
        set -gx PATH /opt/miniforge/bin $PATH
    end

    eval "$(/opt/miniforge/bin/mamba shell hook --shell fish)"
    cat ~/Pictures/ascii/eye.txt
    echo "Mamba conectado."
    
    echo "Ejecutando: mamba activate <env> (vision)"
    mamba activate vision
end
