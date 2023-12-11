package day_5_A

import "core:os"
import "core:fmt"
import "core:time"
import "core:math"

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

set_destination :: proc(source, dest : ^[dynamic]int, almanac : ^[3]int) {
    l := len(source) 
    for i in 0..<l {
        if (source[i] >= almanac.y && source[i] < almanac.y + almanac.z) {
            dest[i] = source[i] - almanac.y + almanac.x
        }
    }
}


get_lowest :: proc(arr : ^[dynamic]int, seed_count : int) -> int {
    lowest := arr[0]
    for i in 1..<seed_count {
        if arr[i] < lowest {
            lowest = arr[i]
        }
    }
    return lowest
}

main :: proc() {
    start := time.now()

    input, open_err := os.open("day_5_input.txt")
    text, read_err := os.read_entire_file_from_handle(input)

    size := len(text)
    i := 6

    gather_seeds := true
    seed_count := 0
    source : [dynamic]int
    destination : [dynamic]int
    almanac : [3]int
    a_i := 0

    for i < size {
        v := int(text[i])
        n : int
        jump : int

        switch v {
            case 10: // new line
            gather_seeds = false
            if a_i == 3 {
                set_destination(&source, &destination, &almanac)

                a_i = 0
            }
            i += 1

            case 58: // :
            for i in 0..<seed_count{
                source[i] = destination[i]
            }  
            
            i += 1

            case 48..=57:
            n, jump = get_number(&text, i)
            if gather_seeds {
                append(&source, n)
                append(&destination, n)
                seed_count += 1
            } else {
                almanac[a_i] = n
                a_i += 1
            }
            i += jump

            case:
            i += 1


        }
    }

    final := get_lowest(&destination, seed_count)


    end := time.since(start)
    ms := time.duration_milliseconds(end)

    fmt.print(final, ms, "milliseconds \n")
}