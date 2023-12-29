% Dynamic predicates to store information during interaction
:- dynamic(course/2).
:- dynamic(admission_criteria/3).
:- dynamic(tuition_fee/3).
:- dynamic(faculty/2).
:- dynamic(extracurricular_activity/1).


menu :-
    write('1. Ask about 7th Sem available courses'), nl,
    write('2. Ask about admission criteria'), nl,
    write('3. Ask about tuition fees'), nl,
    write('4. Ask about faculty information'), nl,
    write('5. Ask about extracurricular activities'), nl,
    write('6. Exit'), nl,
    handle_choice.

handle_choice :-
    write('Select an option: '),
    read(Choice),
    process_choice(Choice).

process_choice(1) :-
    available_courses,
    menu.
process_choice(2) :-
    admission_criteria_info,
    menu.
process_choice(3) :-
    tuition_fee_info,
    menu.
process_choice(4) :-
    faculty_info,
    menu.
process_choice(5) :-
    extracurricular_activities_info,
    menu.
process_choice(6) :-
    fact('exit', Response),
    format('~s~n', [Response]).

process_choice(Choice) :-
    Choice \= 1, Choice \= 2, Choice \= 3, Choice \= 4, Choice \= 5, Choice \= 6,
    write('Invalid choice. Please select a valid option.'), nl,
    menu.

% University information
university('My University').

% Initialize the chatbot
start_chatbot :-
    retractall(course(_, _)),
    retractall(admission_criteria(_, _, _)),
    retractall(tuition_fee(_, _, _)),
    retractall(faculty(_, _)),
    retractall(extracurricular_activity(_)),
    % Initialize with provided data
    init_data,
    write('Welcome to the Nirma University Chatbot! How can I help you today? Type "exit" to end the conversation.'), nl,
    menu.

% Initialize with provided data
init_data :-
    assert(course('2CS701', 'Computer Construction')),
    assert(course('2CS702', 'Big Data Analysis')),
    assert(course('2CS703', 'Minor Project')),
    assert(course('2CSDE80', 'Artificial Intelligence')),
    assert(course('2CSDE93', 'Blockchain Technology')),
    assert(admission_criteria('2CS701', 'JEE', 'ACPC')),
    assert(admission_criteria('2CS702', 'JEE', 'ACPC')),
    assert(admission_criteria('2CS703', 'JEE', 'ACPC')),
    assert(admission_criteria('2CSDE80', 'JEE', 'ACPC')),
    assert(admission_criteria('2CSDE93', 'JEE', 'ACPC')),
    assert(tuition_fee('2CS701', 'Undergraduate', '$10,000')),
    assert(tuition_fee('2CS702', 'Undergraduate', '$15,000')),
    assert(tuition_fee('2CS703', 'Undergraduate', '$15,000')),
    assert(tuition_fee('2CSDE80', 'Undergraduate', '$15,000')),
    assert(tuition_fee('2CSDE93', 'Undergraduate', '$15,000')),
    assert(faculty('Computer Construction', 'John')),
    assert(faculty('Big Data Analysis', 'Max')),
    assert(faculty('Minor Project', 'Fosh')),
    assert(faculty('Artificial Intelligence', 'Goku ')),
    assert(faculty('Blockchain Technology', 'Mahesh')),
    assert(extracurricular_activity('Coding Club')),
    assert(extracurricular_activity('Debate Team')).



available_courses :-
    findall(Course, course(_, Course), Courses),
    format('Available courses:\n', []),
    print_list(Courses).

admission_criteria_info :-
    findall((Course, Criteria1, Criteria2), admission_criteria(Course, Criteria1, Criteria2), Criteria),
    format('Admission criteria:\n', []),
    print_criteria(Criteria).

tuition_fee_info :-
    findall((Course, Level, Fee), tuition_fee(Course, Level, Fee), Fees),
    format('Tuition fees:\n', []),
    print_fees(Fees).

faculty_info :-
    findall((Course, Faculty), faculty(Course, Faculty), Faculties),
    format('Faculty information:\n', []),
    print_faculty(Faculties).

extracurricular_activities_info :-
    findall(Activity, extracurricular_activity(Activity), Activities),
    format('Extracurricular activities:\n', []),
    print_list(Activities).

print_list([]).
print_list([H|T]) :-
    format('• ~w\n', [H]),
    print_list(T).

print_criteria([]).
print_criteria([(Course, Criteria1, Criteria2)|T]) :-
    format('• Course: ~w\n  Criteria 1: ~w\n  Criteria 2: ~w\n', [Course, Criteria1, Criteria2]),
    print_criteria(T).

print_fees([]).
print_fees([(Course, Level, Fee)|T]) :-
    format('• Course: ~w\n  Level: ~w\n  Fee: ~w\n', [Course, Level, Fee]),
    print_fees(T).

print_faculty([]).
print_faculty([(Course, Faculty)|T]) :-
    format('• Course: ~w\n  Faculty: ~w\n', [Course, Faculty]),
    print_faculty(T).


start_chat :-
    write('Welcome to the My University Chatbot! How can I help you today? Type "exit" to end the conversation.'), nl,
    chat.

chat :-
    write('> '),
    read_line_to_codes(user_input, InputCodes1),
    exclude(=(0'?), InputCodes1, InputCodes2),
    atom_codes(InputAtom1, InputCodes2),
    downcase_atom(InputAtom1, InputAtom2),
    trim(InputAtom2, TrimmedInput),
    (
        fact(TrimmedInput, Response) ->
        format('~s~n', [Response])
        ;
        format('Sorry, I don\'t have information about that.~n', [])
    ),
    (TrimmedInput \= 'exit' -> chat ; true).

is_blank(X) :-
    memberchk(X, [' ', '\n', '\r', '\t']).

trim(Atom, TrimmedAtom) :-
    atom_chars(Atom, Chars),
    trim_chars(Chars, TrimmedChars),
    atom_chars(TrimmedAtom, TrimmedChars).

trim_chars(Chars, TrimmedChars) :-
    append([Prefix, TrimmedChars, Suffix], Chars),
    forall(member(X, Prefix), is_blank(X)),
    forall(member(X, Suffix), is_blank(X)),
    (
        TrimmedChars == [];
        (TrimmedChars = [First | _], \+is_blank(First), last(TrimmedChars, Last), \+is_blank(Last))
    ).

fact('what are the available courses', available_courses).
fact('what are the admission criteria for a course', admission_criteria_info).
fact('what is the tuition fee for a course', tuition_fee_info).
fact('who teaches a specific course', faculty_info).
fact('what extracurricular activities are available', extracurricular_activities_info).
fact('exit', 'Thank you for chatting with us! If you have more questions, feel free to return.').












