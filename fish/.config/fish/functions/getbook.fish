# Use this command for downloading books or things more fast than you will do with curl, u need to have aria2c.
# sudo pacman -S aria2

function getbook --wraps='aria2c -c -x16 -s16' --description 'alias getbook=aria2c -c -x16 -s16'
    aria2c -c -x16 -s16 $argv
end
