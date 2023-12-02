package day_2_A

import "core:os"
import "core:fmt"
import "core:time"

Game :: [3]int

is_ascii_number :: proc(n : u8) -> bool {
    if (n >= 48 && n <= 57) {
        return true
    }
    return false
}

get_number :: proc(text : ^[]u8, i : int) -> int {
    output := int(text[i]) - 48
    c := 1
    for {
        if is_ascii_number(text[i + c]) {
            output *= 10
            output += int(text[i + c] - 48)
            c += 1
        } else {
            break
        }
    }
    return output
}

assign_color :: proc(text : ^[]u8, i : int, game_set : ^[3]int, n : int) {
    switch text[i]{
        case 114:
        if n > game_set.r {
            game_set.r = n
        }
        case 103:
        if n > game_set.g {
            game_set.g = n
        }
        case 98:
        if n > game_set.b {
            game_set.b = n
        }
    }
}

main :: proc() {
    start := time.now()

    input, open_err := os.open("day_2_input.txt")
    text, read_err := os.read_entire_file_from_handle(input)

    size := len(text)
    
    game_number := 0   

    total := 0
    
    game_set := Game{0,0,0}
    game_max := Game{12, 13, 14}

    i := 0

    for i < size {
        v := int(text[i])
        
        switch v {
            case 71:
            i += 5
            game_number = get_number(&text, i)
            i += 3

            case 48..=57:
            n := get_number(&text, i)
            if n > 9 {
                i += 3
            } else {
                i += 2
            }
            assign_color(&text, i, &game_set, n)
            i += 3

            case 10:
            if (game_set.r <= game_max.r
            && game_set.g <= game_max.g
            && game_set.b <= game_max.b
            ) {
                total = total + game_number
            }
            game_set *= 0
            game_number = 0
            i += 1
            case:
            i += 1
        }
        

    }


    end := time.since(start)
    ms := time.duration_milliseconds(end)

    fmt.print(total, ms, "milliseconds \n")

}