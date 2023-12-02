package day_2_B

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

get_number :: proc(text : ^[]u8, i : int) -> (int, int) {
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
    return output, c
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

    total := 0
    
    game_set := Game{0,0,0}
    game_max := Game{12, 13, 14}

    i := 0

    for i < size {
        jump : int
        v := int(text[i])
        
        switch v {
            case 71:
            n : int
            i += 5
            n, jump = get_number(&text, i)
            i += 2 + jump

            case 48..=57:
            n : int
            n, jump = get_number(&text, i)
            i += 1 + jump
            assign_color(&text, i, &game_set, n)
            i += 3

            case 10:

            total += game_set.r * game_set.g * game_set.b
            game_set *= 0
            i += 1
            case:
            i += 1
        }
        

    }


    end := time.since(start)
    ms := time.duration_milliseconds(end)

    fmt.print(total, ms, "milliseconds \n")

}