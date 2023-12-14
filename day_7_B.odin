package day_7_B

import "core:os"
import "core:fmt"
import "core:time"
import "core:math"

Win_Type :: enum {
    HIGH_CARD,
    TWO_KIND,
    TWO_PAIR,
    THREE_KIND,
    FULL_HOUSE,
    FOUR_KIND,
    FIVE_KIND
}

Hand :: struct{
    hand : [5]u8,
    bid : int,
    win_type: Win_Type
}

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

play_jokers :: proc(jokers : int, win_type : Win_Type) -> Win_Type {
    new_win_type := win_type
    // it might seem complex to add jokers but there is a
    // limited number of ways they can change the outcome 
    // of the hand since we don't care about values and just
    // the class of the winning hand. 
    #partial switch win_type {
        case .HIGH_CARD: 
        new_win_type = .TWO_KIND 
        case .TWO_KIND:
        new_win_type = .THREE_KIND
        case .TWO_PAIR: // a two-pair is the only case where jokers can have one of two effects
        // if there is 1 joker, then it is applied to one of the pairs to make a full house
        if jokers == 1{
            new_win_type = .FULL_HOUSE
        // if there are 2 jokers, that means one of the pairs is jokers and applied to the other pair
        // makes a 4 of a kind. 
        } else {
            new_win_type = .FOUR_KIND
        }
        case .THREE_KIND: 
        new_win_type = .FOUR_KIND
        case: 
        new_win_type = .FIVE_KIND
    }
    return new_win_type
}

get_hand :: proc(text : ^[]u8, i : int) -> ([5]u8, Win_Type) {
    hand : [5]u8
    win_type : Win_Type
    jokers := 0

    for c in 0..<5 {
        switch text[i + c] {
            case 50:
            hand[c] = 2
            case 51:
            hand[c] = 3
            case 52:
            hand[c] = 4
            case 53:
            hand[c] = 5
            case 54:
            hand[c] = 6
            case 55:
            hand[c] = 7
            case 56:
            hand[c] = 8
            case 57: 
            hand[c] = 9
            case 84:
            hand[c] = 10
            case 74:
            hand[c] = 1
            jokers += 1
            case 81:
            hand[c] = 12
            case 75:
            hand[c] = 13
            case 65:
            hand[c] = 14
        }
    }

    x := 0
    y := x + 1
    match_set_a := 1
    match_set_b := 1
    first_match : u8 = 0

    for {
        if hand[x] == first_match {
            x += 1
            y = x + 1
        } else if hand[x] == hand[y] {
            if first_match == 0 {
                match_set_a += 1
            } else {
                match_set_b += 1
            }
            y += 1
        } else {
            y += 1
        }

        if y == 5 {
            if match_set_a > 1 && first_match == 0 {
                first_match = hand[x]
            }
            if match_set_b > 1 {
                break
            }
            x += 1
            y = x + 1
        }

        if x >= 4{
            break
        }
    }    

    if match_set_a == 1 {
        win_type = .HIGH_CARD
    } else if match_set_a == 2 {
        switch match_set_b {
            case 1:
            win_type = .TWO_KIND
            case 2:
            win_type = .TWO_PAIR
            case 3:
            win_type = .FULL_HOUSE
        }
    } else if match_set_a == 3 {
        switch match_set_b {
            case 1:
            win_type = .THREE_KIND
            case 2:
            win_type = .FULL_HOUSE
        }
    } else if match_set_a == 4 {
        win_type = .FOUR_KIND
    } else if match_set_a == 5 {
        win_type = .FIVE_KIND
    }

    if jokers > 0 {
        win_type = play_jokers(jokers, win_type)
    }
    

    return hand, win_type
}

sort_list :: proc(list : ^[dynamic]Hand) {
    length := len(list)
    i := 0
    j := length - 1 
    index := 0

    swap : Hand

    for{
        if list[i].hand[index] > list[i + 1].hand[index]{
            swap = list[i]
            list[i] = list[i + 1]
            list[i + 1] = swap
            index = 0

        } else if list[i].hand[index] == list[i + 1].hand[index] {
            index += 1
        } else {
            index = 0
            i += 1
        }

        if i == j {
            i = 0
            j -= 1
            if j == 1 {
                break
            }
        }
    }
}

separate_list :: proc(list : ^[dynamic]Hand, separate : ^[dynamic]Hand) {
    size := len(list)

    for i in 0..=6 {
        for j in 0..<size {
            if list[j].win_type == Win_Type(i){
                append(separate, list[j])
            }
            
        }
    }
}

main :: proc() {
    start := time.now()

    input, open_err := os.open("day_7_input.txt")
    text, read_err := os.read_entire_file_from_handle(input)

    size := len(text)
    i := 0

    recording_hand := true

    list_of_hands : [dynamic]Hand
    hand : Hand

    for i < size {
        v := int(text[i])

        switch v {
            case 10:
            recording_hand = true
            i += 1

            case 48..=57:
            if !recording_hand {
                jump : int
                hand.bid, jump = get_number(&text, i)
                append(&list_of_hands, hand)
                i += jump
            } else {
                hand.hand, hand.win_type = get_hand(&text, i)
                recording_hand = false
                i += 5
            }

            case:
            if recording_hand {
                hand.hand, hand.win_type = get_hand(&text, i)
                recording_hand = false
                i += 5
            }
            i += 1
        }
    }

    sort_list(&list_of_hands)
 
    separated_list : [dynamic]Hand

    separate_list(&list_of_hands, &separated_list)

    size = len(separated_list)

    total : int

    for i in 0..<size{
        total += (i+1) * separated_list[i].bid
    }
    end := time.since(start)
    ms := time.duration_milliseconds(end)
    fmt.print(total, ms, "milliseconds \n")
}