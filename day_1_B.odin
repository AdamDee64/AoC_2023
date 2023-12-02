package day_1_B

import "core:os"
import "core:fmt"

match_text :: proc(text : ^[]u8, i : int) -> int {
    d := len(text) - i

    if d >= 5 {
        switch text[i] {
            case 101: // eight
                if (text[i+1] == 105
                && text[i+2] == 103
                && text[i+3] == 104
                && text[i+4] == 116 ){
                    return 8
                }
            case 116: // three
                if (text[i+1] == 104
                && text[i+2] == 114
                && text[i+3] == 101
                && text[i+4] == 101 ){
                    return 3
                }
            case 115: // seven
                if (text[i+1] == 101
                && text[i+2] == 118
                && text[i+3] == 101
                && text[i+4] == 110 ){
                    return 7
                }
        }
    } 
    if d >= 4 {
        switch text[i]{
            case 102: // four, five
                if (text[i+1] == 111
                && text[i+2] == 117
                && text[i+3] == 114 ){
                    return 4
                } else if (text[i+1] == 105
                && text[i+2] == 118
                && text[i+3] == 101 ){
                    return 5
                }
            case 110: // nine
                if (text[i+1] == 105
                && text[i+2] == 110
                && text[i+3] == 101 ){
                    return 9
                }
        }
    }
    if d >= 3 {
        switch text[i]{
            case 111: // one
                if (text[i+1] == 110
                && text[i+2] == 101){
                    return 1
                }
            case 115: // six
                if (text[i+1] == 105
                && text[i+2] == 120){
                    return 6
                }
            case 116: // two
                if (text[i+1] == 119
                && text[i+2] == 111){
                    return 2
                }
        }
    } 
    return 0

}


main :: proc() {

input, open_err := os.open("day_1_input.txt")
text, read_err := os.read_entire_file_from_handle(input)

size := len(text)

ten := 0
one := 0
total := 0

for i in 0..<size {
    v := int(text[i])
    

    switch v {
        case 48..=57:
        one = v - 48
        if ten == 0 {
            ten = v - 48
        }
        
        case 101..=116:
        test := match_text(&text, i)
        if test > 0 {
            one = test
            if ten == 0 {
                ten = test
            }
        }

        case 10:
        total = total + ten * 10 + one
        ten = 0
        one = 0

        case:
        continue
    }

}

fmt.print(total, "\n")

}