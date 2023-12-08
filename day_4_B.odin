package day_3_A

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

is_winning_number :: proc(winning_numbers : ^[10]int, n : int) -> bool {
    length := len(winning_numbers)
    for i in 0..<len(winning_numbers){
        if n == winning_numbers[i]{
            return true
        }
    }
    return false
}

add_cards :: proc (bonus_cards : ^[10]int, count : u8, cards : int) {
    for i in 0..<count {
        bonus_cards[i] += cards
    }
}

card_shift :: proc(bonus_cards : ^[10]int) {
    for i in 0..<9 {
        bonus_cards[i] = bonus_cards[i + 1]
    }
    bonus_cards[9] = 0

}


main :: proc() {
    start := time.now()

    input, open_err := os.open("day_4_input.txt")
    text, read_err := os.read_entire_file_from_handle(input)

    size := len(text)

    total := 0
    i := 0



    winning_numbers : [10]int
    bonus_cards : [10]int
    w_index := 0
    add_to_winning_numbers := true
    win_count : u8 = 0
    amount_of_current_card := 0

    for i < size {
        v := int(text[i])
        n : int
        jump : int
        

        
        switch v {
            case 67: // C
            // add current played card to duplicate cards for total number played
            amount_of_current_card = bonus_cards[0] + 1 
            card_shift(&bonus_cards)
            i += 8

            case 48..=57: // any number
            // count number of wins on current card
            n, jump = get_number(&text, i)
            if add_to_winning_numbers {
                winning_numbers[w_index] = n
                w_index += 1
            } else {
                if is_winning_number(&winning_numbers, n) {
                    win_count += 1
                }
                
            } 
            i += jump

            case 124: // pipe
            add_to_winning_numbers = false
            i += 1

            case 10: // new line
            // accumulate bonus cards based on number of winning numbers * duplicate cards played
            add_cards(&bonus_cards, win_count, amount_of_current_card)
            // add current card count to total
            total += amount_of_current_card
            
            // reset all conditions for next card played
            win_count = 0
            add_to_winning_numbers = true
            w_index = 0
            i += 1

            case:
            i += 1
        }
    }

    end := time.since(start)
    ms := time.duration_milliseconds(end)

    fmt.print(total, ms, "milliseconds \n")
}