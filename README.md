# RPN Calculator Specifications

1. The calculator should use standard input and standard output, unless the
   language makes that impossible.

2. It should implement the four standard arithmetic operators.

3. It should support negative and decimal numbers, and should not have
   arbitrary limits on the number of operations.

4. The calculator should not allow invalid or undefined behavior.

5. The calculator should exit when it receives a `q` command or an end of input 
   indicator (EOF).

## Sample Usage
    
    $ ruby rpn.rb -h
    Usage: rpn [options]
        -m, --MF=TRUE                Using a file containing a list of files(in same dir).
            --D=DELIMITER            Using specified delimiter.

    Extended Usage:
        cat filename | ruby rpn.rb   For a unix pipe.
        ruby rpn.rb < filename       For a redirect.
        ruby rpn.rb filename(s)      For giving filenames as arguments.

---

    $ ruby rpn.rb
    Welcome to Reverse Polish Notation calculator version 0.1!
    This version currently supports these operators +, -, *, /, % (modulo), ** (power),
    /% (absolute percentage) and c5 (cube it and add 5).
    Enter q or EOF(produced by pressing Ctrl+D on Unix and Ctrl+Z on Windows) to quit
    Enter reset to wipe memory, stack to display all values, help for info:

    > 1
    1
    > 2
    2
    > +
    3
    > q

    Thank you for using Reverse Polish Notation calculator!

---

    $ ruby rpn.rb test_cases/test_case_1.txt 
    Processing test_cases/test_case_1.txt ...
    > 5
    5
    > 8
    8
    > +
    13
    > Finished Processing test_cases/test_case_1.txt ...

---

    $ ruby rpn.rb --D=#,# < test_cases/test_cases_for_delimiter.txt
    Processing input from stdin ...
    > Processing input: [1#,#2#,#3#,#4#,#5#,#+#,#+#,#-#,#+] with delimiter: "#,#" ...
    > 1
    1
    > 2
    2
    > 3
    3
    > 4
    4
    > 5
    5
    > +
    9
    > +
    12
    > -
    -10
    > +
    -9
    > Finished Processing input: [1#,#2#,#3#,#4#,#5#,#+#,#+#,#-#,#+] ...
    Processing input: [20#,#13#,#-#,#2#,#/] with delimiter: "#,#" ...
    > 20
    20
    > 13
    13
    > -
    7
    > 2
    2
    > /
    3.5
    > Finished Processing input: [20#,#13#,#-#,#2#,#/] ...
    Finished Processing...


---

    $ cat test_cases/test_case_1.txt | ruby rpn.rb
    Processing input from stdin ...
    > 5
    5
    > 8
    8
    > +
    13
    > Finished Processing...

---
    
    $ ruby rpn.rb --MF=true test_cases/test_cases.txt
    Processing test_cases/test_case_1.txt ...
    > 5
    5
    > 8
    8
    > +
    13
    > Finished Processing test_cases/test_case_1.txt ...

    Processing test_cases/test_case_2.txt ...
    > -3
    -3
    > -2
    -2
    > *
    6
    > 5
    5
    > +
    11
    > Finished Processing test_cases/test_case_2.txt ...

    Processing test_cases/test_case_3.txt ...
    > 2
    2
    > 9
    9
    > 3
    3
    > +
    12
    > *
    24
    > Finished Processing test_cases/test_case_3.txt ...

    Processing test_cases/test_case_4.txt ...
    > Processing input: [20 13 - 2 /] with delimiter: " " ...
    > 20
    20
    > 13
    13
    > -
    7
    > 2
    2
    > /
    3.5
    > Finished Processing input: [20 13 - 2 /] ...
    Finished Processing test_cases/test_case_4.txt ...