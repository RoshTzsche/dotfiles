function getbook --wraps='aria2c -c -x16 -s16' --description 'alias getbook=aria2c -c -x16 -s16'
    aria2c -c -x16 -s16 $argv
end
