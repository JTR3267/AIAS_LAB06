#include <stdio.h>
#include <stdlib.h>

int check(int index, char *test_c_data)
{
    int row = index / 4;    // calculate row
    int column = index % 4; // calculate col

    for (int i = 1; i < 4; i++)
    {
        // check numbers in same col
        if (test_c_data[(index + 4 * i) % 16] == test_c_data[index])
        {
            return 0;
        }
        // check numbers in same row
        if (test_c_data[(index + i) % 4 + 4 * row] == test_c_data[index])
        {
            return 0;
        }
    }
    
    int start_row = row - row % 2;          // top row in square
    int start_column = column - column % 2; // left col in square

    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++)
        {
            // check numbers in square
            int id = (start_row + i) * 4 + start_column + j;
            if (test_c_data[id] == test_c_data[index] && index != id)
            {
                return 0;
            }
        }
    }
    
    // pass
    return 1;
}

int solve(int index, char *test_c_data)
{
    if(index >= 16)
    {
        // all number filled, return true
        return 1;
    }
    if(test_c_data[index])
    {
        // number already filled, solve the next number
        return solve(index + 1, test_c_data);
    }
    else
    {
        for (int i = 1; i <= 4; i++)
        {
            // try 1 ~ 4
            test_c_data[index] = i;
            // check whether i is valid in sudoku
            // if check pass, solve the next number
            if (check(index, test_c_data) && solve(index + 1, test_c_data))
            {
                return 1;
            }
        }
    }
    // set value to 0 to mark it as empty
    test_c_data[index] = 0;
    // solve failed
    return 0;
}

void sudoku_2x2_c(char *test_c_data){
    // TODO
    // Finish your sudoku algorithm in c language
    solve(0, test_c_data);
}