source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

#Deactivate this or modify it for ur self mamba enviroment ;)

function IA_Mode
    if not contains /opt/miniforge/bin $PATH
        set -gx PATH /opt/miniforge/bin $PATH
    end

    eval "$(/opt/miniforge/bin/mamba shell hook --shell fish)"
    cat ~/Pictures/ascii/eye.txt
    echo "Mamba ready."
    
    echo "Running: mamba activate <env> (vision)"
    mamba activate vision
end
