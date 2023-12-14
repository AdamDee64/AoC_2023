package day_7_A

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
    win_type : Win_Type
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

get_hand :: proc(text : ^[]u8, i : int) -> ([5]u8, Win_Type) {
    hand : [5]u8
    win_type : Win_Type

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
            hand[c] = 11
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

    for { // this took me forever to get right. seems simple in retrospect
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
            // this logical and tied it all together and made it work
            //                         v
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

    // create an array of structs. 
    // the Hand struct records the values of the cards (for easier sorting),
    // the bid and the enumerated win type (two of a kind, full house, etc.)
    list_of_hands : [dynamic]Hand
    hand : Hand

    // this loop will populate the array with the input data in one pass.
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

    // first sort the list based on value of cards, this also resolves ties by comparing
    // the next card, and then the next card, etc. 
    // this is by far the heaviest lifting for this solution
    sort_list(&list_of_hands)
    
    // the list is sorted by card value but not hand type.
    // since hand types are enumerated, I make a new array of Hands.
    separated_list : [dynamic]Hand

    // there are 7 types of winning hands, so only need to iterated through the list 7 more times
    // pulling out all of one winning hand at a time, in order.
    separate_list(&list_of_hands, &separated_list)

    size = len(separated_list)
    total : int

    // now just add the bids multiplied by rank in the order they appear in the fully sorted list
    // ranks start at 1 and go to 1000 
    for i in 0..<size{
        total += (i+1) * separated_list[i].bid
    }

    end := time.since(start)
    ms := time.duration_milliseconds(end)
    fmt.print(total, ms, "milliseconds \n")
}